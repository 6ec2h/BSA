require('rules')

modifier_item_set_weapon_int_set_1 = class({})

function modifier_item_set_weapon_int_set_1:IsHidden()
	return true
end

function modifier_item_set_weapon_int_set_1:IsPurgable()
	return false
end

function modifier_item_set_weapon_int_set_1:RemoveOnDeath()
	return false
end

function modifier_item_set_weapon_int_set_1:OnCreated( kv )
	self.result = {
		["bonus_dmg"] = 0,
		["bonus_life"] = 0,
		["bonus_int"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_weapon_int_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_item_set_weapon_int_set_1:GetModifierSpellAmplify_Percentage( params )
	local level = self:GetCaster():GetIntellect()
	local truedmg = level * self.result["bonus_dmg"]
	return truedmg
end

function modifier_item_set_weapon_int_set_1:GetModifierBonusStats_Intellect( params )
	return self.result["bonus_int"]
end

function modifier_item_set_weapon_int_set_1:OnTakeDamage(keys)
	if keys.attacker:HasModifier("modifier_item_set_weapon_int_set_1") then
		self.parent = self:GetParent()
		if self.parent == keys.attacker and keys.unit ~= self.parent then
			if keys.damage_flags ~= 16 and keys.damage_type ~= 1 then
				self.parent:Heal((keys.original_damage * self.result["bonus_life"])/100, self)
				ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			end
		end
	end
end