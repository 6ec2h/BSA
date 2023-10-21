cooldown_lua = class({})
LinkLuaModifier( "modifier_cooldown_lua", "abilities/bosses/cooldown", LUA_MODIFIER_MOTION_NONE )

function cooldown_lua:GetIntrinsicModifierName()
	return "modifier_cooldown_lua"
end

modifier_cooldown_lua = class({})

function modifier_cooldown_lua:IsHidden()
	return true
end

function modifier_cooldown_lua:IsDebuff()
	return false
end

function modifier_cooldown_lua:OnCreated( kv )
end

function modifier_cooldown_lua:OnRefresh( kv )
end

function modifier_cooldown_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function modifier_cooldown_lua:GetModifierPercentageCooldown()
 return 80
end

