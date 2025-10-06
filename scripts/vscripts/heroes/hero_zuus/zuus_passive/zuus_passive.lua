LinkLuaModifier( "modifier_zuus_passive", "heroes/hero_zuus/zuus_passive/zuus_passive", LUA_MODIFIER_MOTION_NONE )

zuus_passive = class({})

function zuus_passive:GetCastRange()
	self.radius = self:GetSpecialValueFor("radius")
	local talent = self:GetCaster():FindAbilityByName("special_bonus_zuus_7")
	if talent and talent:GetLevel() > 0 then 
		self.radius = self.radius + 200
	end
	return self.radius - self:GetCaster():GetCastRangeBonus()
end

function zuus_passive:GetIntrinsicModifierName()
	return "modifier_zuus_passive"
end

--------------------

modifier_zuus_passive = class({})

function modifier_zuus_passive:IsHidden()
	return true
end

function modifier_zuus_passive:IsPurgable()
	return false
end

function modifier_zuus_passive:OnCreated( kv )
	if IsServer() then 
		Timers:CreateTimer(0, function()
			cast_time = 3 
			if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			local talent = self:GetCaster():FindAbilityByName("special_bonus_zuus_1")
			if talent and talent:GetLevel() > 0 then 
				cast_time = 2
			end
			
			self:GetAbility():StartCooldown(cast_time)
		
			self.damage_per_int = self:GetAbility():GetSpecialValueFor( "dmg_per_int" )
		
			local talent = self:GetCaster():FindAbilityByName("special_bonus_zuus_3")
			if talent and talent:GetLevel() > 0 then 
				self.damage_per_int = self.damage_per_int + 0.2
			end
			
			local damage = self.damage_per_int * self:GetCaster():GetIntellect(true)
	
			local talent = self:GetCaster():FindAbilityByName("special_bonus_zuus_3")
			if talent and talent:GetLevel() > 0 then 
				self.damage_per_int = self.damage_per_int + 0.2
			end
			
			local position = self:GetCaster():GetAbsOrigin()
			
			local radius = self:GetAbility():GetSpecialValueFor("radius")
			local talent = self:GetCaster():FindAbilityByName("special_bonus_zuus_7")
			if talent and talent:GetLevel() > 0 then 
				radius = radius + 200
			end
			
			local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			if #hEnemies > 0 then
				for _,unit in pairs(hEnemies) do
				damage_flags = DOTA_DAMAGE_FLAG_NONE
					local damage = {
					victim = unit,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = damage_flags,
					ability = ability
				}
				ApplyDamage( damage )
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
					ParticleManager:SetParticleControl(particle,0,unit:GetAbsOrigin())
					EmitSoundOn("Hero_Zuus.StaticField", unit)
					end	
				end
			end
			return cast_time
		end)
	end
end