LinkLuaModifier( "modifier_sandking_custom_trembling_waves", "heroes/hero_sand/sand_ult/sand_ult", LUA_MODIFIER_MOTION_NONE )

sandking_custom_trembling_waves = class({})

function sandking_custom_trembling_waves:GetIntrinsicModifierName()
	return "modifier_sandking_custom_trembling_waves"
end

function sandking_custom_trembling_waves:GetCooldown( level )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int9")
	if abil ~= nil and abil:GetLevel() > 0 then 
        return self.BaseClass.GetCooldown( self, level ) - 1
    end
	return self.BaseClass.GetCooldown( self, level )
end

function sandking_custom_trembling_waves:IsRefreshable()
	return false 
end

----------------------------------------------------------------------------

modifier_sandking_custom_trembling_waves = class({})

function modifier_sandking_custom_trembling_waves:IsHidden()
	return true
end

function modifier_sandking_custom_trembling_waves:IsPurgable()
	return false
end

function modifier_sandking_custom_trembling_waves:OnCreated( kv )
	self:StartIntervalThink(0.1)
end

function modifier_sandking_custom_trembling_waves:OnIntervalThink()
if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
	if self:GetAbility():IsCooldownReady() then
		
		local caster = self:GetCaster()
		local point = caster:GetAbsOrigin()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local sand_ult_damage = self:GetAbility():GetSpecialValueFor("damage")
		local str_damage = self:GetAbility():GetSpecialValueFor("str_damage")
	
		local try_damage = sand_ult_damage + caster:GetStrength()/100 * str_damage
		
		local damageTable = {
			attacker = self:GetCaster(),
			damage = try_damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self, --Optional.
		}

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
			
				EmitSoundOn( "Ability.SandKing_Epicenter.spell", caster )
				Timers:CreateTimer(0.1, function() 
					StopSoundOn( "Ability.SandKing_Epicenter.spell", caster )
				end)
			
			Timers:CreateTimer(0.01, function() 
				caster.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(caster.ShieldParticle, 1, Vector(radius,0,radius))
				ParticleManager:SetParticleControlEnt(caster.ShieldParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			end)

			for _,enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage( damageTable )
			end	
			
			local level = self:GetAbility():GetLevel()-1
			--self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(level))
			self:GetAbility():UseResources( false,false, false, true )
		end
	end
end





















LinkLuaModifier( "modifier_sand_caustic_debuff", "heroes/hero_sand/sand_caustic/modifier_sand_caustic_debuff", LUA_MODIFIER_MOTION_NONE )

function sandking_waves(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local chance = ability:GetSpecialValueFor("chance")
	local sand_ult_damage = ability:GetSpecialValueFor("damage")
	local str_damage = ability:GetSpecialValueFor("str_damage")
	
	local try_damage = sand_ult_damage + caster:GetStrength()/100 * str_damage
	
	
	local abil = caster:FindAbilityByName("npc_dota_hero_sand_king_int9")
	if abil ~= nil and abil:GetLevel() > 0 then 
        chance = 20
    end

	local try = RandomInt(1,100)
	
	if try < chance then

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage = try_damage
	damage_table.ability = ability
	damage_table.damage_type = DAMAGE_TYPE_MAGICAL
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
    for _, unit in ipairs(units) do
	if unit:IsAlive() then		
        damage_table.victim = unit
		ApplyDamage(damage_table)
	end
	end
	StartSoundEvent( "Ability.SandKing_Epicenter.spell", caster )
	Timers:CreateTimer(0.1, function() 
	StopSoundEvent( "Ability.SandKing_Epicenter.spell", caster )
	end)
	
		Timers:CreateTimer(0.01, function() 
		caster.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(caster.ShieldParticle, 1, Vector(radius,0,radius))


		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(caster.ShieldParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end)
	end
end

------------------------------------------------
------------------------------------------------

