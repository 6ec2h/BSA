zuus_passive = class({})
LinkLuaModifier( "modifier_zuus_passive", "heroes/hero_zuus/zuus_passive/zuus_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function zuus_passive:GetIntrinsicModifierName()
	return "modifier_zuus_passive"
end

modifier_zuus_passive = class({})

--------------------------------------------------------------------------------
function modifier_zuus_passive:IsHidden()
	return true
end

function modifier_zuus_passive:IsPurgable()
	return false
end

function modifier_zuus_passive:OnCreated( kv )
if IsServer() then 
	Timers:CreateTimer(0, function()
	cast_time = 3 
	
	if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int7")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int7"):GetLevel() > 0 then 
			cast_time = 2
		end
	end
	
	local damageType = self:GetAbility():GetAbilityDamageType()
	local int = self:GetCaster():GetIntellect()
	self.damage_per_int = self:GetAbility():GetSpecialValueFor( "dmg_per_int" )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int11")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int11"):GetLevel() > 0 then 
			self.damage_per_int = self:GetAbility():GetSpecialValueFor( "dmg_per_int" ) + 0.1
		end
	end
	local damage = self.damage_per_int*int
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	 
	local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	
	if #hEnemies > 0 then
		for _,unit in pairs(hEnemies) do
		
		damage_flags = DOTA_DAMAGE_FLAG_NONE
		
			local damage = {
			victim = unit,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = damage_flags,
			ability = ability
		}
		ApplyDamage( damage )
		
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControl(particle,0,unit:GetAbsOrigin())
			EmitSoundOn("Hero_Zuus.StaticField", unit)
			end	
		end
		end
		return cast_time
    end)
	end
end