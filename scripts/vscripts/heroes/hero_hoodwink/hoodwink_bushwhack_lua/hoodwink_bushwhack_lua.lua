hoodwink_bushwhack_lua = class({})
LinkLuaModifier( "modifier_hoodwink_bushwhack_lua_thinker", "heroes/hero_hoodwink/hoodwink_bushwhack_lua/hoodwink_bushwhack_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_lua_debuff", "heroes/hero_hoodwink/hoodwink_bushwhack_lua/hoodwink_bushwhack_lua", LUA_MODIFIER_MOTION_HORIZONTAL )

function hoodwink_bushwhack_lua:GetAOERadius()
	return self:GetSpecialValueFor( "trap_radius" )
end

function hoodwink_bushwhack_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local delay = (point-caster:GetOrigin()):Length2D()/projectile_speed
	local target = CreateModifierThinker(caster, self, "modifier_hoodwink_bushwhack_lua_thinker", {duration = delay,}, point, caster:GetTeamNumber(), false)
end

----------------------------------------------------------------------------------------

modifier_hoodwink_bushwhack_lua_debuff = class({})

function modifier_hoodwink_bushwhack_lua_debuff:IsHidden()
	return false
end

function modifier_hoodwink_bushwhack_lua_debuff:IsDebuff()
	return true
end

function modifier_hoodwink_bushwhack_lua_debuff:IsStunDebuff()
	return true
end

function modifier_hoodwink_bushwhack_lua_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_bushwhack_lua_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.height = self:GetAbility():GetSpecialValueFor( "visual_height" )
	self.rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )

	self.distance = 150
	self.speed = 900
	self.interval = 0.1

	if not IsServer() then return end
	self.tree = EntIndexToHScript( kv.tree )
	self.tree_origin = self.tree:GetOrigin()
	if not self:ApplyHorizontalMotionController() then
		return
	end

	self:StartIntervalThink( self.interval )

	self:PlayEffects1()
end

function modifier_hoodwink_bushwhack_lua_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_hoodwink_bushwhack_lua_debuff:OnRemoved()
end

function modifier_hoodwink_bushwhack_lua_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )

end

function modifier_hoodwink_bushwhack_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
	return funcs
end

function modifier_hoodwink_bushwhack_lua_debuff:GetFixedDayVision()
	return 0
end

function modifier_hoodwink_bushwhack_lua_debuff:GetFixedNightVision()
	return 0
end

function modifier_hoodwink_bushwhack_lua_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_hoodwink_bushwhack_lua_debuff:GetOverrideAnimationRate()
	return self.rate
end

function modifier_hoodwink_bushwhack_lua_debuff:GetVisualZDelta()
	return self.height
end

function modifier_hoodwink_bushwhack_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_hoodwink_bushwhack_lua_debuff:OnIntervalThink()
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end
	elseif not self.tree:IsStanding() then
		self:Destroy()
	end
end

function modifier_hoodwink_bushwhack_lua_debuff:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local dir = self.tree_origin-origin
	local dist = dir:Length2D()
	dir.z = 0
	dir = dir:Normalized()
	if dist<self.distance then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:PlayEffects2( dir )
		return
	end
	local target = dir * self.speed*dt
	me:SetOrigin( origin + target )
end

function modifier_hoodwink_bushwhack_lua_debuff:OnHorizontalMotionInterrupted()
	self:GetParent():RemoveHorizontalMotionController( self )
end

function modifier_hoodwink_bushwhack_lua_debuff:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf"
	local sound_cast = "Hero_Hoodwink.Bushwhack.Target"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 15, self.tree_origin )
	self:AddParticle(effect_cast, false, false, -1, false, false)
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_hoodwink_bushwhack_lua_debuff:PlayEffects2( dir )
	local particle_cast = "particles/tree_fx/tree_simple_explosion.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-----------------------------------------------------

modifier_hoodwink_bushwhack_lua_thinker = class({})

function modifier_hoodwink_bushwhack_lua_thinker:IsHidden()
	return false
end

function modifier_hoodwink_bushwhack_lua_thinker:IsDebuff()
	return false
end

function modifier_hoodwink_bushwhack_lua_thinker:IsStunDebuff()
	return false
end

function modifier_hoodwink_bushwhack_lua_thinker:IsPurgable()
	return true
end

function modifier_hoodwink_bushwhack_lua_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.damage = self:GetAbility():GetSpecialValueFor( "total_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
	self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "trap_radius" )

	if not IsServer() then return end

	self.location = self:GetParent():GetOrigin()
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()

	self:PlayEffects1()
end

function modifier_hoodwink_bushwhack_lua_thinker:OnRefresh( kv )
	
end

function modifier_hoodwink_bushwhack_lua_thinker:OnRemoved()
end

function modifier_hoodwink_bushwhack_lua_thinker:OnDestroy()
	if not IsServer() then return end
	AddFOWViewer( self.caster:GetTeamNumber(), self.location, self.radius, self.duration, false )
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	if #enemies<1 then
		self:PlayEffects2( false )
		return
	end

	local trees = GridNav:GetAllTreesAroundPoint( self.location, self.radius, false )
	if #trees<1 then
		self:PlayEffects2( false )
		return
	end

	local damageTable = {
		-- victim = target,
		attacker = self.caster,
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		local origin = enemy:GetOrigin()
		local mytree = trees[1]
		local mytreedist = (trees[1]:GetOrigin()-origin):Length2D()
		for _,tree in pairs(trees) do
			local treedist = (tree:GetOrigin()-origin):Length2D()
			if treedist<mytreedist then
				mytree = tree
				mytreedist = treedist
			end
		end
		enemy:AddNewModifier(self.caster, self.ability, "modifier_hoodwink_bushwhack_lua_debuff", {duration = self.duration, tree = mytree:entindex(),})
	end
	self:PlayEffects2( true )
	UTIL_Remove( self:GetParent() )
end

function modifier_hoodwink_bushwhack_lua_thinker:OnIntervalThink()
end

function modifier_hoodwink_bushwhack_lua_thinker:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf"
	local sound_cast = "Hero_Hoodwink.Bushwhack.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.speed, 0, 0 ) )
	self:AddParticle(effect_cast, false, false, -1, false, false)
	EmitSoundOn( sound_cast, self.caster )
end

function modifier_hoodwink_bushwhack_lua_thinker:PlayEffects2( success )
	local particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf"
	local sound_cast = "Hero_Hoodwink.Bushwhack.Cast"
	local sound_location = "Hero_Hoodwink.Bushwhack.Impact"
	if success then
		particle_cast = "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf"
	end
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.location )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	StopSoundOn( sound_cast, self.caster )
	EmitSoundOnLocationWithCaster( self.location, sound_location, self.caster )
end