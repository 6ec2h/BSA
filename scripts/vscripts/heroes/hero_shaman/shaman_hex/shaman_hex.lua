shaman_hex = class({})
LinkLuaModifier( "modifier_thinker", "heroes/hero_shaman/shaman_hex/shaman_hex", LUA_MODIFIER_MOTION_NONE )

function shaman_hex:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_thinker", -- modifier name
		{ duration = duration } -- kv
	)
end
------------------------------------------------------------------------------------------------

modifier_thinker = class({})

function modifier_thinker:IsHidden()
    return true
end

function modifier_thinker:OnCreated()
time_spawn = 0.5

local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int9")
	if abil ~= nil and abil:GetLevel() > 0 then 
	time_spawn = 0.25
	end
    self:StartIntervalThink(time_spawn)
end

function modifier_thinker:OnIntervalThink()
    local caster = self:GetCaster()
	local point = self:GetCaster():GetAbsOrigin()

		local spawn_hex = CreateUnitByName( "npc_shaman_hex", point + RandomVector( RandomFloat( 150, 150 )), true, nil, nil, DOTA_TEAM_GOODGUYS )
		spawn_hex:SetControllableByPlayer(caster:GetPlayerID(), true)
		spawn_hex:SetOwner(caster)
		spawn_hex:AddNewModifier(spawn_hex, nil, "modifier_hex_ampl_spirit",  { }) 	
		caster:EmitSound("Hero_ShadowShaman.Hex.Target")		
end


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

hex_mine = class({})

function hex_mine:IsHidden()
    return true
end

function hex_mine:GetIntrinsicModifierName()
    return "modifier_hex_mine"
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_hex_mine", "heroes/hero_shaman/shaman_hex/shaman_hex.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

modifier_hex_mine = modifier_hex_mine or class({})

function modifier_hex_mine:OnCreated()
    local caster = self:GetCaster()
    local ability = self
    local particle = "particles/units/heroes/hero_techies/techies_land_mine.vpcf"
    local particle_mine_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_mine_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_mine_fx, 3, caster:GetAbsOrigin())
    self:AddParticle(particle_mine_fx, false, false, -1, false, false)

    self:StartIntervalThink(0.03)
end

function modifier_hex_mine:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local sound = "Hero_Techies.LandMine.Detonate"
        local center = caster:GetAbsOrigin()

        if not caster:IsAlive() then
            self:Destroy()
        end
        local damage = ability:GetSpecialValueFor("damage")
		local player = caster:GetOwner()

		local hex_abil = player:FindAbilityByName("shaman_hex")
		local hex_level = hex_abil:GetLevel()
		local try_damage = damage * hex_level
        local activation_radius = ability:GetSpecialValueFor("activation_radius")
        local damage_radius = ability:GetSpecialValueFor("damage_radius")

        local nearbyEnemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                                caster:GetAbsOrigin(),
                                                nil,
                                                activation_radius,
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_ALL,
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                                FIND_ANY_ORDER,
                                                false)


        if #nearbyEnemies > 0 then
            EmitSoundOn(sound, caster)

            local particle_explosion = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
            local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 1, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(damage_radius, 1, 1))
            ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          caster:GetAbsOrigin(),
                                          nil,
                                          damage_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

            for _,enemy in pairs(enemies) do
                local distance = (caster:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D()
                local damageTable = {victim = enemy,
                                     attacker = caster, 
                                     damage = try_damage,
                                     damage_type = DAMAGE_TYPE_MAGICAL,
                                     ability = self.ability
                }

                ApplyDamage(damageTable)
	
				local abil = player:FindAbilityByName("npc_dota_hero_shadow_shaman_str7")	
				if abil ~= nil and abil:GetLevel() > 0 then 
				enemy:AddNewModifier(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_generic_stunned_lua", -- modifier name
				{ duration = 0.3 } -- kv
				)
				end
            end
            caster:ForceKill(false)
            self:Destroy()
        end
    end    
end

function modifier_hex_mine:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
    }
 
    return state
end


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_hex_ampl_spirit", "heroes/hero_shaman/shaman_hex/shaman_hex.lua", LUA_MODIFIER_MOTION_NONE )

modifier_hex_ampl_spirit = class({})

function modifier_hex_ampl_spirit:IsHidden()
	return false
end

function modifier_hex_ampl_spirit:IsPurgable()
	return false
end

function modifier_hex_ampl_spirit:OnCreated()
if IsServer() then
	local caster = self:GetCaster()
    local player = caster:GetOwner()
	spell_amp_hex = player:GetSpellAmplification(false) * 100
	end
end

function modifier_hex_ampl_spirit:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_hex_ampl_spirit:GetModifierSpellAmplify_Percentage()
	return spell_amp_hex
end