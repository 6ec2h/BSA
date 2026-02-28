acid_blob_jump = class({})
LinkLuaModifier( "modifier_acid_blob_jump", "abilities/creeps/acid_blob_jump", LUA_MODIFIER_MOTION_BOTH )

function acid_blob_jump:Precache( context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
end

function acid_blob_jump:OnSpellStart()
	if IsServer() then

		local hDeathExplosionBuff = self:GetCaster():FindModifierByName( "modifier_acid_blob_death_explosion" )
		if hDeathExplosionBuff ~= nil then
			print( "SKIPPING BLOB JUMP ABILITY SINCE WE'RE DYING" )
			return
		end
		
		local kv =
		{
			vLocX = self:GetCursorPosition().x,
			vLocY = self:GetCursorPosition().y,
			vLocZ = self:GetCursorPosition().z
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_acid_blob_jump", kv )

		self.radius = self:GetSpecialValueFor( "radius" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.land_damage = self:GetSpecialValueFor( "land_damage" )
	end
end

function acid_blob_jump:Smash()
	if IsServer() then
		EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "OgreTank.GroundSmash", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		self:GetCaster():Interrupt()

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.land_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self,
				}

				ApplyDamage( damageInfo )

				if enemy:IsAlive() == false then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
				else
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------
modifier_acid_blob_jump = class({})

local AMOEBA_MINIMUM_HEIGHT_ABOVE_LOWEST = 400
local AMOEBA_MINIMUM_HEIGHT_ABOVE_HIGHEST = 200
local AMOEBA_ACCELERATION_Z = 1500
local AMOEBA_MAX_HORIZONTAL_ACCELERATION = 1500

function modifier_acid_blob_jump:IsHidden()
	return true
end

function modifier_acid_blob_jump:IsPurgable()
	return false
end

function modifier_acid_blob_jump:RemoveOnDeath()
	return false
end

function modifier_acid_blob_jump:OnCreated( kv )
	if IsServer() then
		self.bHorizontalMotionInterrupted = false
		self.bDamageApplied = false
		self.bTargetTeleported = false

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = AMOEBA_MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + AMOEBA_MINIMUM_HEIGHT_ABOVE_HIGHEST )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * AMOEBA_ACCELERATION_Z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * AMOEBA_ACCELERATION_Z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ( AMOEBA_ACCELERATION_Z ), ( self.flInitialVelocityZ - flSqrtDet) / ( AMOEBA_ACCELERATION_Z ) )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

function modifier_acid_blob_jump:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

function modifier_acid_blob_jump:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

function modifier_acid_blob_jump:UpdateHorizontalMotion( me, dt )
	if IsServer() then
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
		local flVelDelta = math.min( flVelDif, AMOEBA_MAX_HORIZONTAL_ACCELERATION )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function modifier_acid_blob_jump:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -AMOEBA_ACCELERATION_Z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * AMOEBA_ACCELERATION_Z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				self:GetAbility():Smash()
			end

			self:Destroy()
		end
	end
end

function modifier_acid_blob_jump:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

function modifier_acid_blob_jump:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_acid_blob_jump:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_acid_blob_jump:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_1
end