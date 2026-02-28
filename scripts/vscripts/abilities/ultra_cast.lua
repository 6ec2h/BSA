ultra_cast = class({})

LinkLuaModifier( "modifier_ultra_cast", "abilities/ultra_cast", LUA_MODIFIER_MOTION_NONE )

function ultra_cast:GetIntrinsicModifierName()
	return "modifier_ultra_cast"
end
----------------------------------------------------------------------------------------------------------------

modifier_ultra_cast = class({})

function modifier_ultra_cast:IsHidden()
	return true
end

function modifier_ultra_cast:IsPurgable()
	return false
end

local function getPlayersCount()
	local count = 0

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero(nPlayerID) then
				count = count + 1
			end
		end
	end

	return count
end

function modifier_ultra_cast:AddNewAbility(abilityName, chance)
	local min = self.abilityChanceMax
	self.abilityChanceMax = self.abilityChanceMax + chance
	local max = self.abilityChanceMax

	table.insert(self.abilityChances, {
		abilityName = abilityName,
		chance = chance,
		min = min,
		max = max,
	})
end

function modifier_ultra_cast:AddNewExtraAbility(abilityName, chance)
	self.extraAbilitiesMap[abilityName] = true

	self:AddNewAbility(abilityName, chance)

	self.extraAbilitiesAdded = true
end

function modifier_ultra_cast:RecalcAbilityChances()
	self.abilityChanceMax = 0

	for _, abilityInfo in ipairs(self.abilityChances) do
		local min = self.abilityChanceMax
		self.abilityChanceMax = self.abilityChanceMax + abilityInfo.chance
		local max = self.abilityChanceMax

		abilityInfo.min = min
		abilityInfo.max = max
	end
end

function modifier_ultra_cast:OnCreated( kv )
	if not IsServer() then return end
	
	self.abilityChances = {}
	self.abilityChanceMax = 0

	self.extraAbilitiesMap = {}
	self.extraAbilitiesAdded = false
	self.extraAbilitiesRemoved = false

	self:AddNewAbility("silencer_global_silence", 10)
	self:AddNewAbility("custom_solar_flare2", 10)
	self:AddNewAbility("thundergods_wrath_datadriven", 10)
	self:AddNewAbility("custom_statick", 10)
	self:AddNewAbility("custom_rosh", 10)
	self:AddNewAbility("custom_stun", 10)
	
	self:AddNewExtraAbility("custom_mine", 10)
	self:AddNewExtraAbility("ultra_cast_sunstrike", 10)

	if getPlayersCount() >= 3 then
		self:AddNewExtraAbility("ultra_cast_spawn_dado", 6)
	end

	self:StartIntervalThink(self:GetRandomInterval())
end

function modifier_ultra_cast:RemoveExtraAbilitiesIfNeed()
	if self.extraAbilitiesRemoved or not self.extraAbilitiesAdded then return end
	if not (_G.Game_Difficulty >= 16 and _G.Game_Difficulty <= 17) then return end
	if not quest_system:QuestIsCompleted("main", 23) then return end

	for i = #self.abilityChances, 1, -1 do
		local abilityInfo = self.abilityChances[i]

		if self.extraAbilitiesMap[abilityInfo.abilityName] then
			table.remove(self.abilityChances, i)
		end
	end

	self.extraAbilitiesMap = {}
	self.extraAbilitiesRemoved = true

	self:RecalcAbilityChances()
end

function modifier_ultra_cast:GetRandomInterval()
	return RandomInt(60, 120)
end

function modifier_ultra_cast:GetRandomAbility()
	local random = RandomInt(0, self.abilityChanceMax - 1)

	for _, abilityInfo in ipairs(self.abilityChances) do
        if random >= abilityInfo.min and random < abilityInfo.max then
            return self:GetCaster():FindAbilityByName(abilityInfo.abilityName)
        end
	end
end

function modifier_ultra_cast:OnIntervalThink()
	self:RemoveExtraAbilitiesIfNeed()

	local ability = self:GetRandomAbility()
	if ability then
		ability:OnSpellStart()
	end
	
	self:StartIntervalThink(-1)
	self:StartIntervalThink(self:GetRandomInterval())
end

function modifier_ultra_cast:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end

function modifier_ultra_cast:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
end

function modifier_ultra_cast:GetModifierProvidesFOWVision()
	return 1
end