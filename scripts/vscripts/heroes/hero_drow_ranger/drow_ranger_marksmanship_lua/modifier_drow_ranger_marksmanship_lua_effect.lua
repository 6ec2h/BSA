modifier_drow_ranger_marksmanship_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drow_ranger_marksmanship_lua_effect:IsHidden()
	return false
end

function modifier_drow_ranger_marksmanship_lua_effect:IsDebuff()
	return false
end

function modifier_drow_ranger_marksmanship_lua_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_drow_ranger_marksmanship_lua_effect:OnCreated( kv )
	self.agility = self:GetAbility():GetSpecialValueFor( "agility_multiplier" )
	self.str = self:GetAbility():GetSpecialValueFor( "agility_multiplier" )
	self:StartIntervalThink(1)
	if not IsServer() then return end
end

function modifier_drow_ranger_marksmanship_lua_effect:OnRefresh( kv )
if not IsServer() then return end
	self.agility = self:GetAbility():GetSpecialValueFor( "agility_multiplier" )
	self.str = self:GetAbility():GetSpecialValueFor( "agility_multiplier" )
	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_agi8")~=nil then
			if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_agi8"):GetLevel() > 0 then
				self.agility = self.agility + 10
			end
		end
end


function modifier_drow_ranger_marksmanship_lua_effect:OnIntervalThink()
self:OnRefresh()
end

function modifier_drow_ranger_marksmanship_lua_effect:OnRemoved()
end

function modifier_drow_ranger_marksmanship_lua_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_drow_ranger_marksmanship_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_drow_ranger_marksmanship_lua_effect:GetModifierBonusStats_Agility()
	if not IsServer() then return end


	if self:GetCaster()==self:GetParent() then
		-- use lock mechanism to prevent infinite recursive
		if self.lock1 then return end

	
		-- calculate bonus
		self.lock1 = true
		local agi = self:GetCaster():GetAgility()
		self.lock1 = false

		local bonus = self.agility*agi/100

		return bonus
	else
		-- this agi includes bonus from this ability, which should be excluded
		local agi = self:GetCaster():GetAgility()
		agi = 100/(100+self.agility)*agi

		local bonus = self.agility*agi/100

		return bonus
	end
end