LinkLuaModifier( "modifier_custom_statick", "heroes/static", LUA_MODIFIER_MOTION_NONE )

custom_statick = class({})

function custom_statick:OnSpellStart()
if not IsServer() then return end
	 local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_statick", {duration = 5})
		end	
end

---------------------------------------------------------------------------------------------------------------

modifier_custom_statick = class({})

function modifier_custom_statick:IsHidden()
   return true
end

function modifier_custom_statick:IsDebuff()
   return true
end

function modifier_custom_statick:IsPurgable()
   return false
end

function modifier_custom_statick:RemoveOnDeath()
   return true
end

function modifier_custom_statick:OnCreated()
if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Treant.Overgrowth.Cast")
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self:GetParent():GetMaxHealth() * 0.15,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
	})
	self:StartIntervalThink(1)
end

function modifier_custom_statick:OnIntervalThink()
if not IsServer() then return end
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self:GetParent():GetMaxHealth() * 0.15,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
	})
end

function modifier_custom_statick:GetEffectName()
	return "particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_cauldron.vpcf"
end

function modifier_custom_statick:CheckState()
   return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end