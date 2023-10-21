npc_dota_hero_queenofpain_spell2 = class({})

function npc_dota_hero_queenofpain_spell2:OnSpellStart()
	EmitSoundOn( "Hero_QueenOfPain.ScreamOfPain", self:GetCaster() )
    if not IsServer() then return end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("scream_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0,false)

		for _,enemy in pairs(enemies) do
			ProjectileManager:CreateTrackingProjectile({
			Target = enemy,
			Source = self:GetCaster(),
			Ability = self,	
			EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
			iMoveSpeed = 900,
			vSourceLoc= self:GetCaster():GetAbsOrigin(),
			bDodgeable = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			bProvidesVision = false,
		})
	end
	local effect_cast = ParticleManager:CreateParticle( "particles/qop2.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function npc_dota_hero_queenofpain_spell2:OnProjectileHit( target, location ) 
	self.damage = self:GetSpecialValueFor("scream_damage")
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_qop_tal_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage = self.damage + 250
	end
	
	ApplyDamage({victim = target,
    attacker = self:GetCaster(),
    damage = self.damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self,})
end