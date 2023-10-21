LinkLuaModifier("modifier_custom_blacksmith_aura", "modifiers/modifier_custom_blacksmith.lua", LUA_MODIFIER_MOTION_NONE)

modifier_custom_blacksmith = class({})

function modifier_custom_blacksmith:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_MIN_HEALTH,
    }
    return funcs
end

function modifier_custom_blacksmith:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}

	return state
end

function modifier_custom_blacksmith:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_custom_blacksmith:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_custom_blacksmith:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_custom_blacksmith:GetMinHealth()
	return 1
end

function modifier_custom_blacksmith:IsHidden()
	return true
end

function modifier_custom_blacksmith:IsAura()
  return true
end

function modifier_custom_blacksmith:GetModifierAura()
  return "modifier_custom_blacksmith_aura"
end

function modifier_custom_blacksmith:GetAuraRadius()
  return 300
end

function modifier_custom_blacksmith:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO
end

function modifier_custom_blacksmith:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_custom_blacksmith:GetAuraDuration()
  return 0.2
end

----------------------------------------------------------------------------------

modifier_custom_blacksmith_aura = class({})

function modifier_custom_blacksmith_aura:IsHidden()
	return true
end

function modifier_custom_blacksmith_aura:OnCreated()
	if IsServer() then
   		self.pid = self:GetParent():GetPlayerOwnerID()
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.pid),"Upgrade_activate", SearchForItems(self:GetParent()))
	end
end

function modifier_custom_blacksmith_aura:OnDestroy()
	if IsServer() then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.pid),"Upgrade_deactivate", {} )
	end
end

function SearchForItems(hero)
	hero_items = {}
	hero_items['set'] = {}
	hero_items['kamen'] = {}
	for i = 0, 5 do
		local item = hero:GetItemInSlot(i)
		if item then
			if string.find(item:GetAbilityName(), "_set_") then --or item:GetAbilityName() == 'item_kamen_boga' then
				hero_items['set'][item:GetAbilityName()] = item:GetLevel()
			end
			if item:GetAbilityName() == 'item_kamen_boga' then
				hero_items['kamen'][item:GetAbilityName()] = item:GetCurrentCharges()
			end
		end
	end
	return hero_items
end