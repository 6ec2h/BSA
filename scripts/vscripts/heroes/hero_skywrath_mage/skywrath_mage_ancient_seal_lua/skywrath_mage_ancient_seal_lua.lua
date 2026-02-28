skywrath_mage_ancient_seal_lua = class({})
LinkLuaModifier( "modifier_skywrath_mage_ancient_seal_lua", "heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_lua/modifier_skywrath_mage_ancient_seal_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_root", "heroes/generic/modifier_generic_root", LUA_MODIFIER_MOTION_NONE )

function skywrath_mage_ancient_seal_lua:IsHiddenWhenStolen()
	return false
end

function skywrath_mage_ancient_seal_lua:GetAOERadius()
local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_skywrath_mage_int7")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
			return self:GetSpecialValueFor("radius")
		end
	return 0
end

function skywrath_mage_ancient_seal_lua:GetBehavior()
local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_skywrath_mage_int7")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
		end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end


function skywrath_mage_ancient_seal_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self

	
local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_skywrath_mage_int7")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		local radius = ability:GetSpecialValueFor("radius")
		local duration = ability:GetSpecialValueFor("seal_duration")
		local target_point = self:GetCursorPosition()


		local units = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,unit in pairs(units) do
			unit:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_skywrath_mage_ancient_seal_lua", -- modifier name
			{ duration = duration })
		end
		else
		local duration = ability:GetSpecialValueFor("seal_duration")
		local target = self:GetCursorTarget()
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_skywrath_mage_ancient_seal_lua", -- modifier name
			{ duration = duration }	)
		end
end