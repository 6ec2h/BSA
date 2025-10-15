LinkLuaModifier("modifier_battlemage_arsenal","items/custom_items/item_battlemage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_battlemage_arsenal_attack_buff","items/custom_items/item_battlemage", LUA_MODIFIER_MOTION_NONE)

item_battlemage = item_battlemage or class({})
item_battlemage_2 = item_battlemage or class({})
item_battlemage_3 = item_battlemage or class({})

function item_battlemage:GetIntrinsicModifierName()
    return "modifier_battlemage_arsenal"
end

function item_battlemage:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_battlemage_arsenal_attack_buff", {
		duration = self:GetSpecialValueFor("duration")
	}):SetStackCount(self:GetSpecialValueFor("hits"))
		
    EmitSoundOn("Item.Brooch.Cast", caster)
end

-------------------------------------------------------------------------------------------

modifier_battlemage_arsenal = class({})

function modifier_battlemage_arsenal:IsHidden()
	return true
end

function modifier_battlemage_arsenal:IsPurgable()
	return false
end

function modifier_battlemage_arsenal:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS, --GetModifierHealthBonus
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, --GetModifierConstantManaRegen
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    }
    return funcs
end

function modifier_battlemage_arsenal:OnCreated()
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")
end

function modifier_battlemage_arsenal:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_battlemage_arsenal:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_battlemage_arsenal:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_battlemage_arsenal:GetModifierSpellAmplify_Percentage()
    return self.bonus_spell_amp
end

function modifier_battlemage_arsenal:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end

function modifier_battlemage_arsenal:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_battlemage_arsenal:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_battlemage_arsenal:GetModifierProjectileSpeedBonus()
	return self.projectile_speed
end

-------------------------------------------------------------------------------------------

modifier_battlemage_arsenal_attack_buff = class({})

function modifier_battlemage_arsenal_attack_buff:IsHidden()
	return false
end

function modifier_battlemage_arsenal_attack_buff:IsPurgable()
	return false
end

function modifier_battlemage_arsenal_attack_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_battlemage_arsenal_attack_buff:GetModifierTotalDamageOutgoing_Percentage( params )
	if params.inflictor then return 0 end
	if params.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
	if params.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end

	if self:GetStackCount() > 0 then
		self:DecrementStackCount()
		if not params.target:IsMagicImmune() then
			local damageTable = {
				victim = params.target,
				attacker = self:GetParent(),
				damage = params.original_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			}
			ApplyDamage( damageTable )
			EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact", params.target )
		else
			EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact.MagicImmune", params.target )
		end
		if self:GetStackCount() == 0 then
			self:Destroy()
		end
	end
	return -200
end

function modifier_battlemage_arsenal_attack_buff:GetOverrideAttackMagical()
    return 1
end

function modifier_battlemage_arsenal_attack_buff:GetModifierProjectileName()
    return "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf"
end

function modifier_battlemage_arsenal_attack_buff:GetEffectName()
    return "particles/items5_fx/revenant_brooch.vpcf"
end