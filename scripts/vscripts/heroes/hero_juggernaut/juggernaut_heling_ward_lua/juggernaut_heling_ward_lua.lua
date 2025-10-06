LinkLuaModifier("modifier_dummy", "modifiers/modifier_dummy", LUA_MODIFIER_MOTION_NONE)

juggernaut_heling_ward_lua = class({})

function juggernaut_heling_ward_lua:IsNetherWardStealable() return false end

function juggernaut_heling_ward_lua:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()

	-- Play cast sound
	caster:EmitSound("Hero_Juggernaut.HealingWard.Cast")

	local healing_ward = CreateUnitByName("npc_dota_juggernaut_healing_ward", targetPoint, true, caster, caster, caster:GetTeamNumber())
	
	--SetCreatureHealth(healing_ward, self:GetSpecialValueFor("health"), true)
	
	healing_ward:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetDuration()})
	healing_ward:AddNewModifier(caster, self, "modifier_dummy", {duration = self:GetDuration()})
	healing_ward:AddAbility("juggernaut_healing_ward_passive_lua"):SetLevel(1)
	
	healing_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
		
	healing_ward:SetContextThink(DoUniqueString(self:GetName()), function()
		healing_ward:MoveToNPC(caster)
		
		return nil
	end, FrameTime())
end

juggernaut_healing_ward_passive_lua = class({})

function juggernaut_healing_ward_passive_lua:GetIntrinsicModifierName()
	return "modifier_juggernaut_healing_ward_passive_lua"
end

function juggernaut_healing_ward_passive_lua:CastFilterResult()
	if not IsTotem(self:GetCaster()) then
		return UF_SUCCESS
	else
		return UF_FAIL_CUSTOM
	end
end

function juggernaut_healing_ward_passive_lua:GetCustomCastError()
	return "Already totem"
end

function juggernaut_healing_ward_passive_lua:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()
	
	caster:EmitSound("Hero_Juggernaut.HealingWard.Cast")
	local healing_ward_ability = caster:GetOwner():FindAbilityByName("juggernaut_heling_ward_lua")

	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:FindModifierByName("modifier_juggernaut_healing_ward_passive_lua"):ForceRefresh()
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_juggernaut_heling_ward_lua_totem", {})
	self:SetActivated(false)
end

LinkLuaModifier("modifier_juggernaut_healing_ward_passive_lua", "heroes/hero_juggernaut/juggernaut_heling_ward_lua/juggernaut_heling_ward_lua", LUA_MODIFIER_MOTION_NONE)
modifier_juggernaut_healing_ward_passive_lua = modifier_juggernaut_healing_ward_passive_lua or class({})

function modifier_juggernaut_healing_ward_passive_lua:OnCreated()
	if IsServer() then
		-- Play spawn particle
		local eruption_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(eruption_pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(eruption_pfx)

		-- Attach ambient particle
		self:GetCaster().healing_ward_ambient_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self:GetCaster().healing_ward_ambient_pfx, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 100))
		ParticleManager:SetParticleControl(self:GetCaster().healing_ward_ambient_pfx, 1, Vector(350, 1, 1))
		ParticleManager:SetParticleControlEnt(self:GetCaster().healing_ward_ambient_pfx, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)

		EmitSoundOn("Hero_Juggernaut.HealingWard.Loop", self:GetParent())
	end
end


function modifier_juggernaut_healing_ward_passive_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_juggernaut_healing_ward_passive_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_juggernaut_healing_ward_passive_lua:GetModifierAura()
	return "modifier_juggernaut_heling_ward_lua_aura"
end

--------------------------------------------------------------------------------

function modifier_juggernaut_healing_ward_passive_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_juggernaut_healing_ward_passive_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_juggernaut_healing_ward_passive_lua:GetAuraRadius()
	if self:GetAbility() then
		return 350
	end
end

function modifier_juggernaut_healing_ward_passive_lua:GetAuraDuration()
	return 0.5
end

function modifier_juggernaut_healing_ward_passive_lua:IsPurgable()
	return false
end

function modifier_juggernaut_healing_ward_passive_lua:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
end

