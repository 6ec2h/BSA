
innateExceptions = {
	modifier_faceless_void_time_walk_tracker = true,
	modifier_weaver_timelapse = true,
	modifier_ember_spirit_fire_remnant_charge_counter = true,
	modifier_ember_spirit_fire_remnant_thinker = true,
	modifier_ember_spirit_fire_remnant_timer = true,
}

delayForDanger = {
	morphling_waveform = 5.0,
	huskar_life_break = 3.0,
	tusk_snowball = 5.0,
	ember_spirit_fire_remnant = 5.0,
	rattletrap_hookshot = 3.0,
	faceless_void_time_walk = 5.0,
	faceless_void_time_walk_reverse = 5.0,
	batrider_sticky_napalm = 10.0,
	pudge_meat_hook=5.0,
	primal_beast_pulverize =10.0
}

function CDOTABaseAbility:ClearInnateModifiers()
	for _,hModifier in ipairs(self:GetCaster():FindAllModifiers()) do
		if hModifier and not hModifier:IsNull() and hModifier:GetAbility() == self then
			if not innateExceptions[hModifier:GetName()] then
				hModifier:Destroy()
			end
		end
	end
end

-- function CDOTA_Item_Lua:IsMuted()	
	
	-- if string.find(self:GetParent():GetUnitName(), "_pet") then
		-- return true
	-- end
	
	-- if self:GetParent():GetTeamNumber() ~= DOTA_TEAM_GOODGUYS then
		-- return false
	-- end
	
	-- if self:GetPurchaser() ~= self:GetParent() then 
		-- return true
	-- end

	-- return false
-- end

function CDOTABaseAbility:Disable()
	if self:IsChanneling() then
		self:SetChanneling(false)
	end
	if self:GetToggleState() then
		self:ToggleAbility()
	end
	if self:GetAutoCastState() then
		self:ToggleAutoCast()
	end
	self:ClearInnateModifiers() -- remove ability modifiers before set level to prevent crash Dark Pact
	self:SetLevel(0)
	self:ClearInnateModifiers() -- remove intrinsic ability modifiers that applies after set level
	self:SetHidden(true)
	self:OnChannelFinish(true)
end

function CDOTABaseAbility:SetRemovalTimer()
    local flDelay = 0.25
    if self and self:GetAbilityName() then
       if delayForDanger[self:GetAbilityName()] then
          flDelay = delayForDanger[self:GetAbilityName()]   
       end
    end
	self.sRemovalTimer=Timers:CreateTimer(flDelay, function()
		if self and not self:IsNull() then
			if self:NumModifiersUsingAbility() ~= 0 or self:IsChanneling() then 
				return 0.25 
			end
			self:ClearInnateModifiers()
			self:RemoveSelf()
		end
	end)
end

function CDOTABaseAbility:HasBehavior(behavior)
	if not self or self:IsNull() then return end
	local abilityBehavior = tonumber(tostring(self:GetBehaviorInt()))
	return bit.band(abilityBehavior, behavior) == behavior
end


----------------------------------------------------------------

