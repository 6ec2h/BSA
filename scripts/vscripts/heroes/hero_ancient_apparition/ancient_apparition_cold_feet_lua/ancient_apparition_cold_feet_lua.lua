LinkLuaModifier("modifier_ancient_apparition_cold_feet_lua_freeze", "heroes/hero_ancient_apparition/ancient_apparition_cold_feet_lua/ancient_apparition_cold_feet_lua", LUA_MODIFIER_MOTION_NONE)

ancient_apparition_cold_feet_lua = class({})

function ancient_apparition_cold_feet_lua:OnSpellStart()
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:EmitSound("Hero_Ancient_Apparition.ColdFeetCast")	
	
	local target_point = self:GetCursorPosition()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target_point, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	for _, hEnemy in pairs( enemies ) do
		hEnemy:AddNewModifier(caster, self, "modifier_ancient_apparition_cold_feet_lua_freeze", {duration = duration})
	end
end

---------------------------------------------------------------------------------------------------
modifier_ancient_apparition_cold_feet_lua_freeze = class({})

function modifier_ancient_apparition_cold_feet_lua_freeze:IsHidden() return true end
function modifier_ancient_apparition_cold_feet_lua_freeze:IsPurgable() return false end

function modifier_ancient_apparition_cold_feet_lua_freeze:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_ancient_apparition_cold_feet_lua_freeze:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_ancient_apparition_cold_feet_lua_freeze:OnCreated()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetFreeze")
	self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():ExtraIntelligenceDamage() * self:GetAbility():GetSpecialValueFor("ExtraIntelligenceDamage")
	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_ancient_apparition_tal2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage = self.damage + 100
	end
	self:StartIntervalThink(0.5)
end

function modifier_ancient_apparition_cold_feet_lua_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end

function modifier_ancient_apparition_cold_feet_lua_freeze:OnIntervalThink()
	if not IsServer() then return end
	ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage/2, damage_type = DAMAGE_TYPE_MAGICAL})
end

function modifier_ancient_apparition_cold_feet_lua_freeze:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return decFuncs
end

function modifier_ancient_apparition_cold_feet_lua_freeze:GetModifierMagicalResistanceBonus()
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )	
	local ability = self:GetCaster():FindAbilityByName("special_bonus_ancient_apparition_tal4")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.resist = self.resist * 2
	end
	self.magic_resist = self.resist * (-1)
	return self.magic_resist
end