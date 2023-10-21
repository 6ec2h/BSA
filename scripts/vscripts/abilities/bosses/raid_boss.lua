LinkLuaModifier( "modifier_raid_aura", "abilities/bosses/raid_boss.lua", LUA_MODIFIER_MOTION_NONE )

raid_aura = class({})

function raid_aura:GetIntrinsicModifierName()
	return "modifier_raid_aura"
end

------------------------------

modifier_raid_aura = class({})

function modifier_raid_aura:IsHidden()
	return true
end

function modifier_raid_aura:IsPurgable()
	return false
end

function modifier_raid_aura:OnCreated( kv )
	self:StartIntervalThink(0.1)
end

function modifier_raid_aura:OnIntervalThink()
	if IsServer() then
		local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		self:GetCaster():SetBaseMagicalResistanceValue(100 - 5 * #heroes)
		self:GetCaster():SetPhysicalArmorBaseValue(250 - 30 * #heroes)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
fire_raze = class({})

function fire_raze:OnSpellStart()
    local caster = self:GetCaster()
    local numProjectiles = RandomInt(10, 20)
    EmitSoundOn("Conquest.FireTrap.Generic", caster)

    for i = 1, numProjectiles do
		if RandomInt(0,1) == 1 then
			effect = "particles/base_attacks/ranged_tower_good_linear.vpcf"
			damage_type = DAMAGE_TYPE_MAGICAL
		else
			effect = "particles/base_attacks/ranged_tower_bad_linear.vpcf"
			damage_type = DAMAGE_TYPE_PHYSICAL
		end
	
        local projectileInfo = {
            Ability = self,
            EffectName = effect,
            vSpawnOrigin = caster:GetAbsOrigin(),
            fDistance = 2000,
            fStartRadius = 64,
            fEndRadius = 64,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_ALL,
            fExpireTime = GameRules:GetGameTime() + 10.0,
            bDeleteOnHit = false,
            vVelocity = RandomVector(1) * 500,
            bProvidesVision = false,
            iVisionRadius = 1000,
            iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData = {damage_type = damage_type} 
        }
        ProjectileManager:CreateLinearProjectile(projectileInfo)
    end
end


function fire_raze:OnProjectileHit_ExtraData(hTarget, vLocation, data)
    if hTarget and not hTarget:IsInvulnerable() then
        local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = hTarget:GetMaxHealth() * 0.25,
            damage_type = data.damage_type,
            ability = self
        }
        ApplyDamage(damage)
    end
    return false
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

fire_storm = class({})

function fire_storm:OnSpellStart()
    local hCaster = self:GetCaster()
    local point = hCaster:GetOrigin()
    local numMeteors = 9
    local meteorRadius = 315

    for i = 1, numMeteors do
        local spot = point + RandomVector(RandomInt(150, 750))

        if debug_drawing == true then
            DebugDrawCircle(spot, Vector(255, 100, 0), 1, 215, true, 5)
        end

        local shadowEffect = ParticleManager:CreateParticle("particles/meteor_shadow.vpcf", PATTACH_ABSORIGIN, hCaster)
        ParticleManager:SetParticleControl(shadowEffect, 0, spot + Vector(0, 0, 200))

        local meteorEffect = ParticleManager:CreateParticle("particles/invoker_chaos_meteor_fly2.vpcf", PATTACH_ABSORIGIN, hCaster)
        ParticleManager:SetParticleControl(meteorEffect, 0, spot + Vector(0, 0, 2000))
        ParticleManager:SetParticleControl(meteorEffect, 1, spot)
        ParticleManager:SetParticleControl(meteorEffect, 2, Vector(4, 0, 0))

        Timers:CreateTimer(4, function()
            local crashEffect = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN, hCaster)
            ParticleManager:SetParticleControl(crashEffect, 0, spot + Vector(0, 0, 200))

            local unitTable = FindUnitsInRadius(hCaster:GetTeamNumber(), spot, nil, meteorRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for k, unit in pairs(unitTable) do
                local damageTable = {
                    victim = unit,
                    attacker = hCaster,
                    damage = unit:GetMaxHealth() * 0.3,
                    damage_type = DAMAGE_TYPE_PURE,
                }
                ApplyDamage(damageTable)
            end
            return 
        end)
    end
end


----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_water_skill_1", "abilities/bosses/raid_boss.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_simply_motion", "abilities/bosses/raid_boss.lua", LUA_MODIFIER_MOTION_BOTH )

water_skill_1 = class({})

function water_skill_1:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_water_skill_1", {})
end

--------------------------------------------------------------------------------

modifier_water_skill_1 = class({})

function modifier_water_skill_1:IsHidden()
    return true
end

function modifier_water_skill_1:IsPurgable()
    return false
end

function modifier_water_skill_1:RemoveOnDeath()
    return true
end

function modifier_water_skill_1:DestroyOnExpire()
    return true
end

function modifier_water_skill_1:OnCreated()
    if IsClient() then
        return
    end
    self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invulnerable", {})
    self.pocs = 0
    self.max_pocs = self:GetAbility():GetSpecialValueFor("max_pocs")
    self:StartIntervalThink(1)
    self:OnIntervalThink()
end

function modifier_water_skill_1:OnIntervalThink()
    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx, false)
    end
    if self.pocs <= self.max_pocs then
        local origin = self:GetCaster():GetOrigin()
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), origin, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 2, false)
        if enemies[1] == nil or enemies[1] == self.lasttarget then
            EmitSoundOn("Hero_Morphling.Waveform", self:GetCaster())
            self.lasttarget = nil
            self.pocs = self.pocs + 1
            local new_pos = origin + RandomVector(600)
            local distance = (origin - new_pos):Length2D()
            local direction = (origin - new_pos):Normalized()
            self.pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControl(self.pfx, 1, direction * 600)
            self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_simply_motion", {
                x = direction.x, y = direction.y, r = distance, s = distance + 30,})
        else
            EmitSoundOn("Hero_Morphling.Waveform", self:GetCaster())
            self.pocs = self.pocs + 1
            self.lasttarget = enemies[1]
            local new_pos = enemies[1]:GetOrigin()
            local distance = (new_pos - origin):Length2D()
            local direction = (new_pos - origin):Normalized()
            self.pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControl(self.pfx, 1, direction * distance )
            self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_simply_motion", {
                x = direction.x, y = direction.y, r = distance, s = distance + 30,})
        end
    else
        self:Destroy()
    end
