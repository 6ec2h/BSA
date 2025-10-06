monkey_king_tree_dance_lua = class({})
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_lua", "abilities/bosses/monkey/monkey_king_tree_dance_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_lua_passive", "abilities/bosses/monkey/monkey_king_tree_dance_lua", LUA_MODIFIER_MOTION_BOTH )

function monkey_king_tree_dance_lua:GetIntrinsicModifierName()
	return "modifier_monkey_king_tree_dance_lua_passive"
end

function monkey_king_tree_dance_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local speed = self:GetSpecialValueFor( "leap_speed" )
	local arc_height = self:GetSpecialValueFor( "top_level_height" )
	local perch_height = self:GetSpecialValueFor( "perched_spot_height" )
	local position = target:GetOrigin()

	-- data above is fake news
	local perch_height = 256
	local speed = 1000
	local height = 192
	local distance = (target:GetOrigin()-caster:GetOrigin()):Length2D()

	-- check if from perch
	local perch = 0
	if caster:FindModifierByNameAndCaster( "modifier_monkey_king_tree_dance_lua", caster ) then
		perch = 1
	end

	-- jump
	local arc = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			target_x = target:GetOrigin().x,
			target_y = target:GetOrigin().y,
			distance = distance,
			speed = speed,
			height = height,
			fix_end = false,
			fix_height = false,
			isStun = true,
			activity = ACT_DOTA_FLAIL,
			start_offset = perch_height*perch,
			end_offset = perch_height,
		} -- kv
	)
	arc:SetEndCallback(function()
		-- add perch modifier
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_monkey_king_tree_dance_lua", -- modifier name
			{
				tree = target:entindex(),
			} -- kv
		)
	end)

	-- set spring ability as active
	if not self.spring then
		self.spring = self:GetCaster():FindAbilityByName( 'monkey_king_primal_spring_lua' )
	end
	if self.spring then
		self.spring:SetActivated( true )
	end

	-- play effects
	self:PlayEffects( arc )
end

--------------------------------------------------------------------------------
-- Ability Events
function monkey_king_tree_dance_lua:OnUpgrade()
	-- find primal spring ability
	if not self.spring then
		self.spring = self:GetCaster():FindAbilityByName( 'monkey_king_primal_spring_lua' )
	end
	if not self.spring then return end

	-- level up
	self.spring:SetLevel( self:GetLevel() )

	-- check perch modifier
	local modifier = self:GetCaster():FindModifierByNameAndCaster( 'modifier_monkey_king_tree_dance_lua', self:GetCaster() )
	if not modifier then
		self.spring:SetActivated( false )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function monkey_king_tree_dance_lua:PlayEffects( modifier )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf"
	local sound_cast = "Hero_MonkeyKing.TreeJump.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	-- buff particle
	modifier:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------

modifier_monkey_king_tree_dance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_monkey_king_tree_dance_lua:IsHidden()
	return false
end

function modifier_monkey_king_tree_dance_lua:IsDebuff()
	return false
end

function modifier_monkey_king_tree_dance_lua:IsStunDebuff()
	return false
end

function modifier_monkey_king_tree_dance_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_monkey_king_tree_dance_lua:OnCreated( kv )
	-- references
	self.perch_height = self:GetAbility():GetSpecialValueFor( "perched_spot_height" )
	self.dayvision = self:GetAbility():GetSpecialValueFor( "perched_day_vision" )
	self.nightvision = self:GetAbility():GetSpecialValueFor( "perched_night_vision" )
	self.stun = self:GetAbility():GetSpecialValueFor( "unperched_stunned_duration" )

	-- reference above is fake news
	self.perch_height = 256

	if not IsServer() then return end
	-- get data
	self.parent = self:GetParent()
	self.tree = EntIndexToHScript( kv.tree )
	self.origin = self.tree:GetOrigin()

	-- apply still motion
	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end
	if not self:ApplyVerticalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	-- set spring ability as active
	self.spring = self:GetCaster():FindAbilityByName( 'monkey_king_primal_spring_lua' )
	if self.spring then
		self.spring:SetActivated( true )
	end

	-- Start interval check for tree cur
	self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()

	-- play effects
	local sound_cast = "Hero_MonkeyKing.TreeJump.Tree"
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_monkey_king_tree_dance_lua:OnRefresh( kv )
	
end

function modifier_monkey_king_tree_dance_lua:OnRemoved()
end

