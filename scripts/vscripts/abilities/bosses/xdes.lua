xdes_lua = class({})
LinkLuaModifier( "modifier_xdes_lua", "abilities/bosses/xdes", LUA_MODIFIER_MOTION_NONE )

function xdes_lua:GetIntrinsicModifierName()
	return "modifier_xdes_lua"
end

modifier_xdes_lua = class({})

function modifier_xdes_lua:IsHidden()
	return true
end

function modifier_xdes_lua:IsDebuff()
	return false
end

function modifier_xdes_lua:OnCreated( kv )
end

function modifier_xdes_lua:OnRefresh( kv )
end

function modifier_xdes_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_xdes_lua:GetModifierSpellAmplify_Percentage()
if self:GetParent():GetUnitName() == "npc_xdes" then return 600 end
	return 300
end
