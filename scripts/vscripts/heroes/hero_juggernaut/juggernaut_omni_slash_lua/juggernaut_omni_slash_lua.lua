LinkLuaModifier("modifier_juggernaut_omni_slash_lua_caster", "heroes/hero_juggernaut/juggernaut_omni_slash_lua/juggernaut_omni_slash_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_omni_slash_lua_image", "heroes/hero_juggernaut/juggernaut_omni_slash_lua/juggernaut_omni_slash_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omnislash_image_afterimage_fade", "heroes/hero_juggernaut/juggernaut_omni_slash_lua/juggernaut_omni_slash_lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_juggernaut_omni_slash_lua_cdr", "heroes/hero_juggernaut/juggernaut_omni_slash_lua/juggernaut_omni_slash_lua", LUA_MODIFIER_MOTION_NONE)

juggernaut_omni_slash_lua = class({})

-- function juggernaut_omni_slash_lua:GetIntrinsicModifierName()
	-- return	"modifier_juggernaut_omni_slash_lua_cdr"
-- end

function juggernaut_omni_slash_lua:IsHiddenWhenStolen()
	return false
end

function juggernaut_omni_slash_lua:OnOwnerDied()
	if not self:IsActivated() then
		self:SetActivated(true)
	end
end

function juggernaut_omni_slash_lua:GetCooldown(level) 
	if self:GetCaster():FindAbilityByName("special_bonus_juggernaut_int8")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_juggernaut_int8"):GetLevel() > 0 then 
			return self.BaseClass.GetCooldown(self, level) - 30
		end
	end
		return self.BaseClass.GetCooldown(self, level)
end

function juggernaut_omni_slash_lua:OnOwnerSpawned()
	self:OnOwnerDied()
end

function juggernaut_omni_slash_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local rand = math.random
	
	if caster:GetName() == "npc_dota_hero_juggernaut" then
		caster:EmitSound("juggernaut_jug_ability_omnislash_0"..rand(3))
	end
	return true
end

function juggernaut_omni_slash_lua:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	self.duration = self:GetSpecialValueFor("duration")

	self.previous_position = self.caster:GetAbsOrigin()
	
	self.caster:Purge(false, true, false, false, false)
	
	local omnislash_modifier_handler
	
	omnislash_modifier_handler = self.caster:AddNewModifier(self.caster, self, "modifier_juggernaut_omni_slash_lua_caster", {duration = self.duration})

	if omnislash_modifier_handler then
		omnislash_modifier_handler.original_caster = self.caster
	end

	self:SetActivated(false)
---------------------------------------------------------------------------------------------------
	if self.caster:HasAbility("juggernaut_blade_fury_lua") then
		self.caster:FindAbilityByName("juggernaut_blade_fury_lua"):SetActivated(false)
	end
---------------------------------------------------------------------------------------------------
	FindClearSpaceForUnit(self.caster, self.target:GetAbsOrigin() + RandomVector(128), false)

	self.caster:EmitSound("Hero_Juggernaut.OmniSlash")

	self.current_position = self.caster:GetAbsOrigin()
	
	local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.caster)
	ParticleManager:SetParticleControl(trail_pfx, 0, self.previous_position)
	ParticleManager:SetParticleControl(trail_pfx, 1, self.current_position)
	ParticleManager:ReleaseParticleIndex(trail_pfx)
	
end

------------------------------------------------------------------------

modifier_juggernaut_omni_slash_lua_image = class ({})

function modifier_juggernaut_omni_slash_lua_image:CheckState()
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end

function modifier_juggernaut_omni_slash_lua_image:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.5)
end

function modifier_juggernaut_omni_slash_lua_image:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetParent()
	if not caster:HasModifier("modifier_juggernaut_omni_slash_lua_caster") then
		self:Destroy()
	end
end

function modifier_juggernaut_omni_slash_lua_image:IsHidden()
	return true
end

function modifier_juggernaut_omni_slash_lua_image:IsPurgable()
	return false
end

function modifier_juggernaut_omni_slash_lua_image:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

----------------------------------------------------------------------------------------

modifier_juggernaut_omni_slash_lua_caster = modifier_juggernaut_omni_slash_lua_caster or class({})

function modifier_juggernaut_omni_slash_lua_caster:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.last_enemy = nil

	if not self:GetAbility() then
		self:Destroy()
		return nil
	end

	self.slash = true

	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			if (not self.parent:IsNull()) then
				
				self.bounce_range = self:GetAbility():GetSpecialValueFor("omni_slash_radius")
				
				self.hero_agility = self.original_caster:GetAgility()
				self:GetAbility():SetRefCountsModifiers(false)

				self:BounceAndSlaughter(true)
				
				local slash_rate = self:GetAbility():GetSpecialValueFor("bounce_delay")--self.caster:GetSecondsPerAttack() / math.max(self:GetAbility():GetSpecialValueFor("attack_rate_multiplier"))
				
				self:StartIntervalThink(slash_rate)
			end
		end)
	end
