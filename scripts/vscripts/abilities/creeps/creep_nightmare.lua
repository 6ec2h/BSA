LinkLuaModifier( "modifier_creep_nightmare", "abilities/creeps/creep_nightmare", LUA_MODIFIER_MOTION_NONE )

creep_nightmare = class({})

function creep_nightmare:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end
	local duration = self:GetSpecialValueFor("duration")

	self.modifier = target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_creep_nightmare", -- modifier name
		{ duration = duration } -- kv
	)
end

--------------------------------------------------------------------------------------

modifier_creep_nightmare = class({})

function modifier_creep_nightmare:IsHidden()
	return false
end

function modifier_creep_nightmare:IsDebuff()
	return true
end

function modifier_creep_nightmare:IsStunDebuff()
	return false
end

function modifier_creep_nightmare:IsPurgable()
	return true
end

function modifier_creep_nightmare:CanParentBeAutoAttacked()
	return false
end

function modifier_creep_nightmare:OnCreated( kv )
	local inv_time = self:GetAbility():GetSpecialValueFor( "nightmare_invuln_time" )
	self.anim_rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )

	if IsServer() then
		self:StartIntervalThink( inv_time )
		local sound_cast = "Hero_Bane.Nightmare"
		local sound_loop = "Hero_Bane.Nightmare.Loop"
		EmitSoundOn( sound_cast, self:GetParent() )
		EmitSoundOn( sound_loop, self:GetParent() )
	end
end

function modifier_creep_nightmare:OnRefresh( kv )
end

function modifier_creep_nightmare:OnRemoved()
end

function modifier_creep_nightmare:OnDestroy()
	if not IsServer() then return end

	local sound_loop = "Hero_Bane.Nightmare.Loop"
	StopSoundOn( sound_loop, self:GetParent() )

	if not self.transfer then
		local sound_stop = "Hero_Bane.Nightmare.End"
		EmitSoundOn( sound_stop, self:GetParent() )
	end
end

function modifier_creep_nightmare:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_creep_nightmare:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end
function modifier_creep_nightmare:GetOverrideAnimationRate()
	return self.anim_rate
end

function modifier_creep_nightmare:OnAttackStart( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end
	if params.attacker==self:GetCaster() then return end
	if not params.attacker:IsMagicImmune() then
		local modifier = params.attacker:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_creep_nightmare", -- modifier name
			{ duration = self:GetDuration() } -- kv
		)

		self:GetAbility().modifier = modifier
		self.transfer = true
	end
	self:Destroy()
end

function modifier_creep_nightmare:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.damage_category==DOTA_DAMAGE_CATEGORY_SPELL then
		self:Destroy()
	end
end

function modifier_creep_nightmare:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = self.invulnerable,
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_creep_nightmare:OnIntervalThink()
	self.invulnerable = false
end

function modifier_creep_nightmare:GetEffectName()
	return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end

function modifier_creep_nightmare:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end