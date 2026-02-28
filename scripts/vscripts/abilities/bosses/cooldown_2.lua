cooldown_2_lua = class({})
LinkLuaModifier( "modifier_cooldown_2_lua", "abilities/bosses/cooldown_2", LUA_MODIFIER_MOTION_NONE )

function cooldown_2_lua:GetIntrinsicModifierName()
	return "modifier_cooldown_2_lua"
end

modifier_cooldown_2_lua = class({})

function modifier_cooldown_2_lua:IsHidden()
	return true
end

function modifier_cooldown_2_lua:IsDebuff()
	return false
end

function modifier_cooldown_2_lua:OnCreated( kv )
end

function modifier_cooldown_2_lua:OnRefresh( kv )
end

function modifier_cooldown_2_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function modifier_cooldown_2_lua:GetModifierPercentageCooldown()
 return 60
end
