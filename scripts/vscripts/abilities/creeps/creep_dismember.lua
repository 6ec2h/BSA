LinkLuaModifier("modifier_creep_dismember","abilities/creeps/creep_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_dismember_buff","abilities/creeps/creep_dismember", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_dismember_pull", "abilities/creeps/creep_dismember", LUA_MODIFIER_MOTION_HORIZONTAL)

creep_dismember = creep_dismember or class({})

function creep_dismember:GetChannelTime()
	return 3
end

function creep_dismember:OnSpellStart()
	if self:GetCaster():IsAlive() then
		self.target = self:GetCursorTarget()
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creep_dismember_buff", {})
		self.target:AddNewModifier(self:GetCaster(), self, "modifier_creep_dismember", {duration = self:GetChannelTime() - FrameTime()})

		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_dismember.vpcf", PATTACH_ABSORIGIN, self.target)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	end
end

function creep_dismember:OnChannelFinish(bInterrupted)
	if self.target then
		local target_buff = self.target:FindModifierByNameAndCaster("modifier_creep_dismember", self:GetCaster())
		if bInterrupted then
			self.target:RemoveModifierByName("modifier_creep_dismember")
		end
	end

	local caster_buff = self:GetCaster():FindModifierByNameAndCaster("modifier_creep_dismember_buff", self:GetCaster())

	if target_buff then target_buff:Destroy() end
	if caster_buff then caster_buff:Destroy() end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

--------------------------------------------------

modifier_creep_dismember = class({})

function modifier_creep_dismember:IgnoreTenacity()	return true end
function modifier_creep_dismember:IsDebuff() return true end
function modifier_creep_dismember:IsHidden() return false end

function modifier_creep_dismember:OnCreated()
	self.dismember_damage = self:GetAbility():GetSpecialValueFor("damage")

	if IsServer() then
		self.standard_tick_interval	= self:GetAbility():GetSpecialValueFor("tick")
		self.tick_interval = self.standard_tick_interval * (1 - self:GetParent():GetStatusResistance())
		self:StartIntervalThink(self.tick_interval)

		self:OnIntervalThink()
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_creep_dismember_pull", {duration = self:GetAbility():GetChannelTime() - FrameTime()})
	end
end

function modifier_creep_dismember:OnIntervalThink()
	local damageTable = {
		victim			= self:GetParent(),
		attacker		= self:GetCaster(),
		damage			= self.dismember_damage / 2,
		damage_type 	= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		ability 		= self:GetAbility(),
	}
	ApplyDamage(damageTable)
	if not self:GetCaster():IsAlive() then
		self:Destroy()
	end
end

function modifier_creep_dismember:OnDestroy()
	if IsServer() then
		if self:GetCaster():IsChanneling() then
			self:GetAbility():EndChannel(false)
			self:GetCaster():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())
		end
	end
end

function modifier_creep_dismember:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true,}
	return state
end

function modifier_creep_dismember:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_creep_dismember:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

----------------------------------------

modifier_creep_dismember_buff = modifier_creep_dismember_buff or class({})

function modifier_creep_dismember_buff:IsDebuff() return false end
function modifier_creep_dismember_buff:IsHidden() return true end
function modifier_creep_dismember_buff:IsPurgable() return false end
function modifier_creep_dismember_buff:IsStunDebuff() return false end

function modifier_creep_dismember_buff:DeclareFunctions()
	local table = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return table
end

function modifier_creep_dismember_buff:GetActivityTranslationModifiers()
	if self:GetCaster():HasItemInInventory("item_imba_aether_lens") then
		return "long_dismember"
	else
		return ""
	end
end

function modifier_creep_dismember_buff:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_4
end

-------------------------------------------------------------------------------------

modifier_creep_dismember_pull = class({})

function modifier_creep_dismember_pull:OnCreated(params)
	if not IsServer() then return end
	
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	
	self.pull_units_per_second = 75
	self.pull_distance_limit = 125

	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_creep_dismember_pull:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	local distance = self.caster:GetOrigin() - me:GetOrigin()
	
	if distance:Length2D() > self.pull_distance_limit and self.parent:HasModifier("modifier_creep_dismember") then
		me:SetOrigin( me:GetOrigin() + distance:Normalized() * self.pull_units_per_second * dt )
	else
		self:Destroy()
	end
end

function modifier_creep_dismember_pull:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveHorizontalMotionController( self )
end