-- Тестовый скрипт для проверки цветовых изменений фона
-- Используйте в консоли: lua_run test_background_colors()

function test_background_colors()
    -- Находим случайного юнита
    local units = Entities:FindAllByClassname("npc_dota_creature")
    if #units == 0 then
        print("No units found for testing")
        return
    end
    
    local testUnit = units[1]
    print("Testing background color changes on unit:", testUnit:GetEntityIndex())
    
    -- Добавляем модификатор
    testUnit:AddNewModifier(testUnit, nil, "modifier_damage_challenge", {})
    
    print("Background color changes should now be visible!")
    print("Color scheme:")
    print("- READY: Green gradient with green border")
    print("- ATTACKING: Red gradient with red border")
    print("- RECHARGE: Purple gradient with purple border")
    print("- DISABLED: Gray gradient with gray border")
    print("- STUNNED: Orange gradient with orange border")
    print("Use 'lua_run test_colors_remove()' to remove it")
end

function test_colors_remove()
    -- Находим юнит с модификатором
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in ipairs(units) do
        if unit:HasModifier("modifier_damage_challenge") then
            unit:RemoveModifierByName("modifier_damage_challenge")
            print("Removed background color test from unit:", unit:GetEntityIndex())
            return
        end
    end
    print("No unit with background color test modifier found")
end

-- Автоматически экспортируем функции
_G.test_background_colors = test_background_colors
_G.test_colors_remove = test_colors_remove
