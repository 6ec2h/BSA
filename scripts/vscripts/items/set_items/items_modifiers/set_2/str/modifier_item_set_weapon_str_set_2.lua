require('rules')

LinkLuaModifier( "modifier_item_set_weapon_str_set_2_slow", "items/set_items/items_modifiers/set_2/str/modifier_item_set_weapon_str_set_2", LUA_MODIFIER_MOTION_NONE )

modifier_item_set_weapon_str_set_2 = class({})

function modifier_item_set_weapon_str_set_2:IsHidden()
	return true
end

function modifier_item_set_weapon_str_set_2:IsPurgable()
	return false
end

function modifier_item_set_weapon_str_set_2:RemoveOnDeath()
	return false
end

function modifier_item_set_weapon_str_set_2:OnCreated( kv )
	self.result = {
		["bonus_dmg"] = 0,
		["bonus_any"] = 0,
		["slow"] = 0,
	}
	self.item_name = self:GetAbility():GetName()
	rules:GetItemValues(self.item_name, self)
end

function modifier_item_set_weapon_str_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_set_weapon_str_set_2:GetModifierPreAttack_BonusDamage( params )
	return self.result["bonus_dmg"]
end

function modifier_item_set_weapon_str_set_2:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and not self:GetParent():IsRangedAttacker() then
			params.target:AddNewModifier(self:GetParent(), self, "modifier_item_set_weapon_str_set_2_slow", { duration = 2 } )
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.target:GetOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				if enemy ~= params.target then
					local damageTable = {
					victim = enemy,
					attacker = self:GetParent(),
					damage = params.damage/100*self.result["bonus_any"],
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					}
					ApplyDamage(damageTable)
				end
			end
		end
	end
end

------------------------------------------------------------------


modifier_item_set_weapon_str_set_2_slow = class({})

function modifier_item_set_weapon_str_set_2_slow:IsHidden()
	return true
end

function modifier_item_set_weapon_str_set_2_slow:OnCreated( params )
end

function modifier_item_set_weapon_str_set_2_slow:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_set_weapon_str_set_2_slow:GetModifierMoveSpeedBonus_Percentage()
	return -25
end	