local triggerActive = true

function Fire(trigger)
	local triggerName = thisEntity:GetName()
	local target = Entities:FindByName( nil, triggerName .. "_target" )
	local spikes = triggerName .. "_model"
	if target ~= nil and triggerActive == true then
		local spikeTrap = thisEntity:FindAbilityByName("spike_trap")
		thisEntity:CastAbilityOnPosition(target:GetOrigin(), spikeTrap, -1 )
		EmitSoundOn( "Conquest.SpikeTrap.Plate" , spikeTrap)
		DoEntFire( spikes, "SetAnimation", "spiketrap_activate", 0, self, self )
		triggerActive = false
		thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModel() end, 4 )
	end
end

function ResetTrapModel()
	triggerActive = true
end

