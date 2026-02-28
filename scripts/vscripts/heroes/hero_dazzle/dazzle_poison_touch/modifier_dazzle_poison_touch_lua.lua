modifier_dazzle_poison_touch_lua = class({})

function modifier_dazzle_poison_touch_lua:IsHidden()
	return false
end

function modifier_dazzle_poison_touch_lua:IsDebuff()
	return true
end

function modifier_dazzle_poison_touch_lua:IsStunDebuff()
	return false
end

function modifier_dazzle_poison_touch_lua:IsPurgable()
	return true
end

function modifier_dazzle_poison_touch_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_dazzle_poison_touch_lua:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		local damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
		self.duration = kv.duration

		damage_type = DAMAGE_TYPE_PHYSICAL
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str11")~=nil then
			if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str11"):GetLevel() > 0 then 
				damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():GetMaxHealth()/50
			end
		end
		
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = damage_type,
			ability = self:GetAbility(), --Optional.
		}
		self:StartIntervalThink(1)
		self:OnIntervalThink()
	end
end

function modifier_dazzle_poison_touch_lua:OnRefresh( kv )
end

function modifier_dazzle_poison_touch_lua:OnRemoved()
end

function modifier_dazzle_poison_touch_lua:OnDestroy()
end

function modifier_dazzle_poison_touch_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_dazzle_poison_touch_lua:OnAttackLanded( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end
	self:SetDuration( self.duration, true )
end

function modifier_dazzle_poison_touch_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_dazzle_poison_touch_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )
	local sound_cast = "Hero_Dazzle.Poison_Tick"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_dazzle_poison_touch_lua:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf"
end

function modifier_dazzle_poison_touch_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dazzle_poison_touch_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_dazzle_copy.vpcf"
end