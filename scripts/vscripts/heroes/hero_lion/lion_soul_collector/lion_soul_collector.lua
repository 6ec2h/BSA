lion_soul_collector = class({})
LinkLuaModifier( "modifier_lion_soul_collector", "heroes/hero_lion/lion_soul_collector/lion_soul_collector", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lion_soul_collector_debuff", "heroes/hero_lion/lion_soul_collector/lion_soul_collector", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function lion_soul_collector:GetIntrinsicModifierName()
	return "modifier_lion_soul_collector"
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

modifier_lion_soul_collector = class({})

function modifier_lion_soul_collector:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_lion_soul_collector:IsPurgable()
	return false
end

function modifier_lion_soul_collector:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_lion_soul_collector:RemoveOnDeath()
	return false
end

function modifier_lion_soul_collector:DestroyOnExpire()
	return false
end

function modifier_lion_soul_collector:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_lion_soul_collector:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_lion_soul_collector:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_lion_soul_collector:OnDeath(params)
    local parent = self:GetParent()

    if parent:PassivesDisabled() or parent:HasModifier("modifier_guild_event") then return end

    if params.unit:IsIllusion() then return end
	
	if not params.unit:FindModifierByNameAndCaster( "modifier_lion_soul_collector_debuff", parent ) then return end

	if not _G.excludedUnitsLookup[params.unit:GetUnitName()] then return end

	count = 1
	local abil = self:GetParent():FindAbilityByName("special_bonus_lion_int10")	
	if abil ~= nil and abil:GetLevel() > 0 then 
		count = 2
	end
	for i = 1, count do
		self:IncrementStackCount()
	end
end


function modifier_lion_soul_collector:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_lion_soul_collector:GetModifierAura()
	return "modifier_lion_soul_collector_debuff"
end

function modifier_lion_soul_collector:GetAuraRadius()
	return self.radius
end

function modifier_lion_soul_collector:GetAuraDuration()
	return 0.5
end

function modifier_lion_soul_collector:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_lion_soul_collector:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_lion_soul_collector:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_lion_soul_collector:IsAuraActiveOnDeath()
	return false
end

function modifier_lion_soul_collector:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity==self:GetCaster() then return true end
	end
	return false
end

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

modifier_lion_soul_collector_debuff = class({})

function modifier_lion_soul_collector_debuff:IsHidden()
	return true
end

function modifier_lion_soul_collector_debuff:IsPurgable()
	return false
endestroyOnExpire()
	return false
end

function modifier_lion_soul_collector:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_lion_soul_collector:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_lion_soul_collector:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_lion_soul_collector:OnDeath(params)
    local parent = self:GetParent()

    if parent:PassivesDisabled() then return end

    if params.unit:IsIllusion() then return end
	
	if not params.unit:FindModifierByNameAndCaster( "modifier_lion_soul_collector_debuff", parent ) then return end

    local excludedUnits = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
	"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
	"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
	"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher", "npc_invoker_creep", "npc_mars_creep", "npc_phoenix_creep"}

    if table.contains(excludedUnits, params.unit:GetUnitName()) then 
		count = 1
		local abil = self:GetParent():FindAbilityByName("special_bonus_lion_int10")	
		if abil ~= nil and abil:GetLevel() > 0 then 
			count = 2
		end
		for i = 1, count do
			self:IncrementStackCount()
		end
	end
end


function modifier_lion_soul_collector:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_lion_soul_collector:GetModifierAura()
	return "modifier_lion_soul_collector_debuff"
end

function modifier_lion_soul_collector:GetAuraRadius()
	return self.radius
end

function modifier_lion_soul_collector:GetAuraDuration()
	return 0.5
end

function modifier_lion_soul_collector:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_lion_soul_collector:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_lion_soul_collector:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_lion_soul_collector:IsAuraActiveOnDeath()
	return false
end

function modifier_lion_soul_collector:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity==self:GetCaster() then return true end
	end
	return false
end

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

modifier_lion_soul_collector_debuff = class({})

function modifier_lion_soul_collector_debuff:IsHidden()
	return true
end

function modifier_lion_soul_collector_debuff:IsPurgable()
	return false
end