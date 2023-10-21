temple_guardian_passive = class({})
LinkLuaModifier( "modifier_temple_guardian_passive",  "abilities/bosses/guard/temple_guardian_passive", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function temple_guardian_passive:GetIntrinsicModifierName()
	return "modifier_temple_guardian_passive"
end

-----------------------------------------------------------------------------------------

modifier_temple_guardian_passive = class({})

function modifier_temple_guardian_passive:IsHidden()
	return true
end

function modifier_temple_guardian_passive:IsPurgable()
	return false
end

function modifier_temple_guardian_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end

function modifier_temple_guardian_passive:GetModifierMoveSpeed_Absolute( params )
	return 300
end
