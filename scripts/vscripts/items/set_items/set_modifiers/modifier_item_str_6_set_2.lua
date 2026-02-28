modifier_item_str_6_set_2 = class({})

function modifier_item_str_6_set_2:IsHidden()
	return true
end

function modifier_item_str_6_set_2:IsPurgable()
	return false
end

function modifier_item_str_6_set_2:RemoveOnDeath()
	return false
end

function modifier_item_str_6_set_2:OnCreated( kv )
end


function modifier_item_str_6_set_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_str_6_set_2:OnCreated()
	if not IsServer() then return end
end

function modifier_item_str_6_set_2:OnTakeDamage(params)
	if not IsServer() then return end
	if params.unit == self:GetParent() and not params.attacker:IsBuilding() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and params.damage_type == 1 then
		local damage = 100 + (params.damage / 100 * 10)

		ApplyDamage({
			victim = params.attacker,
			attacker = params.unit,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		})
	end
end