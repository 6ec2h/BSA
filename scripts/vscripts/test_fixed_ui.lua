-- Тестовый скрипт для проверки исправленного UI
-- Используйте в консоли: lua_run test_fixed_ui()

function test_fixed_ui()
    -- Находим случайного юнита
    local units = Entities:FindAllByClassname("npc_dota_creature")
    if #units == 0 then
        print("No units found for testing")
        return
    end
    
    local testUnit = units[1]
    print("Testing fixed UI on unit:", testUnit:GetEntityIndex())
    
    -- Добавляем модификатор
    testUnit:AddNewModifier(testUnit, nil, "modifier_damage_challenge", {})
    
    print("Fixed UI should now be visible!")
    print("Changes:")
    print("- Timer shows only numbers (no text)")
    print("- Background changes color with status")
    print("- Debug logs in console show state changes")
    print("Status flow:")
    print("1. READY (green) - shows '30'")
    print("2. ATTACKING (red) - shows countdown")
    print("3. RECHARGE (purple) - shows recharge time")
    print("Use 'lua_run test_fixed_remove()' to remove it")
end

function test_fixed_remove()
    -- Находим юнит с модификатором
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in ipairs(units) do
        if unit:HasModifier("modifier_damage_challenge") then
            unit:RemoveModifierByName("modifier_damage_challenge")
            print("Removed fixed UI from unit:", unit:GetEntityIndex())
            return
        end
    end
    print("No unit with fixed UI modifier found")
end

-- Автоматически экспортируем функции
_G.test_fixed_ui = test_fixed_ui
_G.test_fixed_remove = test_fixed_remove
