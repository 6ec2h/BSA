function CreateWard(keys)
	local caster = keys.caster
	
	local ability = keys.ability
	local position = ability:GetCursorPosition()
	
	caster.death_ward = CreateUnitByName("npc_turret", position, true, caster, nil, caster:GetTeam())
	caster.death_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	caster.death_ward:SetOwner(caster)
	local turret_hp = ability:GetLevelSpecialValueFor( "hp", ability:GetLevel() - 1 ) * caster:GetMaxHealth()
	
	caster.death_ward:SetBaseMaxHealth(turret_hp)
	caster.death_ward:SetMaxHealth(turret_hp)
	caster.death_ward:SetHealth(turret_hp)
	
	
	local turret_dmg = ability:GetLevelSpecialValueFor( "dmg", ability:GetLevel() - 1 ) * caster:GetBaseDamageMin()
	if caster:FindAbilityByName("npc_dota_hero_triss_tal3") ~= nil then 
		if caster:FindAbilityByName("npc_dota_hero_triss_tal3"):GetLevel() > 0 then 
			turret_dmg = (ability:GetLevelSpecialValueFor( "dmg", ability:GetLevel() - 1 ) + 0.15 )* caster:GetBaseDamageMin()
		end
	end
	
	caster.death_ward:SetBaseDamageMin(turret_dmg)
	caster.death_ward:SetBaseDamageMax(turret_dmg)
	
	ability:ApplyDataDrivenModifier( caster, caster.death_ward, "modifier_turret_datadriven", {} )
	caster.death_ward:AddNewModifier( caster.death_ward, self, "modifier_tutorial_disable_healing", {} )
end


function boom(data)
	local caster = data.caster
	local particle_explosion = "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf"
	local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_explosion_fx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(damage_radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

	data.caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile_Dud")
	data.caster:ForceKill(false)
end