tidehunter_kraken_shell_lua = class({})
LinkLuaModifier( "modifier_tidehunter_kraken_shell_lua", "heroes/hero_tidehunter/tidehunter_kraken_shell_lua/tidehunter_kraken_shell_lua", LUA_MODIFIER_MOTION_NONE )

function tidehunter_kraken_shell_lua:GetIntrinsicModifierName()
	return "modifier_tidehunter_kraken_shell_lua"
end

--------------------------------------------------------------------

modifier_tidehunter_kraken_shell_lua = class({})

function modifier_tidehunter_kraken_shell_lua:IsHidden()
	return true
end

function modifier_tidehunter_kraken_shell_lua:IsDebuff()
	return false
end

function modifier_tidehunter_kraken_shell_lua:IsPurgable()
	return false
end

function modifier_tidehunter_kraken_shell_lua:AllowIllusionDuplicate()
	return true
end

function modifier_tidehunter_kraken_shell_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.block = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_cleanse" )
	self.reset = self:GetAbility():GetSpecialValueFor( "damage_reset_interval" )
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_tidehunter_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.block = self.block + 25
	end

	if not IsServer() then return end
	self.damage = 0
end

function modifier_tidehunter_kraken_shell_lua:OnRefresh( kv )
	self.block = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_cleanse" )
	self.reset = self:GetAbility():GetSpecialValueFor( "damage_reset_interval" )
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_tidehunter_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.block = self.block + 25
	end
end

function modifier_tidehunter_kraken_shell_lua:OnRemoved()
end

function modifier_tidehunter_kraken_shell_lua:OnDestroy()
end

function modifier_tidehunter_kraken_shell_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}
	return funcs
end

function modifier_tidehunter_kraken_shell_lua:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self.parent then return end
	if self.parent:PassivesDisabled() then return end

	-- if not params.attacker:GetPlayerOwner() then return end

	self:StartIntervalThink( self.reset )

	self.damage = self.damage + params.damage
	if self.damage < self.purge then return end
	self.damage = 0

	self.parent:Purge( false, true, false, true, true )

	self:PlayEffects()
end

function modifier_tidehunter_kraken_shell_lua:GetModifierPhysical_ConstantBlock()
	if self.parent:PassivesDisabled() then return 0 end
	return self.block
end

function modifier_tidehunter_kraken_shell_lua:OnIntervalThink()
	self:StartIntervalThink( -1 )
	self.damage = 0
end

function modifier_tidehunter_kraken_shell_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf"
	local sound_cast = "Hero_Tidehunter.KrakenShell"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self.parent )
end