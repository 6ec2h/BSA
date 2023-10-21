LinkLuaModifier("modifier_triss_boom", "heroes/hero_new/copy.lua", LUA_MODIFIER_MOTION_NONE)

copy = class({})

function copy:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function copy:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function copy:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	EmitSoundOn("Hero_Techies.RemoteMine.Plant", caster )

	caster.death_ward = CreateUnitByName("npc_copy", position, true, caster, nil, caster:GetTeamNumber())
	caster.death_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	caster.death_ward:SetOwner(caster)
	caster.death_ward:AddNewModifier(caster, self, "modifier_triss_boom", {} )
	local hp_mnoz = self:GetSpecialValueFor("hp_tooltip")/100 * caster:GetMaxHealth()
	
	caster.death_ward:SetBaseMaxHealth(hp_mnoz)
	caster.death_ward:SetMaxHealth(hp_mnoz)
	caster.death_ward:SetHealth(hp_mnoz)
end

------------------------------------------------------------------

modifier_triss_boom = class({})

function modifier_triss_boom:IsHidden()
	return false
end

function modifier_triss_boom:IsPermanent()
	return true
end

function modifier_triss_boom:IsPurgable()
	return false
end

function modifier_triss_boom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_triss_boom:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local damage = self:GetAbility():GetSpecialValueFor("dmg_mn_tooltip")
			local hero_dmg = self:GetCaster():GetBaseDamageMin() * damage / 100
			
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _,unit in pairs(enemies) do
				ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = hero_dmg, damage_type = DAMAGE_TYPE_MAGICAL})
				
				if self:GetCaster():FindAbilityByName("npc_dota_hero_triss_tal2") ~= nil then 
					if self:GetCaster():FindAbilityByName("npc_dota_hero_triss_tal2"):GetLevel() > 0 then 	
						unit:AddNewModifier( unit, nil, "modifier_generic_stunned_lua", { duration = 2} )
					end
				end
			end

			local particle_explosion_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(particle_explosion_fx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_explosion_fx, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(450, 1, 1))
			ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

			self:GetCaster():EmitSound("Hero_Techies.Suicide")
		end
	end
end