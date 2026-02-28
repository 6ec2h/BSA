abaddon_mist_coil_lua = class({})


function abaddon_mist_coil_lua:GetAOERadius() 
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_abaddon_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		return 300
	end
	return 0
end

function abaddon_mist_coil_lua:GetBehavior()
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_abaddon_2")
		if ability ~= nil and ability:GetLevel() > 0 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
		end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function abaddon_mist_coil_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_abaddon_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		targets = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, 300, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		if #targets > 0 then
			for _,target in pairs(targets) do
				self:cast(target)
			end
		else
			self:cast(caster)
		end
	else
		target = self:GetCursorTarget()
		self:cast(target)
	end
end

function abaddon_mist_coil_lua:cast(target)
	local caster = self:GetCaster()
	local self_damage = self:GetSpecialValueFor("self_damage")
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_abaddon_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self_damage = self_damage + 150
	end
	
	local projectile_speed = self:GetSpecialValueFor("missile_speed")
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	local damageTable = {
		victim = caster,
		attacker = caster,
		damage = self_damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	self:PlayEffects()
end

function abaddon_mist_coil_lua:OnProjectileHit( target, location )
	local ally = false
	self.heal_amount = self:GetSpecialValueFor("heal_amount")
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_abaddon_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.heal_amount = self.heal_amount + 150
	end
	
	
	if target:GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		ally = true
	end

	if ally then
		target:Heal( self.heal_amount, self:GetCaster() )
	else
		if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
			return
		end

		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = self.heal_amount,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
	end
	local sound_target = "Hero_Abaddon.DeathCoil.Target"
	EmitSoundOn( sound_target, target )
end

function abaddon_mist_coil_lua:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_death_coil_abaddon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Abaddon.DeathCoil.Cast", self:GetCaster() )
end