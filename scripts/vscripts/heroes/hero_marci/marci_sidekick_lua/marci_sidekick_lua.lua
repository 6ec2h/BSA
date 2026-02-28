LinkLuaModifier( "modifier_marci_sidekick_lua", "heroes/hero_marci/marci_sidekick_lua/marci_sidekick_lua", LUA_MODIFIER_MOTION_NONE )

marci_sidekick_lua = class({})

function marci_sidekick_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor( "buff_duration" )

	if not target then return end
	target:AddNewModifier(caster, self, "modifier_marci_sidekick_lua", { duration = duration })
end

--------------------------------------------------------------------------

modifier_marci_sidekick_lua = class({})

function modifier_marci_sidekick_lua:IsHidden()
	return false
end

function modifier_marci_sidekick_lua:IsDebuff()
	return false
end

function modifier_marci_sidekick_lua:IsPurgable()
	return true
end

function modifier_marci_sidekick_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	self.lifesteal = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )
				
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

	if not IsServer() then return end
	self:PlayEffects1()
end

function modifier_marci_sidekick_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_sidekick_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_marci_sidekick_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end

	if params.target:GetTeamNumber()==self.parent:GetTeamNumber() then return end
	if params.target:IsBuilding() or params.target:IsOther() then return end

	self.attack_record = params.record
end

function modifier_marci_sidekick_lua:OnTakeDamage( params )
	if not IsServer() then return end
	if self.attack_record ~= params.record then return end
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_marci_2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.lifesteal = self.lifesteal + 20
	end

	local heal = params.damage * self.lifesteal/100
	self.parent:Heal( heal, self.ability )
	self:PlayEffects2()
end

function modifier_marci_sidekick_lua:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function modifier_marci_sidekick_lua:ShouldUseOverheadOffset()
	return true
end

function modifier_marci_sidekick_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

function modifier_marci_sidekick_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_marci_sidekick_lua:PlayEffects2()
	local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_marci_sidekick_lua:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
	if self.parent~=self.caster then
		particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
	end

	local sound_target = "Hero_Marci.Guardian.Applied"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() )

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		1, -- iPriority
		false, -- bHeroEffect
		true -- bOverheadEffect
	)
	EmitSoundOn( sound_target, self.parent )
end