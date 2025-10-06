LinkLuaModifier("modifier_weaver_shukuchi_custom", "heroes/hero_weaver/weaver_shukuchi_custom/weaver_shukuchi_custom", LUA_MODIFIER_MOTION_NONE)

weaver_shukuchi_custom = class({})

function weaver_shukuchi_custom:OnSpellStart()
    if not IsServer() then return end
	self:GetCaster():EmitSound("Hero_Weaver.Shukuchi")
	if self:GetCaster():FindModifierByNameAndCaster("modifier_weaver_shukuchi_custom", self:GetCaster()) then
		self:GetCaster():RemoveModifierByName("modifier_weaver_shukuchi_custom")
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_weaver_shukuchi_custom", {duration = self:GetSpecialValueFor("duration")})
end

modifier_weaver_shukuchi_custom = class({})

function modifier_weaver_shukuchi_custom:IsPurgable() return false end
function modifier_weaver_shukuchi_custom:IsPurgeException() return false end

function modifier_weaver_shukuchi_custom:GetEffectName()
	return "particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf"
end

function modifier_weaver_shukuchi_custom:OnCreated()
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	if not IsServer() then return end
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	self.damage				= self:GetAbility():GetSpecialValueFor("damage")
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.hit_targets		= {}
	self.shukuchi_particle	= nil
	self.damage_table		= 
    {
		victim 			= nil,
		damage 			= self.damage,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetParent(),
		ability 		= self:GetAbility()
	}	
	self:StartIntervalThink(FrameTime())
end

function modifier_weaver_shukuchi_custom:OnIntervalThink()
    if not IsServer() then return end
	self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(self.enemies) do
		if not self.hit_targets[enemy] then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_shukuchi_damage_arc.vpcf", PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			self.damage_table.victim = enemy
			ApplyDamage(self.damage_table)
			self.hit_targets[enemy]	= true
		end
	end
end

function modifier_weaver_shukuchi_custom:CheckState()
    return 
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
        [MODIFIER_STATE_UNSLOWABLE]			= true,
        [MODIFIER_STATE_INVISIBLE]			= true
    }
end

function modifier_weaver_shukuchi_custom:DeclareFunctions()
	return 
    {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_weaver_shukuchi_custom:GetModifierMoveSpeedBonus_Constant()
	return self.speed
end

function modifier_weaver_shukuchi_custom:GetModifierInvisibilityLevel()
	return 1
end

function modifier_weaver_shukuchi_custom:OnAttack(keys)
	if keys.attacker == self:GetParent() and not keys.no_attack_cooldown then
		self:Destroy()
	end
end

function modifier_weaver_shukuchi_custom:OnAbilityFullyCast(keys)
    if keys.unit == self:GetParent() and keys.ability ~= self:GetAbility() then
        self:Destroy()
    end
end