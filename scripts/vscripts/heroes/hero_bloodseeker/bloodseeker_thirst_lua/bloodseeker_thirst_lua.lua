LinkLuaModifier( "modifier_bloodseeker_thirst_lua", "heroes/hero_bloodseeker/bloodseeker_thirst_lua/bloodseeker_thirst_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodseeker_thirst_lua_debuff", "heroes/hero_bloodseeker/bloodseeker_thirst_lua/bloodseeker_thirst_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodseeker_thirst_lua_speed", "heroes/hero_bloodseeker/bloodseeker_thirst_lua/bloodseeker_thirst_lua", LUA_MODIFIER_MOTION_NONE )

bloodseeker_thirst_lua = class({})

function bloodseeker_thirst_lua:GetIntrinsicModifierName()
	return "modifier_bloodseeker_thirst_lua"
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

modifier_bloodseeker_thirst_lua = class({})

function modifier_bloodseeker_thirst_lua:IsHidden()
	return true
end

function modifier_bloodseeker_thirst_lua:IsPurgable()
	return false
end

function modifier_bloodseeker_thirst_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_bloodseeker_thirst_lua:RemoveOnDeath()
	return false
end

function modifier_bloodseeker_thirst_lua:DestroyOnExpire()
	return false
end

function modifier_bloodseeker_thirst_lua:OnCreated( kv )
end

function modifier_bloodseeker_thirst_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_bloodseeker_thirst_lua:OnDeath(params)
    local parent = self:GetParent()

    if parent:PassivesDisabled() then return end

    if params.unit:IsIllusion() then return end
	
	if not params.unit:FindModifierByNameAndCaster( "modifier_bloodseeker_thirst_lua_debuff", parent ) then return end

    local excludedUnits = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
	"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
	"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
	"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher", "npc_invoker_creep", "npc_mars_creep", "npc_phoenix_creep"}

    if table.contains(excludedUnits, params.unit:GetUnitName()) then 
	
		self.hp = self:GetAbility():GetSpecialValueFor( "hp" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

		local tal = self:GetCaster():FindAbilityByName("special_bonus_bloodseeker_2")
		if tal and tal:GetLevel() > 0 then
			self.hp = self.hp + 15
		end
		
		parent:Heal(self.hp, parent)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, self.hp, nil)
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_bloodseeker_thirst_lua_speed", { duration = self.duration })
	end
end

function modifier_bloodseeker_thirst_lua:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_bloodseeker_thirst_lua:GetModifierAura()
	return "modifier_bloodseeker_thirst_lua_debuff"
end

function modifier_bloodseeker_thirst_lua:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bloodseeker_thirst_lua:GetAuraDuration()
	return 0.5
end

function modifier_bloodseeker_thirst_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_bloodseeker_thirst_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_bloodseeker_thirst_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_bloodseeker_thirst_lua:IsAuraActiveOnDeath()
	return false
end

function modifier_bloodseeker_thirst_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity==self:GetCaster() then return true end
	end
	return false
end

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

modifier_bloodseeker_thirst_lua_debuff = class({})

function modifier_bloodseeker_thirst_lua_debuff:IsHidden()
	return true
end

function modifier_bloodseeker_thirst_lua_debuff:IsPurgable()
	return false
end

------------------------------------------------------

modifier_bloodseeker_thirst_lua_speed = class({})

function modifier_bloodseeker_thirst_lua_speed:IsHidden()
	return true
end

function modifier_bloodseeker_thirst_lua_speed:IsDebuff()
	return false
end

function modifier_bloodseeker_thirst_lua_speed:IsPurgable()
	return false
end

function modifier_bloodseeker_thirst_lua_speed:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_bloodseeker_thirst_lua_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_bloodseeker_thirst_lua_speed:GetModifierMoveSpeedBonus_Percentage()
	self.ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	local tal = self:GetCaster():FindAbilityByName("special_bonus_bloodseeker_1")
	if tal and tal:GetLevel() > 0 then
		self.ms = self.ms + 3
		return self.ms
	end
	return self.ms
end
