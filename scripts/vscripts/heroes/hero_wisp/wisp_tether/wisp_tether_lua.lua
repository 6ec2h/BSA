wisp_tether_lua = class({})

LinkLuaModifier("modifier_wisp_tether_lua", "heroes/hero_wisp/wisp_tether/wisp_tether_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_tether_lua_ally", "heroes/hero_wisp/wisp_tether/wisp_tether_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_tether_lua_latch", "heroes/hero_wisp/wisp_tether/wisp_tether_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_tether_lua_ally_attack", "heroes/hero_wisp/wisp_tether/wisp_tether_lua.lua", LUA_MODIFIER_MOTION_NONE)

function wisp_tether_lua:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	elseif target:HasModifier("modifier_wisp_tether_lua") and self:GetCaster():HasModifier("modifier_wisp_tether_lua_ally") then
		return "WHY WOULD YOU DO THIS"
	end
end

function wisp_tether_lua:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target == caster then
			return UF_FAIL_CUSTOM
		end

		if target:IsCourier() then
			return UF_FAIL_COURIER
		end

		if target:HasModifier("modifier_wisp_tether_lua") and self:GetCaster():HasModifier("modifier_wisp_tether_lua_ally") then
			return UF_FAIL_CUSTOM
		end
		
		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber())
		return nResult
	end
end

function wisp_tether_lua:OnSpellStart()
	local caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	
	if self.target:HasModifier("modifier_wisp_tether_lua_ally") then return rules:DisplayError(self:GetCaster():GetPlayerID(), "No") end
	
	caster:AddNewModifier(self.target, self, "modifier_wisp_tether_lua", {})
	
	self.target:AddNewModifier(caster, self, "modifier_wisp_tether_lua_ally", {})
	
	if self:GetCaster():FindAbilityByName("special_bonus_wisp_int8")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_wisp_int8"):GetLevel() > 0 then 
			self.target:AddNewModifier(caster, self, "modifier_wisp_tether_lua_ally_attack", {})
		end
	end

	if not caster:HasAbility("wisp_tether_break_lua") then
		caster:AddAbility("wisp_tether_break_lua")
	end

	caster:SwapAbilities("wisp_tether_lua", "wisp_tether_break_lua", false, true)
	caster:FindAbilityByName("wisp_tether_break_lua"):SetLevel(1)
	caster:FindAbilityByName("wisp_tether_break_lua"):StartCooldown(0.25)
end

function wisp_tether_lua:OnUnStolen()
	if self:GetCaster():HasAbility("wisp_tether_break_lua") then
		self:GetCaster():RemoveAbility("wisp_tether_break_lua")
	end
end

-------------------------------------------------------------------------------------------------------------------------------

modifier_wisp_tether_lua = class({})

function modifier_wisp_tether_lua:IsHidden() return false end
function modifier_wisp_tether_lua:IsPurgable() return false end
function modifier_wisp_tether_lua:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_wisp_tether_lua:OnCreated(params)
	self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
	self.target = self:GetCaster()
end

function modifier_wisp_tether_lua:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return decFuncs
end

function modifier_wisp_tether_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_wisp_tether_lua:OnRemoved()
	if IsServer() then
		if self.target:HasModifier("modifier_wisp_tether_lua_ally") then
			self.target:RemoveModifierByName("modifier_wisp_tether_lua_ally")
		end
		self:GetCaster():EmitSound("Hero_Wisp.Tether.Stop")
		self:GetCaster():StopSound("Hero_Wisp.Tether")
		self:GetParent():SwapAbilities("wisp_tether_break_lua", "wisp_tether_lua", false, true)
	end
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

modifier_wisp_tether_lua_ally = class({})

function modifier_wisp_tether_lua_ally:IsHidden() return false end
function modifier_wisp_tether_lua_ally:IsPurgable() return false end

function modifier_wisp_tether_lua_ally:OnCreated()
	self.regen = self:GetAbility():GetSpecialValueFor("tether_heal_amp")
	
	if self:GetCaster():FindAbilityByName("special_bonus_wisp_str9")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_wisp_str9"):GetLevel() > 0 then 
			self.regen = self.regen + 1.5
		end
	end
	
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

		EmitSoundOn("Hero_Wisp.Tether.Target", self:GetParent())
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_wisp_tether_lua_ally:OnIntervalThink()
	if IsServer() then
		if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 900 then
			self:GetCaster():RemoveModifierByName("modifier_wisp_tether_lua")
		end
	end
end

function modifier_wisp_tether_lua_ally:OnRemoved() 
	if IsServer() then
		self:GetParent():StopSound("Hero_Wisp.Tether.Target")
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	
		if self:GetAbility() then
			self:GetAbility().target = nil
		end
		
		self:GetParent():RemoveModifierByName("modifier_wisp_tether_lua_ally_attack")
		self:GetCaster():RemoveModifierByName("modifier_wisp_tether_lua")
	end
end

function modifier_wisp_tether_lua_ally:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return decFuncs
end

function modifier_wisp_tether_lua_ally:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage")
	end
end

function modifier_wisp_tether_lua_ally:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetCaster():GetMaxHealth()/100*self.regen
	end
end

function modifier_wisp_tether_lua_ally:GetModifierMoveSpeedBonus_Percentage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("movespeed")
	end
end

---------------------------------------------------------------------------------------------------------

modifier_wisp_tether_lua_ally_attack = class({})

function modifier_wisp_tether_lua_ally_attack:IsHidden() return true end
function modifier_wisp_tether_lua_ally_attack:IsPurgable() return false end
function modifier_wisp_tether_lua_ally_attack:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK
	}
	return decFuncs
end

function modifier_wisp_tether_lua_ally_attack:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetCaster():PerformAttack(params.target, true, true, true, false, true, false, false)
		end
	end
end

------------------------------

wisp_tether_break_lua = class({})

function wisp_tether_break_lua:IsInnateAbility() return true end
function wisp_tether_break_lua:IsStealable() return false end
function wisp_tether_break_lua:ProcsMagicStick() return false end

function wisp_tether_break_lua:OnSpellStart()
	if not self:GetCaster():HasAbility("wisp_tether_lua") then
		local stolenAbility = self:GetCaster():AddAbility("wisp_tether_lua")
		stolenAbility:SetLevel(min((self:GetCaster():GetLevel() / 2) - 1, 4))
		self:GetCaster():SwapAbilities("wisp_tether_break_lua", "wisp_tether_lua", false, true)
	end

	self:GetCaster():RemoveModifierByName("modifier_wisp_tether_lua")
	local target = self:GetCaster():FindAbilityByName("wisp_tether_lua").target
end

function wisp_tether_break_lua:OnUnStolen()
	if self:GetCaster():HasAbility("wisp_tether_lua") then
		self:GetCaster():RemoveAbility("wisp_tether_lua")
	end
end