LinkLuaModifier('modifier_abaddon_curse_of_avernus_lua_debuff', "heroes/hero_abaddon/abaddon_curse_of_avernus_lua/abaddon_curse_of_avernus_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_abaddon_curse_of_avernus_lua_debuff_slow', "heroes/hero_abaddon/abaddon_curse_of_avernus_lua/abaddon_curse_of_avernus_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_abaddon_curse_of_avernus_lua', "heroes/hero_abaddon/abaddon_curse_of_avernus_lua/abaddon_curse_of_avernus_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_abaddon_curse_of_avernus_lua_buff', "heroes/hero_abaddon/abaddon_curse_of_avernus_lua/abaddon_curse_of_avernus_lua", LUA_MODIFIER_MOTION_NONE)

abaddon_curse_of_avernus_lua = class({})

function abaddon_curse_of_avernus_lua:GetIntrinsicModifierName() 
    return 'modifier_abaddon_curse_of_avernus_lua'
end

-----------------------------------------------------------------------------------------------

modifier_abaddon_curse_of_avernus_lua = class({})

function modifier_abaddon_curse_of_avernus_lua:IsHidden()
	return true
end	

function modifier_abaddon_curse_of_avernus_lua:IsPurgable()
	return false
end	

function modifier_abaddon_curse_of_avernus_lua:IsPermanent()
	return true
end	

function modifier_abaddon_curse_of_avernus_lua:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor('duration')
	self.lifesteal = self:GetAbility():GetSpecialValueFor('lifesteal')
end

function modifier_abaddon_curse_of_avernus_lua:OnRefresh()
	self.duration = self:GetAbility():GetSpecialValueFor('duration')
	self.lifesteal = self:GetAbility():GetSpecialValueFor('lifesteal')
end

function modifier_abaddon_curse_of_avernus_lua:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end	

function modifier_abaddon_curse_of_avernus_lua:OnAttackLanded(data)
    if not IsServer() then return end
    if data.attacker ~= self:GetParent() then return end
	if data.target:HasModifier('modifier_abaddon_curse_of_avernus_lua_debuff') then
		local damageTable = {
			victim = data.target,
			attacker = data.attacker,
			damage = self.lifesteal,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}
		ApplyDamage(damageTable)
		
		data.attacker:Heal(self.lifesteal, self:GetParent())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, data.attacker, self.lifesteal, nil)
	end
	
	if not data.target:HasModifier('modifier_abaddon_curse_of_avernus_lua_debuff') then
		local modifier = data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_abaddon_curse_of_avernus_lua_debuff_slow', {duration = self.duration})
		modifier:SetStackCount(modifier:GetStackCount() + 1)
		modifier:UpdateCounter()
		
		count = self:GetAbility():GetSpecialValueFor('hit_count')
		local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_abaddon_4")
		if ability ~= nil and ability:GetLevel() > 0 then 
			count = count - 1
		end
		if modifier:GetStackCount() >= count then 
			modifier:Destroy()
			data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_abaddon_curse_of_avernus_lua_debuff', {duration = self.duration})
			data.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_abaddon_curse_of_avernus_lua_buff', {duration = self.duration})
			data.target:EmitSound('Hero_Abaddon.Curse.Proc')
		end
	end
end

-----------------------------------------------------------------------------------------------

modifier_abaddon_curse_of_avernus_lua_buff = class({})

function modifier_abaddon_curse_of_avernus_lua_buff:IsHidden()
	return true
end	

function modifier_abaddon_curse_of_avernus_lua_buff:IsPurgable()
	return false
end

function modifier_abaddon_curse_of_avernus_lua_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end	

function modifier_abaddon_curse_of_avernus_lua_buff:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('bonus_as')
end

-----------------------------------------------------------------------------------------------

modifier_abaddon_curse_of_avernus_lua_debuff = class({})

function modifier_abaddon_curse_of_avernus_lua_debuff:IsHidden()
	return true
end	

function modifier_abaddon_curse_of_avernus_lua_debuff:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------------

modifier_abaddon_curse_of_avernus_lua_debuff_slow = class({})

function modifier_abaddon_curse_of_avernus_lua_debuff_slow:IsHidden()
	return true
end	

function modifier_abaddon_curse_of_avernus_lua_debuff_slow:IsPurgable()
	return false
end

function modifier_abaddon_curse_of_avernus_lua_debuff_slow:OnCreated()
    if not IsServer() then return end
    self.nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf', PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.nfx, 1, Vector(0,1,0))
end

function modifier_abaddon_curse_of_avernus_lua_debuff_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end	

function modifier_abaddon_curse_of_avernus_lua_debuff_slow:GetModifierMoveSpeedBonus_Percentage()
    return -self:GetAbility():GetSpecialValueFor('movement_speed')
end

function modifier_abaddon_curse_of_avernus_lua_debuff_slow:OnDestroy()
    if not IsServer() then return end
    ParticleManager:DestroyParticle(self.nfx, true)
    ParticleManager:ReleaseParticleIndex(self.nfx)
end

function modifier_abaddon_curse_of_avernus_lua_debuff_slow:UpdateCounter()
    ParticleManager:SetParticleControl(self.nfx, 1, Vector(0,self:GetStackCount(),0))
end