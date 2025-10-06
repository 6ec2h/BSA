LinkLuaModifier("modifier_primal_beast_rock_throw", "heroes/hero_primal_beast/primal_beast_rock_throw_lua/primal_beast_rock_throw_lua", LUA_MODIFIER_MOTION_NONE)

primal_beast_rock_throw_lua = class({})
	
function primal_beast_rock_throw_lua:OnSpellStart()
	local dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

	local info = {
		Target = dummy,
		Source = self:GetCaster(),
		Ability = self,	
		
		EffectName = "particles/units/heroes/hero_primal_beast/primal_beast_rock_throw.vpcf",
		iMoveSpeed = 800,
		bDodgeable = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
	self:GetCaster():EmitSound("Hero_PrimalBeast.RockThrow.Cast")
end

function primal_beast_rock_throw_lua:OnProjectileHit(target, location)
	if not target or target:IsMagicImmune() or target:IsInvulnerable() or target:IsBuilding() then return end
	local caster = self:GetCaster()
	local rock_radius = self:GetSpecialValueFor("impact_radius")
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_primal_beast_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		attack_damage = self:GetSpecialValueFor( "base_damage" ) + 240
	else
		attack_damage = self:GetSpecialValueFor( "base_damage" )
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, rock_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		local damage_table = {
			victim = enemy,
			attacker = caster,
			damage = attack_damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self,
		}

		ApplyDamage(damage_table)
		enemy:AddNewModifier(caster, self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") })
	end
	self:PlayEffects( target )
end


function primal_beast_rock_throw_lua:PlayEffects( target )
	target:EmitSound("Hero_PrimalBeast.RockThrow.Impact")
	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_primal_beast/primal_beast_rock_throw_impact.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:ForceKill(false)
end