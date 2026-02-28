modifier_axe_enrage_lua = class({})

function modifier_axe_enrage_lua:IsHidden()
	return false
end

function modifier_axe_enrage_lua:IsDebuff()
	return false
end

function modifier_axe_enrage_lua:IsPurgable()
	return false
end

function modifier_axe_enrage_lua:OnCreated()
	if not IsServer() then return end
	
	self:GetCaster():FindAbilityByName("axe_counter_helix_lua"):EndCooldown()
end

function modifier_axe_enrage_lua:GetModifierModelScale()
	return 45
end

function modifier_axe_enrage_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end

function modifier_axe_enrage_lua:GetMinHealth()
	return 1
end

function modifier_axe_enrage_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_axe_enrage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
2
	end
end
end

function modifier_axe_enrage_lua:OnDestroy( kv )
end
--------------------------------------------------------------------------------

function modifier_axe_enrage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_axe_enrage_lua:GetModifierIncomingDamage_Percentage( params )
	return -self.damage_reduction
end

function modifier_axe_enrage_lua:GetModifierModelScale( params )
	return 45
end

function modifier_axe_enrage_lua:GetModifierBonusStats_Strength( params )

	return self.bonus_str
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_axe_enrage_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_axe_enrage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
