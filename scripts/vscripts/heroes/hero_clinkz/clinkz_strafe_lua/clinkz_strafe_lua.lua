LinkLuaModifier("modifier_clinkz_strafe_lua", "heroes/hero_clinkz/clinkz_strafe_lua/clinkz_strafe_lua", LUA_MODIFIER_MOTION_NONE)

clinkz_strafe_lua = class({})

function clinkz_strafe_lua:OnSpellStart()
	if IsServer() then        
	local duration = self:GetSpecialValueFor("duration")
	local talent = self:GetCaster():FindAbilityByName("special_bonus_clinkz_tal1")
	if talent ~= nil and talent:GetLevel() > 0 then
		duration = self:GetSpecialValueFor("duration") + 2
	end
		EmitSoundOn("Hero_Clinkz.Strafe", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_clinkz_strafe_lua", {duration = duration})
	end
end

---------------------------------------------------------------------------------------------

modifier_clinkz_strafe_lua = class({})

function modifier_clinkz_strafe_lua:OnCreated()
	self.as = self:GetAbility():GetSpecialValueFor("bonus_as")
	self.range = self:GetAbility():GetSpecialValueFor("range")
end

function modifier_clinkz_strafe_lua:IsHidden() return false end
function modifier_clinkz_strafe_lua:IsPurgable() return true end
function modifier_clinkz_strafe_lua:IsDebuff() return false end

function modifier_clinkz_strafe_lua:GetEffectName()
	return "particles/units/heroes/hero_clinkz/clinkz_strafe_fire.vpcf"
end

function modifier_clinkz_strafe_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_clinkz_strafe_lua:DeclareFunctions()
	local decFuncs = {
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_EVENT_ON_ATTACK
	}
	return decFuncs
end

function modifier_clinkz_strafe_lua:GetModifierAttackSpeedBonus_Constant()
	return self.as
end

function modifier_clinkz_strafe_lua:GetModifierAttackRangeBonus()
	return self.range
end	


function modifier_clinkz_strafe_lua:OnAttack( params )
if IsServer() then
	local talent = self:GetCaster():FindAbilityByName("special_bonus_clinkz_tal3")
	if talent ~= nil and talent:GetLevel() > 0 then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end
		if pass then
					local caster = params.attacker
			local target = params.target
			local ability = self
			local attack_range = caster:Script_GetAttackRange() + 100
			local arrow_count = 1
			
			if ability ~= nil then 

			local units = FindUnitsInRadius(caster:GetTeamNumber(), 
											caster:GetAbsOrigin(),
											nil,
											attack_range,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
											DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											FIND_CLOSEST, 
											false) 
			
			if ability.split == nil then
				ability.split = true
			elseif ability.split == false then
				return
			end
			
			ability.split = false 
			if arrow_count > #units-1  then 
				arrow_count = #units-1
			end

			local index = 1
			local arrow_deal = 0
			
			while arrow_deal < arrow_count   do
				if units[index] == target then
				else
					caster:PerformAttack(units[ index ], true, true, true, false, true, false, false)
					arrow_deal = arrow_deal + 1
				end	
				index = index + 1
			end
			
			ability.split = true	
			end
		end
	end
	end
end


