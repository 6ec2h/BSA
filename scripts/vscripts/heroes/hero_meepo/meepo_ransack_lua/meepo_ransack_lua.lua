meepo_ransack_lua = class({})
LinkLuaModifier( "modifier_meepo_ransack_lua", "heroes/hero_meepo/meepo_ransack_lua/meepo_ransack_lua", LUA_MODIFIER_MOTION_NONE )

function meepo_ransack_lua:GetIntrinsicModifierName()
	return "modifier_meepo_ransack_lua"
end

-----------------------------------------------------------------------------

modifier_meepo_ransack_lua = class({})

function modifier_meepo_ransack_lua:IsHidden()
	return true
end

function modifier_meepo_ransack_lua:IsPurgable()
	return false
end

function modifier_meepo_ransack_lua:OnCreated( kv )
	self.steal = self:GetAbility():GetSpecialValueFor( "steal" )
	self:StartIntervalThink(1)
end

function modifier_meepo_ransack_lua:OnRefresh( kv )
	self.steal = self:GetAbility():GetSpecialValueFor( "steal" )	
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_meepo_int3")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		self.steal = self:GetAbility():GetSpecialValueFor( "steal" ) * 2
	end
end

function modifier_meepo_ransack_lua:OnIntervalThink()
self:OnRefresh()
end

function modifier_meepo_ransack_lua:OnDestroy( kv )

end

function modifier_meepo_ransack_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}
	return funcs
end

function modifier_meepo_ransack_lua:GetModifierProcAttack_BonusDamage_Pure( params )
	self:GetParent():Heal( self.steal, self:GetAbility() )
	local sound_cast = "Hero_Meepo.Ransack"
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetParent() )
	return self.steal
end
