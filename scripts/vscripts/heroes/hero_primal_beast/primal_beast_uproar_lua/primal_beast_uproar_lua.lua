LinkLuaModifier( "modifier_primal_beast_uproar_lua_buff", "heroes/hero_primal_beast/primal_beast_uproar_lua/primal_beast_uproar_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_lua_debuff", "heroes/hero_primal_beast/primal_beast_uproar_lua/primal_beast_uproar_lua", LUA_MODIFIER_MOTION_NONE )

primal_beast_uproar_lua = class({})

function primal_beast_uproar_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	caster:AddNewModifier(caster, self, "modifier_primal_beast_uproar_lua_buff",{duration = duration})

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_primal_beast_uproar_lua_debuff", {duration = duration})
	end
	self:PlayEffects( radius )
	self:PlayEffects2()
end


function primal_beast_uproar_lua:PlayEffects( radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_roar_aoe.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_PrimalBeast.Uproar.Cast", self:GetCaster() )
end

function primal_beast_uproar_lua:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_primal_beast/primal_beast_roar.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_jaw_fx", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------------------------------------

modifier_primal_beast_uproar_lua_buff = class({})

function modifier_primal_beast_uproar_lua_buff:IsHidden()
	return false
end

function modifier_primal_beast_uproar_lua_buff:IsDebuff()
	return false
end

function modifier_primal_beast_uproar_lua_buff:IsPurgable()
	return true
end

function modifier_primal_beast_uproar_lua_buff:OnCreated( kv )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_primal_beast_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) + 10
	else
		self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	end
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self:PlayEffects()
end

function modifier_primal_beast_uproar_lua_buff:OnRefresh( kv )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_primal_beast_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) + 10
	else
		self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	end
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
end

function modifier_primal_beast_uproar_lua_buff:OnRemoved()
end

function modifier_primal_beast_uproar_lua_buff:OnDestroy()
end

function modifier_primal_beast_uproar_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_primal_beast_uproar_lua_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage
end
function modifier_primal_beast_uproar_lua_buff:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_primal_beast_uproar_lua_buff:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast, 2, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	self:AddParticle(effect_cast, false, false, -1, false, false)
end

-----------------------------------------------------------------------------------------------------

modifier_primal_beast_uproar_lua_debuff = class({})

function modifier_primal_beast_uproar_lua_debuff:IsHidden()
	return false
end

function modifier_primal_beast_uproar_lua_debuff:IsDebuff()
	return true
end

function modifier_primal_beast_uproar_lua_debuff:IsPurgable()
	return true
end

function modifier_primal_beast_uproar_lua_debuff:GetTexture()
	return "primal_beast_uproar"
end

function modifier_primal_beast_uproar_lua_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow" )
end

function modifier_primal_beast_uproar_lua_debuff:OnRefresh( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow" )
end

function modifier_primal_beast_uproar_lua_debuff:OnRemoved()
end

function modifier_primal_beast_uproar_lua_debuff:OnDestroy()
end

function modifier_primal_beast_uproar_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_primal_beast_uproar_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_primal_beast_uproar_lua_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf"
end

function modifier_primal_beast_uproar_lua_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end