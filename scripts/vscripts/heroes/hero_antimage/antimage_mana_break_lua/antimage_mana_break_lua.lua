antimage_mana_break_lua = class({})
LinkLuaModifier( "modifier_antimage_mana_break_lua", "heroes/hero_antimage/antimage_mana_break_lua/antimage_mana_break_lua", LUA_MODIFIER_MOTION_NONE )

function antimage_mana_break_lua:GetIntrinsicModifierName()
	return "modifier_antimage_mana_break_lua"
end

----------------------------------------------------------------

modifier_antimage_mana_break_lua = class({})

function modifier_antimage_mana_break_lua:IsHidden()
	return true
end

function modifier_antimage_mana_break_lua:IsPurgable()
	return false
end

function modifier_antimage_mana_break_lua:OnCreated( kv )
	self.mana_break = self:GetAbility():GetSpecialValueFor( "mana_per_hit" )
	self.mana_damage_pct = self:GetAbility():GetSpecialValueFor( "damage_per_burn" )
end

function modifier_antimage_mana_break_lua:OnRefresh( kv )
	self.mana_break = self:GetAbility():GetSpecialValueFor( "mana_per_hit" )
	self.mana_damage_pct = self:GetAbility():GetSpecialValueFor( "damage_per_burn" )
end

function modifier_antimage_mana_break_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_antimage_mana_break_lua:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		local target = params.target
		local result = UnitFilter(
			target,	-- Target Filter
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- Team Filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
			DOTA_UNIT_TARGET_FLAG_MANA_ONLY,	-- Unit Flag
			self:GetParent():GetTeamNumber()	-- Team reference
		)
	
		if result == UF_SUCCESS then
		
			local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_antimage_int1")
			if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
				self.mana_damage_pct = self:GetAbility():GetSpecialValueFor( "damage_per_burn" ) * 2
			end
	
			local mana_burn =  math.min( target:GetMana(), self.mana_break )
			target:Script_ReduceMana(mana_burn, nil)

			self:PlayEffects( target )

			return mana_burn * self.mana_damage_pct
		end

	end
end

function modifier_antimage_mana_break_lua:PlayEffects( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Antimage.ManaBreak", target )
end