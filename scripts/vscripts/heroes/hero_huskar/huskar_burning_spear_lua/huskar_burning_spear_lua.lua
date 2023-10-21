LinkLuaModifier( "modifier_huskar_burning_spear_lua", "heroes/hero_huskar/huskar_burning_spear_lua/huskar_burning_spear_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_huskar_burning_spear_lua_stack", "heroes/hero_huskar/huskar_burning_spear_lua/huskar_burning_spear_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )

huskar_burning_spear_lua = class({})

function huskar_burning_spear_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function huskar_burning_spear_lua:GetProjectileName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end

function huskar_burning_spear_lua:OnOrbFire( params )
	local damageTable = {
		victim = self:GetCaster(),
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetMaxHealth() * self:GetSpecialValueFor("health_cost") / 100,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
	}
	ApplyDamage(damageTable)
end

function huskar_burning_spear_lua:OnOrbImpact( params )
	local duration = self:GetDuration()

	params.target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_huskar_burning_spear_lua", -- modifier name
		{ duration = duration } -- kv
	)

	local sound_cast = "Hero_Huskar.Burning_Spear.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function huskar_burning_spear_lua:OnSpellStart()
end

-------------------------------------------------------------------------------------------------

modifier_huskar_burning_spear_lua = class({})

function modifier_huskar_burning_spear_lua:IsHidden()
	return false
end

function modifier_huskar_burning_spear_lua:IsDebuff()
	return true
end

function modifier_huskar_burning_spear_lua:IsStunDebuff()
	return false
end

function modifier_huskar_burning_spear_lua:IsPurgable()
	return false
end

function modifier_huskar_burning_spear_lua:OnCreated( kv )
	if IsServer() then
		local duration = self:GetAbility():GetDuration()
		
		-- add stack modifier
		local this = tempTable:AddATValue( self )
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_huskar_burning_spear_lua_stack", -- modifier name
			{
				duration = duration,
				modifier = this,
			} -- kv
		)
		self:IncrementStackCount()

		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = 500,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		self:StartIntervalThink( 1 )
	end
end

function modifier_huskar_burning_spear_lua:OnRefresh( kv )
	if IsServer() then
		local duration = self:GetAbility():GetDuration()
		local this = tempTable:AddATValue( self )
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_huskar_burning_spear_lua_stack", -- modifier name
			{
				duration = duration,
				modifier = this,
			} -- kv
		)
		self:IncrementStackCount()
	end
end

function modifier_huskar_burning_spear_lua:OnRemoved()
	local sound_cast = "Hero_Huskar.Burning_Spear"
	StopSoundOn( sound_cast, self:GetParent() )
end

function modifier_huskar_burning_spear_lua:OnDestroy()
end

function modifier_huskar_burning_spear_lua:OnIntervalThink()
	self.dps = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_tal_1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.dps = self.dps + 15
	end

	self.damageTable.damage = self:GetStackCount() * self.dps
	ApplyDamage( self.damageTable )
end

function modifier_huskar_burning_spear_lua:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_huskar_burning_spear_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------

modifier_huskar_burning_spear_lua_stack = class({})

function modifier_huskar_burning_spear_lua_stack:IsHidden()
	return true
end

function modifier_huskar_burning_spear_lua_stack:IsPurgable()
	return false
end

function modifier_huskar_burning_spear_lua_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_huskar_burning_spear_lua_stack:OnCreated( kv )
	if IsServer() then
		self.modifier = tempTable:RetATValue( kv.modifier )
	end

	local sound_cast = "Hero_Huskar.Burning_Spear"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_huskar_burning_spear_lua_stack:OnRemoved()
	if IsServer() then
		if not self.modifier:IsNull() then
			self.modifier:DecrementStackCount()
		end
	end
end

function modifier_huskar_burning_spear_lua_stack:OnDestroy()
end

----------------------------------

if not tempTable then
	tempTable = {}
	tempTable.table = {}
end

function tempTable:GetATEmptyKey()
	local i = 1
	while self.table[i]~=nil do
		i = i+1
	end
	return i
end

function tempTable:AddATValue( value )
	local i = self:GetATEmptyKey()
	self.table[i] = value
	return i
end

function tempTable:RetATValue( key )
	local ret = self.table[key]
	self.table[key] = nil
	return ret
end

function tempTable:GetATValue( key )
	return self.table[key]
end

function tempTable:Print()
	for k,v in pairs(self.table) do
		print(k,v)
	end
end

return tempTable