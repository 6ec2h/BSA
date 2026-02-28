LinkLuaModifier("modifier_medusa_mana_shield_lua", "heroes/hero_medusa/medusa_mana_shield_lua/medusa_mana_shield_lua", LUA_MODIFIER_MOTION_NONE)

medusa_mana_shield_lua = class({})

function medusa_mana_shield_lua:GetIntrinsicModifierName()
	return "modifier_medusa_mana_shield_lua"
end

--------------------------------------------------------------

modifier_medusa_mana_shield_lua = class({})

function modifier_medusa_mana_shield_lua:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end

function modifier_medusa_mana_shield_lua:IsHidden() return true end
function modifier_medusa_mana_shield_lua:IsPurgable() return false end
function modifier_medusa_mana_shield_lua:RemoveOnDeath() return false end

function modifier_medusa_mana_shield_lua:OnCreated()
	self.damage_per_mana = self:GetAbility():GetSpecialValueFor("damage_per_mana")
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
	self.radius = self:GetCaster():Script_GetAttackRange()
	if not IsServer() then return end
	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
	self:StartIntervalThink(0.1)
end

function modifier_medusa_mana_shield_lua:OnRefresh( kv )
	self.damage_per_mana = self:GetAbility():GetSpecialValueFor("damage_per_mana")
	
	self.radius = self:GetCaster():Script_GetAttackRange()
	if not IsServer() then return end
	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
end

function modifier_medusa_mana_shield_lua:OnIntervalThink()
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName( "medusa_split_shot_lua" )
		if ability~=nil and ability:GetLevel() > 0 then
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
			if #enemies < 2 then
				self:SetStackCount(100)
			else 
				self:SetStackCount(0)
			end
		end
	end
end

function modifier_medusa_mana_shield_lua:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return decFuncs
end


function modifier_medusa_mana_shield_lua:OnDeath(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int11")~=nil then
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int11"):GetLevel() > 0 then 
		local parent = self:GetParent()
			if IsMyKilledBadGuys(parent, params) then
				local mana = parent:GetMaxMana()/10
				parent:GiveMana(mana)
				SendOverheadEventMessage(parent:GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, parent, mana, nil )
			end
		end
	end
end

function modifier_medusa_mana_shield_lua:GetModifierDamageOutgoing_Percentage(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi6")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi6"):GetLevel() > 0 then 
				return self:GetStackCount()
			end
		end
	return 0
end

function modifier_medusa_mana_shield_lua:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	if not (keys.damage_type == DAMAGE_TYPE_MAGICAL and self:GetParent():IsMagicImmune()) and self:GetParent().GetMana then
		self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str9")~=nil then
			if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str9"):GetLevel() > 0 then 
				self.absorption_tooltip = self.absorption_tooltip + 4
			end	
		end
	
		local mana_to_block	= keys.original_damage * self.absorption_tooltip * 0.01 / self.damage_per_mana
		
		if mana_to_block >= self:GetParent():GetMana() then
			self:GetParent():EmitSound("Hero_Medusa.ManaShield.Proc")
			
			local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(shield_particle)
		end			

		local mana_before = self:GetParent():GetMana()
		self:GetParent():Script_ReduceMana(mana_to_block, nil)
		local mana_after = self:GetParent():GetMana()
		
		return math.min(self.absorption_tooltip, self.absorption_tooltip * self:GetParent():GetMana() / math.max(mana_to_block, 1)) * (-1)
	end
end




function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end