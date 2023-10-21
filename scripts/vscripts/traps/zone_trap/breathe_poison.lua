breathe_poison = class({})

--------------------------------------------------------------------------------

function breathe_poison:OnSpellStart()
	self.start_radius = self:GetSpecialValueFor( "start_radius" )
	self.end_radius = self:GetSpecialValueFor( "end_radius" )
	self.range = self:GetSpecialValueFor( "range" )
	self.speed = self:GetSpecialValueFor( "speed" )
	self.damage = self:GetSpecialValueFor( "damage" ) 

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

	local effect_name = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf" ---          particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf

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
	
	EmitSoundOn( "Conquest.PoisonTrap.Generic", self:GetCaster() )
end

function breathe_poison:OnProjectileHit( hTarget, vLocation )
	local poisonDamage = self.damage
	if self.targetLevel ~= nil and self.targetLevel > 3 then
		poisonDamage = poisonDamage * ( self.targetLevel / 3 )
	end
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then

		local damageSource = self:GetCaster()
		if self:GetCaster() ~= nil and self:GetCaster().KillerToCredit ~= nil then
			damageSource = self:GetCaster().KillerToCredit
		end

		if poisonDamage > 0 then
			local damage = {
				victim = hTarget,
				attacker = damageSource,
				damage = poisonDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			ApplyDamage( damage )
		end
	end
	return false
end