function modifier_juggernaut_healing_ward_passive_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_juggernaut_healing_ward_passive_lua:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_juggernaut_healing_ward_passive_lua:OnAttackLanded(params) -- health handling
	if params.target == self:GetParent() then
		if self:GetParent():GetHealth() > 1 then
			self:GetParent():SetHealth( self:GetParent():GetHealth() - 1)
		else
			self:GetParent():Kill(nil, params.attacker)
		end
	end
end

function modifier_juggernaut_healing_ward_passive_lua:OnDeath(params) -- modifier kill instadeletes thanks valve
	if params.unit == self:GetParent() then
		ParticleManager:DestroyParticle(self:GetCaster().healing_ward_ambient_pfx, false)
		ParticleManager:ReleaseParticleIndex(self:GetCaster().healing_ward_ambient_pfx)
		self:GetCaster().healing_ward_ambient_pfx = nil
		StopSoundOn("Hero_Juggernaut.HealingWard.Loop", self:GetParent())
	end
end

LinkLuaModifier("modifier_juggernaut_heling_ward_lua_aura", "heroes/hero_juggernaut/juggernaut_heling_ward_lua/juggernaut_heling_ward_lua", LUA_MODIFIER_MOTION_NONE)
modifier_juggernaut_heling_ward_lua_aura = modifier_juggernaut_heling_ward_lua_aura or class({})

function modifier_juggernaut_heling_ward_lua_aura:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.caster = self:GetCaster()

	if not IsServer() then return end

	local healing_ward_ability = self.caster:GetOwner():FindAbilityByName("juggernaut_heling_ward_lua")
	self.heal_per_sec = healing_ward_ability:GetSpecialValueFor("health")
	
		if self:GetCaster():FindAbilityByName("special_bonus_juggernaut_agi1")~=nil then
			if self:GetCaster():FindAbilityByName("special_bonus_juggernaut_agi1"):GetLevel() > 0 then 
				self.heal_per_sec =  healing_ward_ability:GetSpecialValueFor("health") + 1
			end
		end
	
	
	self.heal_per_sec_totem	= self.heal_per_sec
	
	self:SetHasCustomTransmitterData(true)
end

function modifier_juggernaut_heling_ward_lua_aura:AddCustomTransmitterData() return {
	heal_per_sec = self.heal_per_sec,
	heal_per_sec_totem = self.heal_per_sec_totem,
} end

function modifier_juggernaut_heling_ward_lua_aura:HandleCustomTransmitterData(data)
	self.heal_per_sec = data.heal_per_sec
	self.heal_per_sec_totem = data.heal_per_sec_totem
end

function modifier_juggernaut_heling_ward_lua_aura:OnRefresh()
	self:OnCreated()
end

function modifier_juggernaut_heling_ward_lua_aura:GetEffectName()
	return "particles/units/heroes/hero_juggernaut/juggernaut_ward_heal.vpcf"
end

function modifier_juggernaut_heling_ward_lua_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_juggernaut_heling_ward_lua_aura:GetModifierHealthRegenPercentage()
	if self:GetCaster() and self:GetCaster().HasModifier and self:GetCaster():HasModifier("modifier_juggernaut_heling_ward_lua_totem") then
		return self.heal_per_sec_totem
	else
		return self.heal_per_sec
	end
end

function modifier_juggernaut_heling_ward_lua_aura:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

-------------------------------------------------
-- MODIFIER_juggernaut_heling_ward_lua_TOTEM --
-------------------------------------------------

LinkLuaModifier("modifier_juggernaut_heling_ward_lua_totem", "heroes/hero_juggernaut/juggernaut_heling_ward_lua/juggernaut_heling_ward_lua", LUA_MODIFIER_MOTION_NONE)

modifier_juggernaut_heling_ward_lua_totem	= modifier_juggernaut_heling_ward_lua_totem or class({})

function modifier_juggernaut_heling_ward_lua_totem:IsPurgable()		return false end
function modifier_juggernaut_heling_ward_lua_totem:RemoveOnDeath()	return false end

function modifier_juggernaut_heling_ward_lua_totem:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_juggernaut_heling_ward_lua_totem:GetModifierModelChange()
	return "models/items/juggernaut/ward/dc_wardupate/dc_wardupate.vmdl"
end