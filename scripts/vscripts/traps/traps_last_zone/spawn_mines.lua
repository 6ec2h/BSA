require("data")
mines_spawn = class({})

LinkLuaModifier("modifier_mines_spawn", "traps/traps_last_zone/spawn_mines.lua", LUA_MODIFIER_MOTION_VERTICAL)

function mines_spawn:GetIntrinsicModifierName()
	return "modifier_mines_spawn"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_mines_spawn = class({})

function modifier_mines_spawn:IsHidden()
	return true
end

function modifier_mines_spawn:IsPurgable()
	return false
end

function modifier_mines_spawn:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_mines_spawn:OnIntervalThink()
	if IsServer() then
		if _G.last_zone_traps_active then
			if self:GetAbility():IsCooldownReady() and self:GetParent():IsAlive() then
				local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
				if #hEnemies > 0 then
					local unit = CreateUnitByName("land_mine", self:GetParent():GetAbsOrigin() + RandomVector( RandomInt(  RandomInt( 200, 200 ),  RandomInt( 200, 200 ) )), true, nil, nil, DOTA_TEAM_NEUTRALS)
					unit:AddNewModifier(unit, nil, "modifier_kill", {duration = 6})
					local random_ability = passive[RandomInt(1,#passive)]
					rules:aura_dif(unit,random_ability)
					self:GetAbility():UseResources( false,false, false, true )
				end	
			end
		end
	end
end