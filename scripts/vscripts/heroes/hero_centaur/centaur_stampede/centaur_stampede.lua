function Stampede( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "base_damage" , ability:GetLevel() - 1  )
	local casterSTR = caster:GetStrength()
	local strength_damage = ability:GetLevelSpecialValueFor( "strength_damage" , ability:GetLevel() - 1  )
	local damageType = ability:GetAbilityDamageType()
	local total_damage = damage + ( casterSTR * strength_damage )
	local hit = false

	local targetsHit = event.ability.TargetsHit
	for k,v in pairs(targetsHit) do
		if v == target then
			hit = true
		end
	end

	if not hit then
		ApplyDamage({ victim = target, attacker = caster, damage = total_damage, damage_type = damageType })

		ability:ApplyDataDrivenModifier( caster, target, "modifier_stampede_debuff", nil)

		table.insert(event.ability.TargetsHit, target)
	end
end

function StampedeStart( event )
	EmitGlobalSound("Hero_Centaur.Stampede.Cast")

	event.ability.TargetsHit = {}
end