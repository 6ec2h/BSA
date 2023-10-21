LinkLuaModifier("modifier_backtrack_lua", "heroes/hero_faceless_void/backtrack_lua/backtrack_lua", LUA_MODIFIER_MOTION_NONE)

backtrack_lua = class({})

function backtrack_lua:GetIntrinsicModifierName()
	return "modifier_backtrack_lua"
end

-------------------------------------------------------------------------

modifier_backtrack_lua = class({})

function modifier_backtrack_lua:IsHidden()
	return true
end

function modifier_backtrack_lua:IsPurgable()
	return false
end

function modifier_backtrack_lua:RemoveOnDeath()
	return false
end

function modifier_backtrack_lua:OnCreated( kv )
	self.caster = self:GetCaster()
end

function modifier_backtrack_lua:OnRefresh( kv )
end

function modifier_backtrack_lua:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_backtrack_lua:GetModifierIncomingDamage_Percentage()
	local caster = self:GetCaster()
	max_chance = self:GetAbility():GetSpecialValueFor( "chance" )
	
	local talent = caster:FindAbilityByName("npc_dota_hero_faceless_void_2")
	if talent and talent:GetLevel() > 0 then
		max_chance = max_chance + 10
	end
	
	if RandomInt(1,100) <= max_chance then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end