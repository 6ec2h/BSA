modifier_shadow_fiend_necromastery_lua = class({})

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:IsHidden()
	return false
end

function modifier_shadow_fiend_necromastery_lua:IsDebuff()
	return false
end

function modifier_shadow_fiend_necromastery_lua:IsPurgable()
	return false
end

function modifier_shadow_fiend_necromastery_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:OnCreated( kv )
	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")
end

function modifier_shadow_fiend_necromastery_lua:OnRefresh( kv )

	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")
end

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_shadow_fiend_necromastery_lua:OnDeath( params )
	if IsServer() then
		-- Проверяем, кто умер
		if params.unit == self:GetParent() then
			-- Умер сам герой - применяем DeathLogic
			self:DeathLogic( params )
		else
			-- Умер враг - применяем KillLogic
			self:KillLogic( params )
		end
	end
end

function modifier_shadow_fiend_necromastery_lua:GetModifierPreAttack_BonusDamage( params )
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount() * self.soul_damage
	end
end

never_creeps = {"satyr_soulstealer","satyr_hellcaller","npc_dota_creature_hellbear","npc_dota_creature_small_hellbear","npc_dota_creature_dire_hound","npc_dota_creature_dire_hound_boss",
"forest_zombie","skeleton","npc_creep_crystal","apparat","tusk","icespider","white_walker","mirana","npc_dota_creature_large_ogre_seal","guard","npc_trap_visage","tank","undying","morf",
"npc_blob","npc_slardar_unit","npc_shaker","npc_zone_jungle_1","npc_zone_jungle_2","npc_zone_jungle_3","npc_zone_jungle_4","npc_keeper_of_the_light","miner","small_hellbear","encha","treant",
"npc_lifestealer","batr","warlock","pudge","npc_venom_creep","demon","npc_gyro","npc_enigma","npc_sniper","npc_disruptor","cher"}

--------------------------------------------------------------------------------
function modifier_shadow_fiend_necromastery_lua:DeathLogic( params )
	local caster = self:GetCaster()
	local unit = params.unit
	
	-- Проверяем, что умер именно этот герой и нет реинкарнации
	if unit ~= self:GetParent() or params.reincarnate then return end

	local special_bonus_unique_nevermore_2 = caster:FindAbilityByName("special_bonus_unique_nevermore_2")

	if special_bonus_unique_nevermore_2 and special_bonus_unique_nevermore_2:GetLevel() > 0 then return end

	-- При смерти героя теряем часть душ
	self:SetStackCount(math.max(1, math.floor(self:GetStackCount() * self.soul_release)))
end

function modifier_shadow_fiend_necromastery_lua:KillLogic( params )
	local target = params.unit
	local attacker = params.attacker
	local unit_name = target:GetUnitName()
	
	-- Проверяем базовые условия
	if attacker ~= self:GetParent() or target == self:GetParent() or not attacker:IsAlive() then
		return
	end
	
	-- Проверяем, что цель не иллюзия и не здание
	if target:IsIllusion() or target:IsBuilding() then
		return
	end
	
	-- Проверяем, что пассивка не отключена
	if self:GetParent():PassivesDisabled() then
		return
	end
	
	-- Проверяем, что убитая цель в списке разрешенных
	local pass = false
	for _, current_name in pairs(never_creeps) do
		if current_name == unit_name then
			pass = true
			break
		end
	end
	
	if pass then
		self:AddStack(1)
	end
end

function modifier_shadow_fiend_necromastery_lua:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value

	self:SetStackCount( after )
end

function modifier_shadow_fiend_necromastery_lua:PlayEffects( target )
	-- Get Resources
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

	-- CreateProjectile
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