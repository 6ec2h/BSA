zuus_thundergods_wrath_lua = class({})

function zuus_thundergods_wrath_lua:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath.PreCast")
	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 0, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 1, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 2, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	return true
end

function zuus_thundergods_wrath_lua:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end

function zuus_thundergods_wrath_lua:OnSpellStart() 
	if IsServer() then
		local caster = self:GetCaster()
		local sight_radius = self:GetSpecialValueFor("sight_radius")
		local sight_duration = self:GetSpecialValueFor("sight_duration")
		local damage = self:GetSpecialValueFor("damage")+ self:GetCaster():ExtraIntelligenceDamage() * self:GetSpecialValueFor("ExtraIntelligenceDamage") 
		local position = self:GetCaster():GetAbsOrigin()	
		local range = self:GetCastRange(position, caster) + caster:GetCastRangeBonus()
		
		if self.thundergod_spell_cast then
			ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
		end

		EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Zuus.GodsWrath", self:GetCaster())

		local damage_table 			= {}
		damage_table.attacker 		= self:GetCaster()
		damage_table.ability 		= self
		damage_table.damage_type 	= self:GetAbilityDamageType() 
		damage_table.damage_flags	= damage_flags
		
		count = 1
		
		local talent = self:GetCaster():FindAbilityByName("special_bonus_zuus_2")
		if talent and talent:GetLevel() > 0 then 
			count = 2
		end
		
		local talent = self:GetCaster():FindAbilityByName("special_bonus_zuus_5")
		if talent and talent:GetLevel() > 0 then 
			damage = damage + 500
		end
		
		Timers:CreateTimer(0, function()
			count = count - 1
			local hEnemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			for _,enemy in pairs(hEnemies) do 
				if enemy:IsAlive() then 
					local target_point = enemy:GetAbsOrigin()
					local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
					ParticleManager:SetParticleControl(thundergod_strike_particle, 0, Vector(target_point.x, target_point.y, target_point.z + enemy:GetBoundingMaxs().z))
					ParticleManager:SetParticleControl(thundergod_strike_particle, 1, Vector(target_point.x, target_point.y, 2000))
					ParticleManager:SetParticleControl(thundergod_strike_particle, 2, Vector(target_point.x, target_point.y, target_point.z + enemy:GetBoundingMaxs().z))

					if not enemy:IsMagicImmune() and not enemy:IsInvisible() then
						damage_table.damage	 = damage
						damage_table.victim  = enemy
						ApplyDamage(damage_table)
						
						AddFOWViewer(caster:GetTeamNumber(), target_point, sight_radius, sight_duration, false )

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
					enemy:EmitSound("Hero_Zuus.GodsWrath.Target")
				end
			end
			if count > 0 then
				return 0.5
			else
				return nil
			end	
		end)
	end
end