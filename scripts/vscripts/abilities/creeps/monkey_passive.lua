monkey_passive = class({})

LinkLuaModifier( "modifier_monkey_passive", "abilities/creeps/monkey_passive", LUA_MODIFIER_MOTION_NONE )

function monkey_passive:GetIntrinsicModifierName()
	return "modifier_monkey_passive"
end

--------------------------------------------------------------------------------------

modifier_monkey_passive = class({})

function modifier_monkey_passive:IsHidden()
	return true
end

function modifier_monkey_passive:IsPurgable()
	return false
end

function modifier_monkey_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

function modifier_monkey_passive:GetActivityTranslationModifiers( params )
	return "run"
end
