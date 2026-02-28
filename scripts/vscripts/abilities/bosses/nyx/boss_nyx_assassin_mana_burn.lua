boss_nyx_assassin_mana_burn = class({})

function boss_nyx_assassin_mana_burn:OnSpellStart(target)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_NyxAssassin.ManaBurn.Target"
	local particle_manaburn = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"

	local damage = self:GetSpecialValueFor("damage")*0.01

	EmitSoundOn(sound_cast, target)

	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end

	local particle_manaburn_fx = ParticleManager:CreateParticle(particle_manaburn, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle_manaburn_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)


	local try_damage = target:GetMaxMana() * damage
	
	local target_mana = target:GetMana()

	if target_mana > try_damage then
		target:Script_ReduceMana(try_damage, nil)
	else
		target:Script_ReduceMana(target_mana, nil)
	end

	damageTable =    
	{
		victim = target,
		attacker = caster,
		damage = try_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	}

	ApplyDamage(damageTable)
end