end

function modifier_juggernaut_omni_slash_lua_caster:OnIntervalThink()
	self.hero_agility = self.original_caster:GetAgility()
	self:BounceAndSlaughter()
	
	local slash_rate = self:GetAbility():GetSpecialValueFor("bounce_delay") --bounce_delay self.caster:GetSecondsPerAttack() / math.max(self:GetAbility():GetSpecialValueFor("attack_rate_multiplier"))
	-- print(slash_rate)

	self:StartIntervalThink(-1)
	self:StartIntervalThink(slash_rate)
end

function modifier_juggernaut_omni_slash_lua_caster:BounceAndSlaughter(first_slash)
	local order = FIND_ANY_ORDER
	
	if first_slash then
		order = FIND_CLOSEST
	end
	
	self.nearby_enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.bounce_range,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		order,
		false
	)
	
	for count = #self.nearby_enemies, 1, -1 do
		-- "Cannot jump on units in the Fog of War, invisible or hidden units, Tombstone Zombies and on Astral Spirits."
		if self.nearby_enemies[count] and (self.nearby_enemies[count]:GetName() == "npc_dota_unit_undying_zombie" or self.nearby_enemies[count]:GetName() == "npc_dota_elder_titan_ancestral_spirit") then
			table.remove(self.nearby_enemies, count)
		end
	end

	if #self.nearby_enemies >= 1 then
		for _,enemy in pairs(self.nearby_enemies) do
			local previous_position = self.parent:GetAbsOrigin()
			-- Used to be 128 but it seems to interrupt a lot at fast speeds if there's Lotus battles...
			FindClearSpaceForUnit(self.parent, enemy:GetAbsOrigin() + RandomVector(100), false)
			
			if not self:GetAbility() then break end

			local current_position = self.parent:GetAbsOrigin()

			-- Face the enemy every slash
			self.parent:FaceTowards(enemy:GetAbsOrigin())
			
			-- Provide vision of the target for a short duration
			AddFOWViewer(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), 200, 1, false)

			-- Perform the slash
			self.slash = true
			
			if first_slash and enemy:TriggerSpellAbsorb(self:GetAbility()) then
				break
			else
				self.parent:PerformAttack(enemy, true, true, true, true, true, false, false)
			end

			-- If the target is not Roshan or a hero, instantly kill it
			if enemy:IsConsideredHero() or enemy:GetUnitName() == "npc_dota_mutation_golem" then
				if not enemy:IsAlive() and self:GetAbility().omnislash_kill_count then
					self:GetAbility().omnislash_kill_count = self:GetAbility().omnislash_kill_count + 1
				end
	--			else
	--			enemy:Kill(self:GetAbility(), self.original_caster)
			end

			-- Play hit sound
			enemy:EmitSound("Hero_Juggernaut.OmniSlash.Damage")

			-- Play hit particle on the current target
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:SetParticleControl(hit_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Play particle trail when moving
			local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.parent)
			ParticleManager:SetParticleControl(trail_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)

			if self.last_enemy ~= enemy then
				local dash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_dash.vpcf", PATTACH_ABSORIGIN, self.parent)
				ParticleManager:SetParticleControl(dash_pfx, 0, previous_position)
				ParticleManager:SetParticleControl(dash_pfx, 2, current_position)
				ParticleManager:ReleaseParticleIndex(dash_pfx)
			end

			self.last_enemy = enemy



			break
		end
	else
		self:Destroy()
	end
end

