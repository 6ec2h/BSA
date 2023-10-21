function WindRunner( keys )
    local caster = keys.caster
    local target = keys.target
	local ability = keys.ability
	local mana_prc = ability:GetLevelSpecialValueFor( "mana_prc" , ability:GetLevel() - 1  ) 
    if caster:HasAbility("windrunner_powershot_lua") and not caster:IsIllusion() then
        if caster:FindAbilityByName("windrunner_powershot_lua")~=nil then
        if caster:FindAbilityByName("windrunner_powershot_lua"):GetLevel() > 0 then
            local trigger_ability = caster:FindAbilityByName("windrunner_powershot_lua")
			local level = trigger_ability:GetLevel()
			local mana = trigger_ability:GetManaCost(level)
			local manacost = mana * mana_prc*0.01
			
            if trigger_ability:IsOwnersManaEnough() then
				caster:GiveMana(manacost)
     
                local position  = target:GetAbsOrigin()
                caster:SetCursorPosition(position)
                trigger_ability:OnSpellStart()
                trigger_ability:SetChanneling(true)
                trigger_ability:EndChannel(true)
                trigger_ability:UseResources(true, false, false, false )
        
                -- if caster:HasAbility("special_bonus_unique_windrunner_attack_triggers") and caster:FindAbilityByName("special_bonus_unique_windrunner_attack_triggers"):GetLevel() > 0 then
                --     local position  = target:GetAbsOrigin() + RandomVector(250)
                --     caster:SetCursorPosition(position)
                --     trigger_ability:OnSpellStart()
                --     trigger_ability:SetChanneling(true)
                --     trigger_ability:EndChannel(true)
                --     trigger_ability:UseResources(false, false, false)
                -- end
            end
        end
		end
    end
end