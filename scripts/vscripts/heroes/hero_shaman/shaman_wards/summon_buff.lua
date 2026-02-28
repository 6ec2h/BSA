summon_buff = class({})

function summon_buff:Spawn()
	if IsServer() then self:SetLevel(1) end
end

function summon_buff:GetIntrinsicModifierName() return "modifier_summon_buff" end

LinkLuaModifier("modifier_summon_buff", "heroes/hero_shaman/shaman_wards/summon_buff", LUA_MODIFIER_MOTION_NONE)

modifier_summon_buff = class({})

function modifier_summon_buff:IsHidden() return true end
function modifier_summon_buff:IsDebuff() return false end
function modifier_summon_buff:IsPurgable() return false end
function modifier_summon_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_summon_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 	-- GetModifierDamageOutgoing_Percentage
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 	-- GetModifierAttackSpeedBonus_Constant
	}
end

function modifier_summon_buff:OnCreated()
	self:SetHasCustomTransmitterData(true)
	if IsClient() then return end
	
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if (not self.parent) or (not self.ability) or self.parent:IsNull() or self.ability:IsNull() then self:Destroy() return end

	self.owner = self.parent:GetOwner()
	self.exception_power = 1
	local player_owner = self.parent:GetPlayerOwner()

	if (not self.owner) or (not player_owner) or self.owner:IsNull() or player_owner:IsNull() then self:Destroy() return end

	self.hero = (player_owner.GetAssignedHero and player_owner:GetAssignedHero()) or nil

	if (not self.hero) or self.hero:IsNull() then self:Destroy() return end


	Timers:CreateTimer(0.01, function()
		self:OnIntervalThink()
		if self.parent and (not self.parent:IsNull()) then self.parent:SetHealth(self.parent:GetMaxHealth()) end
	end)

	self:StartIntervalThink(1.0)
end

function modifier_summon_buff:OnRefresh()
	if IsClient() then return end
	if not self.parent or self.parent:IsNull() or not self.hero or self.hero:IsNull() or not self.ability or self.ability:IsNull() then return end
	
	self:SetValues()
	
	local agi = self.hero:GetAgility() or 0
	local int = self.hero:GetIntellect() or 0
	local abil_hero = self.hero:FindAbilityByName("shaman_wards_custom")
	local level_abil = abil_hero:GetLevel()

	self.bonus_dmg = math.floor(self.dmg_per_int * int * level_abil)
	self.bonus_as = math.floor(self.as_per_agi * agi * level_abil)	
	self:SendBuffRefreshToClients()
end

function modifier_summon_buff:OnIntervalThink() self:OnRefresh() end


function modifier_summon_buff:SetValues()
	self.as_per_agi = self.ability:GetSpecialValueFor("as_per_agi")
	self.dmg_per_int = self.ability:GetSpecialValueFor("dmg_per_int")
end

function modifier_summon_buff:GetModifierAttackSpeedBonus_Constant() return self.bonus_as end
function modifier_summon_buff:GetModifierPreAttack_BonusDamage() return self.bonus_dmg end

function modifier_summon_buff:AddCustomTransmitterData()
	return {
		bonus_as = self.bonus_as,
		bonus_dmg = self.bonus_dmg,
	}
end

function modifier_summon_buff:HandleCustomTransmitterData(data)
	self.bonus_as = tonumber(data.bonus_as)
	self.bonus_dmg = tonumber(data.bonus_dmg)
end
