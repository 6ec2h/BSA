require("data")
blob_die_spawn = class({})

LinkLuaModifier("modifier_blob_die_spawn", "abilities/creeps/blob_die_spawn", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_blob_die_spawn_effect", "abilities/creeps/blob_die_spawn", LUA_MODIFIER_MOTION_VERTICAL)

function blob_die_spawn:GetIntrinsicModifierName()
	return "modifier_blob_die_spawn"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_blob_die_spawn = class({})

function modifier_blob_die_spawn:IsHidden()
	return true
end

function modifier_blob_die_spawn:IsPurgable()
	return false
end

function modifier_blob_die_spawn:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_blob_die_spawn:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, enemy in pairs(enemies) do			
					enemy:AddNewModifier(enemy, nil, "modifier_blob_die_spawn_effect", { duration = 3})
				end
			for i = 1, 4 do
				local unit = CreateUnitByName("npc_mini_blob", self:GetParent():GetAbsOrigin()+ RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
				local random_ability = passive[RandomInt(1,#passive)]
				rules:aura_dif(unit,random_ability)
			end
		end
	end
end

--------------------------------------------------------------------------------------

modifier_blob_die_spawn_effect = class({})				
				
function modifier_blob_die_spawn:IsHidden() return false end				
function modifier_blob_die_spawn_effect:IsDebuff() return true end
function modifier_blob_die_spawn_effect:IsPurgable() return false end

function modifier_blob_die_spawn_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
end

function modifier_blob_die_spawn_effect:GetModifierMiss_Percentage()
	return 75
end