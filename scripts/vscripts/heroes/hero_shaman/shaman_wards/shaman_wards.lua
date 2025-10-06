shaman_wards_custom = class({})

function shaman_wards_custom:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function shaman_wards_custom:GetAOERadius()
	return 150
end

function shaman_wards_custom:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	local count = self:GetSpecialValueFor("count")
	local sound_cast = "Hero_ShadowShaman.SerpentWard"
	EmitSoundOn( sound_cast, caster )
	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_shadow_shaman_7")             
	if abil ~= nil and abil:GetLevel() > 0 then 
		count = count + 6
	end

	for i = 1, count do	  
		shadow_ward = CreateUnitByName("shadow_shaman_ward", position + RandomVector( RandomFloat( 50, 50 )), true, caster, nil, caster:GetTeam())
		FindClearSpaceForUnit(shadow_ward, position, false)
		shadow_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
		shadow_ward:SetOwner(caster)
		-- shadow_ward:AddAbility("summon_buff"):SetLevel(1)
		shadow_ward:AddNewModifier(caster, nil, "modifier_kill", {duration = self:GetSpecialValueFor("duration")} )
		shadow_ward:AddNewModifier(caster, nil, "modifier_shadow_ward_hp", {} )
		shadow_ward:AddNewModifier(caster, self, "modifier_summon_buff", {} )
	end
end

LinkLuaModifier("modifier_shadow_ward_hp", "heroes/hero_shaman/shaman_wards/shaman_wards", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------
modifier_shadow_ward_hp = class({})

function modifier_shadow_ward_hp:IsDebuff() return false end
function modifier_shadow_ward_hp:IsHidden() return true end
function modifier_shadow_ward_hp:IsPurgable() return false end

function modifier_shadow_ward_hp:OnCreated()
end

function modifier_shadow_ward_hp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end

function modifier_shadow_ward_hp:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_shadow_ward_hp:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_shadow_ward_hp:GetDisableHealing()
    return 1
end

function modifier_shadow_ward_hp:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() then
			local damage = 1
			if self:GetParent():GetHealth() > damage then
				self:GetParent():SetHealth( self:GetParent():GetHealth() - damage)
			else
				self:GetParent():ForceKill(false)
			end
		end
	end
end

--------------------------------------------------------------------------

LinkLuaModifier("modifier_summon_buff", "heroes/hero_shaman/shaman_wards/shaman_wards", LUA_MODIFIER_MOTION_NONE)

modifier_summon_buff = class({})

function modifier_summon_buff:IsHidden() return true end
function modifier_summon_buff:IsDebuff() return false end
function modifier_summon_buff:IsPurgable() return false end
function modifier_summon_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_summon_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_summon_buff:OnCreated()
	self:SetHasCustomTransmitterData(true)
	if not IsServer() then return end
	self.as_per_agi = self:GetAbility():GetSpecialValueFor("as_per_agi")
	self.dmg_per_int = self:GetAbility():GetSpecialValueFor("dmg_per_int")
	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_shadow_shaman_8")	
	if abil ~= nil and abil:GetLevel() > 0 then 
		self.as_per_agi = self.as_per_agi + 0.5
		self.dmg_per_int = self.dmg_per_int + 0.5
	end
	
	local agi = self:GetCaster():GetAgility() or 0
	local int = self:GetCaster():GetIntellect(true) or 0

	self.bonus_dmg = math.floor(self.dmg_per_int * int)
	self.bonus_as = math.floor(self.as_per_agi * agi)	
	self:SendBuffRefreshToClients()
	
	-- self:StartIntervalThink(0.3)
end

-- function modifier_summon_buff:OnRefresh()
	-- if not IsServer() then return end


-- end

-- function modifier_summon_buff:OnIntervalThink()
	-- self:OnRefresh()
-- end

function modifier_summon_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_summon_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus_dmg
end

function modifier_summon_buff:AddCustomTransmitterData()
	return {
		bonus_as = self.bonus_as,
		bonus_dmg = self.bonus_dmg,
	}
end

function modifier_summon_buff:HandleCustomTransmitterData(data)
	self.bonus_as = tonumber(data.bonus_as)
	self.bonus_dmg = tonumber(data.bonus_dmg)
end
