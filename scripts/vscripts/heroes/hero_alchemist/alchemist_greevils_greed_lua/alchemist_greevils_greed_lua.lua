alchemist_greevils_greed_lua = class({})
LinkLuaModifier( "modifier_alchemist_greevils_greed_lua", "heroes/hero_alchemist/alchemist_greevils_greed_lua/alchemist_greevils_greed_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_greevils_greed_lua_debuff", "heroes/hero_alchemist/alchemist_greevils_greed_lua/alchemist_greevils_greed_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function alchemist_greevils_greed_lua:GetIntrinsicModifierName()
	return "modifier_alchemist_greevils_greed_lua"
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

modifier_alchemist_greevils_greed_lua = class({})

function modifier_alchemist_greevils_greed_lua:IsHidden()
	return true
end

function modifier_alchemist_greevils_greed_lua:IsPurgable()
	return false
end

function modifier_alchemist_greevils_greed_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_alchemist_greevils_greed_lua:RemoveOnDeath()
	return false
end

function modifier_alchemist_greevils_greed_lua:DestroyOnExpire()
	return false
end

function modifier_alchemist_greevils_greed_lua:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.hero_bonus = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
end

function modifier_alchemist_greevils_greed_lua:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.hero_bonus = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
end

function modifier_alchemist_greevils_greed_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_alchemist_greevils_greed_lua:OnDeath(params)
    local parent = self:GetParent()

    if parent:PassivesDisabled() then return end

    if params.unit:IsIllusion() then return end
	
	if not params.unit:FindModifierByNameAndCaster( "modifier_alchemist_greevils_greed_lua_debuff", parent ) then return end

    local excludedUnits = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
	"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
	"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
	"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher", "npc_invoker_creep", "npc_mars_creep", "npc_phoenix_creep"}

    if table.contains(excludedUnits, params.unit:GetUnitName()) then 
		local heroBonus = self:GetAbility():GetSpecialValueFor("bonus_gold")

		local agiAbility = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi1")
		if agiAbility and agiAbility:GetLevel() > 0 then
			heroBonus = heroBonus * 2
		end

		parent:ModifyGold( heroBonus, true, 0 )
		SendOverheadEventMessage(parent, OVERHEAD_ALERT_GOLD, parent, heroBonus, nil)
		
		self:PlayEffects1()
	end
end

function modifier_alchemist_greevils_greed_lua:PlayEffects1()	
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_alchemist_greevils_greed_lua:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_alchemist_greevils_greed_lua:GetModifierAura()
	return "modifier_alchemist_greevils_greed_lua_debuff"
end

function modifier_alchemist_greevils_greed_lua:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_greevils_greed_lua:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_greevils_greed_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_alchemist_greevils_greed_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_alchemist_greevils_greed_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_alchemist_greevils_greed_lua:IsAuraActiveOnDeath()
	return false
end

function modifier_alchemist_greevils_greed_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity==self:GetCaster() then return true end
	end
	return false
end

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

modifier_alchemist_greevils_greed_lua_debuff = class({})

function modifier_alchemist_greevils_greed_lua_debuff:IsHidden()
	return true
end

function modifier_alchemist_greevils_greed_lua_debuff:IsPurgable()
	return false
end