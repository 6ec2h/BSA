LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua_speed_handler", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_flak_cannon_lua_side_gunner", "heroes/hero_gyrocopter/gyrocopter_flak_cannon_lua/gyrocopter_flak_cannon_lua", LUA_MODIFIER_MOTION_NONE)

gyrocopter_flak_cannon_lua = gyrocopter_flak_cannon_lua or class({})
modifier_gyrocopter_flak_cannon_lua = modifier_gyrocopter_flak_cannon_lua or class({})
modifier_gyrocopter_flak_cannon_lua_speed_handler = modifier_gyrocopter_flak_cannon_lua_speed_handler or class({})
modifier_gyrocopter_flak_cannon_lua_side_gunner	= modifier_gyrocopter_flak_cannon_lua_side_gunner or class({})

function gyrocopter_flak_cannon_lua:GetIntrinsicModifierName()
	return "modifier_gyrocopter_flak_cannon_lua_side_gunner"
end

function gyrocopter_flak_cannon_lua:OnInventoryContentsChanged()
	if self:GetIntrinsicModifierName() and self:GetCaster():HasModifier(self:GetIntrinsicModifierName()) then
			self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):StartIntervalThink(-1)
	end
end

function gyrocopter_flak_cannon_lua:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function gyrocopter_flak_cannon_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.FlackCannon.Activate")

	self:GetCaster():RemoveModifierByName("modifier_gyrocopter_flak_cannon_lua")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_flak_cannon_lua", {duration = self:GetDuration()})
end

function gyrocopter_flak_cannon_lua:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	if self:GetCaster():FindAbilityByName("special_bonus_gyrocopter_agi3")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_gyrocopter_agi3"):GetLevel() > 0 then 
			cooldown = cooldown - 4
		end
	end
	return cooldown
end

------------------------------------------
------------------------------------------

function modifier_gyrocopter_flak_cannon_lua:GetEffectName()
	return "particles/units/heroes/hero_gyrocopter/gyro_flak_cannon_overhead.vpcf"
end

function modifier_gyrocopter_flak_cannon_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_gyrocopter_flak_cannon_lua:OnCreated()
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.max_attacks		= self:GetAbility():GetSpecialValueFor("max_attacks")
	self.projectile_speed	= self:GetAbility():GetSpecialValueFor("projectile_speed")
	self.fresh_rounds		= self:GetAbility():GetSpecialValueFor("fresh_rounds")
	
	if not IsServer() then return end
	
	self.weapons			= {"attach_attack1", "attach_attack2"}
	
	self:SetStackCount(self.max_attacks)
end

function modifier_gyrocopter_flak_cannon_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_gyrocopter_flak_cannon_lua:OnAttack(keys)
	if keys.attacker == self:GetParent() and not keys.no_attack_cooldown then
		self:GetParent():EmitSound("Hero_Gyrocopter.FlackCannon")
		
		-- "Does not target couriers, wards, buildings, invisible units, or units inside the Fog of War."
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.target and not enemy:IsCourier() then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_gyrocopter_flak_cannon_lua_speed_handler", {projectile_speed = self.projectile_speed})
				-- IMBAfication: Fresh Rounds
				self:GetParent():PerformAttack(enemy, true, self:GetStackCount() > self.max_attacks - self.fresh_rounds, true, true, true, false, false)
				self:GetParent():RemoveModifierByName("modifier_gyrocopter_flak_cannon_lua_speed_handler")
			end
		end
		
		self:DecrementStackCount()
		
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------
--------------------------------------------------------


function modifier_gyrocopter_flak_cannon_lua_speed_handler:IsHidden()		return true end
function modifier_gyrocopter_flak_cannon_lua_speed_handler:IsPurgable()	return false end

function modifier_gyrocopter_flak_cannon_lua_speed_handler:OnCreated(keys)
	if not IsServer() then return end
	
	self.projectile_speed		= keys.projectile_speed
	self.projectile_speed_base	= self:GetParent():GetProjectileSpeed()
end

function modifier_gyrocopter_flak_cannon_lua_speed_handler:DeclareFunctions()
	return {MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS}
end

function modifier_gyrocopter_flak_cannon_lua_speed_handler:GetModifierProjectileSpeedBonus()
	if self.projectile_speed and self.projectile_speed_base then
		return self.projectile_speed - self.projectile_speed_base
	end
end

------------------------------------------------------
------------------------------------------------------

function modifier_gyrocopter_flak_cannon_lua_side_gunner:IsHidden()		return true end
function modifier_gyrocopter_flak_cannon_lua_side_gunner:IsPurgable()		return false end
function modifier_gyrocopter_flak_cannon_lua_side_gunner:RemoveOnDeath()	return false end

-- Tthe scepter effect seems to be tied to the hero as vanilla so this probably won't be necessary

-- "The Side Gunner does not attack when Gyrocopter is hidden, invisible, or affected by Break."
function modifier_gyrocopter_flak_cannon_lua_side_gunner:OnIntervalThink()
	if self:GetParent():HasScepter() and not self:GetParent():IsOutOfGame() and not self:GetParent():IsInvisible() and not self:GetParent():PassivesDisabled() and self:GetParent():IsAlive() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("scepter_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_FARTHEST, false)) do
			if not enemy:IsCourier() then
				self:GetParent():PerformAttack(enemy, false, false, true, true, true, false, false)
				break
			end
		end
	end
end