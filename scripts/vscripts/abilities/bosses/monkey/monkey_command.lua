LinkLuaModifier("modifier_wukongs_command_custom_thinker", "abilities/bosses/monkey/monkey_command", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_passive_2_effect", "abilities/creeps/monkey_passive_2", LUA_MODIFIER_MOTION_NONE )

monkey_king_wukongs_command_custom = class({})

_G.clone = {}

function monkey_king_wukongs_command_custom:OnSpellStart()
	local caster = self:GetCaster()
	local center = Vector(-1140,-1525,120)
	if caster:GetUnitName() == 'npc_necro_monkey_king' then
		center = Vector(7680,-7424,256)
	end
	caster:EmitSound("Hero_MonkeyKing.FurArmy")
	CreateModifierThinker(caster, self, "modifier_wukongs_command_custom_thinker", {duration = 30}, center, caster:GetTeamNumber(), false)
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
    self.particleHandler = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(self.particleHandler, 0, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(self.particleHandler, 1, Vector(800, 0, 0))
	local caster = self:GetCaster()
	local center = Vector(-1140,-1525,120)
	local line_pos = center + self:GetCaster():GetForwardVector() * 800
	local rotation_rate = 360 / 8	
	self.table_clone = {}
	for i = 1, 8 do
		line_pos = RotatePosition(center, QAngle(0, rotation_rate, 0), line_pos)
		self:CreateUnit(center, line_pos)
	end	
	
	self:StartIntervalThink(0.1)
end

function modifier_wukongs_command_custom_thinker:CreateUnit(center, line_pos)
	self.unit = CreateUnitByName("clone_monkey_king", line_pos, true, nil, nil, self:GetCaster():GetTeamNumber())
	self.unit:AddNewModifier( self:GetCaster(), self, "modifier_kill", {duration = 30} )
	self.unit:AddNewModifier( self:GetCaster(), nil, "modifier_monkey_passive_2_effect", {duration = 30} )
	table.insert(_G.clone, self.unit)
end

function modifier_wukongs_command_custom_thinker:OnIntervalThink()
	if not self:GetCaster():IsAlive() then 
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		if self.particleHandler then
			ParticleManager:DestroyParticle(self.particleHandler, false)
			ParticleManager:ReleaseParticleIndex(self.particleHandler)
		end
		if self.table_clone then
			for i, unit in pairs(_G.clone) do
				if unit then
					unit:ForceKill(false)
				end
			end	
		end
		_G.clone = {}
		if parent and not parent:IsNull() then
			parent:ForceKill(false)
		end
	end
end
