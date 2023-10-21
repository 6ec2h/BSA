require("data")

function add_ability(event)
local caster = event.caster
local item = event.ability 
local playerID = caster:GetPlayerID()
	if caster:HasAbility("ability_slot_1") then
	
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)			--чекаем какой спел во 3 слоте
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()		--имя спела во 3 слоте
		
		local ability_name = "ability_slot_1"
		local ability_name2 = abiility_all[RandomInt(1,#abiility_all)]
		if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 then EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID)) return 0.1 
		end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:AddAbility(ability_name2)
		caster:SwapAbilities(ability_name, ability_name2, false, true)									
		caster:RemoveAbility(ability_name)
		UTIL_Remove(item)
		return
	end
	
	if caster:HasAbility("ability_slot_2") then
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()	
		
		local ability_name = "ability_slot_2"
		local ability_name2 = abiility_all[RandomInt(1,#abiility_all)]
		if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 then EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID)) return 0.1 
		end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:AddAbility(ability_name2)
		caster:SwapAbilities(ability_name, ability_name2, false, true)									
		caster:RemoveAbility(ability_name)
		UTIL_Remove(item)
		return
	end
	
	if caster:HasAbility("ability_slot_3") then
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()
		
		local ability_name = "ability_slot_3"
		local ability_name2 = abiility_all[RandomInt(1,#abiility_all)]
		if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 then EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID)) return 0.1 
		end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:AddAbility(ability_name2)
		caster:SwapAbilities(ability_name, ability_name2, false, true)									
		caster:RemoveAbility(ability_name)
		UTIL_Remove(item)
		return
		end
end


