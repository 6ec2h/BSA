modifier_axe_enrage_lua = class({})

function HasTalent(unit, talentName)

    if unit:HasAbility(talentName) then
        if unit:FindAbilityByName(talentName):GetLevel() > 0 then return true end
    end
    return false
end

function modifier_axe_enrage_lua:IsHidden()
	return false
end

function modifier_axe_enrage_lua:IsDebuff()
	return false
end

function modifier_axe_enrage_lua:IsPurgable()
	return false
end

function modifier_axe_enrage_lua:OnCreated( kv )
if IsServer() then
	self.caster = self:GetCaster()
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str") * (self.caster:GetStrength()/100)
	self.damage = self:GetCaster():GetAttackDamage()--/2 
	if HasTalent(self:GetCaster(),"special_bonus_axe_3") then
	self.bonus_str = self.bonus_str * 2
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
