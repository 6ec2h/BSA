LinkLuaModifier( "modifier_hoodwink_sharpshooter_lua", "heroes/hero_hoodwink/hoodwink_sharpshooter_lua/hoodwink_sharpshooter_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_lua_debuff", "heroes/hero_hoodwink/hoodwink_sharpshooter_lua/hoodwink_sharpshooter_lua", LUA_MODIFIER_MOTION_NONE )

hoodwink_sharpshooter_lua = class({})

function hoodwink_sharpshooter_lua:GetCooldown( level )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_hoodwink_4")
	if ability ~= nil and ability:GetLevel() > 0 then 
		return self.BaseClass.GetCooldown( self, level ) - 40
	end
	return self.BaseClass.GetCooldown( self, level )
end

function hoodwink_sharpshooter_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor( "misfire_time" )

	caster:AddNewModifier(caster, self, "modifier_hoodwink_sharpshooter_lua",
		{
			duration = duration,
			x = point.x,
			y = point.y,
		}
	)
end

function hoodwink_sharpshooter_lua:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end
	local ability = self
	local caster = self:GetCaster()
	damage = self:GetSpecialValueFor( "max_damage" )
	if hTarget then 
		ApplyDamage({
			victim = hTarget,
			attacker = caster, 
			ability = ability,
			damage_type = ability:GetAbilityDamageType(), 
			damage = damage,
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		})
	end
end

-------------------------------------------------------------------------------------

modifier_hoodwink_sharpshooter_lua = class({})

function modifier_hoodwink_sharpshooter_lua:IsHidden()
	return false
end

function modifier_hoodwink_sharpshooter_lua:IsDebuff()
	return false
end

function modifier_hoodwink_sharpshooter_lua:IsStunDebuff()
	return false
end

function modifier_hoodwink_sharpshooter_lua:IsPurgable()
	return false
end

function modifier_hoodwink_sharpshooter_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.team = self.parent:GetTeamNumber()

	self.charge = self:GetAbility():GetSpecialValueFor( "max_charge_time" )
	self.duration = self:GetAbility():GetSpecialValueFor( "max_slow_debuff_duration" )
	self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )

	self.recoil_distance = self:GetAbility():GetSpecialValueFor( "recoil_distance" )
	self.recoil_duration = self:GetAbility():GetSpecialValueFor( "recoil_duration" )
	self.recoil_height = self:GetAbility():GetSpecialValueFor( "recoil_height" )

	self.interval = 0.03 
	self:StartIntervalThink( self.interval )

	if not IsServer() then return end

	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "arrow_speed" )
	self.projectile_range = self:GetAbility():GetSpecialValueFor( "arrow_range" )
	self.projectile_width = self:GetAbility():GetSpecialValueFor( "arrow_width" )
	local projectile_vision = self:GetAbility():GetSpecialValueFor( "arrow_vision" )
	local projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf"

	local vec = Vector( kv.x, kv.y, 0 )
	self:SetDirection( vec )
	self.current_dir = self.target_dir
	self.face_target = true
	self.parent:SetForwardVector( self.current_dir )
	self.turn_speed = self.interval*self.turn_rate

	self.info = {
		EffectName = projectile_name,
		Ability = self:GetAbility(),
		fStartRadius = self.projectile_width,
	    fEndRadius = self.projectile_width,
		fDistance = self.projectile_range,
		Source = self.parent,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_BASIC,
	    bDeleteOnHit = false,
	    
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = self.caster:GetTeamNumber()
	}
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_hoodwink_sharpshooter_lua:OnRefresh( kv )
	
end

function modifier_hoodwink_sharpshooter_lua:OnRemoved()
end

function modifier_hoodwink_sharpshooter_lua:OnDestroy()
	if not IsServer() then return end
	local direction = self.current_dir
	self.info.vSpawnOrigin = self.parent:GetOrigin()
	self.info.vVelocity = direction * self.projectile_speed

	local sound = CreateModifierThinker(
		self.caster, -- player source
		self, -- ability source
		"", -- modifier name
		{}, -- kv
		self.caster:GetOrigin(),
		self.team,
		false
	)
	EmitSoundOn( "Hero_Hoodwink.Sharpshooter.Projectile", sound )
	ProjectileManager:CreateLinearProjectile( self.info )
	self:PlayEffects4( mod )
end

function modifier_hoodwink_sharpshooter_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,	
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}
	return funcs
end

function modifier_hoodwink_sharpshooter_lua:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	end
end

function modifier_hoodwink_sharpshooter_lua:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_hoodwink_sharpshooter_lua:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

function modifier_hoodwink_sharpshooter_lua:GetModifierDisableTurning()
	return 1
end

