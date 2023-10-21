LinkLuaModifier("modifier_necro_spawn_lua", "abilities/bosses/final/spawn_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_necro_spawn_lua_effect", "abilities/bosses/final/spawn_lua.lua", LUA_MODIFIER_MOTION_NONE)

spawn_list = {'npc_necro_bear', 'npc_necro_undy', 'npc_necro_lich', 'npc_necro_storegga', 'npc_necro_nyx', 'npc_necro_slardar', 'npc_necro_monkey_king', 'npc_necro_fura', 'npc_necro_lord', 'npc_necro_medusa', 'npc_necro_arc'}
spawn_index = 1
_G.spawn_count = 1

spawn_lua = class({})

function spawn_lua:OnSpellStart()
	local position = Vector(7680, -7394, 235)
	local index = spawn_index
	local caster = self:GetCaster()
	
	if spawn_index < 12 then
		spawn_index = spawn_index + 1
	end
	
	local spawn_count = _G.spawn_count
	print(index)
	
	for i = 1, spawn_count do
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-1200, 1200)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		local target_pos = Vector(position.x + dx, position.y + dy, position.z)
		local dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, caster, caster, caster:GetTeamNumber())
		dummy:AddNewModifier(dummy, nil, "modifier_dummy", {})
		dummy:AddNewModifier(dummy, nil, "modifier_kill", {duration = 2})
		dummy:AddNewModifier(dummy, self, "modifier_necro_spawn_lua", {duration = 2})
		
		Timers:CreateTimer({useGameTime = false, endTime = 1.9, callback = function()
			SpawnUnit(dummy, index)
		end})
	end
	
	if spawn_index == 12 then
		spawn_index = 1
		_G.spawn_count = _G.spawn_count + 1
	end
end

function SpawnUnit(dummy, index)
	if not IsServer() then return end
	local unit = CreateUnitByName(spawn_list[index], dummy:GetOrigin(), false, nil, nil, dummy:GetTeamNumber())
	unit:AddNewModifier(unit, nil, "modifier_necro_spawn_lua_effect", {})
	rules:aura_dif(unit,random_ability)
	-- unit:AddNewModifier(unit, nil, "modifier_kill", {duration = 5})
end

------------------------------------------------

modifier_necro_spawn_lua = class({})

function modifier_necro_spawn_lua:IsHidden() return true end
function modifier_necro_spawn_lua:IsPurgable() return false end

function modifier_necro_spawn_lua:OnCreated()
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_necro_spawn_lua:OnDestroy()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	StopSoundOn( "Hero_AbyssalUnderlord.DarkRift.Cast", self:GetParent() )
	StopSoundOn( "Hero_AbyssalUnderlord.DarkRift.Target", self:GetParent() )
	EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Cancel", self:GetParent() )
end

function modifier_necro_spawn_lua:PlayEffects1()
	local parent = self:GetParent()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		6,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Target", parent )
end

function modifier_necro_spawn_lua:PlayEffects2()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		2,
		caster,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Cast", caster )
end


---------------------------------
modifier_necro_spawn_lua_effect = class({})

function modifier_necro_spawn_lua_effect:IsHidden() return true end
function modifier_necro_spawn_lua_effect:IsPurgable() return false end

function modifier_necro_spawn_lua_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
