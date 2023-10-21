LinkLuaModifier( "modifier_legion_odds_buff", "heroes/hero_legion/legion_odds/legion_odds", LUA_MODIFIER_MOTION_NONE )

legion_odds = class({})

function legion_odds:GetIntrinsicModifierName()
	return "modifier_legion_odds_stack"
end

function legion_odds:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end


function legion_odds:OnSpellStart() 
	if IsServer() then
		local ability 				= self
		local caster 				= self:GetCaster()
		local damage 				= self:GetSpecialValueFor("damage")
		local radius 				= ability:GetSpecialValueFor("radius")
		local duration 				= ability:GetSpecialValueFor("duration")
		local pierce_spellimmunity 	= false
		
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_tal1")
		if abil ~= nil and abil:GetLevel() > 0 then 
			damage = damage + 150
		end
		
		local position = self:GetCaster():GetAbsOrigin()	

		if self.thundergod_spell_cast then
			ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
		end

		EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_LegionCommander.Overwhelming.Location", self:GetCaster())

		local damage_table 			= {}
		damage_table.attacker 		= self:GetCaster()
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage_flags	= damage_flags
		
		
		local hEnemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			for _,enemy in pairs(hEnemies) do 
				if enemy:IsAlive() and enemy:GetTeamNumber() ~= caster:GetTeamNumber() then 
				
					caster:AddNewModifier( caster, self, "modifier_legion_odds_buff", {duration = duration }):SetStackCount(#hEnemies)
				
					local target_point = enemy:GetAbsOrigin()

					local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
					ParticleManager:SetParticleControl(thundergod_strike_particle, 0, Vector(target_point.x, target_point.y, target_point.z + enemy:GetBoundingMaxs().z))
					ParticleManager:SetParticleControl(thundergod_strike_particle, 1, Vector(target_point.x, target_point.y, 2000))
					ParticleManager:SetParticleControl(thundergod_strike_particle, 2, Vector(target_point.x, target_point.y, target_point.z + enemy:GetBoundingMaxs().z))

					if (not enemy:IsMagicImmune() or pierce_spellimmunity) and (not enemy:IsInvisible() or caster:CanEntityBeSeenByMyTeam(enemy)) then
						
						damage_table.damage	 = damage
						damage_table.victim  = enemy
						ApplyDamage(damage_table)

						Timers:CreateTimer(FrameTime(), function()
							if not enemy:IsAlive() then
								local thundergod_kill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zues_kill_empty.vpcf", PATTACH_WORLDORIGIN, nil)
								ParticleManager:SetParticleControl(thundergod_kill_particle, 0, enemy:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 1, enemy:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 2, enemy:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 3, enemy:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 6, enemy:GetAbsOrigin())
							end
						end)
					end

				enemy:EmitSound("Hero_LegionCommander.Overwhelming.Creep")
			end
		end
	end
end


-------------------------------------------------------------------------------

modifier_legion_odds_buff = class({})

function modifier_legion_odds_buff:IsHidden()
	return false
end

function modifier_legion_odds_buff:IsPurgable()
	return false
end

function modifier_legion_odds_buff:OnCreated( kv )
end

function modifier_legion_odds_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_legion_odds_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("hp_regen") * self:GetStackCount()
end

function modifier_legion_odds_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor") * self:GetStackCount()
end

