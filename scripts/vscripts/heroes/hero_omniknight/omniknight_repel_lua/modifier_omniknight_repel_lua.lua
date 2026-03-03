modifier_omniknight_repel_lua = class({})

function modifier_omniknight_repel_lua:IsHidden()
	return false
end

function modifier_omniknight_repel_lua:IsDebuff()
	return false
end

function modifier_omniknight_repel_lua:IsPurgable()
	return false
end

function modifier_omniknight_repel_lua:OnCreated( kv )
	if IsServer() then
		self.sound_cast = "Hero_Omniknight.Repel"
		EmitSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_omniknight_repel_lua:OnRefresh( kv )
	
end

function modifier_omniknight_repel_lua:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_omniknight_repel_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS
	}
	return funcs
end

function modifier_omniknight_repel_lua:GetModifierExtraStrengthBonus()
	return self:GetParent():GetBaseStrength() * self:GetAbility():GetSpecialValueFor("str") / 100
end

function modifier_omniknight_repel_lua:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_omniknight_repel_lua:CheckState()
	local state = {
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_omniknight_repel_lua:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
end

function modifier_omniknight_repel_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end