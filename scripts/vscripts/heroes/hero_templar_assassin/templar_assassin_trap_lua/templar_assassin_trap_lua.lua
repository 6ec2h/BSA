LinkLuaModifier("modifier_templar_assassin_trap_lua", "heroes/hero_templar_assassin/templar_assassin_trap_lua/templar_assassin_trap_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_trap_lua_slow", "heroes/hero_templar_assassin/templar_assassin_trap_lua/templar_assassin_trap_lua", LUA_MODIFIER_MOTION_NONE)

templar_assassin_trap_lua = class({})

function templar_assassin_trap_lua:OnSpellStart()
	local position = self:GetCaster():GetAbsOrigin()

	self:GetCaster():EmitSound("Hero_TemplarAssassin.Trap.Cast")
	EmitSoundOnLocationWithCaster(position, "Hero_TemplarAssassin.Trap", self:GetCaster())
	if self:GetCaster():GetName() == "npc_dota_hero_templar_assassin" then
		if RollPercentage(1) then
			self:GetCaster():EmitSound("templar_assassin_temp_psionictrap_04")
		elseif RollPercentage(50) then
			self:GetCaster():EmitSound("templar_assassin_temp_psionictrap_0"..RandomInt(1, 3))
		end
	end

	local trap = CreateUnitByName("npc_dota_templar_assassin_psionic_trap", position, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	FindClearSpaceForUnit(trap, trap:GetAbsOrigin(), false)
	trap:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	trap:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
	trap:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_trap_lua", {})
end


function templar_assassin_trap_lua:OnUpgrade()
	if IsServer() then
		local teleport = self:GetCaster():FindAbilityByName("templar_assassin_trap_lua_teleport")
		local level = self:GetLevel()
		if teleport then
			if teleport:GetLevel() < level then
				teleport:SetLevel(level)
			end
		end		
	end
end

-------------------------------------------------------------------------------------------

modifier_templar_assassin_trap_lua = class({})

function modifier_templar_assassin_trap_lua:IsHidden()
	return true
end

function modifier_templar_assassin_trap_lua:IsPurgable()
	return true
end

function modifier_templar_assassin_trap_lua:OnCreated()
	self.self_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.self_particle, 60, Vector(141, 0, 0))
	ParticleManager:SetParticleControl(self.self_particle, 61, Vector(1, 0, 0))
	self:AddParticle(self.self_particle, false, false, -1, false, false)
end

function modifier_templar_assassin_trap_lua:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end

function modifier_templar_assassin_trap_lua:OnDestroy()
	self:GetParent():EmitSound("Hero_TemplarAssassin.Trap.Explode")
	self.explode_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.explode_particle, 60, Vector(141, 0, 0))
	ParticleManager:SetParticleControl(self.explode_particle, 61, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(self.explode_particle)

	for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		local slow_modifier = enemy:AddNewModifier(self:GetParent():GetOwner(), self:GetAbility(), "modifier_templar_assassin_trap_lua_slow", {duration = self:GetAbility():GetSpecialValueFor("slow_duration")})
	end
end

-----------------------------------------------------

modifier_templar_assassin_trap_lua_slow = class({})

function modifier_templar_assassin_trap_lua_slow:GetTexture()
	return "templar_assassin_psionic_trap"
end

function modifier_templar_assassin_trap_lua_slow:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_slow.vpcf"
end

function modifier_templar_assassin_trap_lua_slow:OnCreated(params)
	self.slow = self:GetAbility():GetSpecialValueFor("slow") * (-1)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_templar_assassin_tal2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage = self.damage + 150
	end
if not IsServer() then return end	
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
	self:StartIntervalThink(1)
end

function modifier_templar_assassin_trap_lua_slow:OnIntervalThink()
if not IsServer() then return end
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

function modifier_templar_assassin_trap_lua_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_templar_assassin_trap_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

-------------------------------------------------------------------------

templar_assassin_trap_lua_teleport = class({})

function templar_assassin_trap_lua_teleport:OnSpellStart()
	local position = self:GetCaster():GetAbsOrigin()

	self:GetCaster():EmitSound("Hero_TemplarAssassin.Trap.Cast")

	traps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	if #traps > 0 then
		for _,trap in pairs(traps) do
			if trap:GetUnitName() == "npc_dota_templar_assassin_psionic_trap" then
				local trap_ability = self:GetCaster():FindAbilityByName("templar_assassin_trap_lua")
				for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
					local slow_modifier = enemy:AddNewModifier(self:GetCaster(), trap_ability, "modifier_templar_assassin_trap_lua_slow", {duration = trap_ability:GetSpecialValueFor("slow_duration")})
				end
				FindClearSpaceForUnit(self:GetCaster(), trap:GetAbsOrigin(), false)
				trap:ForceKill(false)
				break
			end
		end
	end
end