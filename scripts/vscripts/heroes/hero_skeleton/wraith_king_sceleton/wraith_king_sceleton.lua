LinkLuaModifier("modifier_wraith_king_sceleton", "heroes/hero_skeleton/wraith_king_sceleton/wraith_king_sceleton", LUA_MODIFIER_MOTION_NONE)

wraith_king_sceleton = class({})

function wraith_king_sceleton:GetIntrinsicModifierName()
	return "modifier_wraith_king_sceleton"
end

if modifier_wraith_king_sceleton == nil then 
    modifier_wraith_king_sceleton = class({})
end

function modifier_wraith_king_sceleton:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_wraith_king_sceleton:OnDeath(params)
    local parent = self:GetParent()
	if IsMyKilledBadGuys2(parent, params) then
		self:IncrementStackCount()
		parent:CalculateStatBonus(true)
	end
end

function modifier_wraith_king_sceleton:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor( "bonus" )
end

function modifier_wraith_king_sceleton:GetModifierConstantHealthRegen(params)
	silencer_bonus = self:GetAbility():GetSpecialValueFor( "stack_bonus" )
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_skeleton_king_tal1")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
			silencer_bonus = self:GetAbility():GetSpecialValueFor( "stack_bonus" ) + 0.2
		end
    return self:GetStackCount() *  silencer_bonus
end	

function modifier_wraith_king_sceleton:IsHidden()
	return false
end

function modifier_wraith_king_sceleton:IsPurgable()
    return false
end
 
function modifier_wraith_king_sceleton:RemoveOnDeath()
    return false
end

function modifier_wraith_king_sceleton:OnCreated(kv)
end

salo_creeps = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}


function IsMyKilledBadGuys2(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS then
        return false
    end
	local attacker = params.attacker
	local unit_name = params.unit:GetUnitName()
		for _,current_name in pairs(salo_creeps) do
			if current_name == unit_name and hero == attacker then
			return true
		end
	end
end