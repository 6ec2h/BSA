LinkLuaModifier( "modifier_item_custom_dragon_lance","items/custom_items/item_dragon_lance", LUA_MODIFIER_MOTION_NONE )

item_dragon_lance_lua1 = class({})

function item_dragon_lance_lua1:GetIntrinsicModifierName()
	return "modifier_item_custom_dragon_lance"
end

----------------------------------------------------------------------

item_dragon_lance_lua2 = class({})
LinkLuaModifier( "modifier_item_custom_dragon_lance2","items/custom_items/item_dragon_lance", LUA_MODIFIER_MOTION_NONE )

function item_dragon_lance_lua2:GetIntrinsicModifierName()
	return "modifier_item_custom_dragon_lance2"
end

----------------------------------------------------------------------

item_dragon_lance_lua3 = class({})

LinkLuaModifier("modifier_item_custom_dragon_lance3","items/custom_items/item_dragon_lance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_dragon_lance3_reduced_damage","items/custom_items/item_dragon_lance", LUA_MODIFIER_MOTION_NONE)

function item_dragon_lance_lua3:GetIntrinsicModifierName()
	return "modifier_item_custom_dragon_lance3"
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_custom_dragon_lance = class({})

function modifier_item_custom_dragon_lance:IsHidden()
	return true
end

function modifier_item_custom_dragon_lance:IsPurgable()
	return false
end

function modifier_item_custom_dragon_lance:OnCreated( kv )
	
	self.bonus_str = self:GetAbility():GetSpecialValueFor( "bonus_str" )
	self.bonus_agi = self:GetAbility():GetSpecialValueFor( "bonus_agi" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "bonus_range" )
	self:StartIntervalThink( 0.1 )
		
end


function modifier_item_custom_dragon_lance:OnIntervalThink()
	if self:GetCaster():HasModifier( "modifier_item_custom_dragon_lance2") or self:GetCaster():HasModifier("modifier_item_custom_dragon_lance3") then
		self.bonus_range = 0
	end
end

function modifier_item_custom_dragon_lance:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
		MODIFIER_ATTRIBUTE_NONE
	}
	return funcs
end

function modifier_item_custom_dragon_lance:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_custom_dragon_lance:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_custom_dragon_lance:GetModifierAttackRangeBonusUnique( params )
if self:GetCaster():IsRangedAttacker() then
	return self.bonus_range
end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_item_custom_dragon_lance2 = class({})

function modifier_item_custom_dragon_lance2:IsHidden()
	return true
end

function modifier_item_custom_dragon_lance2:IsPurgable()
	return false
end

function modifier_item_custom_dragon_lance2:OnCreated( kv )
	
	self.bonus_str = self:GetAbility():GetSpecialValueFor( "bonus_str" )
	self.bonus_agi = self:GetAbility():GetSpecialValueFor( "bonus_agi" )
	self.bonus_as = self:GetAbility():GetSpecialValueFor( "bonus_as" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "bonus_range" )
end

function modifier_item_custom_dragon_lance2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
		MODIFIER_ATTRIBUTE_NONE
	}
	return funcs
end

function modifier_item_custom_dragon_lance2:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_custom_dragon_lance2:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_as
end

function modifier_item_custom_dragon_lance2:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_custom_dragon_lance2:GetModifierAttackRangeBonusUnique( params )
if self:GetCaster():IsRangedAttacker() then

	return self.bonus_range
end
end

function modifier_item_custom_dragon_lance2:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

-------------------------------------------------------------
-------------------------------------------------------------

modifier_item_custom_dragon_lance3 = class({})

function modifier_item_custom_dragon_lance3:IsDebuff() return false end
function modifier_item_custom_dragon_lance3:IsHidden() return true end
function modifier_item_custom_dragon_lance3:IsPurgable() return false end
function modifier_item_custom_dragon_lance3:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_item_custom_dragon_lance3:OnCreated( kv )
	
	self.bonus_str = self:GetAbility():GetSpecialValueFor( "bonus_str" )
	self.bonus_agi = self:GetAbility():GetSpecialValueFor( "bonus_agi" )
	self.bonus_as = self:GetAbility():GetSpecialValueFor( "bonus_as" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "bonus_range" )
	self:StartIntervalThink( 0.1 )	
end

function modifier_item_custom_dragon_lance3:OnIntervalThink()
if self:GetCaster():HasModifier( "modifier_item_custom_dragon_lance2" ) then
		self.bonus_range = 0
end
if not self:GetCaster():HasModifier( "modifier_item_custom_dragon_lance2" ) then
		self.bonus_range = self:GetAbility():GetSpecialValueFor( "bonus_range" )
end
end

function modifier_item_custom_dragon_lance3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_item_custom_dragon_lance3:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_item_custom_dragon_lance3:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_item_custom_dragon_lance3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_item_custom_dragon_lance3:GetModifierAttackRangeBonusUnique()
	if self:GetCaster():IsRangedAttacker() then
		return self.bonus_range
	end
end

function modifier_item_custom_dragon_lance3:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	
	if self.bSplitShot then
		return self:GetAbility():GetSpecialValueFor("split_shot_damage")
	else
		return 0
	end
end


function modifier_item_custom_dragon_lance3:OnAttack(keys)
	if not IsServer() then return end
--	R5 = RandomInt(1,100)
--	if R5 < 10 then
    if keys.attacker == self:GetParent() then
    end
	if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown then	
		
		if not self:GetParent():HasFlyMovementCapability() and  not self:GetParent():IsIllusion() then
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), keys.target:GetAbsOrigin(), keys.target, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
			local nTargetNumber = 0		
			for _, hEnemy in pairs(enemies) do
				if hEnemy ~= keys.target then

					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_custom_dragon_lance3_reduced_damage", {})				
					self:GetParent():PerformAttack(hEnemy, false, false, true, true, true, false, false)		
					self:GetParent():RemoveModifierByName("modifier_item_custom_dragon_lance3_reduced_damage")
					
					nTargetNumber = nTargetNumber + 1
					
					if nTargetNumber >= self:GetAbility():GetSpecialValueFor("max_target") then
						break
					end
				end
			end
		end
--	end
end
end


modifier_item_custom_dragon_lance3_reduced_damage = class({})

function modifier_item_custom_dragon_lance3_reduced_damage:IsDebuff() return false end
function modifier_item_custom_dragon_lance3_reduced_damage:IsHidden() return true end
function modifier_item_custom_dragon_lance3_reduced_damage:IsPurgable() return false end
function modifier_item_custom_dragon_lance3_reduced_damage:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_item_custom_dragon_lance3_reduced_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_item_custom_dragon_lance3_reduced_damage:GetModifierDamageOutgoing_Percentage()
	return -1*(100-self:GetAbility():GetSpecialValueFor("split_shot_damage"))
end