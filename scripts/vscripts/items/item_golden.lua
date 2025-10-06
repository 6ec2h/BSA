function gold2000(keys)
	local wws = keys.caster
	local spawnPoint = wws:GetAbsOrigin()	
	local new_charges = keys.ability:GetCurrentCharges() - 1
	if new_charges <= 0 then
		UTIL_Remove(keys.ability)
		keys.caster:EmitSound("DOTA_Item.Hand_Of_Midas")
	end
end