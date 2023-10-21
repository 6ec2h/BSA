require('rules')

modifier_item_set_weapon_int_set_2 = class({})

function modifier_item_set_weapon_int_set_2:IsHidden()
	return true
end

function modifier_item_set_weapon_int_set_2:IsPurgable()
	return false
end

function modifier_item_set_weapon_int_set_2:RemoveOnDeath()
	return false
end

function modifier_item_set_weapon_int_set_2:OnCreated( kv )
	self.result = {
		["crit"] = 0,
		["bonus_int"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_weapon_int_set_2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_item_set_weapon_int_set_2:GetModifierBonusStats_Intellect( params )
	return self.result["bonus_int"]
end

function modifier_item_set_weapon_int_set_2:OnTakeDamage( params )
	  if IsServer() then
        if params.attacker ~= self:GetParent() then return end
		if self:GetParent():GetTeamNumber() == params.unit:GetTeamNumber() then return end
        if params.damage_type ~= DAMAGE_TYPE_MAGICAL and params.damage_type ~= DAMAGE_TYPE_PURE and params.inflictor == nil then return end
        if params.damage_flags == DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then return end
		damage = (self.result["crit"] * params.damage / 100)

   		ApplyDamage({
   			victim = params.unit,
   			attacker = params.attacker,
   			damage =  damage - params.damage,
   			damage_type = DAMAGE_TYPE_PURE,
   			-- ability = self:GetAbility(),
   			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
   		})

   		SendOverheadEventMessage( params.attacker, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , params.unit, damage, nil )
	end
	return 0
end