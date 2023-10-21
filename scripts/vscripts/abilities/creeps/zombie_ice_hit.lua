zombie_ice_hit = class({})

LinkLuaModifier("modifier_zombie_ice_hit", "abilities/creeps/zombie_ice_hit", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_movespeed_slow", "abilities/creeps/zombie_ice_hit", LUA_MODIFIER_MOTION_VERTICAL)

function zombie_ice_hit:GetIntrinsicModifierName()
	return "modifier_zombie_ice_hit"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_zombie_ice_hit = class({})

function modifier_zombie_ice_hit:IsHidden()
	return true
end

function modifier_zombie_ice_hit:IsPurgable()
	return false
end


function modifier_zombie_ice_hit:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_zombie_ice_hit:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end
			if not target:HasModifier("modifier_movespeed_slow") then
			target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_movespeed_slow", {duration = 2})
		end	
	end
end

-----------------------------------------------------------------------------------------

modifier_movespeed_slow = class({})

function modifier_movespeed_slow:IsHidden()
	return false
end

function modifier_movespeed_slow:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE  }
end

function modifier_movespeed_slow:GetTexture()
    return "zombie_ice_hit"
end

function modifier_movespeed_slow:GetModifierMoveSpeedBonus_Percentage ()
		return -35
end

function modifier_movespeed_slow:RemoveOnDeath()
	return true
end