function modifier_monkey_king_tree_dance_lua:OnDestroy()
	if not IsServer() then return end

	-- set spring ability as inactive
	if self.spring then
		self.spring:SetActivated( false )
	end

	-- preserve height
	local pos = self:GetParent():GetOrigin()

	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	-- preserve height
	if not self.unperched then
		self:GetParent():SetOrigin( pos )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_monkey_king_tree_dance_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	}

	return funcs
end

function modifier_monkey_king_tree_dance_lua:OnOrder( params )
	if params.unit~=self.parent then return end

	-- right click, switch position
	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- dont do anything if on cooldown
		if not self:GetAbility():IsCooldownReady() then
			local order = {
				UnitIndex = self.parent:entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP,
			}
			ExecuteOrderFromTable( order )
			return
		end

		-- don't do anything if casting primal spring
		if self.spring and self.spring:IsChanneling() then return end

		-- get target
		local pos = params.new_pos
		if params.target then pos = params.target:GetOrigin() end
		local direction = (pos-self.parent:GetOrigin())
		direction.z = 0
		direction = direction:Normalized()

		-- set facing
		self.parent:SetForwardVector( direction )

		-- jump arc
		local arc = self.parent:AddNewModifier(
			self.parent, -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				dir_x = direction.x,
				dir_y = direction.y,
				distance = 150,
				speed = 550,
				height = 1,
				start_offset = self.perch_height,
				fix_end = false,
				isForward = true,
			} -- kv
		)
		arc:SetEndCallback(function()
			-- find clear space
			FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), true )
		end)

		-- play effects
		self:PlayEffects( arc )

		-- self destroy
		self:Destroy()
	end
end

function modifier_monkey_king_tree_dance_lua:GetFixedDayVision()
	return self.dayvision
end

function modifier_monkey_king_tree_dance_lua:GetFixedNightVision()
	return self.nightvision
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_monkey_king_tree_dance_lua:CheckState()
	local state = {
		-- [MODIFIER_STATE_FLYING] = true,
		-- [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_monkey_king_tree_dance_lua:OnIntervalThink()
	-- temp tree
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end
		return
	end

	-- check if the tree is still standing
	if self.tree:IsStanding() then return end

	-- destroy modifier and stun
	local mod = self.parent:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_stunned", -- modifier name
		{ duration = self.stun } -- kv
	)

	-- add tag
	self.unperched = true

	self:Destroy()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_monkey_king_tree_dance_lua:UpdateHorizontalMotion( me, dt )
	me:SetOrigin( self.origin )
end

function modifier_monkey_king_tree_dance_lua:UpdateVerticalMotion( me, dt )
	-- if temp tree destroyed, destroy
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end
		return
	end

	local pos = self.tree:GetOrigin()
	pos.z = pos.z + self.perch_height

	me:SetOrigin( pos )
end

function modifier_monkey_king_tree_dance_lua:OnVerticalMotionInterrupted()
	self:Destroy()
end

function modifier_monkey_king_tree_dance_lua:OnHorizontalMotionInterrupted()
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_monkey_king_tree_dance_lua:PlayEffects( modifier )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	-- buff particle
	modifier:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end



modifier_monkey_king_tree_dance_lua_passive = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_monkey_king_tree_dance_lua_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_monkey_king_tree_dance_lua_passive:OnCreated( kv )
	-- references
	self.cooldown = self:GetAbility():GetSpecialValueFor( "jump_damage_cooldown" )

	if not IsServer() then return end
end

function modifier_monkey_king_tree_dance_lua_passive:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_monkey_king_tree_dance_lua_passive:OnRemoved()
end

function modifier_monkey_king_tree_dance_lua_passive:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_monkey_king_tree_dance_lua_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_monkey_king_tree_dance_lua_passive:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end

	-- not if perched
	if params.unit:HasModifier( "modifier_monkey_king_tree_dance_lua" ) then return end

	-- not if jumping
	local mod = false
	local modifiers = params.unit:FindAllModifiersByName( 'modifier_generic_arc_lua' )
	for _,modifier in pairs(modifiers) do
		if modifier:GetAbility()==self:GetAbility() then
			mod = true
			break
		end
	end
	if mod then return end

	-- only roshan/player-based damage
	if not params.attacker:IsControllableByAnyPlayer() and params.attacker:GetUnitName()~="npc_dota_roshan" then return end

	-- add cooldown
	self:GetAbility():StartCooldown( self.cooldown )
end