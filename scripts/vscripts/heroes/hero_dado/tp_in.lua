LinkLuaModifier( "modifier_dado_tp_mana", "heroes/hero_dado/tp_in.lua", LUA_MODIFIER_MOTION_NONE )

dado_tp = class({})

function dado_tp:GetIntrinsicModifierName()
	return "modifier_dado_tp_mana"
end

function dado_tp:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	EmitSoundOn("Hero_Enigma.Black_Hole.Stop", caster )
	unit = CreateUnitByName("tp_in", position, true, caster, nil, caster:GetTeamNumber())
	unit:AddNewModifier( unit, nil, "modifier_kill", {duration = self:GetSpecialValueFor("dur")})
end

-----------------------------

modifier_dado_tp_mana = class({})

function modifier_dado_tp_mana:IsHidden() return true end
function modifier_dado_tp_mana:IsPurgable() return false end

function modifier_dado_tp_mana:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_dado_tp_mana:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("mana")
end	