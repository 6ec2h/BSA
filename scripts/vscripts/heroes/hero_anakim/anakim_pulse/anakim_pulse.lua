LinkLuaModifier( "modifier_shadow_fiend_anakim_pulse_lua", "heroes/hero_anakim/anakim_pulse/anakim_pulse", LUA_MODIFIER_MOTION_NONE )

anakim_pulse = class({})

function anakim_pulse:Precache( context )
	PrecacheResource( "particle", "particles/anakim/anakim_pulse.vpcf", context )
end


function anakim_pulse:OnSpellStart()
	local caster = self:GetCaster()
	local distance = self:GetSpecialValueFor("range")
	local count = self:GetSpecialValueFor("count")
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local delay = self:GetSpecialValueFor("delay")
	local start_position = self:GetCaster():GetOrigin()
	local right_vector = self:GetCaster():GetRightVector()
	local forward = self:GetCaster():GetForwardVector():Normalized()
	local step = distance / count
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_anakim_tal1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		damage = damage + ability:GetSpecialValueFor("value")
	end
	
	local pulse = 0
	Timers:CreateTimer(0, function()
		if pulse < count then
			pulse = pulse + 1
			local point = (start_position + forward * (step * pulse)) + right_vector * RandomInt(-100,100)
			
			local dummy = CreateUnitByName( "npc_dummy_unit", point, false, nil, nil, self:GetCaster():GetTeamNumber())
			dummy:AddNewModifier(dummy, nil, "modifier_dummy", {})
			
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				local damageTable = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}
				ApplyDamage( damageTable )
			end
			anakim_pulse:PlayEffects( self, point, target_radius, dummy )	
			return delay
		else
			return nil
		end
	end)
end

function anakim_pulse:PlayEffects( self, position, radius, target )
	local effect_cast = ParticleManager:CreateParticle( "particles/anakim/anakim_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, position )
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 6, target, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( position, "Hero_Luna.LucentBeam.Target", target )
	target:ForceKill(false)
end