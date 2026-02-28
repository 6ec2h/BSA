require("data")
zombie_spawn = class({})

LinkLuaModifier("modifier_zombie_spawn", "abilities/creeps/zombie_spawn", LUA_MODIFIER_MOTION_VERTICAL)

function zombie_spawn:GetIntrinsicModifierName()
	return "modifier_zombie_spawn"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_zombie_spawn = class({})

function modifier_zombie_spawn:IsHidden()
	return true
end

function modifier_zombie_spawn:IsPurgable()
	return false
end

function modifier_zombie_spawn:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_zombie_spawn:OnIntervalThink()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() and self:GetParent():IsAlive() then
			local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			if #hEnemies > 0 then
				local unit = CreateUnitByName("forest_fat_zombie", self:GetParent():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
				unit:AddNewModifier(unit, nil, "modifier_kill", {duration = 10})
				local random_ability = passive[RandomInt(1,#passive)]
				rules:aura_dif(unit,random_ability)
				self:GetAbility():UseResources( false,false, false, true )
			end	
		end
	end
end