function chek( keys )	
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_fury_swipes_target_datadriven"
	local current_stack = keys.caster:GetModifierStackCount( modifierName, ability )
	if keys.caster:HasModifier( modifierName ) and current_stack > 14 then	
		keys.caster:RemoveModifierByName( modifierName )
	end
end