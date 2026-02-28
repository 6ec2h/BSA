LinkLuaModifier("modifier_gavnina", "abilities/bosses/gavnina", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_gavnina_thinker", "abilities/bosses/gavnina", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_gavnina_burn", "abilities/bosses/gavnina", LUA_MODIFIER_MOTION_VERTICAL)

gavnina = class({})

function gavnina:OnSpellStart()
	self.mod_caster = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_gavnina", {duration = 3})
end

------------------------------------------------------------------------------

modifier_gavnina = class({})

function modifier_gavnina:IsHidden()
    return true
end

function modifier_gavnina:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(self.interval)
end


function modifier_gavnina:OnIntervalThink()
if not IsServer() then return end
	local caster_pos = self:GetCaster():GetAbsOrigin()
		
	local angle = RandomInt(0, 360)
	local variance = RandomInt(-self.radius, self.radius)
	local dy = math.sin(angle) * variance
	local dx = math.cos(angle) * variance
	local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
	
	CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_gavnina_thinker", {}, target_point, self:GetCaster():GetTeamNumber(), false)
	
	self:StartIntervalThink(-1)
	self:StartIntervalThink(self.interval)
end

--------------------------------------------------------------------------

modifier_gavnina_thinker = class({})

function modifier_gavnina_thinker:IsHidden()
	return true
end

function modifier_gavnina_thinker:OnCreated( kv )
	if IsServer() then
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = self:GetAbility():GetSpecialValueFor( "land_time" )
		self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )


		self.interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
		self.duration = self:GetAbility():GetSpecialValueFor( "burn_duration" )
		
		self.fallen = false

		self:StartIntervalThink( self.delay )
		self:PlayEffects1()
	end
end

function modifier_gavnina_thinker:OnDestroy( kv )
	if IsServer() then
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
	end
end

function modifier_gavnina_thinker:OnIntervalThink()
	if not self.fallen then
		self.fallen = true
		self:Burn()
		self:PlayEffects2()
		self:Destroy()
	end
end

function modifier_gavnina_thinker:Burn()
	local damage = self:GetAbility():GetSpecialValueFor( "main_damage" )
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}
		ApplyDamage( self.damageTable )

		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_gavnina_burn", { duration = self.duration } )
	end
end

function modifier_gavnina_thinker:PlayEffects1()
	local particle_cast = "particles/gavnina/gavnina_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	local height = 1000
	local height_target = -0

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_gavnina_thinker:PlayEffects2()
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
end


------------------------------------------------------------------

modifier_gavnina_burn = class({})

function modifier_gavnina_burn:IsHidden()
	return false
end

function modifier_gavnina_burn:IsDebuff()
	return true
end

function modifier_gavnina_burn:IsStunDebuff()
	return false
end

function modifier_gavnina_burn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_gavnina_burn:IsPurgable()
	return true
end

function modifier_gavnina_burn:OnCreated( kv )
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor( "burn_dps" )
		local delay = 1
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}

		self:StartIntervalThink( delay )
	end
end

function modifier_gavnina_burn:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING,
    }
    return funcs
end

function modifier_gavnina_burn:GetDisableHealing()
    return 1
end

function modifier_gavnina_burn:OnIntervalThink()
	ApplyDamage( self.damageTable )
	EmitSoundOn( "Hero_Invoker.ChaosMeteor.Damage", self:GetParent() )
end