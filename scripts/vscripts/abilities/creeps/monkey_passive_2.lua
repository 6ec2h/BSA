LinkLuaModifier( "modifier_monkey_passive_2", "abilities/creeps/monkey_passive_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_monkey_passive_2_effect", "abilities/creeps/monkey_passive_2", LUA_MODIFIER_MOTION_NONE )

monkey_passive_2 = class({})

function monkey_passive_2:GetIntrinsicModifierName()
	return "modifier_monkey_passive_2"
end

function monkey_passive_2:Precache(context)
	PrecacheResource("particle", "particles/status_fx/status_effect_terrorblade_reflection.vpcf", context)
end

----------------------------------------------------------------------------

modifier_monkey_passive_2 = class({})

function modifier_monkey_passive_2:IsHidden()
	return true
end

function modifier_monkey_passive_2:IsPurgable()
	return false
end

function modifier_monkey_passive_2:OnCreated( kv )
	self:StartIntervalThink(4)
end

function modifier_monkey_passive_2:OnIntervalThink()		
if not IsServer() then return end	
	if self:GetCaster():IsAlive() then
		self.unit = CreateUnitByName("clone_monkey_king", self:GetParent():GetOrigin() + RandomVector( RandomInt( 50, 50 )), true, nil, nil, self:GetParent():GetTeamNumber())
		self.live_time = math.ceil(100 - self:GetCaster():GetHealthPercent()) / 10
		self.unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_monkey_passive_2_effect", { duration = 0.8 + self.live_time } )
		self.unit:AddNewModifier( self:GetCaster(), self, "modifier_kill", {duration = 0.8 + self.live_time } )
	end
end

----------------------------------------------------------------------------------------------

local MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9 = 10001

modifier_monkey_passive_2_effect = class({})

function modifier_monkey_passive_2_effect:IsHidden()
	return true
end

function modifier_monkey_passive_2_effect:IsDebuff()
	return false
end

function modifier_monkey_passive_2_effect:IsPurgable()
	return false
end

function modifier_monkey_passive_2_effect:OnRefresh( kv )
	
end

function modifier_monkey_passive_2_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_monkey_passive_2_effect:OnDeath(event)
    if not IsServer() then return end
    local creep = event.unit
    if creep ~= self:GetParent() then return end
	clear(creep)
end

function clear(creep)
	Timers:CreateTimer(0.06, function()
		UTIL_Remove(creep)
	end)
end

function modifier_monkey_passive_2_effect:GetModifierMoveSpeed_Absolute()
	return 0
end

function modifier_monkey_passive_2_effect:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	return state
end

function modifier_monkey_passive_2_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_monkey_passive_2_effect:StatusEffectPriority()
	return MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9
end