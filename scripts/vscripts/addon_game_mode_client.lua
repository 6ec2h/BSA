pcall(require, "encrypt")

require("libraries/debounce")

LinkLuaModifier( "modifier_difficult", "abilities/difficult/modifier_difficult", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_guild", "modifiers/modifier_guild", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aegis", "items/item_aegis_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_antilag", "modifiers/modifier_creep_antilag", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_speed", "modifiers/modifier_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kill_aura", "modifiers/modifier_kill_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_check_set", "items/set_items/check_set", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_player_exp", "modifiers/modifier_player_exp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ban", "modifiers/modifier_ban", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_new_player", "modifiers/modifier_new_player", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_teleport_event", "modifiers/modifier_teleport_event", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_guild_event", "modifiers/modifier_guild_event", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wait", "modifiers/modifier_wait", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_guild_event_buff", "modifiers/modifier_guild_event_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_statue", "modifiers/modifier_statue", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custom_blacksmith", "modifiers/modifier_custom_blacksmith", LUA_MODIFIER_MOTION_NONE )

all_skills = {"str","agi","int","hpr","mpr","movespeed","armor","mresist","exp","cooldown","damage","attack_speed","evasion","spellamp"}
for _, skill in pairs(all_skills) do 
	LinkLuaModifier( "modifier_"..skill, "abilities/skill/modifier_"..skill, LUA_MODIFIER_MOTION_NONE )
end

boss_reward_modifiers = {"modifier_agi_10","modifier_armor_5","modifier_as_30","modifier_attack_range_50","modifier_cd_5","modifier_damage_40","modifier_evasion_10","modifier_exp_3","modifier_hp_regen_10",
"modifier_int_10","modifier_mg_resist_5","modifier_mp_regen_10","modifier_ms_30","modifier_spell_10","modifier_str_10"}

for _, skill in pairs(boss_reward_modifiers) do 
	LinkLuaModifier( skill, "modifiers/boss_reward/"..skill, LUA_MODIFIER_MOTION_NONE )
end