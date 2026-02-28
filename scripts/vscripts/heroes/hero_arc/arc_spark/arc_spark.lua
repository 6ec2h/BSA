ark_spark_lua = ark_spark_lua or class({})

function ark_spark_lua:GetAbilityTextureName()
	return "arc_warden_spark_wraith"
end

function ark_spark_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local radius = self:GetSpecialValueFor("radius")
		local damage = self:GetSpecialValueFor("damage")
		local enemy_speed = self:GetSpecialValueFor("enemy_speed")

		caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do

		local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_arc_warden_int9")
		if talent_ability == nil or talent_ability:GetLevel() == 0 then
			enemy = enemies[1]
		end

			local enemy_projectile =
				{
					Target = enemy,
					Source = caster,
					Ability = self,
					EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = enemy_speed,
					flExpireTime = GameRules:GetGameTime() + 60,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					ExtraData = {Target = enemy, Ability = self}
				}
				

			ProjectileManager:CreateTrackingProjectile(enemy_projectile)
		end
	end
end

function ark_spark_lua:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")	
	
		ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
		target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
	end
end