LinkLuaModifier("modifier_npc_dota_hero_queenofpain_spell6_effect", "heroes/hero_qop/npc_dota_hero_queenofpain_spell6", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_queenofpain_spell6 = class({})

function npc_dota_hero_queenofpain_spell6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_queenofpain_spell6"
end

function npc_dota_hero_queenofpain_spell6:OnAbilityPhaseStart()
	if not IsServer() then return end
		self:GetCaster():EmitSound("Hero_QueenOfPain.SonicWave.Precast")
	return true
end

function npc_dota_hero_queenofpain_spell6:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
	self:GetCaster():StopSound("Hero_QueenOfPain.SonicWave.Precast")
end

function npc_dota_hero_queenofpain_spell6:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		local damage = self:GetSpecialValueFor("damage")
		local start_radius = self:GetSpecialValueFor("start_radius")
		local end_radius = self:GetSpecialValueFor("end_radius")
		local travel_distance = self:GetSpecialValueFor("travel_distance") + self:GetCaster():GetCastRangeBonus()
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local direction
		if target_loc == caster_loc then
			direction = caster:GetForwardVector()
		else
			direction = (target_loc - caster_loc):Normalized()
		end

		caster:EmitSound("Hero_QueenOfPain.SonicWave")

		projectile =
			{
				Ability				= self,
				EffectName			= "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf",
				vSpawnOrigin		= caster_loc,
				fDistance			= travel_distance,
				fStartRadius		= start_radius,
				fEndRadius			= end_radius,
				Source				= caster,
				bHasFrontalCone		= true,
				bReplaceExisting	= false,
				iUnitTargetTeam		= self:GetAbilityTargetTeam(),
				iUnitTargetFlags	= self:GetAbilityTargetFlags(),
				iUnitTargetType		= self:GetAbilityTargetType(),
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= true,
				vVelocity			= Vector(direction.x,direction.y,0) * projectile_speed,
				bProvidesVision		= false,
				ExtraData			= {damage = damage}
			}

		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function npc_dota_hero_queenofpain_spell6:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		ApplyDamage({attacker = self:GetCaster(), victim = target, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
		target:AddNewModifier(self:GetCaster(), self, "modifier_npc_dota_hero_queenofpain_spell6_effect", {duration = self:GetSpecialValueFor("duration")})
	end
end

-------------------------------------------

modifier_npc_dota_hero_queenofpain_spell6_effect = class({})

function modifier_npc_dota_hero_queenofpain_spell6_effect:IsHidden() return true end

function modifier_npc_dota_hero_queenofpain_spell6_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
    }
    return funcs
end

function modifier_npc_dota_hero_queenofpain_spell6_effect:GetModifierMiss_Percentage()
    return 100
end

function modifier_npc_dota_hero_queenofpain_spell6_effect:CheckState()
	local state = {
		[MODIFIER_STATE_BLIND] = true,	
		[MODIFIER_STATE_MUTED] = true,	
	}
	return state
end