end

function modifier_water_skill_1:OnDestroy()
    if IsClient() then
        return
    end
    self.mod:Destroy()
end

function modifier_water_skill_1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_CHANGE
    }
end

function modifier_water_skill_1:GetModifierModelChange()
    return "models/development/invisiblebox.vmdl"
end

----------------------------------------

modifier_simply_motion = class({})

function modifier_simply_motion:IsHidden()
	return true
end

function modifier_simply_motion:IsPurgable()
	return false
end

function modifier_simply_motion:OnCreated( kv )
	if IsServer() then
        self.units = {}
		self.distance = kv.r
		self.direction = Vector(kv.x,kv.y,0):Normalized()
		self.speed = kv.s
		self.origin = self:GetParent():GetOrigin()
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_simply_motion:OnRefresh( kv )
	if IsServer() then
		self.distance = kv.r
		self.direction = Vector(kv.x,kv.y,0):Normalized()
		self.speed = kv.s
		self.origin = self:GetParent():GetOrigin()
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end	
end

function modifier_simply_motion:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_simply_motion:UpdateHorizontalMotion( me, dt )
	local pos = self:GetParent():GetOrigin()
	if (pos-self.origin):Length2D()>=self.distance then
		self:Destroy()
		return
	end
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,unit in pairs(enemies) do
        if self.units[unit] == nil then
	        ApplyDamage({
				victim = unit,
				damage = unit:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("damage")/100,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker = self:GetCaster(),
			})
		
            self.units[unit] = true
            local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform_dmg.vpcf", PATTACH_POINT, unit)
            ParticleManager:ReleaseParticleIndex(pfx)
        end
    end
    local target = pos + self.direction * (self.speed*dt)
	self:GetParent():SetOrigin( target )
end

function modifier_simply_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end