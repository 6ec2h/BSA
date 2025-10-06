function agi(keys)
	local new_charges = keys.ability:GetCurrentCharges() - 1
	if new_charges <= 0 then
		UTIL_Remove(keys.ability)
		if keys.caster:GetPrimaryAttribute() == 1 then
		keys.caster:SetBaseAgility(keys.caster:GetBaseAgility() + 5)
		else
		local atribute = keys.caster:GetPrimaryAttribute()
			if atribute == 0 then
			keys.caster:SetBaseAgility(keys.caster:GetBaseAgility() + 3)
			end
			if atribute == 2 then
			keys.caster:SetBaseAgility(keys.caster:GetBaseAgility() + 3)
			end
		end	
	end
end

function str(keys)
	local new_charges = keys.ability:GetCurrentCharges() - 1
	if new_charges <= 0 then
		UTIL_Remove(keys.ability)
		if keys.caster:GetPrimaryAttribute() == 0 then
		keys.caster:SetBaseStrength(keys.caster:GetBaseStrength() + 5)
		else
		local atribute = keys.caster:GetPrimaryAttribute()
			if atribute == 1 then
			keys.caster:SetBaseStrength(keys.caster:GetBaseStrength() + 3)
			end
			if atribute == 2 then
			keys.caster:SetBaseStrength(keys.caster:GetBaseStrength() + 3)
			end
		end	
	end
end

function int(keys)
	local new_charges = keys.ability:GetCurrentCharges() - 1
	if new_charges <= 0 then
		UTIL_Remove(keys.ability)
		if keys.caster:GetPrimaryAttribute() == 2 then
		keys.caster:SetBaseIntellect(keys.caster:GetBaseIntellect() + 5)
		else
		local atribute = keys.caster:GetPrimaryAttribute()
			if atribute == 1 then
			keys.caster:SetBaseIntellect(keys.caster:GetBaseIntellect() + 3)
			end
			if atribute == 0 then
			keys.caster:SetBaseIntellect(keys.caster:GetBaseIntellect() + 3)
			end
		end	
	end
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

function randomstat(keys)
	local R5 = RandomInt(1, 3)
	local new_charges = keys.ability:GetCurrentCharges() - 1
	if new_charges <= 0 then
		UTIL_Remove(keys.ability)
		if R5 == 1 then
		keys.caster:SetBaseIntellect(keys.caster:GetBaseIntellect() + 15)
		end
		if R5 == 2 then
		keys.caster:SetBaseStrength(keys.caster:GetBaseStrength() + 15)
		end
		if R5 == 3 then
		keys.caster:SetBaseAgility(keys.caster:GetBaseAgility() + 15)
		end
	end
return
end