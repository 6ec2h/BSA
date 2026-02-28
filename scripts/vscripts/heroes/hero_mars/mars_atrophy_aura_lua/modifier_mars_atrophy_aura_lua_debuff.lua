modifier_mars_atrophy_aura_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_atrophy_aura_lua_debuff:IsHidden()
	return false
end

function modifier_mars_atrophy_aura_lua_debuff:IsDebuff()
	return true
end

function modifier_mars_atrophy_aura_lua_debuff:IsStunDebuff()
	return false
end

function modifier_mars_atrophy_aura_lua_debuff:IsPurgable()
	return true
end

function modifier_mars_atrophy_aura_lua_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mars_atrophy_aura_lua_debuff:OnCreated( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction_pct" )
self:StartIntervalThink(0.1)
	if not IsServer() then return end
end

function modifier_mars_atrophy_aura_lua_debuff:OnRefresh( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction_pct" )	
end

function modifier_mars_atrophy_aura_lua_debuff:OnIntervalThink()

	self:OnRefresh()
end


function modifier_mars_atrophy_aura_lua_debuff:OnRemoved()
end

function modifier_mars_atrophy_aura_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_atrophy_aura_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_mars_atrophy_aura_lua_debuff:GetModifierBaseDamageOutgoing_Percentage( params )
	return -self.reduction
end
