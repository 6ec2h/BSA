breathe_poison_oneshot = class({})

--------------------------------------------------------------------------------

function breathe_poison_oneshot:OnSpellStart()
	self.start_radius = self:GetSpecialValueFor( "start_radius" )
	self.end_radius = self:GetSpecialValueFor( "end_radius" )
	self.range = self:GetSpecialValueFor( "range" )
	self.speed = self:GetSpecialValueFor( "speed" )
	self.strike_damage = self:GetSpecialValueFor( "strike_damage" ) 
	self.duration = self:GetSpecialValueFor( "duration" ) 

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

	local effect_name = "particles/traps/temple_trap_arrow.vpcf"

	local info = {
		EffectName = effect_name,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.start_radius,
		fEndRadius = self.end_radius,
		vVelocity = vDirection * self.speed,
		fDistance = self.range,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO,
	}

	ProjectileManager:CreateLinearProjectile( info )
	
	EmitSoundOn( "Dungeon.FireTrap", self:GetCaster() )-- EmitSoundOn( "Tower.Fire.Attack", self:GetCaster() )
end

--------------------------------------------------------------------------------

function breathe_poison_oneshot:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damageSource = self:GetCaster()
		if self:GetCaster() ~= nil and self:GetCaster().KillerToCredit ~= nil then
			damageSource = self:GetCaster().KillerToCredit
		end
		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = self.strike_damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}

		ApplyDamage( damage )
	end
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------