LinkLuaModifier("modifier_silencer_infinite_int_lua", "heroes/hero_silencer/silencer_infinite_int_lua/silencer_infinite_int_lua", LUA_MODIFIER_MOTION_NONE)

silencer_infinite_int_lua = class({})

function silencer_infinite_int_lua:GetIntrinsicModifierName()
	return "modifier_silencer_infinite_int_lua"
end

if modifier_silencer_infinite_int_lua == nil then 
    modifier_silencer_infinite_int_lua = class({})
end

function modifier_silencer_infinite_int_lua:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_silencer_infinite_int_lua:OnDeath(params)
    local parent = self:GetParent()
	if self:GetStackCount() < self:GetAbility():GetSpecialValueFor( "max_stack_count" ) then
		if IsMyKilledBadGuys2(parent, params) then
			self:IncrementStackCount()
			parent:CalculateStatBonus(true)
		end
	end
end

function modifier_silencer_infinite_int_lua:GetModifierBonusStats_Intellect(params)
	silencer_bonus_int = self:GetAbility():GetSpecialValueFor( "stack_bonus_int" )
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_silencer_int4")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		silencer_bonus_int = self:GetAbility():GetSpecialValueFor( "stack_bonus_int" ) + 0.1
	end
    return self:GetStackCount() *  silencer_bonus_int + self:GetAbility():GetSpecialValueFor( "bonus_int" )
end

function modifier_silencer_infinite_int_lua:IsHidden()
	return false
end

function modifier_silencer_infinite_int_lua:IsPurgable()
    return false
end
 
function modifier_silencer_infinite_int_lua:RemoveOnDeath()
    return false
end

function modifier_silencer_infinite_int_lua:OnCreated(kv)
end

function IsMyKilledBadGuys2(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS then
        return false
    end
	local attacker = params.attacker
	if hero ~= attacker or attacker:HasModifier("modifier_guild_event") then return false end

	if not _G.excludedUnitsLookup[params.unit:GetUnitName()] then return false end

	return true
end