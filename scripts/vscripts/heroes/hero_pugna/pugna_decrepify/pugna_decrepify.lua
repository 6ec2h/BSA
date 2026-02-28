pugna_decrepify_lua = class({})
LinkLuaModifier("modifier_decrepify_lua", "heroes/hero_pugna/pugna_decrepify/pugna_decrepify.lua", LUA_MODIFIER_MOTION_NONE)

function pugna_decrepify_lua:IsHiddenWhenStolen()
	return false
end

function pugna_decrepify_lua:GetAOERadius()
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int8")
		if ability ~= nil and ability:GetLevel() > 0 then
			return self:GetSpecialValueFor("radius")
	end
	return 0
end

function pugna_decrepify_lua:GetBehavior()
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int8")
		if ability ~= nil and ability:GetLevel() > 0 then
			return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
		end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function pugna_decrepify_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius") 
	EmitSoundOn("Hero_Pugna.Decrepify", self:GetCaster())
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int8")
	
	if ability ~= nil and ability:GetLevel() > 0 then
		local target_point = self:GetCursorPosition()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			unit:AddNewModifier(caster, self, "modifier_decrepify_lua", {duration = duration})
		end
	else

	local target = self:GetCursorTarget()
		target:AddNewModifier(caster, self, "modifier_decrepify_lua", {duration = duration})	
	end
end


-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

modifier_decrepify_lua = class({})

function modifier_decrepify_lua:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_decrepify_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_decrepify_lua:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self.particle_pre_blast = "particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf"
	self.particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	self.ally_res_reduction_pct = self.ability:GetSpecialValueFor("ally_res_reduction_pct")
	self.enemy_res_reduction_pct = self.ability:GetSpecialValueFor("enemy_res_reduction_pct")
	self.enemy_slow_pct = self.ability:GetSpecialValueFor("enemy_slow_pct")

	if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
		self.is_ally = true
	else
		self.is_ally = false
	end

	if IsServer() then
		self.damage_stored = 0
	end
end

function modifier_decrepify_lua:OnRefresh()
	if IsServer() then
		self:OnDestroy()
		self.damage_stored = 0
	end
end

function modifier_decrepify_lua:IsHidden() return false end
function modifier_decrepify_lua:IsPurgable() return true end

function modifier_decrepify_lua:IsDebuff()
	if self.is_ally then
		return false
	else
		return true
	end
end


function modifier_decrepify_lua:CheckState()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_agi7")
	if abil ~= nil	and abil:GetLevel() > 0 then 
		if not self.is_ally then
			return {
				[MODIFIER_STATE_ATTACK_IMMUNE]	= true,
				[MODIFIER_STATE_DISARMED]		= true
			}
		end
		if self.is_ally then
			return {
				[MODIFIER_STATE_ATTACK_IMMUNE]	= false,
				[MODIFIER_STATE_DISARMED]		= false
			}
		end
	end
	return {
				[MODIFIER_STATE_ATTACK_IMMUNE]	= true,
				[MODIFIER_STATE_DISARMED]		= true
			}
end

function modifier_decrepify_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_decrepify_lua:GetModifierMagicalResistanceBonus()
	if self.is_ally then
		return self.ally_res_reduction_pct * (-1)
	else
		return self.enemy_res_reduction_pct * (-1)
	end
end

function modifier_decrepify_lua:GetModifierMoveSpeedBonus_Percentage()
	if self.is_ally then
		return nil
	else
		return self.enemy_slow_pct * (-1)
	end
end

function modifier_decrepify_lua:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_decrepify_lua:OnTakeDamage(keys)
	-- Only apply if the unit taking damage is the parent of this modifier
	if keys.unit == self:GetParent() then
		-- Add the current damage to the damage stored
		self.damage_stored = self.damage_stored + keys.damage
	end
end
