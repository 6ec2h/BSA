LinkLuaModifier( "modifier_primal_beast_pulverize_lua", "heroes/hero_primal_beast/primal_beast_pulverize_lua/primal_beast_pulverize_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_lua_debuff", "heroes/hero_primal_beast/primal_beast_pulverize_lua/primal_beast_pulverize_lua", LUA_MODIFIER_MOTION_BOTH )

primal_beast_pulverize_lua = class({})

function primal_beast_pulverize_lua:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

primal_beast_pulverize_lua.modifiers = {}
function primal_beast_pulverize_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then
		caster:Interrupt()
		return
	end
	local duration = self:GetSpecialValueFor( "channel_time" )
	local mod = target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_primal_beast_pulverize_lua_debuff", -- modifier name
		{ duration = duration } -- kv
	)
	self.modifiers[mod] = true

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_primal_beast_pulverize_lua", -- modifier name
		{ duration = duration } -- kv
	)

	if target:IsCreep() then
		EmitSoundOn( "Hero_PrimalBeast.Pulverize.Cast.Creep", caster )
	else
		EmitSoundOn( "Hero_PrimalBeast.Pulverize.Cast", caster )
	end
end

function primal_beast_pulverize_lua:GetChannelTime()
	return self:GetSpecialValueFor( "channel_time" )
end

function primal_beast_pulverize_lua:OnChannelFinish( bInterrupted )
	for mod,_ in pairs(self.modifiers) do
		if not mod:IsNull() then
			mod:Destroy()
		end
	end
	self.modifiers = {}

	local self_mod = self:GetCaster():FindModifierByName( "modifier_primal_beast_pulverize_lua" )
	if self_mod then
		self_mod:Destroy()
	end
end

function primal_beast_pulverize_lua:RemoveModifier( mod )
	self.modifiers[mod] = nil
	local has_enemies = false
	for _,mod in pairs(self.modifiers) do
		has_enemies = true
	end

	if not has_enemies then
		self:EndChannel( true )
	end
end

---------------------------------------------------------

modifier_primal_beast_pulverize_lua = class({})

function modifier_primal_beast_pulverize_lua:IsHidden()
	return false
end

function modifier_primal_beast_pulverize_lua:IsDebuff()
	return false
end

function modifier_primal_beast_pulverize_lua:IsPurgable()
	return false
end

function modifier_primal_beast_pulverize_lua:OnCreated( kv )
	if not IsServer() then return end
end

function modifier_primal_beast_pulverize_lua:OnRefresh( kv )
	
end

function modifier_primal_beast_pulverize_lua:OnRemoved()
end

function modifier_primal_beast_pulverize_lua:OnDestroy()
end


function modifier_primal_beast_pulverize_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

function modifier_primal_beast_pulverize_lua:GetModifierDisableTurning()
	return 1
end

-----------------------------------------------------

modifier_primal_beast_pulverize_lua_debuff = class({})

function modifier_primal_beast_pulverize_lua_debuff:IsHidden()
	return false
end

function modifier_primal_beast_pulverize_lua_debuff:IsDebuff()
	return true
end

function modifier_primal_beast_pulverize_lua_debuff:IsPurgable()
	return true
end

function modifier_primal_beast_pulverize_lua_debuff:IsStunDebuff()
	return true
end

