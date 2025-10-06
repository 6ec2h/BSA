LinkLuaModifier( "modifier_anakim_wisp", "heroes/hero_anakim/anakim_wisp/anakim_wisp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_anakim_wisp_handler", "heroes/hero_anakim/anakim_wisp/anakim_wisp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_anakim_wisp_debuff", "heroes/hero_anakim/anakim_wisp/anakim_wisp", LUA_MODIFIER_MOTION_NONE )

anakim_wisp = class({})

function anakim_wisp:Precache( context )
	PrecacheResource( "particle", "particles/anakim/anakim_wisp.vpcf", context )
end


function anakim_wisp:GetIntrinsicModifierName()
	return "modifier_anakim_wisp"
end

----------------------------------------------------------------------------

modifier_anakim_wisp = class({})

function modifier_anakim_wisp:IsHidden()
	return false
end

function modifier_anakim_wisp:IsPurgable()
	return false
end

function modifier_anakim_wisp:RemoveOnDeath()
	return false
end

function modifier_anakim_wisp:OnCreated( kv )
	self.soul_defense = self:GetAbility():GetSpecialValueFor("soul_defense")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")
	self.soul_ampl = self:GetAbility():GetSpecialValueFor("soul_ampl")
	self.kills = self:GetAbility():GetSpecialValueFor("kills")
	self.max_souls = self:GetAbility():GetSpecialValueFor("max_souls")
	self.spirit_min_radius = self:GetAbility():GetSpecialValueFor("min_range")
	
	self:update_talents()
	
	self.kill_count = 0
	
	self.spirits = {}
	self.update_timer 	= 0
	self.time_to_update = 0.5
	self.start_time = GameRules:GetGameTime()
	self:SetHasCustomTransmitterData(true)
	
	self.shield = 0
	self.damage = 0
	
	self:StartIntervalThink(0.03)
	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_anakim_wisp:update_talents()
	self.soul_defense = self:GetAbility():GetSpecialValueFor("soul_defense")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")
	self.soul_ampl = self:GetAbility():GetSpecialValueFor("soul_ampl")
	self.kills = self:GetAbility():GetSpecialValueFor("kills")
	self.max_souls = self:GetAbility():GetSpecialValueFor("max_souls")
	self.spirit_min_radius = self:GetAbility():GetSpecialValueFor("min_range")
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_anakim_tal3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.soul_defense = self.soul_defense + ability:GetSpecialValueFor("value")
	end
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_anakim_tal4")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.kills = self.kills + ability:GetSpecialValueFor("value")
	end
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_anakim_tal5")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.soul_damage = self.soul_damage + 5
		self.soul_ampl = self.soul_ampl + 2
	end
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_anakim_tal6")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.max_souls = self.max_souls + ability:GetSpecialValueFor("value")
	end
end

function modifier_anakim_wisp:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_anakim_wisp:GetModifierPreAttack_BonusDamage()
    return self.soul_damage * self:GetStackCount()
end

function modifier_anakim_wisp:GetModifierSpellAmplify_Percentage()
    return self.soul_ampl * self:GetStackCount()
end

function modifier_anakim_wisp:AddCustomTransmitterData()
    return {
        shield = self.shield,
    }
end

function modifier_anakim_wisp:HandleCustomTransmitterData( data )
    self.shield = data.shield
end

function modifier_anakim_wisp:GetModifierIncomingDamageConstant(event)
    if not IsServer() then
        if self.shield >= 0 then
            return self.shield
        end
    end

    if self:GetParent():IsRealHero() then
        if self.shield > 0 then
            self.damage = self.damage + event.damage
            local num_stacks_to_remove = math.floor(self.damage / self.soul_defense)
            if num_stacks_to_remove > 0 and self:GetStackCount() >= num_stacks_to_remove then
               	for i=1, num_stacks_to_remove do
					self:DecrementStackCount()
				end
                self.damage = self.damage % self.soul_defense
			elseif num_stacks_to_remove > self:GetStackCount() then
				self.damage = 0
				self.shield = 0
				self:SetStackCount(0)
				return 0
            end
            if self:GetStackCount() > 0 then
                self.shield = self.shield - event.damage
                return -event.damage
            else
                self.shield = 0
            end
        end
    else
        return 0
    end
end

