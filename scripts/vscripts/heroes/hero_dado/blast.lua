LinkLuaModifier( "modifier_dado_storm_lua_thinker", "heroes/hero_dado/blast", LUA_MODIFIER_MOTION_NONE )

dado_storm_lua = class({})

function dado_storm_lua:GetManaCost(iLevel)
	local talent = self:GetCaster():FindAbilityByName("special_bonus_dado_tal1")
	if talent ~= nil and talent:GetLevel() > 0 then 
		return self:GetCaster():GetMaxMana() * 10 * 0.01
	end
	return self:GetCaster():GetMaxMana() * 20 * 0.01
end

function dado_storm_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	mana = caster:GetMaxMana()
	if target:TriggerSpellAbsorb( self ) then return end
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

-----------------------------------------------------------

modifier_dado_storm_lua_thinker = class({})

function modifier_dado_storm_lua_thinker:IsHidden()
	return true
end

function modifier_dado_storm_lua_thinker:IsPurgable()
	return false
end

function modifier_dado_storm_lua_thinker:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
	mana = caster:GetMaxMana()

	self.delay = self:GetAbility():GetSpecialValueFor( "jump_delay" )
	self.count = self:GetAbility():GetSpecialValueFor( "jump_count" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage =  self:GetAbility():GetSpecialValueFor( "dmg" )
	
	local talent = self:GetCaster():FindAbilityByName("special_bonus_dado_tal7")
	if talent ~= nil and talent:GetLevel() > 0 then 
		self.damage = self.damage + 0.2
	end
	
	self.targets = {}
	self.damageTable = {
		attacker = self:GetCaster(),
		damage = self.damage * mana,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
end

function modifier_dado_storm_lua_thinker:Cast( target )
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


function modifier_dado_storm_lua_thinker:Struck( target )
	if not target:IsMagicImmune() then
		self.damageTable.victim = target
		ApplyDamage( self.damageTable )
		self.targets[target] = true
	end

	self:PlayEffects( target )

	self.count = self.count - 1
	if self.count<=0 then
		self:Destroy()
	end
end

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