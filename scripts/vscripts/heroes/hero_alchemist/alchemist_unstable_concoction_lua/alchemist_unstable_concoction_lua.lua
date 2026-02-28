LinkLuaModifier( "modifier_alchemist_unstable_concoction_lua", "heroes/hero_alchemist/alchemist_unstable_concoction_lua/modifier_alchemist_unstable_concoction_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_lua_disarm", "heroes/hero_alchemist/alchemist_unstable_concoction_lua/alchemist_unstable_concoction_lua", LUA_MODIFIER_MOTION_NONE )

alchemist_unstable_concoction_lua = class({})

function alchemist_unstable_concoction_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "brew_explosion" )
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_alchemist_unstable_concoction_lua", -- modifier name
		{ duration = duration } -- kv
	)
	local ability = caster:FindAbilityByName( "alchemist_unstable_concoction_throw_lua" )
	if not ability then
		ability = caster:AddAbility( "alchemist_unstable_concoction_throw_lua" )
		ability:SetStolen( true )
	end
	ability:SetLevel( self:GetLevel() )
	caster:SwapAbilities(
		self:GetAbilityName(),
		ability:GetAbilityName(),
		false,
		true
	)
end

--------------------------------------------------------------------------------

alchemist_unstable_concoction_throw_lua = class({})

function alchemist_unstable_concoction_throw_lua:GetAOERadius()
	return self:GetSpecialValueFor( "midair_explosion_radius" )
end

function alchemist_unstable_concoction_throw_lua:OnUpgrade()
	local ability = self:GetCaster():FindAbilityByName( "alchemist_unstable_concoction_lua" )
	ability:SetLevel( self:GetLevel() )
end

function alchemist_unstable_concoction_throw_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local max_brew = self:GetSpecialValueFor( "brew_time" )
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "movement_speed" )
	local projectile_vision = self:GetSpecialValueFor( "vision_range" )

	local brew_time
	local modifier = caster:FindModifierByName( "modifier_alchemist_unstable_concoction_lua" )
	if modifier then
		brew_time = math.min( GameRules:GetGameTime()-modifier:GetCreationTime(), max_brew )
		modifier:Destroy()
	elseif alchemist_unstable_concoction_throw_lua.reflected_brew_time then
		brew_time = alchemist_unstable_concoction_throw_lua.reflected_brew_time
	elseif self.stored_brew_time then
		brew_time = self.stored_brew_time
	else
		brew_time = 0
	end

	self.brew_time = brew_time

	count = 1
	
	local talent = self:GetCaster():FindAbilityByName("special_bonus_alchemist_agi6")
	if talent and talent:GetLevel() > 0 then 
		count = 2
	end
	
	throw = true
	
	for i=1, count do
		Timers:CreateTimer(0, function()
		local info = {
			Target = target,
			Source = caster,
			Ability = self,	
			
			EffectName = projectile_name,
			iMoveSpeed = projectile_speed,
			bDodgeable = false,                           -- Optional
		
			bVisibleToEnemies = true,                         -- Optional
			bProvidesVision = true,                           -- Optional
			iVisionRadius = projectile_vision,                              -- Optional
			iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
			ExtraData = {
				brew_time = brew_time,
			}
		}
		ProjectileManager:CreateTrackingProjectile(info)
		EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Throw", caster )
			if count == 2 and throw then
				throw = false
				return 1
			end
		end)
	end

	local ability = caster:FindAbilityByName( "alchemist_unstable_concoction_lua" )
	if not ability then return end -- reflected

	caster:SwapAbilities(
		self:GetAbilityName(),
		ability:GetAbilityName(),
		false,
		true
	)
end


function alchemist_unstable_concoction_throw_lua:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target then return end
	local brew_time = ExtraData.brew_time
	alchemist_unstable_concoction_throw_lua.reflected_brew_time = brew_time
	local TRIGGERED = target:TriggerSpellAbsorb( self )
	alchemist_unstable_concoction_throw_lua.reflected_brew_time = nil
	if TRIGGERED then return end
	local max_brew = self:GetSpecialValueFor( "brew_time" )
	local min_stun = self:GetSpecialValueFor( "min_stun" )
	local max_stun = self:GetSpecialValueFor( "max_stun" )
	local min_damage = self:GetSpecialValueFor( "min_damage" )
	local max_damage = self:GetSpecialValueFor( "max_damage" )
	local radius = self:GetSpecialValueFor( "midair_explosion_radius" )
	local stun = (brew_time/max_brew)*(max_stun-min_stun) + min_stun
	local damage = (brew_time/max_brew)*(max_damage-min_damage) + min_damage
	local damageTable = {
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_ALL,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )
		
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = stun })
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_unstable_concoction_lua_disarm", { duration = stun })
	end

	-- Play effects
	self:PlayEffects( target )
end


function alchemist_unstable_concoction_throw_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf"
	local sound_cast = "Hero_Alchemist.UnstableConcoction.Stun"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------
--------------------------------------------------------

if modifier_alchemist_unstable_concoction_lua_disarm == nil then modifier_alchemist_unstable_concoction_lua_disarm = class({}) end
function modifier_alchemist_unstable_concoction_lua_disarm:IsHidden() return false end
function modifier_alchemist_unstable_concoction_lua_disarm:IsDebuff() return true end
function modifier_alchemist_unstable_concoction_lua_disarm:IsPurgable() return true end

function modifier_alchemist_unstable_concoction_lua_disarm:OnCreated()
	self.armor_reduction = (-1) * self:GetAbility():GetSpecialValueFor("disarm")
end

function modifier_alchemist_unstable_concoction_lua_disarm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_alchemist_unstable_concoction_lua_disarm:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
endtion
end