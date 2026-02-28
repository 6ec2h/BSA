require("data")
summon_lord = class({})

LinkLuaModifier("modifier_summon_lord", "abilities/creeps/summon_lord", LUA_MODIFIER_MOTION_VERTICAL)

function summon_lord:GetIntrinsicModifierName()
	return "modifier_summon_lord"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_summon_lord = class({})

function modifier_summon_lord:IsHidden()
	return true
end

function modifier_summon_lord:IsPurgable()
	return false
end

function modifier_summon_lord:OnCreated( kv )
	self:StartIntervalThink(0.3)
end

function modifier_summon_lord:OnIntervalThink()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() and self:GetParent():IsAlive() then
			local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
				if #hEnemies > 0 then
				local unit = CreateUnitByName("zombie_"..self:GetParent():GetUnitName(), self:GetParent():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
				Timers:CreateTimer({endTime = 10, callback = function()
					UTIL_Remove(unit)
				end})
				local random_ability = passive[RandomInt(1,#passive)]
				rules:aura_dif(unit,random_ability)
				self:GetAbility():UseResources( false,false, false, true )
			end	
		end
	end
end