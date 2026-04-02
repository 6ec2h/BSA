LinkLuaModifier( "modifier_lycan_howl_lua_buff", "heroes/hero_lycan/lycan_howl_lua/lycan_howl_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

lycan_howl_lua = class({})

function lycan_howl_lua:OnSpellStart()
if not IsServer() then return end
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
	for _,ally in pairs(allies) do
		ally:AddNewModifier( self:GetCaster(), self, "modifier_lycan_howl_lua_buff",  { duration = duration } )
	end
	local sound_cast = "Hero_Lycan.Howl"
	-- EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), sound_cast, self:GetCaster())
	EmitSoundOn(sound_cast, self:GetCaster())
	
	local particle_lycan_howl_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 0 , self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 1 , self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 2 , self:GetCaster():GetAbsOrigin())
end


---------------------------------------------------------------

modifier_lycan_howl_lua_buff = class({})

function modifier_lycan_howl_lua_buff:IsPurgable()		return false end
function modifier_lycan_howl_lua_buff:RemoveOnDeath()	return false end
function modifier_lycan_howl_lua_buff:IsHidden() return false end

function modifier_lycan_howl_lua_buff:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_lycan_howl_lua_buff:OnCreated()
end

function modifier_lycan_howl_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_lycan_howl_lua_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "as" )
end

function modifier_lycan_howl_lua_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor( "movespeed" )
end

function modifier_lycan_howl_lua_buff:GetModifierBaseDamageOutgoing_Percentage()
	local abil = self:GetCaster():FindAbilityByName("special_bonus_lycan_tal1")
	if abil ~= nil and abil:GetLevel() > 0 then 
		return 25
	end
	return 0	
end
