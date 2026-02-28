if boss_reward == nil then
    _G.boss_reward = class({})
end

boss_reward_modifiers = {"modifier_agi_10","modifier_armor_5","modifier_as_30","modifier_attack_range_50","modifier_cd_5","modifier_damage_40","modifier_evasion_10","modifier_exp_3","modifier_hp_regen_10",
"modifier_int_10","modifier_mg_resist_5","modifier_mp_regen_10","modifier_ms_30","modifier_spell_10","modifier_str_10"}

function boss_reward:init()
	CustomGameEventManager:RegisterListener("select_skill_lua", Dynamic_Wrap( self, 'select_skill_lua'))
	CustomGameEventManager:RegisterListener("replace_skill_lua", Dynamic_Wrap( self, 'replace_skill_lua'))
end

function boss_reward:skillsPreparation(t)
    local result  = {}
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    while #result < 3 do
        local skill = boss_reward_modifiers[RandomInt(1,#boss_reward_modifiers)]
        for i = 1, #result do
		    if result[i] == skill then
                break
            end
            if i == #result then
                table.insert(result, skill)
            end
        end
        if #result == 0 then
            table.insert(result, skill)
        end
    end
    return result
end

function boss_reward:getPlayerSkills(t)
    local result  = {}
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    for _,plArr in pairs(HeroList.arr) do
        for _,plAbi in pairs(plArr.skill_list) do
            for _,abiName in pairs(plAbi) do
                if hero:FindAbilityByName(abiName) then
                    table.insert(result, plAbi)
                    break
                end
            end
        end
    end
    return result
end

function boss_reward:show(t)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "show_skills_js",  self:skillsPreparation(t))
end

function boss_reward:replace(t)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "replace_skills_js",  self:getPlayerSkills(t))
end

function boss_reward:select_skill_lua(t)
    boss_reward:addSkill(t)
end

function boss_reward:addSkill(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    for _, ability_name in pairs(t) do
		if string.sub(ability_name, 0,8) == "modifier" then
			LinkLuaModifier( ability_name, "modifiers/boss_reward/"..ability_name, LUA_MODIFIER_MOTION_NONE )
			hero:AddNewModifier(hero, nil, ability_name, {})
			EmitSoundOn( "hud.equip.agh_shard", hero )
		end	
    end
end

function boss_reward:removeSkill(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    for _, ability_name in pairs(HeroList:searchBySkillName(t.skill_name).ability_value) do
        hero:RemoveAbility(ability_name)
    end
end

function boss_reward:replace_skill_lua(t)
    boss_reward:removeSkill(t)
    boss_reward:show(t)
end

boss_reward:init()