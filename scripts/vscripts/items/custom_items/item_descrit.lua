item_descrit_lua1 = item_descrit_lua1 or class({})
item_descrit_lua2 = item_descrit_lua1 or class({})
item_descrit_lua3 = item_descrit_lua1 or class({})

LinkLuaModifier("modifier_item_descrit_lua", 'items/custom_items/item_descrit.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_descrit_lua_debuff", 'items/custom_items/item_descrit.lua', LUA_MODIFIER_MOTION_NONE)

function item_descrit_lua1:GetIntrinsicModifierName()
	return "modifier_item_descrit_lua"
end

----------------------------------------------------------

modifier_item_descrit_lua = class({})

function modifier_item_descrit_lua:IsHidden()
	return true
end

function modifier_item_descrit_lua:IsPurgable()
	return false
end


function modifier_item_descrit_lua:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

function ChangeAttackProjectileImba(unit)
	local particle_deso = "particles/items_fx/desolator_projectile.vpcf"
	unit:SetRangedProjectileName(particle_deso)
end	
	
function modifier_item_descrit_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_descrit_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_item_descrit_lua:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor("crit_multiplier")
	self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_item_descrit_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end


function modifier_item_descrit_lua:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_descrit_lua_debuff", {duration = self.duration * (1 - target:GetStatusResistance())})
	end
end

function modifier_item_descrit_lua:GetModifierPreAttack_CriticalStrike(keys)
	if self:GetAbility() and (keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("crit_chance"), self) then
		return self:GetAbility():GetSpecialValueFor("crit_multiplier")
	end
end

function modifier_item_descrit_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function RollPseudoRandom(base_chance, entity)
	local ran = RandomInt(1,100)
	if base_chance >= ran then return true
	else return false
	end
end

-------------------------------------------------

if modifier_item_descrit_lua_debuff == nil then modifier_item_descrit_lua_debuff = class({}) end
function modifier_item_descrit_lua_debuff:IsHidden() return false end
function modifier_item_descrit_lua_debuff:IsDebuff() return true end
function modifier_item_descrit_lua_debuff:IsPurgable() return true end

function modifier_item_descrit_lua_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption")
end

function modifier_item_descrit_lua_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_descrit_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end