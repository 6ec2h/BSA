LinkLuaModifier("modifier_tiny_toss_movement", "abilities/creeps/tiny_toss_creep_lua", LUA_MODIFIER_MOTION_NONE)

tiny_toss_creep_lua = tiny_toss_creep_lua or class({})

traps_spike = {"jungle_1_trigger_spike_trap_cp2","jungle_2_trigger_spike_trap_cp2","jungle_3_trigger_spike_trap_cp2","jungle_4_trigger_spike_trap_cp2","jungle_5_trigger_spike_trap_cp2","jungle_6_trigger_spike_trap_cp2","jungle_7_trigger_spike_trap_cp2",
"jungle_8_trigger_spike_trap_cp2","jungle_8_trigger_spike_trap_cp2","jungle_10_trigger_spike_trap_cp2"}


	

function tiny_toss_creep_lua:OnSpellStart()
	
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	self.tossPosition = caster:GetOrigin()
	
	for _, points in pairs(traps_spike) do
		local point = Entities:FindByName( nil, points):GetOrigin()
		local flDist = (point - caster:GetOrigin()):Length2D()
		if flDist < 1000 then
			self.tossPosition = point
			break
		end
	end

	if hTarget then
		self.tossTarget = hTarget
	else
		self.tossTarget = nil
	end

	local vLocation = self.tossPosition
	local kv =
	{
		vLocX = vLocation.x,
		vLocY = vLocation.y,
		vLocZ = vLocation.z,
		duration = duration,
		damage = self:GetSpecialValueFor("toss_damage")
	}

	local tossVictims = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, 1, false)

	for _, victim in pairs(tossVictims) do
		if (PlayerResource:IsDisableHelpSetForPlayerID(victim:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID())) then
			table.remove(tossVictims, _)
		end
	end

	for _, victim in pairs(tossVictims) do
		if victim ~= caster then
			victim:AddNewModifier(caster, self, "modifier_tiny_toss_movement", kv)
		end
	end

	if #tossVictims <= 1 then
		caster:AddNewModifier(caster, self, "modifier_tiny_toss_movement", kv)
	end
	caster:StartGesture(ACT_TINY_TOSS)
	EmitSoundOn("Ability.TossThrow", self:GetCaster())
end

--------------------------------------------------------------------------------------------

modifier_tiny_toss_movement = modifier_tiny_toss_movement or class({})

function modifier_tiny_toss_movement:IsDebuff() return true end
function modifier_tiny_toss_movement:IsStunDebuff() return true end
function modifier_tiny_toss_movement:RemoveOnDeath() return false end
function modifier_tiny_toss_movement:IsHidden() return true end
function modifier_tiny_toss_movement:IgnoreTenacity() return true end
function modifier_tiny_toss_movement:IsMotionController() return true end
function modifier_tiny_toss_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_tiny_toss_movement:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:OnCreated( kv )
	self.toss_minimum_height_above_lowest = 500
	self.toss_minimum_height_above_highest = 100
	self.toss_acceleration_z = 4000
	self.toss_max_horizontal_acceleration = 3000

	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		EmitSoundOn("Hero_Tiny.Toss.Target", self:GetParent())

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.damage = kv.damage
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = self.toss_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.toss_minimum_height_above_highest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.toss_acceleration_z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.toss_acceleration_z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.toss_acceleration_z, ( self.flInitialVelocityZ - flSqrtDet) / self.toss_acceleration_z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_tiny_toss_movement:OnIntervalThink()
	if IsServer() then
		-- if not self:CheckMotionControllers() then
			-- self:Destroy()
			-- return nil
		-- end
		self:HorizontalMotion(self.parent, self.frametime)
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_tiny_toss_movement:TossLand()
	if IsServer() then
		-- If the Toss was already completed, do nothing
		if self.toss_land_commenced then
			return nil
		end


		self.toss_land_commenced = true

		local caster = self:GetCaster()

		local radius = self:GetAbility():GetSpecialValueFor("radius")


		GridNav:DestroyTreesAroundPoint(self.vLastKnownTargetPos, radius, true)

		local victims = FindUnitsInRadius(caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 1, false)
		for _, victim in pairs(victims) do
			local damage = self.damage

				ApplyDamage({victim = victim, attacker = caster, damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})

		end

		EmitSoundOn("Ability.TossImpact", self.parent)


		-- self.parent:SetUnitOnClearGround()
		Timers:CreateTimer(FrameTime(), function()
			ResolveNPCPositions(self.parent:GetAbsOrigin(), 150)
		end)
	end