function modifier_juggernaut_omni_slash_lua_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_juggernaut_omni_slash_lua_caster:GetModifierPreAttack_BonusDamage(kv)
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_juggernaut_omni_slash_lua_caster:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_juggernaut_omni_slash_lua_caster:OnDestroy()
	if IsServer() then
		self:GetAbility():SetActivated(true)

		if self.caster:HasModifier("modifier_juggernaut_arcana") then
			Timers:CreateTimer(0.1, function()
				if self.ability.omnislash_kill_count and self.ability.omnislash_kill_count > 0 then
					ArcanaKill(self.caster, self.ability.omnislash_kill_count)
					self.ability.omnislash_kill_count = 0
				end
			end)
		end

		-- Re-enable Blade Fury during Omnislash (vanilla)
		if self.caster:HasAbility("juggernaut_blade_fury_lua") then
			self.caster:FindAbilityByName("juggernaut_blade_fury_lua"):SetActivated(true)
		end

		self.parent:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		
		self.parent:MoveToPositionAggressive(self.parent:GetAbsOrigin())

		-- Create the delay effect before the image destroys itself.
		if self.parent:HasModifier("modifier_juggernaut_omni_slash_lua_image") then
			if self.parent:HasModifier("modifier_imba_juggernaut_blade_fury") then
				self.parent:RemoveModifierByName("modifier_imba_juggernaut_blade_fury")
			end

	
	

			-- Create the after image before it fades
			if self.previous_pos then
				CreateModifierThinker(self.original_caster, self:GetAbility(), "modifier_omnislash_image_afterimage_fade" ,{duration = 1.0, previous_position_x = self.previous_pos.x, previous_position_y = self.previous_pos.y, previous_position_z = self.previous_pos.z}, self.current_pos, self.original_caster:GetTeamNumber(), false)
			else -- not a real fix, just unallow an uncontrollable jugg to spawn
				print("No previous pos!")
			end

			self:GetParent():MakeIllusion()
			self:GetParent():RemoveModifierByName("modifier_juggernaut_omni_slash_lua_image")

			for item_id=0, 5 do
				local item_in_caster = self.parent:GetItemInSlot(item_id)
				if item_in_caster ~= nil then
					UTIL_Remove(item_in_caster)
				end
			end

			-- Search for buffs and debuffs
			local caster_modifiers = self.parent:FindAllModifiers()
			for _,modifier in pairs(caster_modifiers) do
				if modifier then
					UTIL_Remove(modifier)
				end
			end

			if (not self:GetParent():IsNull()) then
				-- self:GetCaster():SetAbsOrigin(Vector(0,0,99999))
				-- self:GetCaster():AddNoDraw()

				local iparent = self:GetParent()
				UTIL_Remove(iparent)
			end
		end
	end	
end

modifier_omnislash_image_afterimage_fade = modifier_omnislash_image_afterimage_fade or class({})

function modifier_omnislash_image_afterimage_fade:OnCreated(keys)
	if not IsServer() then return end

	local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControl(trail_pfx, 0, Vector(keys.previous_position_x, keys.previous_position_y, keys.previous_position_z))
	ParticleManager:SetParticleControl(trail_pfx, 1, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(trail_pfx)
end

function modifier_juggernaut_omni_slash_lua_caster:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		-- [MODIFIER_STATE_STUNNED] = true,
		-- [MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

function modifier_juggernaut_omni_slash_lua_caster:StatusEffectPriority()
	return 20
end

function modifier_juggernaut_omni_slash_lua_caster:GetStatusEffectName()
	return self:GetCaster().omni_slash_status_effect or "particles/status_fx/status_effect_omnislash.vpcf"
end

function modifier_juggernaut_omni_slash_lua_caster:IsHidden() return false end
function modifier_juggernaut_omni_slash_lua_caster:IsPurgable() return false end
function modifier_juggernaut_omni_slash_lua_caster:IsDebuff() return false end

--------------------------------------------------------------------------------------------

modifier_juggernaut_arcana = modifier_juggernaut_arcana or class ({})

function modifier_juggernaut_arcana:RemoveOnDeath()
	return false
end

function modifier_juggernaut_arcana:IsHidden()
	return not IsInToolsMode()
end

function modifier_juggernaut_arcana:OnCreated()
	if IsServer() then
		self.kill_count = 0
		self.timer_running = false
	end
end

function modifier_juggernaut_arcana:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_HERO_KILLED
	}
end

function modifier_juggernaut_arcana:OnIntervalThink()
	if self.kill_count > 0 then
		self.kill_count = 0
	end

	self.timer_running = false
	self:StartIntervalThink(-1)
end

function modifier_juggernaut_arcana:OnHeroKilled(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not self:GetParent():HasModifier("modifier_juggernaut_omni_slash_lua_caster") then
			if self.timer_running == false then
				self.timer_running = true
				self:StartIntervalThink(20.0)
			end

			self.kill_count = self.kill_count + 1

			if self.kill_count >= 3 then
				ArcanaKill(self:GetParent())
			end
		end
	end
end

-- Arcana animation handler
LinkLuaModifier("modifier_juggernaut_arcana_kill", "heroes/hero_juggernaut/juggernaut_omni_slash_lua/juggernaut_omni_slash_lua", LUA_MODIFIER_MOTION_NONE)

modifier_juggernaut_arcana_kill = modifier_juggernaut_arcana_kill or class ({})

function modifier_juggernaut_arcana_kill:IsHidden()
	return true
end

function modifier_juggernaut_arcana_kill:DeclareFunctions()
	local table = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return table
end

function modifier_juggernaut_arcana_kill:GetActivityTranslationModifiers()
	return "arcana_style"
end

function modifier_juggernaut_arcana_kill:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ARCANA
end

function modifier_juggernaut_arcana_kill:OnCreated(keys)
	if IsServer() then
		self:GetParent():EmitSound("Hero_Juggernaut.ArcanaTrigger")

		if keys.kills == nil then keys.kills = 0 end

		local pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 3, Vector(math.min(keys.kills, 5), 0, 0))

		if keys.kills > 0 then
			local pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControl(pfx, 1, Vector(10, math.min(keys.kills, 9), 0))
		end
	end
end
