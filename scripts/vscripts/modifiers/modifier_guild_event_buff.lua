LinkLuaModifier( "modifier_guild_event_buff_debuff", "modifiers/modifier_guild_event_buff", LUA_MODIFIER_MOTION_NONE)

modifier_guild_event_buff = class({})

function modifier_guild_event_buff:IsHidden()		return true end
function modifier_guild_event_buff:IsPurgable()		return false end
function modifier_guild_event_buff:RemoveOnDeath()	return false end
function modifier_guild_event_buff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_guild_event_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_guild_event_buff:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end
		local stack = self:GetStackCount()
		mod = target:AddNewModifier(owner, nil, "modifier_guild_event_buff_debuff", {})
		if mod:GetStackCount() < stack then
			mod:SetStackCount(stack)
		end
	end
end

---------------------------------------------

modifier_guild_event_buff_debuff = class({})

function modifier_guild_event_buff_debuff:IsHidden() return false end
function modifier_guild_event_buff_debuff:IsDebuff() return true end
function modifier_guild_event_buff_debuff:IsPurgable() return true end

function modifier_guild_event_buff_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_guild_event_buff_debuff:GetModifierPhysicalArmorBonus()
	return -self:GetStackCount() / 10
end

function modifier_guild_event_buff_debuff:GetModifierMagicalResistanceBonus()
	return -self:GetStackCount() / 10
end