dado_storm_lua = class({})
dado_storm_lua = class({})
LinkLuaModifier( "modifier_dado_storm_lua", "heroes/hero_dado/blast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dado_storm_lua_thinker", "heroes/hero_dado/blast", LUA_MODIFIER_MOTION_NONE )


function dado_storm_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal1") ~= nil then 
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal1"):GetLevel() > 0 then 
			return self:GetCaster():GetMaxMana() * 10 * 0.01
		end
	end
	return self:GetCaster():GetMaxMana() * 20 * 0.01
end

--------------------------------------------------------------------------------
-- Ability Start
function dado_storm_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	mana = caster:GetMaxMana()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_dado_storm_lua_thinker", -- modifier name
		{  }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local modifier = thinker:FindModifierByName( "modifier_dado_storm_lua_thinker" )
	modifier:Cast( target )
end


modifier_dado_storm_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dado_storm_lua:IsHidden()
	return true
end

function modifier_dado_storm_lua:IsDebuff()
	return true
end

function modifier_dado_storm_lua:IsStunDebuff()
	return false
end

function modifier_dado_storm_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dado_storm_lua:OnCreated( kv )
	if IsServer() then
		-- references
		self.slow =  self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )
	end
end

function modifier_dado_storm_lua:OnRefresh( kv )
	self.slow =  self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )
end

function modifier_dado_storm_lua:OnRemoved()
end

function modifier_dado_storm_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dado_storm_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

function modifier_dado_storm_lua:GetModifierMagicalResistanceBonus()
	return self.slow
end


modifier_dado_storm_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dado_storm_lua_thinker:IsHidden()
	return true
end

function modifier_dado_storm_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dado_storm_lua_thinker:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
	mana = caster:GetMaxMana()


	-- references
	self.delay = self:GetAbility():GetSpecialValueFor( "jump_delay" )
	self.count = self:GetAbility():GetSpecialValueFor( "jump_count" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )
	
	-- init and precache
	self.targets = {}
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbility():GetSpecialValueFor( "slow_duration" ) * mana/10,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_dado_storm_lua_thinker:Cast( target )
	-- guaranteed on server
	self.current_target = target
	self.started = false
	self:StartIntervalThink( self.delay )
end

function modifier_dado_storm_lua_thinker:OnRefresh( kv )
	
end

function modifier_dado_storm_lua_thinker:OnRemoved()
end

function modifier_dado_storm_lua_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dado_storm_lua_thinker:OnIntervalThink()
	if not self.started then
		self.started = true

		self:Struck( self.current_target )
		return
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self.current_target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	local found = false
	for _,enemy in pairs(enemies) do
		if not self.targets[enemy] then
			found = true
			self.current_target = enemy
			self:Struck( enemy )
			break
		end
	end

	if not found then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_dado_storm_lua_thinker:Struck( target )
	if not target:IsMagicImmune() then
		-- damage
		self.damageTable.victim = target
		ApplyDamage( self.damageTable )

		-- slow
		target:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_dado_storm_lua", -- modifier name
			{
				duration = self.duration,
				slow = self.slow,
			} -- kv
		)

		-- track targeted
		self.targets[target] = true

	end

	-- play effects
	self:PlayEffects( target )

	-- count
	self.count = self.count - 1
	if self.count<=0 then
		self:Destroy()
	end
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dado_storm_lua_thinker:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/dado_bolt.vpcf"
	local sound_cast = "Hero_Enigma.MaleficeTick"

	-- get data
	local location = target:GetOrigin()
	local height = Vector( 0, 0, 50 )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, location + Vector( 0, 0, 250 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end