function modifier_hoodwink_sharpshooter_lua:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_hoodwink_sharpshooter_lua:OnIntervalThink()
	if not IsServer() then
		self:UpdateStack()
		return
	end

	self:TurnLogic()

	local startpos = self.parent:GetOrigin()
	local visions = self.projectile_range/self.projectile_width
	local delta = self.parent:GetForwardVector() * self.projectile_width
	for i=1,visions do
		AddFOWViewer( self.team, startpos, self.projectile_width, 0.1, false )
		startpos = startpos + delta
	end

	if not self.charged and self:GetElapsedTime()>self.charge then
		self.charged = true
		local sound_cast = "Hero_Hoodwink.Sharpshooter.MaxCharge"
		EmitSoundOnClient( sound_cast, self.parent:GetPlayerOwner() )
	end

	local remaining = self:GetRemainingTime()
	local seconds = math.ceil( remaining )
	local isHalf = (seconds-remaining)>0.5
	if isHalf then seconds = seconds-1 end

	if self.half~=isHalf then
		self.half = isHalf
		self:PlayEffects3( seconds, isHalf )
	end
	self:UpdateEffect()
end

function modifier_hoodwink_sharpshooter_lua:SetDirection( vec )
	self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.face_target = false
end

function modifier_hoodwink_sharpshooter_lua:TurnLogic()
	if self.face_target then return end

	local current_angle = VectorToAngles( self.current_dir ).y
	local target_angle = VectorToAngles( self.target_dir ).y
	local angle_diff = AngleDiff( current_angle, target_angle )

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*self.turn_speed then
		self.current_dir = self.target_dir
		self.face_target = true
	else
		self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
	end

	local a = self.parent:IsCurrentlyHorizontalMotionControlled()
	local b = self.parent:IsCurrentlyVerticalMotionControlled()
	if not (a or b) then
		self.parent:SetForwardVector( self.current_dir )
	end
end

function modifier_hoodwink_sharpshooter_lua:UpdateStack()
	local pct = math.min( self:GetElapsedTime(), self.charge )/self.charge
	pct = math.floor( pct*100 )
	self:SetStackCount( pct )
end


function modifier_hoodwink_sharpshooter_lua:OrderFilter( data )
	if #data.units>1 then return true end
	local unit
	for _,id in pairs(data.units) do
		unit = EntIndexToHScript( id )
	end
	if unit~=self.parent then return true end
	if data.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	elseif data.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or data.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		local pos = EntIndexToHScript( data.entindex_target ):GetOrigin()

		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end

	return true
end

function modifier_hoodwink_sharpshooter_lua:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf"
	local sound_cast = "Hero_Hoodwink.Sharpshooter.Channel"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self.parent:GetOrigin(), -- unknown
		true -- unknown, true
	)
	self:AddParticle(effect_cast, false, false, -1, false, false)
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_hoodwink_sharpshooter_lua:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf"
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.parent:GetForwardVector() * self.projectile_range
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 0, startpos )
	ParticleManager:SetParticleControl( effect_cast, 1, endpos )

	self:AddParticle(effect_cast, false, false, -1, false, false)
	self.effect_cast = effect_cast
end

function modifier_hoodwink_sharpshooter_lua:PlayEffects3( seconds, half )
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf"

	local mid = 1
	if half then mid = 8 end

	local len = 2
	if seconds<1 then
		len = 1
		if not half then return end
	end

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, seconds, mid ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( len, 0, 0 ) )
end

function modifier_hoodwink_sharpshooter_lua:PlayEffects4( modifier )
	local particle_cast = "particles/items_fx/force_staff.vpcf"
	local sound_channel = "Hero_Hoodwink.Sharpshooter.Channel"
	local sound_cast = "Hero_Hoodwink.Sharpshooter.Cast"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )

	self:AddParticle(effect_cast, false, false, -1, false, false)
	
	StopSoundOn( sound_channel, self.caster )
	EmitSoundOn( sound_cast, self.caster )
end

function modifier_hoodwink_sharpshooter_lua:UpdateEffect()
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.current_dir * self.projectile_range
	ParticleManager:SetParticleControl( self.effect_cast, 0, startpos )
	ParticleManager:SetParticleControl( self.effect_cast, 1, endpos )
end

--------------------------------------------------

modifier_hoodwink_sharpshooter_lua_debuff = class({})

function modifier_hoodwink_sharpshooter_lua_debuff:IsHidden()
	return false
end

function modifier_hoodwink_sharpshooter_lua_debuff:IsDebuff()
	return true
end

function modifier_hoodwink_sharpshooter_lua_debuff:IsStunDebuff()
	return false
end

function modifier_hoodwink_sharpshooter_lua_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_sharpshooter_lua_debuff:OnCreated( kv )
	self.parent = self:GetParent()

	self.slow = -self:GetAbility():GetSpecialValueFor( "slow_move_pct" )

	if not IsServer() then return end
	
	local direction = Vector( kv.x, kv.y, 0 ):Normalized()
	self:PlayEffects( direction )
end

function modifier_hoodwink_sharpshooter_lua_debuff:OnRefresh( kv )
end

function modifier_hoodwink_sharpshooter_lua_debuff:OnRemoved()
end

function modifier_hoodwink_sharpshooter_lua_debuff:OnDestroy()
end

function modifier_hoodwink_sharpshooter_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_hoodwink_sharpshooter_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_hoodwink_sharpshooter_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
	return state
end

function modifier_hoodwink_sharpshooter_lua_debuff:PlayEffects( direction )
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self.parent:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end