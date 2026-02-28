boss_ampl = class({})
LinkLuaModifier( "modifier_boss_ampl", "abilities/bosses/boss_ampl", LUA_MODIFIER_MOTION_NONE )

function boss_ampl:GetIntrinsicModifierName()
	return "modifier_boss_ampl"
end

modifier_boss_ampl = class({})

function modifier_boss_ampl:IsHidden()
	return true
end

function modifier_boss_ampl:IsDebuff()
	return false
end

function modifier_boss_ampl:OnCreated( kv )
end

function modifier_boss_ampl:OnRefresh( kv )
end

function modifier_boss_ampl:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_boss_ampl:GetModifierSpellAmplify_Percentage()
	return 150
end