end

function modifier_tiny_toss_movement:OnDestroy()
	if IsServer() then
		-- self.parent:SetUnitOnClearGround()
	end
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_tiny_toss_movement:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				return {[MODIFIER_STATE_STUNNED] = true}
			else
				return {[MODIFIER_STATE_ROOTED] = true}
			end
		end
	end
	
	return {}
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:HorizontalMotion( me, dt )
	if IsServer() then
		-- If the unit being tossed died, interrupt motion controllers and remove self (nah lul)
		-- if not self.parent:IsAlive() then
			-- self.parent:InterruptMotionControllers(true)
			-- self:Destroy()
		-- end

		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.toss_max_horizontal_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function modifier_tiny_toss_movement:VerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.toss_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0

		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.toss_acceleration_z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			self:TossLand()
		end
	end
end

----------------------------------------
----------------------------------------
----------------------------------------


function modifier_tiny_toss_movement:CheckMotionControllers()
	local parent = self:GetParent()
	local modifier_priority = self:GetMotionControllerPriority()
	local is_motion_controller = false
	local motion_controller_priority
	local found_modifier_handler

	local non_imba_motion_controllers =
	{"modifier_brewmaster_storm_cyclone",
	 "modifier_dark_seer_vacuum",
	 "modifier_eul_cyclone",
	 "modifier_earth_spirit_rolling_boulder_caster",
	 "modifier_huskar_life_break_charge",
	 "modifier_invoker_tornado",
	 "modifier_item_forcestaff_active",
	 "modifier_rattletrap_hookshot",
	 "modifier_phoenix_icarus_dive",
	 "modifier_shredder_timber_chain",
	 "modifier_slark_pounce",
	 "modifier_spirit_breaker_charge_of_darkness",
	 "modifier_tusk_walrus_punch_air_time",
	 "modifier_earthshaker_enchant_totem_leap"}
	

	local modifiers = parent:FindAllModifiers()	

	for _,modifier in pairs(modifiers) do		
		-- Ignore the modifier that is using this function
		if self ~= modifier then			

			-- Check if this modifier is assigned as a motion controller
			if modifier.IsMotionController then
				if modifier:IsMotionController() then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- Get the motion controller priority
					motion_controller_priority = modifier:GetMotionControllerPriority()

					-- Stop iteration					
					break
				end
			end

			-- If not, check on the list
			for _,non_imba_motion_controller in pairs(non_imba_motion_controllers) do				
				if modifier:GetName() == non_imba_motion_controller then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- We assume that vanilla controllers are the highest priority
					motion_controller_priority = DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST

					-- Stop iteration					
					break
				end
			end
		end
	end

	-- If this is a motion controller, check its priority level
	if is_motion_controller and motion_controller_priority then

		-- If the priority of the modifier that was found is higher, override
		if motion_controller_priority > modifier_priority then			
			return false

		-- If they have the same priority levels, check which of them is older and remove it
		elseif motion_controller_priority == modifier_priority then			
			if found_modifier_handler:GetCreationTime() >= self:GetCreationTime() then				
				return false
			else				
				found_modifier_handler:Destroy()
				return true
			end

		-- If the modifier that was found is a lower priority, destroy it instead
		else			
			parent:InterruptMotionControllers(true)
			found_modifier_handler:Destroy()
			return true
		end
	else
		-- If no motion controllers were found, apply
		return true
	end
end
