LinkLuaModifier('modifier_npc_dota_hero_clinkz_permanent_ability', "heroes/hero_clinkz/clinkz_ult_lua/clinkz_ult_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_clinkz_permanent_ability_effect', "heroes/hero_clinkz/clinkz_ult_lua/clinkz_ult_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_npc_dota_hero_clinkz_permanent_ability_hp', "heroes/hero_clinkz/clinkz_ult_lua/clinkz_ult_lua", LUA_MODIFIER_MOTION_NONE)

clinkz_ult_lua = class({})

function clinkz_ult_lua:GetIntrinsicModifierName() 
    return 'modifier_npc_dota_hero_clinkz_permanent_ability'
end

function clinkz_ult_lua:OnUpgrade()
	self.OnUpgrade = function() end

	if not IsServer() then return end

	self:ToggleAutoCast()
end

-------------------------------------------------------------------------------------------

modifier_npc_dota_hero_clinkz_permanent_ability = class({})

function modifier_npc_dota_hero_clinkz_permanent_ability:IsHidden()
	return true
end

function modifier_npc_dota_hero_clinkz_permanent_ability:OnCreated()
	self:SetStackCount(1)
	self.count = self:GetAbility():GetSpecialValueFor("count")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	local talent = self:GetCaster():FindAbilityByName("special_bonus_clinkz_tal4")
	if talent ~= nil and talent:GetLevel() > 0 then
		self.count = self:GetAbility():GetSpecialValueFor("count") - 1
	end
end

function modifier_npc_dota_hero_clinkz_permanent_ability:OnRefresh()
	self:OnCreated()
end

function modifier_npc_dota_hero_clinkz_permanent_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_npc_dota_hero_clinkz_permanent_ability:OnAttackLanded( params )
	if IsServer() then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end

		if pass then
			self:AddStack()
		end
	end
end

count_archers = {}

function modifier_npc_dota_hero_clinkz_permanent_ability:AddStack()
	local ability = self:GetAbility()
	if not ability:GetAutoCastState() then return end

	if not self:GetParent():PassivesDisabled() then
		if self:GetStackCount() < self.count then
			self:SetStackCount(self:GetStackCount() + 1)
		end
		if self:GetStackCount() == self.count then
			if #count_archers < self:GetAbility():GetSpecialValueFor("archers") then
				local pos = self:GetCaster():GetAbsOrigin() + RandomVector(50)
				local archer = CreateUnitByName("npc_dota_clinkz_skeleton_archer", pos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
				-- range = self:GetParent():Script_GetAttackRange()
				archer:SetControllableByPlayer(self:GetParent():GetPlayerID(), true)
				archer:SetOwner(self:GetParent())
				table.insert(count_archers, archer)
				archer:AddNewModifier(self:GetCaster(), nil, "modifier_npc_dota_hero_clinkz_permanent_ability_effect", {})
				archer:AddNewModifier(self:GetCaster(), nil, "modifier_npc_dota_hero_clinkz_permanent_ability_hp", {})
				archer:AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = self.duration})
				archer:SetForwardVector(self:GetCaster():GetForwardVector())
			end
			self:ResetStack()
		end
	end
end

function modifier_npc_dota_hero_clinkz_permanent_ability:ResetStack()
	if not self:GetParent():PassivesDisabled() then
		self:SetStackCount(1)
	end
end

-------------------------------------------------------------

modifier_npc_dota_hero_clinkz_permanent_ability_effect = class({})

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:IsHidden() return true end
function modifier_npc_dota_hero_clinkz_permanent_ability_effect:IsPurgable() return true end

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:OnCreated()
	if not IsServer() then return end
	self.level = 0
	local caster_abil = self:GetCaster():FindAbilityByName("clinkz_searing_arrows_lua")
	if caster_abil then
		self.level = caster_abil:GetLevel()
	end
	
	local abil = self:GetParent():FindAbilityByName("clinkz_searing_arrows_lua")
	abil:SetLevel(self.level)
	abil:ToggleAutoCast()
	self:SetStackCount(self:GetCaster():GetBaseDamageMin())
end

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
end

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_npc_dota_hero_clinkz_permanent_ability_effect:GetModifierAttackRangeBonus()
    bonusRange = self:GetCaster():Script_GetAttackRange() - 600
    return bonusRange
end

-----------------------------------------------------------------------------------------------------------

modifier_npc_dota_hero_clinkz_permanent_ability_hp = class({})

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:IsDebuff() return false end
function modifier_npc_dota_hero_clinkz_permanent_ability_hp:IsHidden() return true end
function modifier_npc_dota_hero_clinkz_permanent_ability_hp:IsPurgable() return false end

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:OnCreated()
end

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:GetDisableHealing()
    return 1
end

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() then
			local damage = 1
			if self:GetParent():GetHealth() > damage then
				self:GetParent():SetHealth( self:GetParent():GetHealth() - damage)
			else
				self:GetParent():Kill(nil, params.attacker)
			end
		end
	end
end

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:OnDestroy()
    if not IsServer() then return end
	for i, unit in pairs(count_archers) do
		if self:GetParent() == unit then
			table.remove(count_archers, i)
		end
	end
end	

function modifier_npc_dota_hero_clinkz_permanent_ability_hp:OnDeath(keys)
	if not IsServer() then return end
	if self:GetParent() == keys.unit then
		self:Destroy()
	end
end
