LinkLuaModifier("modifier_wukongs_command_custom_thinker", "abilities/bosses/monkey/monkey_command", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_passive_2_effect", "abilities/creeps/monkey_passive_2", LUA_MODIFIER_MOTION_NONE )

monkey_king_wukongs_command_custom = class({})

_G.clone = {}

function monkey_king_wukongs_command_custom:OnSpellStart()
	local caster = self:GetCaster()
	local center = caster:GetOrigin()
	caster:EmitSound("Hero_MonkeyKing.FurArmy")

	local thinkers = Entities:FindAllByName("npc_dota_thinker")

	for i = 1, #thinkers do
		local thinker = thinkers[i]

		local mkMod = thinker:FindModifierByName("modifier_wukongs_command_custom_thinker")
		if mkMod then
			UTIL_Remove(thinker)
		end
	end

	CreateModifierThinker(caster, self, "modifier_wukongs_command_custom_thinker", {duration = self:GetCooldown(self:GetLevel() - 1)}, center, caster:GetTeamNumber(), false)
end

function monkey_king_wukongs_command_custom:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf", context)
end

---------------------------------------------------------------------

modifier_wukongs_command_custom_thinker = class({})

function modifier_wukongs_command_custom_thinker:IsHidden()
  return true
end

function modifier_wukongs_command_custom_thinker:IsDebuff()
  return false
end

function modifier_wukongs_command_custom_thinker:IsPurgable()
  return false
end

function modifier_wukongs_command_custom_thinker:OnCreated()
	if not IsServer() then return end

	local caster = self:GetCaster()

    self.particleHandle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.particleHandle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particleHandle, 1, Vector(800, 0, 0))
	
	local center = caster:GetOrigin()
	local line_pos = center + caster:GetForwardVector() * 800
	local rotation_rate = 360 / 8	
	self.table_clone = {}
	for i = 1, 8 do
		line_pos = RotatePosition(center, QAngle(0, rotation_rate, 0), line_pos)
		self:CreateUnit(center, line_pos)
	end	
	
	self:StartIntervalThink(0.1)
end

function modifier_wukongs_command_custom_thinker:CreateUnit(center, line_pos)
	local ability = self:GetAbility()
	local duration = ability:GetCooldown(ability:GetLevel() - 1)

	self.unit = CreateUnitByName("clone_monkey_king", line_pos, true, nil, nil, self:GetCaster():GetTeamNumber())
	self.unit:AddNewModifier( self:GetCaster(), self, "modifier_kill", {duration = duration} )
	self.unit:AddNewModifier( self:GetCaster(), nil, "modifier_monkey_passive_2_effect", {duration = duration} )
	table.insert(_G.clone, self.unit)
end

function modifier_wukongs_command_custom_thinker:OnDestroy()
	if not IsServer() then return end
	
	if self.particleHandle then
		ParticleManager:DestroyParticle(self.particleHandle, true)
		ParticleManager:ReleaseParticleIndex(self.particleHandle)
	end
	
	if self.table_clone then
		for i, unit in pairs(_G.clone) do
			if unit and not unit:IsNull() then
				unit:ForceKill(false)
			end
		end	
	end
	_G.clone = {}
	
	local parent = self:GetParent()

	if parent and not parent:IsNull() then
		parent:ForceKill(false)
	end
end

function modifier_wukongs_command_custom_thinker:OnIntervalThink()
	local caster = self:GetCaster()

	if caster and caster:IsAlive() then return end

	if self.particleHandle then
		ParticleManager:DestroyParticle(self.particleHandle, true)
		ParticleManager:ReleaseParticleIndex(self.particleHandle)
	end

	if self.table_clone then
		for i, unit in pairs(_G.clone) do
			if unit and not unit:IsNull() then
				unit:ForceKill(false)
			end
		end	
	end
	_G.clone = {}
	
	local parent = self:GetParent()

	if parent and not parent:IsNull() then
		parent:ForceKill(false)
	end
end
