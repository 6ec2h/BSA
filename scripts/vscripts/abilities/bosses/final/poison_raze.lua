poison_raze = class({})

function poison_raze:OnSpellStart()
	for i=1, RandomInt(9,18) do	
		local effect_name = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf" 
		local info = {
			EffectName = effect_name,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = 100,
			fEndRadius = 100,
			vVelocity = RandomVector(1) * 400,
			fDistance = 1500,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		ProjectileManager:CreateLinearProjectile( info )
	end
	
	Timers:CreateTimer(2, function()
	EmitSoundOn( "Conquest.PoisonTrap.Generic", self:GetCaster() )
		for i=1, RandomInt(9,18) do	
			local effect_name = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf" 
			local info = {
				EffectName = effect_name,
				Ability = self,
				vSpawnOrigin = self:GetCaster():GetOrigin(), 
				fStartRadius = 100,
				fEndRadius = 100,
				vVelocity = RandomVector(1) * 400,
				fDistance = 1500,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			}

			ProjectileManager:CreateLinearProjectile( info )
		end
	end)
	EmitSoundOn( "Conquest.PoisonTrap.Generic", self:GetCaster() )
end


function poison_raze:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}
		ApplyDamage( damage )
	end
	return false
end
