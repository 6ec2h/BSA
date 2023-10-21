function str_atribute(keys)
	keys.caster:RemoveItem(keys.ability)
	keys.caster:SetPrimaryAttribute(0)
end

function agi_atribute(keys)
	keys.caster:RemoveItem(keys.ability)
	keys.caster:SetPrimaryAttribute(1)
end

function int_atribute(keys)
	keys.caster:RemoveItem(keys.ability)
	keys.caster:SetPrimaryAttribute(2)
end
