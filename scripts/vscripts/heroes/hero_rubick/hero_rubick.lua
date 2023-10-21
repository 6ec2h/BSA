LinkLuaModifier("modifier_hero_rubick", "heroes/hero_rubick/hero_rubick", LUA_MODIFIER_MOTION_NONE)

hero_rubick_ability = class({})

function hero_rubick_ability:GetBehavior()
	local ability = self:GetCaster():FindAbilityByName("special_bonus_unique_rubick_5")
		if ability ~= nil and ability:GetLevel() > 0 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
		end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
end

function hero_rubick_ability:OnSpellStart()
	local hero = self:GetCaster()
	self.ability_level = {}
	local ability_list = {}
	local ability_list_ult = {}
	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and not ability:IsNull() then
			local ability_name = ability:GetAbilityName()
			if not string.find(ability_name, "special_bonus")
			and not string.find(ability_name, "ability_lamp_use")
			and not string.find(ability_name, "ability_pluck_famango")
			and not string.find(ability_name, "twin_gate_portal_warp")
			and not string.find(ability_name, "ability_capture")
			and not string.find(ability_name, "hero_rubick_ability")
			and not string.find(ability_name, "abyssal_underlord_portal_warp") then
				table.insert(self.ability_level, ability:GetLevel())
				hero:RemoveAbility(ability_name)
			end
		end
	end
	
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		if PlayerResource:GetTeam(nPlayerID) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero(nPlayerID) then
				local unit = PlayerResource:GetSelectedHeroEntity(nPlayerID)
				if unit ~= hero then
					for i = 0, 5 do
						local ability = unit:GetAbilityByIndex(i)
						if ability and not ability:IsNull() and not ability:IsHidden() then
							local ability_name = ability:GetAbilityName()
							if not string.find(ability_name, "special_bonus")
							and not string.find(ability_name, "ability_lamp_use")
							and not string.find(ability_name, "ability_pluck_famango")
							and not string.find(ability_name, "twin_gate_portal_warp")
							and not string.find(ability_name, "ability_capture")
							and not string.find(ability_name, "hero_rubick_ability")
							and not string.find(ability_name, "NoAbilityName")
							and not string.find(ability_name, "generic_hidden")
							and not string.find(ability_name, "abyssal_underlord_portal_warp") then
								if ability:GetAbilityType() == 1 then
									table.insert(ability_list_ult, ability_name)
								else
									table.insert(ability_list, ability_name)
								end
							end
						end
					end
				end
			end
		end
	end
	
	for i = 0, 2 do
		local new_ability_name = nil
		while true do
			new_ability_name = table.shuffle(ability_list)[1]
			local existing_ability = hero:FindAbilityByName(new_ability_name)
			if not existing_ability then
				break
			end
		end
		
		if new_ability_name then
			local new_ability = hero:AddAbility(new_ability_name)
			if new_ability then
				local level = self.ability_level[i+1] or 0 
				new_ability:SetLevel(0)
				new_ability:SetLevel(level)
			end
		end
	end
	
	local new_ability_ult = table.shuffle(ability_list_ult)[1]
	local new_ult = hero:AddAbility(new_ability_ult)
	if new_ult then
		local level = self.ability_level[4] or 0 
		new_ult:SetLevel(0)
		new_ult:SetLevel(level)
	end
end

function hero_rubick_ability:GetIntrinsicModifierName()
    return "modifier_hero_rubick"
end

function hero_rubick_ability:IsRefreshable()
    return false
end

---------------------------------------------------------------------------------------

modifier_hero_rubick = class({})

function modifier_hero_rubick:IsHidden()
	return true
end

function modifier_hero_rubick:IsPurgeException()
	return false
end

function modifier_hero_rubick:IsPurgable()
	return false
end

function modifier_hero_rubick:RemoveOnDeath()
	return false
end

function modifier_hero_rubick:OnCreated(kv)
	local hero = self:GetCaster()
	self:clear(hero)
    self:StartIntervalThink(0.1)
end

function modifier_hero_rubick:clear(hero)
	self.ability_level = {}
	if not IsServer() then return end
	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and not ability:IsNull() then
			local ability_name = ability:GetAbilityName()
			if not string.find(ability_name, "special_bonus")
			and not string.find(ability_name, "ability_lamp_use")
			and not string.find(ability_name, "ability_pluck_famango")
			and not string.find(ability_name, "twin_gate_portal_warp")
			and not string.find(ability_name, "ability_capture")
			and not string.find(ability_name, "hero_rubick_ability")
			and not string.find(ability_name, "abyssal_underlord_portal_warp") then
				table.insert(self.ability_level, ability:GetLevel())
				hero:RemoveAbility(ability_name)
			end
		end
	end
end

function modifier_hero_rubick:OnIntervalThink()
    if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("special_bonus_unique_rubick_5")
		if ability == nil or ability:GetLevel() == 0 then
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			local ability_list = {}
			local ability_list_ult = {}
			if caster:IsRealHero() and caster:IsAlive() and ability:IsCooldownReady() then
				self:clear(caster)
				for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
					if PlayerResource:GetTeam(nPlayerID) == DOTA_TEAM_GOODGUYS then
						if PlayerResource:HasSelectedHero(nPlayerID) then
							local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
							if hero ~= caster then
								for i = 0, 5 do
									local ability = hero:GetAbilityByIndex(i)
									if ability and not ability:IsNull() and not ability:IsHidden() then
										local ability_name = ability:GetAbilityName()
										if not string.find(ability_name, "special_bonus")
										and not string.find(ability_name, "ability_lamp_use")
										and not string.find(ability_name, "ability_pluck_famango")
										and not string.find(ability_name, "twin_gate_portal_warp")
										and not string.find(ability_name, "ability_capture")
										and not string.find(ability_name, "hero_rubick_ability")
										and not string.find(ability_name, "NoAbilityName")
										and not string.find(ability_name, "generic_hidden")
										and not string.find(ability_name, "abyssal_underlord_portal_warp") then
											if ability:GetAbilityType() == 1 then
												table.insert(ability_list_ult, ability_name)
											else
												table.insert(ability_list, ability_name)
											end
										end
									end
								end
							end
						end
					end
				end
				for i = 0, 2 do
					local new_ability_name = nil
					while true do
						new_ability_name = table.shuffle(ability_list)[1]
						local existing_ability = caster:FindAbilityByName(new_ability_name)
						if not existing_ability then
							break
						end
					end
					
					if new_ability_name then
						local new_ability = caster:AddAbility(new_ability_name)
						if new_ability then
							local level = self.ability_level[i+1] or 0 
							new_ability:SetLevel(level)
						end
					end
				end
				
				local new_ability_ult = table.shuffle(ability_list_ult)[1]
				local new_ult = caster:AddAbility(new_ability_ult)
				if new_ult then
					local level = self.ability_level[4] or 0 
					new_ult:SetLevel(level)
				end
				ability:UseResources(false, false, false, true)
			end
		end
    else
		self:StartIntervalThink(-1)
	end
end