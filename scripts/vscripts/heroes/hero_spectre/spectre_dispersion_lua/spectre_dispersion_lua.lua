LinkLuaModifier( "modifier_spectre_dispersion_lua", "heroes/hero_spectre/spectre_dispersion_lua/spectre_dispersion_lua" ,LUA_MODIFIER_MOTION_NONE )

spectre_dispersion_lua = class({})

function spectre_dispersion_lua:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_lua"
end

--------------------------------------------------------------------

modifier_spectre_dispersion_lua = class({})

function modifier_spectre_dispersion_lua:IsHidden()
	return true
end

function modifier_spectre_dispersion_lua:IsDebuff()
	return false
end

function modifier_spectre_dispersion_lua:IsPurgable()
	return false
end

function modifier_spectre_dispersion_lua:AllowIllusionDuplicate()
	return true
end

function modifier_spectre_dispersion_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_cleanse" )
	self.reset = self:GetAbility():GetSpecialValueFor( "damage_reset_interval" )
	self.proc = true
	self.damage = 0
end

function modifier_spectre_dispersion_lua:OnRefresh( kv )
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_cleanse" )
	self.reset = self:GetAbility():GetSpecialValueFor( "damage_reset_interval" )
end

function modifier_spectre_dispersion_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_spectre_dispersion_lua:GetModifierIncomingDamage_Percentage()
	local talent = self:GetCaster():FindAbilityByName("special_bonus_spectre_tal1")
	if talent ~= nil and talent:GetLevel() > 0 then
		self.block = (self:GetAbility():GetSpecialValueFor("damage_reflection_pct") + 10) * -1
	else
		self.block = self:GetAbility():GetSpecialValueFor("damage_reflection_pct") * -1
	end
	return self.block
end

function modifier_spectre_dispersion_lua:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self.parent then return end
	if self.parent:PassivesDisabled() then return end

	self.damage = self.damage + params.damage
	if self.damage > self.purge and self.proc then 
		self.proc = false
		self:StartIntervalThink( self.reset )
		self:PlayEffects()
	end
end

function modifier_spectre_dispersion_lua:OnIntervalThink()
	self.damage = 0	
	self.proc = true
	self:StartIntervalThink( -1 )
end

function modifier_spectre_dispersion_lua:PlayEffects()
	self:GetCaster():EmitSound("DOTA_Item.BladeMail.Activate")	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _,enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = self.purge,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}
		ApplyDamage(damageTable)
	end
end