LinkLuaModifier( "modifier_boss_nyx_assassin_dispersion_cast", "abilities/bosses/nyx/boss_nyx_assassin_dispersion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_ring_lua", "heroes/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nyx_cd", "abilities/bosses/nyx/boss_nyx_assassin_dispersion", LUA_MODIFIER_MOTION_NONE )

boss_nyx_assassin_dispersion = class({})

function boss_nyx_assassin_dispersion:OnSpellStart(target)
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.BladeMail.Activate")
	caster:AddNewModifier(caster, self, "modifier_boss_nyx_assassin_dispersion_cast", {duration = self:GetSpecialValueFor("duration")})
end

---------------------------------------------------------------------------------------

modifier_nyx_cd = class({})

function modifier_nyx_cd:IsHidden()
	return true
end

function modifier_nyx_cd:IsPurgable()
	return false
end

---------------------------------------------------------------------------------------

modifier_boss_nyx_assassin_dispersion_cast = class({})

function modifier_boss_nyx_assassin_dispersion_cast:IsHidden()
	return true
end

function modifier_boss_nyx_assassin_dispersion_cast:IsPurgable()
	return false
end

function modifier_boss_nyx_assassin_dispersion_cast:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_boss_nyx_assassin_dispersion_cast:GetEffectName()
	return "particles/dispersion/dispersion_effect.vpcf"
end

function modifier_boss_nyx_assassin_dispersion_cast:OnTakeDamage(keys)
	if not IsServer() then return end
	if keys.unit == self:GetParent() and not self:GetParent():HasModifier("modifier_nyx_cd") then

		self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_nyx_cd", {duration = 0.2})	
		self.original_damage = keys.original_damage
		self:CastWave()	
	end
end

function modifier_boss_nyx_assassin_dispersion_cast:CastWave()
	self.caster = self:GetCaster()
	local ability = self:GetAbility()
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local speed = self:GetAbility():GetSpecialValueFor( "speed" )
	local effect = self:PlayEffects( radius, speed )
	
	local ring = self.caster:AddNewModifier(
		self.caster, -- player source
		self, -- ability source
		"modifier_generic_ring_lua", -- modifier name
		{
			start_radius = 0,
			end_radius = radius,
			speed = speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			IsCircle = 0,
		}
	)
	ring:SetCallback( function( enemy )
		self:OnHit(enemy, ability)
	end)
	ring:SetEndCallback( function()
		ParticleManager:SetParticleControl(effect, 1, Vector( speed, radius, -1))
	end)

	ring:SetEndCallback( function()
		ParticleManager:DestroyParticle( effect, false )
		ParticleManager:ReleaseParticleIndex( effect )
	end)	
end

function modifier_boss_nyx_assassin_dispersion_cast:OnHit(enemy, ability)
    local radius = ability:GetSpecialValueFor("radius")
    local damage_percentage = ability:GetSpecialValueFor("damage")
    local damage = damage_percentage * self.original_damage / 100
    local damageTable = {
        victim = enemy,
        attacker = self.caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE,
    }
    ApplyDamage(damageTable)

    EmitSoundOn("Ability.PlasmaFieldImpact", enemy)
end


function modifier_boss_nyx_assassin_dispersion_cast:PlayEffects( radius, speed )
	local effect_cast = ParticleManager:CreateParticle( "particles/dispersion/dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, radius, 1 ) )
	EmitSoundOn( "Ability.PlasmaField", self:GetCaster() )
	return effect_cast
end