dragon_2_skill = class({})

LinkLuaModifier( "modifier_dragon", "heroes/hero_dragon/dragon_2_skill/modifier_dragon_2_skill", LUA_MODIFIER_MOTION_NONE )

function dragon_2_skill:GetIntrinsicModifierName()
	return "modifier_dragon"
end

