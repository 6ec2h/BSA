require('rules')

modifier_item_set_weapon_agi_set_2 = class({})

function modifier_item_set_weapon_agi_set_2:IsHidden()
	return true
end

function modifier_item_set_weapon_agi_set_2:IsPurgable()
	return false
end

function modifier_item_set_weapon_agi_set_2:RemoveOnDeath()
	return false
end

function modifier_item_set_weapon_agi_set_2:OnCreated( kv )
	self.result = {
		["bonus_dmg"] = 0,
		["bonus_agi"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_weapon_agi_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_set_weapon_agi_set_2:GetModifierPreAttack_BonusDamage( params )
	return self.result["bonus_dmg"]
end

function modifier_item_set_weapon_agi_set_2:GetModifierBonusStats_Agility( params )
	return self.result["bonus_agi"]
end

function modifier_item_set_weapon_agi_set_2:OnAttackLanded(keys)
if not IsServer() then return end
	if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() and self:GetParent():IsRangedAttacker() then
		local enemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, keys.target:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		count = 0
		for _,enemy in pairs(enemies) do
			if enemy ~= keys.target and count < 1 then
				ApplyDamage({victim = enemy, attacker = keys.attacker, damage = keys.damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
				count = count + 1
			end
		end
	end
end