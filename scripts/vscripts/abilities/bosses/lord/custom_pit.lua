LinkLuaModifier("modifier_custom_pit", "abilities/bosses/lord/custom_pit", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_custom_pit_thinker", "abilities/bosses/lord/custom_pit", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_custom_pit_cooldown", "abilities/bosses/lord/custom_pit", LUA_MODIFIER_MOTION_VERTICAL)

custom_pit = class({})

function custom_pit:OnSpellStart()    
	if not IsServer() then return end
	local caster = self:GetCaster()
	local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #hEnemies > 0 then
		for _, target in ipairs(hEnemies) do
			local point = target:GetAbsOrigin()
			local duration = self:GetSpecialValueFor( "pit_duration" )
			CreateModifierThinker(caster, self, "modifier_custom_pit_thinker", { duration = duration }, point, caster:GetTeamNumber(), false)
			self:PlayEffects( point )
		end
	end
end

function custom_pit:PlayEffects( point )
	local particle_cast = "particles/units/heroes/heroes_underlord/underlord_pitofmalice_pre.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.PitOfMalice.Start"
	local radius = self:GetSpecialValueFor( "radius" )
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, 1, 1 ) )
	EmitSoundOnLocationForAllies( point, sound_cast, self:GetCaster() )
end

---------------------------------------------------------

modifier_custom_pit_thinker = class({})

function modifier_custom_pit_thinker:IsHidden()
	return false
end

function modifier_custom_pit_thinker:IsDebuff()
	return false
end

function modifier_custom_pit_thinker:IsPurgable()
	return false
end

function modifier_custom_pit_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "ensnare_duration" )

	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self:StartIntervalThink( 0.033 )
	self:OnIntervalThink()

	self:PlayEffects()
end

function modifier_custom_pit_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_custom_pit_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetOrigin(),	nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByNameAndCaster( "modifier_custom_pit_cooldown", self:GetCaster() )
		if not modifier then
			enemy:AddNewModifier(self.caster, self:GetAbility(),  "modifier_custom_pit", { duration = self.duration })
		end
	end
end

function modifier_custom_pit_thinker:PlayEffects()
	local particle_cast = "particles/units/heroes/heroes_underlord/underlord_pitofmalice.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.PitOfMalice"

	local parent = self:GetParent()

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetDuration(), 0, 0 ) )

	self:AddParticle(effect_cast, false, false, -1, false, false)
	EmitSoundOn( sound_cast, parent )
end

--------------------------------------------------------------

modifier_custom_pit = class({})

function modifier_custom_pit:IsHidden()
	return false
end

function modifier_custom_pit:IsDebuff()
	return true
end

function modifier_custom_pit:IsStunDebuff()
	return false
end

function modifier_custom_pit:IsPurgable()
	return true
end

function modifier_custom_pit:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_custom_pit:OnCreated( kv )
	local interval = self:GetAbility():GetSpecialValueFor( "pit_interval" )
	local damage = self:GetAbility():GetSpecialValueFor( "pit_damage" )

	if not IsServer() then return end

	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_custom_pit_cooldown", -- modifier name
		{
			duration = interval,
		} -- kv
	)
	
	local damage_table = {
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage = damage,
		victim = self:GetParent(),
		}
	ApplyDamage(damage_table)	

	local hero = self:GetParent():IsHero()
	local sound_cast = "Hero_AbyssalUnderlord.Pit.TargetHero"
	if not hero then
		sound_cast = "Hero_AbyssalUnderlord.Pit.Target"
	end
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_custom_pit:OnRefresh( kv )
	
end

function modifier_custom_pit:OnRemoved()
end

function modifier_custom_pit:OnDestroy()
end

function modifier_custom_pit:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

function modifier_custom_pit:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function modifier_custom_pit:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------------------------------------------

modifier_custom_pit_cooldown = class({})

function modifier_custom_pit_cooldown:IsHidden()
	return true
end

function modifier_custom_pit_cooldown:IsDebuff()
	return true
end

function modifier_custom_pit_cooldown:IsPurgable()
	return false
end

function modifier_custom_pit_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_custom_pit_cooldown:OnCreated( kv )
end

function modifier_custom_pit_cooldown:OnRefresh( kv )
end

function modifier_custom_pit_cooldown:OnRemoved()
end

function modifier_custom_pit_cooldown:OnDestroy()
end