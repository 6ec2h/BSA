LinkLuaModifier("modifier_hero_destroyer_second_skill_hp", "heroes/hero_destroyer/second_skill/second_skill_hp", LUA_MODIFIER_MOTION_NONE)

hero_destroyer_second_skill_hp = class({})

function hero_destroyer_second_skill_hp:GetIntrinsicModifierName()
	return "modifier_hero_destroyer_second_skill_hp"
end

function hero_destroyer_second_skill_hp:OnSpellStart()
print("c")
	self.level = self:GetLevel()
	self:GetCaster():AddAbility("hero_destroyer_second_skill_armor"):SetLevel(self.level)
	self:GetCaster():SwapAbilities("hero_destroyer_second_skill_hp", "hero_destroyer_second_skill_armor", true, true)
	self:GetCaster():RemoveAbility("hero_destroyer_second_skill_hp")
end

-------------------------------------------------------------------------------------------

modifier_hero_destroyer_second_skill_hp = class({})

function modifier_hero_destroyer_second_skill_hp:IsHidden()
	return false
end

function modifier_hero_destroyer_second_skill_hp:IsPurgable()
	return false
end

function modifier_hero_destroyer_second_skill_hp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_hero_destroyer_second_skill_hp:GetModifierHealthRegenPercentage()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor("regen")
	end
end

function modifier_hero_destroyer_second_skill_hp:GetModifierProcAttack_Feedback( params )
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

function modifier_hero_destroyer_second_skill_hp:OnTakeDamage( params )
	if IsServer() then
		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end

		if pass then
			local heal = params.damage * self:GetAbility():GetSpecialValueFor("lifesteal")/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

function modifier_hero_destroyer_second_skill_hp:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
