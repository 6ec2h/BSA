function anti_mr( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	if target.fervor_target then
		--if target.fervor_target == caster then --
			if target:HasModifier(modifier) then
				local stack_count = target:GetModifierStackCount(modifier, ability)
			--	if stack_count < max_stacks then			
					target:SetModifierStackCount(modifier, ability, stack_count + 1)
			--	end
			else
				ability:ApplyDataDrivenModifier(target, target, modifier, {})
				target:SetModifierStackCount(modifier, ability, 1)
			end
		--else
		--	target:RemoveModifierByName(modifier)
	--		target.fervor_target = caster
	--	end
	else
		target.fervor_target = caster
	end
end