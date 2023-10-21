LinkLuaModifier( "modifier_hero_pangolier_ki_burst", "heroes/hero_pangolier/hero_pangolier_ki_burst/hero_pangolier_ki_burst", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_NONE )

hero_pangolier_ki_burst = class({})

function hero_pangolier_ki_burst:OnSpellStart()
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor( "damage" )
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor( "jump_duration" )
	local height = self:GetSpecialValueFor( "jump_height" )

	caster:AddNewModifier(caster, self, "modifier_hero_pangolier_ki_burst", {duration = duration})
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
end

function hero_pangolier_ki_burst:PlayEffects1( modifier )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	modifier:AddParticle( effect_cast, false, false, -1, false, false)
	EmitSoundOn( "Hero_Pangolier.TailThump.Cast", self:GetCaster() )
end

function hero_pangolier_ki_burst:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Pangolier.TailThump", self:GetCaster() )
end

function hero_pangolier_ki_burst:PlayEffects3( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf", PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

----------------------------------------------------------------------------------------

modifier_hero_pangolier_ki_burst = class({})

function modifier_hero_pangolier_ki_burst:IsHidden() return false end
function modifier_hero_pangolier_ki_burst:IsPurgable() return false end

function modifier_hero_pangolier_ki_burst:OnCreated()
	self.smash_particle = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"
	self.smash_sound = "Hero_Pangolier.TailThump"

	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.buff_duration = self:GetAbility():GetSpecialValueFor("jump_duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	if IsServer() then
		self.distance	= 1
		self.direction	= self:GetCaster():GetForwardVector()
		self.duration	= self:GetAbility():GetSpecialValueFor("jump_duration")
		self.height		= self:GetAbility():GetSpecialValueFor("jump_height")
		self.stun_duration		= self:GetAbility():GetSpecialValueFor("stun_duration")
		
		if self:GetParent():IsRooted() then return end

		self.velocity = self.direction * self.distance / self.duration
		self.vertical_velocity		= 4 * self.height / self.duration
		self.vertical_acceleration	= -(8 * self.height) / (self.duration * self.duration)
		self:GetParent():RemoveHorizontalMotionController(self)
		if self:ApplyVerticalMotionController() == nil or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
		end
		
		-- if not self:GetParent():HasModifier("modifier_pangolier_gyroshell") and self:ApplyHorizontalMotionController() == false then 
			-- self:Destroy()
		-- end
	end
end

function modifier_hero_pangolier_ki_burst:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveHorizontalMotionController(self)
	self:GetParent():RemoveVerticalMotionController(self)
	
	local smash = ParticleManager:CreateParticle(self.smash_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())

	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.smash_sound, self:GetCaster())


	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
	
	damage_table = ({
		attacker = self:GetCaster(),
		ability = self:GetAbility(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL
	})
	
	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() then
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
			damage_table.victim = enemy
			ApplyDamage(damage_table)
		end
	end
	ParticleManager:ReleaseParticleIndex(smash)
end

function modifier_hero_pangolier_ki_burst:UpdateHorizontalMotion(me, dt)
	me:SetOrigin( me:GetOrigin() + self.velocity * dt )
end

function modifier_hero_pangolier_ki_burst:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_hero_pangolier_ki_burst:UpdateVerticalMotion(me, dt)
	me:SetOrigin( me:GetOrigin() + Vector(0, 0, self.vertical_velocity) * dt )
	if GetGroundHeight(self:GetParent():GetAbsOrigin(), nil) > self:GetParent():GetAbsOrigin().z then
		self:Destroy()
	else
		self.vertical_velocity = self.vertical_velocity + (self.vertical_acceleration * dt)
	end
end

function modifier_hero_pangolier_ki_burst:OnVerticalMotionInterrupted()
	self:Destroy()
end

function modifier_hero_pangolier_ki_burst:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_STUNNED]							= true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
