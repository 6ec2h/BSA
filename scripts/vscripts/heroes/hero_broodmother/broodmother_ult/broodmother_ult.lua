LinkLuaModifier('modifier_broodmother_ult', "heroes/hero_broodmother/broodmother_ult/broodmother_ult", LUA_MODIFIER_MOTION_NONE)

broodmother_ult = class({})

function broodmother_ult:GetIntrinsicModifierName() 
    return 'modifier_broodmother_ult'
end

--------------------------------------------------------------------------

modifier_broodmother_ult = class({})

function modifier_broodmother_ult:IsHidden()
	return false
end

function modifier_broodmother_ult:IsPurgable()
	return false
end

function modifier_broodmother_ult:RemoveOnDeath()
	return false
end

function modifier_broodmother_ult:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.regen = self:GetAbility():GetSpecialValueFor("regen")
	self.ms = self:GetAbility():GetSpecialValueFor("ms")
	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_broodmother_ult:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.regen = self:GetAbility():GetSpecialValueFor("regen")
	self.ms = self:GetAbility():GetSpecialValueFor("ms")
end

function modifier_broodmother_ult:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
	return funcs
end

function modifier_broodmother_ult:OnTooltip()
    return self:GetStackCount() * (self.damage + talent(self:GetCaster())) 
end

function modifier_broodmother_ult:OnTooltip2()
	return self:GetStackCount() * (self.regen + talent(self:GetCaster())) 
end

function modifier_broodmother_ult:OnDeath( params )
	local target = params.unit
	local attacker = params.attacker
	local unit_name = params.unit:GetUnitName()
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			for _,current_name in pairs(brood_creeps) do
				if current_name == unit_name and self:GetParent() == attacker then
					pass = true
				end
			end
		end
	end
	if pass and (not self:GetParent():PassivesDisabled()) then
		self:IncrementStackCount()
	end
end

brood_creeps = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher", "npc_invoker_creep", "npc_mars_creep", "npc_phoenix_creep"}

---------------------------------------------------------

function talent(caster)
	local ability = caster:FindAbilityByName("special_bonus_broodmother_4")
	if ability ~= nil and ability:GetLevel() > 0 then 
		return 0.2
	end
	return 0
end	

function modifier_broodmother_ult:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount() * (self.damage + talent(self:GetCaster())) 
end

function modifier_broodmother_ult:GetModifierConstantHealthRegen()
	return self:GetStackCount() * (self.regen + talent(self:GetCaster())) 
end

function modifier_broodmother_ult:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * (self.ms + talent(self:GetCaster())) 
end

function modifier_broodmother_ult:GetModifierIgnoreMovespeedLimit()
	return 1
end