function CDOTA_BaseNPC:IsMonkeyClone()
	return (self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_wukongs_command_warrior"))
end


function CDOTA_BaseNPC:IsMainHero()
	return self and (not self:IsNull()) and self:IsRealHero() and (not self:IsTempestDouble()) and (not self:IsMonkeyClone())
end


function CDOTA_BaseNPC:HasShard()
	if not self or self:IsNull() then return end
	return self:HasModifier("modifier_item_aghanims_shard")
end


function CDOTA_BaseNPC:HasTalent(talent_name)
	if not self or self:IsNull() then return end

	local talent = self:FindAbilityByName(talent_name)
	if talent and talent:GetLevel() > 0 then return true end
end


function CDOTA_BaseNPC:FindTalentValue(talent_name, key)
	if self:HasTalent(talent_name) then
		local value_name = key or "value"
		return self:FindAbilityByName(talent_name):GetSpecialValueFor(value_name)
	end
	return 0
end

function CDOTA_BaseNPC:ExtraIntelligenceDamage()
	if self:IsRealHero() and self:GetIntellect(true) then
		return self:GetIntellect(true)
	end
	return 0
end

function CDOTA_BaseNPC:GetTalentValue(talent_name)
	local talent = self:FindAbilityByName(talent_name)
	if talent and talent:GetLevel() >= 1 then return talent:GetSpecialValueFor("value") end

	return 0
end


function CDOTA_BaseNPC:RemoveAbilityForEmpty(ability_name)
	local ability = self:FindAbilityByName(ability_name)
	if not ability then return end
	local index = ability:GetAbilityIndex()
	ability:Disable()
	if index <= 5 then -- only swap if we get assigned hotkey, otherwise pointless
		self:SwapAbilities(ability_name, "empty_"..index, false, false)
	end
	ability:SetRemovalTimer()
end


function CDOTA_BaseNPC:RemoveAbilityWithRestructure(ability_name)
	local ability = self:FindAbilityByName(ability_name)
	if not ability then return end
	ability:Disable()
	local index = ability:GetAbilityIndex()
	local placeholder_name = "empty_"..index

	self:SwapAbilities(ability_name, placeholder_name, false, false)

	ability:SetRemovalTimer()

	if index > 5 then return end
	Timers:CreateTimer(function()
		for i = index, 25 do
			local next_ability = self:GetAbilityByIndex(i + 1)
			if next_ability and not next_ability.placeholder and not next_ability:IsHidden() then
				local next_ability_name = next_ability:GetAbilityName()
				if not next_ability_name:find("special_bonus") then
					self:SwapAbilities(placeholder_name, next_ability_name, false, true)
				end
			end
		end
	end)
end


function CDOTA_BaseNPC:RemoveSafely()
   self:AddNoDraw()
   self:AddNewModifier(self, nil, "modifier_hero_hidden", {})
   
   self:ForceKill(false)
   
   Timers:CreateTimer(0.5,function()
	   for i=0, 30 do
	      local hAbility = self:GetAbilityByIndex(i)
	      if hAbility and hAbility.GetAbilityName then
	         local sAbilityName = hAbility:GetAbilityName()
	         if (not string.find(sAbilityName, "special_bonus")) and (not string.find(sAbilityName, "empty_")) then
	        	  hAbility:Disable()
	        	  hAbility:SetRemovalTimer()
	         end
	      end
	   end
   end)

   Timers:CreateTimer(1,function()

   	if (not self) or (self:IsNull()) then
   		return nil
   	end
   	local bSafe = true
	   for i=0, 30 do
	      local hAbility = self:GetAbilityByIndex(i)
	      if hAbility and hAbility.GetAbilityName then
	      	local sAbilityName = hAbility:GetAbilityName()
	      	if (not string.find(sAbilityName, "special_bonus")) and (not string.find(sAbilityName, "empty_")) then
	      		--print(sAbilityName.." Not Safe")
	            bSafe = false
	         end
	      end
	   end

	   if bSafe then
	   	  print(self:GetUnitName().."Safe to Remove")
	   	  UTIL_Remove(self)
	   	  return nil
	   else
	   	  return 0.5
	   end
   end)
end


function CDOTA_BaseNPC:FindHotKeyForAbility(sAbilityName)
	Timers:CreateTimer(function()
		for i = 0, 25 do
			local hPlaceholderAability = self:GetAbilityByIndex(i)
			if hPlaceholderAability and hPlaceholderAability:GetAbilityName()	 then
				local sPlaceholderAbilityName = hPlaceholderAability:GetAbilityName()	
				if sPlaceholderAbilityName == sAbilityName then
					break  
			   end
			   if hPlaceholderAability.nPlaceholder then		
				    self:SwapAbilities(sPlaceholderAbilityName, sAbilityName, false, true)
				    break
				end
			end
		end
	end)
end