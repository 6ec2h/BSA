LinkLuaModifier( "modifier_lycan_feral_lua_buff", "heroes/hero_lycan/lycan_feral_lua/lycan_feral_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

lycan_feral_lua = class({})

function lycan_feral_lua:GetIntrinsicModifierName()	
    return "modifier_lycan_feral_lua_buff"
end

---------------------------------------------------------------

modifier_lycan_feral_lua_buff = class({})

function modifier_lycan_feral_lua_buff:IsPurgable()		return false end
function modifier_lycan_feral_lua_buff:RemoveOnDeath()	return false end
function modifier_lycan_feral_lua_buff:IsHidden() return true end


function modifier_lycan_feral_lua_buff:OnCreated()
end

function modifier_lycan_feral_lua_buff:DeclareFunctions()	
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
					  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
	
	return decFuncs	
end

function modifier_lycan_feral_lua_buff:GetModifierBaseDamageOutgoing_Percentage()	 		
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lycan_tal2")
	if abil ~= nil and abil:GetLevel() > 0 then 
		return self:GetAbility():GetSpecialValueFor( "damage" ) * 2
	end
	return self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_lycan_feral_lua_buff:GetModifierPhysicalArmorBonus()	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lycan_tal2")
	if abil ~= nil and abil:GetLevel() > 0 then 
		return self:GetAbility():GetSpecialValueFor( "armor" ) * 2
	end
	return self:GetAbility():GetSpecialValueFor( "armor" )
end