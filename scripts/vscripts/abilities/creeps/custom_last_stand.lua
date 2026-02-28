LinkLuaModifier("modifier_custom_last_stand_spawn",  "abilities/creeps/custom_last_stand", LUA_MODIFIER_MOTION_NONE)

custom_last_stand = class({})

function custom_last_stand:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_last_stand_spawn", {duration = self:GetChannelTime()})
	EmitSoundOn("Hero_LegionCommander.PressTheAttack", self:GetCaster())
end

function custom_last_stand:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	if self:GetCaster():HasModifier("modifier_custom_last_stand_spawn") then
		self:GetCaster():RemoveModifierByName("modifier_custom_last_stand_spawn")
	end
end

--------------------------------------------------------------------------------------------------

modifier_custom_last_stand_spawn = class({})


function modifier_custom_last_stand_spawn:IsPurgable()
	return false
end

function modifier_custom_last_stand_spawn:IsPurgeException()
	return false
end

function modifier_custom_last_stand_spawn:OnCreated()
	if not IsServer() then return end
	local caster = self:GetCaster()	
	self:StartIntervalThink(1)
end

function modifier_custom_last_stand_spawn:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local number_creep = RandomInt(1,3)
	local caster_pos = caster:GetAbsOrigin()
	EmitSoundOn("Hero_LegionCommander.PressTheAttack", caster)
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_2})
	local unit = CreateUnitByName("legion_creep_"..number_creep, caster_pos + RandomVector( RandomFloat( 700, 700 )), true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, nil, "modifier_kill", {duration = self:GetAbility():GetCooldownReduction()})
end

function modifier_custom_last_stand_spawn:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end