function modifier_primal_beast_pulverize_lua_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.isRoshan = self.parent:GetUnitName()=="npc_dota_roshan"

	self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.ministun = self:GetAbility():GetSpecialValueFor( "ministun" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.animrate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_primal_beast_4")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage = self.damage + 250
	end

	if not IsServer() then return end
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	-- channel interrupt data
	self.interrupt_pos = self.caster:GetOrigin() + self.caster:GetForwardVector() * 200
	self.cast_pos = self.caster:GetOrigin()
	self.pos_threshold = 100

	-- caster attachment location
	local attach_rollback = {
		[1] = "attach_pummel",
		[2] = "attach_attack1",
		[3] = "attach_attack",
		[4] = "attach_hitloc",
	}
	for i,name in ipairs(attach_rollback) do
		self.attach_name = name
		if self.caster:ScriptLookupAttachment( name )~=0 then
			break
		end
	end

	local hitloc_enum = self.parent:ScriptLookupAttachment( "attach_hitloc" )
	local hitloc_pos = self.parent:GetAttachmentOrigin( hitloc_enum )
	self.deltapos = self.parent:GetOrigin() - hitloc_pos

	if not self:ApplyHorizontalMotionController() then
		if not self.isRoshan then
			self:Destroy()
			return
		end
	end
	if not self:ApplyVerticalMotionController() then
		if not self.isRoshan then
			self:Destroy()
			return
		end
	end

	self:SetPriority( DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST )
	self:StartIntervalThink( self.interval )
end

function modifier_primal_beast_pulverize_lua_debuff:OnRefresh( kv )
	
end

function modifier_primal_beast_pulverize_lua_debuff:OnRemoved()
	if not IsServer() then return end
end

function modifier_primal_beast_pulverize_lua_debuff:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveHorizontalMotionController( self )

	if not (self.parent:IsCurrentlyHorizontalMotionControlled() or self.parent:IsCurrentlyVerticalMotionControlled()) then
		FindClearSpaceForUnit( self.parent, self.interrupt_pos, false )
		local angle = self.parent:GetAnglesAsVector()
		self.parent:SetAngles( 0, angle.y+180, 0 )
	end
	self.ability:RemoveModifier( self )
end

function modifier_primal_beast_pulverize_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
	return funcs
end

function modifier_primal_beast_pulverize_lua_debuff:GetOverrideAnimation()
	if self.isRoshan then
		return ACT_DOTA_DISABLED
	end
	return ACT_DOTA_FLAIL
end

function modifier_primal_beast_pulverize_lua_debuff:GetOverrideAnimationRate()
	return self.animrate
end

function modifier_primal_beast_pulverize_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}

	return state
end

function modifier_primal_beast_pulverize_lua_debuff:OnIntervalThink()
	local origin = self.interrupt_pos

	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.abilityTargetTeam,	-- int, team filter
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damageTable = {
		-- victim = target,
		attacker = self.caster,
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		
		enemy:AddNewModifier(
			self.caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = self.ministun } -- kv
		)

		EmitSoundOn( "Hero_PrimalBeast.Pulverize.Stun", self.caster )
	end

	self:PlayEffects( origin, self.radius )

	if (self.caster:GetOrigin()-self.cast_pos):Length2D()>self.pos_threshold then
		self:Destroy()
		return		
	end
end

function modifier_primal_beast_pulverize_lua_debuff:UpdateHorizontalMotion( me, dt )
	if self.parent:IsOutOfGame() or self.parent:IsInvulnerable() then
		self:Destroy()
		return
	end
	local attach = self.caster:ScriptLookupAttachment( self.attach_name )
	local pos = self.caster:GetAttachmentOrigin( attach )
	local angles = self.caster:GetAttachmentAngles( attach )
	me:SetLocalAngles( 180-angles.x, 180+angles.y, 0 )
	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos
	me:SetOrigin( pos )
end

function modifier_primal_beast_pulverize_lua_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_pulverize_lua_debuff:UpdateVerticalMotion( me, dt )
	local attach = self.caster:ScriptLookupAttachment( self.attach_name )
	local pos = self.caster:GetAttachmentOrigin( attach )
	local angles = self.caster:GetAttachmentAngles( attach )

	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos

	local mepos = me:GetOrigin()
	mepos.z = pos.z
	me:SetOrigin( mepos )
end

function modifier_primal_beast_pulverize_lua_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end


function modifier_primal_beast_pulverize_lua_debuff:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function modifier_primal_beast_pulverize_lua_debuff:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function modifier_primal_beast_pulverize_lua_debuff:PlayEffects( origin, radius )
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf"
	local sound_cast = "Hero_PrimalBeast.Pulverize.Impact"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self.parent:GetOrigin(), sound_cast, self.caster )
end