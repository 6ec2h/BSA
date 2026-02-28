local triggerActive = true

function OnStartTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local level = trigger.activator:GetLevel()

	local button = triggerName .. "_button"
	local model = triggerName .. "_model"
	local npc = Entities:FindByName( nil, triggerName .. "_npc" )
	local target = Entities:FindByName( nil, triggerName .. "_target" )
	local fireTrap = npc:FindAbilityByName("breathe_fire")
	if not triggerActive then

		return
	end
	triggerActive = false
	npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 2 )
	npc:CastAbilityOnPosition(target:GetOrigin(), fireTrap, -1 )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 1, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 1.5, self, self )

	DoEntFire( model, "SetAnimation", "bark_attack", .4, self, self )
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	npc.KillerToCredit = heroHandle
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()

	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
end

function ResetButtonModel()

	triggerActive = true
end