function modifier_anakim_wisp:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then 
			self:SetStackCount(0)
			self.shield = 0
			self.damage = 0
			self.kill_count = 0
		end
	
		local pass = false
		local parent = self:GetParent()
		
		if parent:PassivesDisabled() then return end
		if params.unit:IsIllusion() then return end
		if not params.unit:FindModifierByNameAndCaster( "modifier_anakim_wisp_debuff", parent ) then return end
		
		local excludedUnits = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
		"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
		"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
		"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher", "npc_invoker_creep", "npc_mars_creep", "npc_phoenix_creep"}
		
		if table.contains(excludedUnits, params.unit:GetUnitName()) then 
			self.kill_count = self.kill_count + 1
			if self.kill_count >= self.kills and self:GetStackCount() <= self.max_souls then
				pass = true
				self.kill_count = 0
			end
		end
		if pass and (not self:GetParent():PassivesDisabled()) then
			if self:GetStackCount() < self.max_souls then
				self:IncrementStackCount()
				self.shield = math.min(self.shield + self.soul_defense, self:GetStackCount() * self.soul_defense)
			else
				self.shield = math.min(self.shield + self.soul_defense, self:GetStackCount() * self.soul_defense)
			end
		end
	end
end

function modifier_anakim_wisp:OnIntervalThink()
	if IsServer() then
		self:update_talents()
		self:SendBuffRefreshToClients()
		local caster = self:GetCaster()
		local caster_position = caster:GetAbsOrigin()
		local elapsedTime = GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned = elapsedTime / 0.5
		self.update_timer = self.update_timer + FrameTime()
		
		if #self.spirits < self:GetStackCount() then
			local newSpirit = CreateUnitByName("npc_spitit_wisp", caster_position, false, caster, caster, caster:GetTeam())
			newSpirit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			local pfx = ParticleManager:CreateParticle("particles/anakim/anakim_wisp.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			newSpirit.spirit_pfx_silence = pfx
			table.insert(self.spirits, newSpirit)
			newSpirit:AddNewModifier( caster,  self:GetAbility(),  "modifier_anakim_wisp_handler", {})
		end
		
		if #self.spirits > self:GetStackCount() then
			self.spirits[#self.spirits]:RemoveModifierByName("modifier_anakim_wisp_handler")
			self.spirits[#self.spirits] = nil
		end

		local currentRotationAngle	= elapsedTime * 100
		local rotationAngleOffset	= 360 / self.max_souls
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( self.spirits) do
			if not spirit:IsNull() then
				numSpiritsAlive = numSpiritsAlive + 1

				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos 		= Vector(0, self.spirit_min_radius, 0)
				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)

				spirit:SetAbsOrigin(absPos)
			end
		end

		if self.update_timer > self.time_to_update then 
			self.update_timer = 0
		end
		
		if not caster:IsAlive() then
			for k, spirit in pairs( self.spirits) do
				if not spirit:IsNull() then
					spirit:RemoveModifierByName("modifier_anakim_wisp_handler")
				end
			end
			self.spirits = {}
		end
	end
end

-----------------------------------------------------------------------------------------


function modifier_anakim_wisp:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_anakim_wisp:GetModifierAura()
	return "modifier_anakim_wisp_debuff"
end

function modifier_anakim_wisp:GetAuraRadius()
	return 800
end

function modifier_anakim_wisp:GetAuraDuration()
	return 0.5
end

function modifier_anakim_wisp:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_anakim_wisp:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_anakim_wisp:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_anakim_wisp:IsAuraActiveOnDeath()
	return false
end

function modifier_anakim_wisp:GetAuraEntityReject(hEntity)
	if IsServer() then
		if hEntity==self:GetCaster() then return true end
	end
	return false
end

-----------------------------------------------------------------------------------------

modifier_anakim_wisp_debuff = class({})

function modifier_anakim_wisp_debuff:IsHidden()
	return true
end

function modifier_anakim_wisp_debuff:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

modifier_anakim_wisp_handler = class({})

function modifier_anakim_wisp_handler:IsHidden()
	return false
end

function modifier_anakim_wisp_handler:IsPurgable()
	return false
end

function modifier_anakim_wisp_handler:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	}

	return state
end

function modifier_anakim_wisp_handler:OnCreated(params)
end

function modifier_anakim_wisp_handler:OnRemoved()
	if IsServer() then
		local spirit = self:GetParent()
		local ability = self:GetAbility()
		if spirit.spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
		end
		spirit:ForceKill( true )
	end
end

----------------------------------------------------------------------------------------------

function modifier_anakim_wisp:PlayEffects( target )
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 400,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end