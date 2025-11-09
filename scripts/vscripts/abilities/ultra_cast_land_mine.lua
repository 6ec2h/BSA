LinkLuaModifier("modifier_ultra_cast_land_mine", "abilities/ultra_cast_land_mine.lua", LUA_MODIFIER_MOTION_NONE)

ultra_cast_land_mine = class({})

function ultra_cast_land_mine:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_techies/techies_land_mine.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context)
end

function ultra_cast_land_mine:GetIntrinsicModifierName()
    return "modifier_ultra_cast_land_mine"
end

modifier_ultra_cast_land_mine = class({})

function modifier_ultra_cast_land_mine:OnCreated()
	if not IsServer() then return end

    local caster = self:GetCaster()

    local particle_mine_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_mine_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_mine_fx, 3, caster:GetAbsOrigin())
    self:AddParticle(particle_mine_fx, false, false, -1, false, false)

	EmitSoundOn("Hero_Techies.RemoteMine.Priming", caster)

    self:StartIntervalThink(1.5)
end

function modifier_ultra_cast_land_mine:OnIntervalThink()
    if not IsServer() then return end

	local caster = self:GetCaster()

	if not caster:IsAlive() then
		self:Destroy()
		return
	end

	local ability = self:GetAbility()
	local damageRadius = 450

	EmitSoundOn("Hero_Techies.RemoteMine.Detonate", caster)

	local pos = caster:GetAbsOrigin()

	local particle_explosion_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_explosion_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_explosion_fx, 1, pos)
	ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(damageRadius, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

	local nearbyEnemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, damageRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	for _, enemy in pairs(nearbyEnemies) do
		if not enemy:IsQuestSheep() then
			ApplyDamage({
				victim = enemy,
				attacker = caster, 
				damage = enemy:GetMaxHealth() / 2,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self.ability
			})
		end
	end

	caster:ForceKill(false)
	self:Destroy()
end

function modifier_ultra_cast_land_mine:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true,
    }
end