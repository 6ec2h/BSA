auto_shot_zone_2 = class({})

function auto_shot_zone_2:OnSpellStart()
	if not IsServer() then return end
	self.start_radius = self:GetSpecialValueFor( "start_radius" )
	self.end_radius = self:GetSpecialValueFor( "end_radius" )
	self.range = self:GetSpecialValueFor( "range" )
	self.speed = self:GetSpecialValueFor( "speed" )
	
	
	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.speed = self.speed * ( ( self.range ) / ( self.range -self.start_radius ) )

	local info = {
		EffectName = "particles/traps_zone_2/auto_shot_trap.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.start_radius,
		fEndRadius = self.end_radius,
		vVelocity = vDirection * self.speed,
		fDistance = self.range,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	
	self:GetCaster():EmitSound("Tower.Fire.Attack") -- где звук?
end

function auto_shot_zone_2:OnProjectileHit( hTarget, vLocation )
	if not IsServer() then return end
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = hTarget:GetMaxHealth()*0.35,
			damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage( damage )
		end
	return false
end