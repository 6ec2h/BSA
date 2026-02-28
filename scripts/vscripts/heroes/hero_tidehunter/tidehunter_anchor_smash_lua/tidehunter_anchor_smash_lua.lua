tidehunter_anchor_smash_lua = class({})
LinkLuaModifier( "modifier_tidehunter_anchor_smash_lua", "heroes/hero_tidehunter/tidehunter_anchor_smash_lua/tidehunter_anchor_smash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tidehunter_anchor_smash_lua_buff", "heroes/hero_tidehunter/tidehunter_anchor_smash_lua/tidehunter_anchor_smash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tidehunter_anchor_smash_lua_talent", "heroes/hero_tidehunter/tidehunter_anchor_smash_lua/tidehunter_anchor_smash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tidehunter_anchor_smash_lua_cd", "heroes/hero_tidehunter/tidehunter_anchor_smash_lua/tidehunter_anchor_smash_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function tidehunter_anchor_smash_lua:GetIntrinsicModifierName()
	return "modifier_tidehunter_anchor_smash_lua_talent"
end

function tidehunter_anchor_smash_lua:OnSpellStart()
	local caster = self:GetCaster()
	local reduction_radius = self:GetSpecialValueFor("radius")
	local reduction_duration = self:GetSpecialValueFor("reduction_duration")
	local bonus_damage = self:GetSpecialValueFor("attack_damage")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, reduction_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	local mod = caster:AddNewModifier(caster, self, "modifier_tidehunter_anchor_smash_lua_buff", {bonus = bonus_damage})

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_tidehunter_anchor_smash_lua", { duration = reduction_duration })
		caster:PerformAttack( enemy, true, true, true, true, false, false, true )
	end

	mod:Destroy()
	self:PlayEffects()
end

function tidehunter_anchor_smash_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_Tidehunter.AnchorSmash", self:GetCaster() )
end

-----------------------------------------------------------------------------------

modifier_tidehunter_anchor_smash_lua = class({})

function modifier_tidehunter_anchor_smash_lua:IsDebuff()
	return true
end

function modifier_tidehunter_anchor_smash_lua:OnCreated( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_tidehunter_anchor_smash_lua:OnRefresh( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_tidehunter_anchor_smash_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_tidehunter_anchor_smash_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.reduction
end

--------------------------------------------------------------------------------

modifier_tidehunter_anchor_smash_lua_buff = class({})

function modifier_tidehunter_anchor_smash_lua_buff:IsHidden()
	return true
end

function modifier_tidehunter_anchor_smash_lua_buff:IsDebuff()
	return false
end

function modifier_tidehunter_anchor_smash_lua_buff:IsPurgable()
	return false
end

function modifier_tidehunter_anchor_smash_lua_buff:OnCreated( kv )
	if not IsServer() then return end
	self.bonus = kv.bonus
end

function modifier_tidehunter_anchor_smash_lua_buff:OnRefresh( kv )
end

function modifier_tidehunter_anchor_smash_lua_buff:OnRemoved()
end

function modifier_tidehunter_anchor_smash_lua_buff:OnDestroy()
end

function modifier_tidehunter_anchor_smash_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SUPPRESS_CLEAVE,
	}
	return funcs
end

function modifier_tidehunter_anchor_smash_lua_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus
end

function modifier_tidehunter_anchor_smash_lua_buff:GetSuppressCleave()
	return 1
end


--------------------------------------------------------------------------------

modifier_tidehunter_anchor_smash_lua_talent = class({})

function modifier_tidehunter_anchor_smash_lua_talent:IsHidden()
	return true
end

function modifier_tidehunter_anchor_smash_lua_talent:IsDebuff()
	return false
end

function modifier_tidehunter_anchor_smash_lua_talent:IsPurgable()
	return false
end

function modifier_tidehunter_anchor_smash_lua_talent:OnRefresh( kv )
end

function modifier_tidehunter_anchor_smash_lua_talent:OnRemoved()
end

function modifier_tidehunter_anchor_smash_lua_talent:OnDestroy()
end

function modifier_tidehunter_anchor_smash_lua_talent:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_tidehunter_anchor_smash_lua_talent:OnAttackLanded( params )
	self.parent = self:GetParent()
	if params.attacker~=self.parent then return end
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end
	if self.parent:PassivesDisabled() then return end

	local ability = self:GetCaster():FindAbilityByName("special_bonus_tidehunter_4")
	if ability ~= nil and ability:GetLevel() > 0 and not self.parent:HasModifier('modifier_tidehunter_anchor_smash_lua_cd') then 
		if RandomInt(1,100) <= 50 then
			self.parent:AddNewModifier(self.parent, nil, "modifier_tidehunter_anchor_smash_lua_cd", { duration = 0.15 })
			self:GetAbility():OnSpellStart()
		end
	end
end

--------------------------------------------------

modifier_tidehunter_anchor_smash_lua_cd = class({})

function modifier_tidehunter_anchor_smash_lua_cd:IsHidden()
	return true
end

function modifier_tidehunter_anchor_smash_lua_cd:IsPurgable()
	return false
end