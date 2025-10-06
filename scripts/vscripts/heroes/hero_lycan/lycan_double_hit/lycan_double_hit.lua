LinkLuaModifier( "modifier_lycan_double_hit_sabre", "heroes/hero_lycan/lycan_double_hit/lycan_double_hit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_double_hit_haste", "heroes/hero_lycan/lycan_double_hit/lycan_double_hit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_double_hit_slow", "heroes/hero_lycan/lycan_double_hit/lycan_double_hit", LUA_MODIFIER_MOTION_NONE )

lycan_double_hit = class({})

function lycan_double_hit:GetIntrinsicModifierName()
	return "modifier_lycan_double_hit_sabre"
end

----------------------------------------------------------------------------------------------------------------------------------------

modifier_lycan_double_hit_sabre = class({})

function modifier_lycan_double_hit_sabre:IsPurgable()		return false end
function modifier_lycan_double_hit_sabre:RemoveOnDeath()	return false end
function modifier_lycan_double_hit_sabre:IsHidden() return true end

function modifier_lycan_double_hit_sabre:OnCreated()
end

function modifier_lycan_double_hit_sabre:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_lycan_double_hit_sabre:OnAttack(keys)
	if keys.attacker == self:GetParent() and self:GetAbility() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
		if not self:GetParent():IsRangedAttacker() then 
			if self:GetAbility():IsCooldownReady() and not keys.no_attack_cooldown then
				self:GetAbility():UseResources( false,false, false, true )		
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lycan_double_hit_haste", {})
			end
		end
	end
end

function modifier_lycan_double_hit_sabre:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and self:GetAbility() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
		keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lycan_double_hit_slow", {duration = self:GetAbility():GetSpecialValueFor( "duration" )})
	end
end

---------------------------------------------------------------------------------------------------------------------
modifier_lycan_double_hit_slow = class({})

function modifier_lycan_double_hit_slow:IsPurgable()		return false end
function modifier_lycan_double_hit_slow:RemoveOnDeath()	return false end
function modifier_lycan_double_hit_slow:IsHidden() return true end

function modifier_lycan_double_hit_slow:OnCreated()
end

function modifier_lycan_double_hit_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT	
	}
end

function modifier_lycan_double_hit_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor( "slow" )  * (-1)
end

function modifier_lycan_double_hit_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "slow_as" )  * (-1)
end
---------------------------------------------------------------------------------------------------------------------

modifier_lycan_double_hit_haste = modifier_lycan_double_hit_haste or class({})
function modifier_lycan_double_hit_haste:IsDebuff() return false end
function modifier_lycan_double_hit_haste:IsHidden() return true end
function modifier_lycan_double_hit_haste:IsPurgable() return false end
function modifier_lycan_double_hit_haste:IsPurgeException() return false end
function modifier_lycan_double_hit_haste:IsStunDebuff() return false end
function modifier_lycan_double_hit_haste:RemoveOnDeath() return true end

function modifier_lycan_double_hit_haste:OnCreated()
	local current_speed = self:GetParent():GetIncreasedAttackSpeed(true)
	current_speed = current_speed * 2

	local max_hits = 2
	self:SetStackCount(max_hits)
	self.attack_speed_buff = math.max(500, current_speed)
end

function modifier_lycan_double_hit_haste:OnRefresh()
	self:OnCreated()
end

function modifier_lycan_double_hit_haste:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_lycan_double_hit_haste:OnAttack(keys)
	if self:GetParent() == keys.attacker then
		self:SetStackCount(self:GetStackCount() - 1)
		if self:GetStackCount() == 1 then
			self:Destroy()
		end
	end
end

function modifier_lycan_double_hit_haste:OnAttackLanded(keys)
	if self:GetParent() == keys.attacker then
		if self:GetStackCount() == 2 then
			local abil = self:GetCaster():FindAbilityByName("special_bonus_lycan_tal3")
			if abil ~= nil and abil:GetLevel() > 0 then 
				local damage = keys.original_damage
				DoCleaveAttack( self:GetParent(), keys.target, self:GetAbility(), damage, 150, 360, 360, 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf')
			end
		end
	end	
end

function modifier_lycan_double_hit_haste:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_buff
end