function remove_ability1(event)
local caster = event.caster
local item = event.ability
local playerID = caster:GetPlayerID()
for _, T in ipairs(abiility_all) do
	local Spell = caster:FindAbilityByName(T)  							-- ищем у героя спел
		if Spell then													--если есть спел	
		local ability_name = Spell:GetName()							--узнаем имя
		local level = Spell:GetLevel()									--урвень спела
		
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)			--чекаем какой спел во 3 слоте
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()		--имя спела во 3 слоте
		
		if ability_in_slot_name1 == ability_name then					--если спел совпали
		
		local ability_name2 = abiility_all[RandomInt(1,#abiility_all)]
		
			if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 then
			EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
			UTIL_Remove(item)
			return 0.1 
			end
			
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:RemoveAbility(ability_name)
		caster:AddAbility(ability_name2):SetLevel(level)								
		UTIL_Remove(item)
		return
	end
	end
end
end

function remove_ability2(event)
local caster = event.caster
local item = event.ability
local playerID = caster:GetPlayerID()
for _, T in ipairs(abiility_all) do
	local Spell = caster:FindAbilityByName(T)  							-- ищем у героя спел
		if Spell then													--если есть спел	
		local ability_name = Spell:GetName()							--узнаем имя
		local level = Spell:GetLevel()									--урвень спела
		
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)			--чекаем какой спел во 3 слоте
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()		--имя спела во 3 слоте
		
		if ability_in_slot_name2 == ability_name then					--если спел совпали
		
		local ability_name2 = abiility_all[RandomInt(1,#abiility_all)]
		
			if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 then
			EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
			UTIL_Remove(item)
			return 0.1 
			end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:RemoveAbility(ability_name)
		caster:AddAbility(ability_name2):SetLevel(level)								
		UTIL_Remove(item)
		return
	end
	end
end
end

function remove_ability3(event)
local caster = event.caster
local item = event.ability
local playerID = caster:GetPlayerID()
for _, T in ipairs(abiility_all) do
	local Spell = caster:FindAbilityByName(T)  							-- ищем у героя спел
		if Spell then													--если есть спел	
		local ability_name = Spell:GetName()							--узнаем имя
		local level = Spell:GetLevel()									--урвень спела
		
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)			--чекаем какой спел во 3 слоте
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()		--имя спела во 3 слоте
		
		if ability_in_slot_name3 == ability_name then					--если спел совпали
		
		local ability_name2 = abiility_all[RandomInt(1,#abiility_all)]
		
			if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 then
			EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
			UTIL_Remove(item)
			return 0.1 
			end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:RemoveAbility(ability_name)
		caster:AddAbility(ability_name2):SetLevel(level)								
		UTIL_Remove(item)
		return
	end
	end
end
end


-----------------------------------------------------------------------------------------------------------------------------------------------.
function add_ability_bonus(event)
local caster = event.caster
local item = event.ability 
local playerID = caster:GetPlayerID()
	if caster:HasAbility("ability_slot_4") then
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)			--чекаем какой спел во 3 слоте
		local ability_in_slot5 = caster:GetAbilityByIndex(5)			--чекаем какой спел во 3 слоте
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name5 = ability_in_slot5:GetName()		--имя спела во 3 слоте
		
		local ability_name = "ability_slot_4"
		local ability_name2 = ability_bonus[RandomInt(1,#ability_bonus)]
		if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 or ability_in_slot_name5 == ability_name2 then EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID)) return 0.1 
		end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:AddAbility(ability_name2):SetLevel(4)
		caster:SwapAbilities(ability_name, ability_name2, false, true)									
		caster:RemoveAbility(ability_name)
		UTIL_Remove(item)
		return
		end
end

function remove_ability_bonus(event)
local caster = event.caster
local item = event.ability
local playerID = caster:GetPlayerID()
for _, T in ipairs(ability_bonus) do
	local Spell = caster:FindAbilityByName(T)  							-- ищем у героя спел
		if Spell then													--если есть спел	
		local ability_name = Spell:GetName()							--узнаем имя
		local level = Spell:GetLevel()									--урвень спела
		
		local ability_in_slot1 = caster:GetAbilityByIndex(0)			--чекаем какой спел во 1 слоте
		local ability_in_slot2 = caster:GetAbilityByIndex(1)			--чекаем какой спел во 2 слоте
		local ability_in_slot3 = caster:GetAbilityByIndex(2)			--чекаем какой спел во 3 слоте
		local ability_in_slot4 = caster:GetAbilityByIndex(3)			--чекаем какой спел во 3 слоте
		local ability_in_slot5 = caster:GetAbilityByIndex(5)			--чекаем какой спел во 3 слоте
		
		local ability_in_slot_name1 = ability_in_slot1:GetName()		--имя спела во 1 слоте
		local ability_in_slot_name2 = ability_in_slot2:GetName()		--имя спела во 2 слоте
		local ability_in_slot_name3 = ability_in_slot3:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name4 = ability_in_slot4:GetName()		--имя спела во 3 слоте
		local ability_in_slot_name5 = ability_in_slot5:GetName()		--имя спела во 3 слоте
		
		if ability_in_slot_name4 == ability_name then					--если спел совпали
		
		local ability_name2 = ability_bonus[RandomInt(1,#ability_bonus)]
		
			if ability_in_slot_name1 == ability_name2 or ability_in_slot_name2 == ability_name2 or ability_in_slot_name3 == ability_name2 or ability_in_slot_name4 == ability_name2 or ability_in_slot_name5 == ability_name2 then
			EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
			UTIL_Remove(item)
			return 0.1 
			end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:RemoveAbility(ability_name)
		caster:AddAbility(ability_name2):SetLevel(level)								
		UTIL_Remove(item)
		return
	end
	end
end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
function add_ultimate(event)
local caster = event.caster
local item = event.ability 
local playerID = caster:GetPlayerID()
	if caster:HasAbility("ability_slot_5") then
	EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
	local ability_name = "ability_slot_5"
	local ability_name2 = abiility_ultimate[RandomInt(1,#abiility_ultimate)]
		caster:AddAbility(ability_name2)
		caster:SwapAbilities(ability_name, ability_name2, false, true)									
		caster:RemoveAbility(ability_name)
		UTIL_Remove(item)
		return
	end
end

function remove_ultimate(event)
local caster = event.caster
local item = event.ability
local playerID = caster:GetPlayerID()
for _, T in ipairs(abiility_ultimate) do
	local Spell = caster:FindAbilityByName(T)  							-- ищем у героя спел
		if Spell then													--если есть спел	
		local ability_name = Spell:GetName()							--узнаем имя
		local level = Spell:GetLevel()									--урвень спела
		local ability_in_slot_ult = caster:GetAbilityByIndex(5)			--чекаем какой спел во 1 слоте
		local ability_in_slot_name5 = ability_in_slot_ult:GetName()		--имя спела во 1 слоте

		
		if ability_in_slot_name5 == ability_name then					--если спел совпали
		
		local ability_name2 = abiility_ultimate[RandomInt(1,#abiility_ultimate)]
		
			if ability_in_slot_name5 == ability_name2 then
			EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
			UTIL_Remove(item)
			return 0.1 
			end
		
		EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
		caster:RemoveAbility(ability_name)
		caster:AddAbility(ability_name2):SetLevel(level)								
		UTIL_Remove(item)
		return
	end
	end
end
end