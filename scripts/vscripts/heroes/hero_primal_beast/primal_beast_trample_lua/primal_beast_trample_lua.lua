LinkLuaModifier( "modifier_primal_beast_trample_lua", "heroes/hero_primal_beast/primal_beast_trample_lua/primal_beast_trample_lua", LUA_MODIFIER_MOTION_NONE )

primal_beast_trample_lua = class({})

function primal_beast_trample_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	caster:AddNewModifier(caster, self, "modifier_primal_beast_trample_lua", {duration = duration})
end

-----------------------------------------------------------------------------

modifier_primal_beast_trample_lua = class({})

function modifier_primal_beast_trample_lua:IsHidden()
	return false
end

function modifier_primal_beast_trample_lua:IsDebuff()
	return false
end

function modifier_primal_beast_trample_lua:IsPurgable()
	return false
end

function modifier_primal_beast_trample_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.step_distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_primal_beast_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.attack_damage = (self:GetAbility():GetSpecialValueFor( "attack_damage" ) + 20) / 100
	else
		self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" )/100
	end

	if not IsServer() then return end
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.distance = 0
	self.treshold = 500
	self.currentpos = self.parent:GetOrigin()
	self:StartIntervalThink( 0.1 )
	self:Trample()
end

function modifier_primal_beast_trample_lua:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_primal_beast_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.attack_damage = (self:GetAbility():GetSpecialValueFor( "attack_damage" ) + 20) / 100
	else
		self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" )/100
	end
end

function modifier_primal_beast_trample_lua:OnRemoved()
end

function modifier_primal_beast_trample_lua:OnDestroy()
end

function modifier_primal_beast_trample_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

function modifier_primal_beast_trample_lua:GetActivityTranslationModifiers()
	return "heavy_steps"
end

function modifier_primal_beast_trample_lua:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_primal_beast_trample_lua:OnIntervalThink()
	local pos = self.parent:GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos
	GridNav:DestroyTreesAroundPoint( pos, self.radius, false )
	if dist>self.treshold then return end
	self.distance = self.distance + dist
	if self.distance > self.step_distance then
		self:Trample()
		self.distance = 0
	end
end

function modifier_primal_beast_trample_lua:Trample()
	local pos = self.parent:GetOrigin()
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	local damage = self.base_damage + self.parent:GetAverageTrueAttackDamage(self.parent)*self.attack_damage
	local damageTable = {
		attacker = self.parent,
		damage = damage,
		damage_type = self.abilityDamageType,
	}
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
	end
	self:PlayEffects()
end

function modifier_primal_beast_trample_lua:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_disarm.vpcf"
end

function modifier_primal_beast_trample_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_primal_beast_trample_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf"
	local sound_cast = "Hero_PrimalBeast.Trample"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self.parent )
end
