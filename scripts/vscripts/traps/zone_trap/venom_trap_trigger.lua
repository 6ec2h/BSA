local triggerActive = true
function OnStartTouch(trigger)
	print(trigger.activator)
	local triggerName = thisEntity:GetName()
	local level = trigger.activator:GetLevel()
	if not triggerActive then
		return
	end
	triggerActive = false
	local button = triggerName .. "_button"

	local model = triggerName .. "_model"
	local npc = Entities:FindByName( nil, triggerName .. "_npc" )
	local target = Entities:FindByName( nil, triggerName .. "_target" )
	if npc ~= nil then
		local venomTrap = npc:FindAbilityByName("breathe_poison")
		npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 0.5 )
		npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", .4, self, self )
	end

	local model1 = triggerName .. "_model1"
	local npc1 = Entities:FindByName( nil, triggerName .. "_npc1" )
	local target1 = Entities:FindByName( nil, triggerName .. "_target1" )
	if npc1 ~= nil then
		local venomTrap = npc1:FindAbilityByName("breathe_poison")
		--npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 4 )
		npc1:CastAbilityOnPosition(target1:GetOrigin(), venomTrap, -1 )
		DoEntFire( model1, "SetAnimation", "fang_attack", .4, self, self )
	end

	local model2 = triggerName .. "_model2"
	local npc2 = Entities:FindByName( nil, triggerName .. "_npc2" )
	local target2 = Entities:FindByName( nil, triggerName .. "_target2" )
	if npc2 ~= nil then
		local venomTrap = npc2:FindAbilityByName("breathe_poison")
		--npc2:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 4 )
		npc2:CastAbilityOnPosition(target2:GetOrigin(), venomTrap, -1 )
		DoEntFire( model2, "SetAnimation", "fang_attack", .4, self, self )
	end

	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 0.5, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 0.6, self, self )

	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	npc.KillerToCredit = heroHandle
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
end

function ResetButtonModel()
	triggerActive = true
end