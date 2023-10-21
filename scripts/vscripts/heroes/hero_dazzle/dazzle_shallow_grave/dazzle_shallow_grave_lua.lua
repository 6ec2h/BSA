dazzle_shallow_grave_lua = class({})
LinkLuaModifier( "modifier_dazzle_shallow_grave_lua", "heroes/hero_dazzle/dazzle_shallow_grave/dazzle_shallow_grave_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dazzle_resist", "heroes/hero_dazzle/dazzle_shallow_grave/dazzle_shallow_grave_lua", LUA_MODIFIER_MOTION_NONE )

function dazzle_shallow_grave_lua:IsHiddenWhenStolen()
	return false
end

function dazzle_shallow_grave_lua:GetAOERadius()
local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str8")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		return self:GetSpecialValueFor("radius")
	end
	return 0
end

function dazzle_shallow_grave_lua:GetBehavior()
local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str8")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
			return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
		end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end



function dazzle_shallow_grave_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str8")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		
		local target_point = self:GetCursorPosition()



		local units = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,unit in pairs(units) do
			unit:AddNewModifier(caster, ability, "modifier_dazzle_shallow_grave_lua", {duration = duration})
			
				if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str7")~=nil then 
					if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str7"):GetLevel() > 0 then 
					Timers:CreateTimer(duration, function()
						unit:AddNewModifier(caster, ability, "modifier_dazzle_resist", {duration = 2})	
					end)	
				end
			end
		end
		
		else
		
		target = self:GetCursorTarget()
		target:AddNewModifier(caster, ability, "modifier_dazzle_shallow_grave_lua", {duration = duration})			
		end
	
	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str7")~=nil then
			if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str7"):GetLevel() > 0 then 
				Timers:CreateTimer(duration, function()
				target:AddNewModifier(caster, ability, "modifier_dazzle_resist", {duration = 2})	
			end)	
		end
	end
end


modifier_dazzle_shallow_grave_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dazzle_shallow_grave_lua:IsHidden()
	return false
end

function modifier_dazzle_shallow_grave_lua:IsDebuff()
	return false
end

function modifier_dazzle_shallow_grave_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dazzle_shallow_grave_lua:OnCreated( kv )
		local sound_cast = "Hero_Dazzle.Shallow_Grave"
		self.hp = self:GetAbility():GetSpecialValueFor("hp")
		EmitSoundOn( sound_cast, self:GetParent() )
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dazzle_shallow_grave_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end
function modifier_dazzle_shallow_grave_lua:GetMinHealth()
	return 1
end

function modifier_dazzle_shallow_grave_lua:GetModifierHealthRegenPercentage()

	return self.hp

end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dazzle_shallow_grave_lua:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf"
end

function modifier_dazzle_shallow_grave_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------


modifier_dazzle_resist = class({})

function modifier_dazzle_resist:IsHidden()
	return false
end

function modifier_dazzle_resist:IsPurgable()
	return false
end

function modifier_dazzle_resist:OnCreated( kv )
end

function modifier_dazzle_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end


function modifier_dazzle_resist:GetModifierMagicalResistanceBonus()
	return 25
end