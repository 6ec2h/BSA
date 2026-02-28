function Spawn(entityKeyValues)
    if not IsServer() then
        return
    end

    if not thisEntity then
        return
    end

    thisEntity:SetContextThink("NeutralThink", NeutralThink, 1)
    thisEntity.bSearchedForItems = false
    thisEntity.bSearchedForSpells = false
end

function NeutralThink()
    if not thisEntity:IsAlive() or GameRules:IsGamePaused() or thisEntity:IsChanneling() or thisEntity:IsDisarmed() then
        return 1
    end

    local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	local target = enemies[RandomInt(1, #enemies)]
	
	if target then
		ability = thisEntity:FindItemInInventory('item_black_king_bar_lua2')
		ability.Behavior = "no_target"
		Cast(ability, target)
		
		Timers:CreateTimer(0.1, function()
			ability = thisEntity:FindItemInInventory('item_blink')
			ability.Behavior = "point"
			Cast(ability, target)
		
		end)

		Timers:CreateTimer(0.2, function()
			ability = thisEntity:FindAbilityByName('creep_midnight')
			ability.Behavior = "point"
			Cast(ability, target)
		end)
		
		Timers:CreateTimer(0.3, function()
			ability = thisEntity:FindAbilityByName('enigma_black_hole')
			ability.Behavior = "point"
			Cast(ability, target)
		end)
	end
    return 0.3
end

function Cast(Spell, enemy)
	local order_type
	local vTargetPos = enemy:GetOrigin()

    if Spell.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET
    elseif Spell.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET
    elseif Spell.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION
    elseif Spell.Behavior == "passive" then
        return
    end
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
end