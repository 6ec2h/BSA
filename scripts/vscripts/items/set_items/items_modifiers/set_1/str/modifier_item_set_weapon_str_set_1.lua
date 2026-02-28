require('rules')

modifier_item_set_weapon_str_set_1 = class({})

function modifier_item_set_weapon_str_set_1:IsHidden()
	return true
end

function modifier_item_set_weapon_str_set_1:IsPurgable()
	return false
end

function modifier_item_set_weapon_str_set_1:RemoveOnDeath()
	return false
end

function modifier_item_set_weapon_str_set_1:OnCreated( kv )
	self.result = {
		["bonus_dmg"] = 0,
		["bonus_life"] = 0,
		["bonus_str"] = 0,
	}
	item_name = self:GetAbility():GetName()
	rules:GetItemValues(item_name, self)
end

function modifier_item_set_weapon_str_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_set_weapon_str_set_1:GetModifierPreAttack_BonusDamage( params )
	return self.result["bonus_dmg"]
end

function modifier_item_set_weapon_str_set_1:GetModifierBonusStats_Strength( params )
	return self.result["bonus_str"]
end

function modifier_item_set_weapon_str_set_1:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
				pass = true
			end
		end
		if pass then
			self.attack_record = params.record
		end
	end
end

function modifier_item_set_weapon_str_set_1:OnTakeDamage( params )
	if IsServer() then
		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end
		if pass then
			local heal = params.damage * self.result["bonus_life"]/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

function modifier_item_set_weapon_str_set_1:PlayEffects( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end