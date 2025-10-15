if Shop == nil then
    _G.Shop = class({})
end

_G.game_shop = {
	[1] = {
        name = 'treasures',
        [1] = {price = {don = 10}, itemname = "item_treasure_1", color = "ancient", type='treasures'},--40
        [2] = {price = {don = 20}, itemname = "item_treasure_2", color = "ancient", type='treasures'},--60
        [3] = {price = {don = 30}, itemname = "item_treasure_3", color = "ancient", type='treasures'},--80
        [4] = {price = {don = 40}, itemname = "item_treasure_4", color = "ancient", type='treasures'},--100
        [5] = {price = {don = 40}, itemname = "item_treasure_5", color = "ancient", type='treasures'},--100
        -- [6] = {price = {don = 50}, itemname = "item_treasure_6", color = "ancient", type='treasures'},
    },
    [2] = {
        name = 'tab_1',
        [1] = {price = {don = 3,rp = 30}, itemname = "item_armor_aura", type='consumable'},
        [2] = {price = {don = 3,rp = 30}, itemname = "item_base_damage_aura", type='consumable'},
        [3] = {price = {don = 3,rp = 30}, itemname = "item_expiriance_aura", type='consumable'},
        [4] = {price = {don = 3,rp = 30}, itemname = "item_move_aura", type='consumable'},
        [5] = {price = {don = 3,rp = 30}, itemname = "item_attack_speed_aura", type='consumable'},
        [6] = {price = {don = 3,rp = 30}, itemname = "item_hp_aura", type='consumable'},
        [7] = {price = {don = 3,rp = 30}, itemname = "item_cd_aura", type='consumable'},
        [8] = {price = {don = 3,rp = 30}, itemname = "item_lifesteal_aura", type='consumable'},
        [9] = {price = {don = 3,rp = 30}, itemname = "item_spell_aura", type='consumable'},
        [10] = {price = {don = 3,rp = 30}, itemname = "item_gold_aura", type='consumable'},
		
        [11] = {price = {don = 15,rp = 150}, itemname = "item_bkb_flask", type='consumable'},
        -- [12] = {price = {don = 2,rp = 20}, itemname = "item_bones", type='consumable'},
        -- [13] = {price = {don = 10,rp = 100}, itemname = "item_golden_skull", type='consumable'},
        -- [14] = {price = {don = 25,rp = 250}, itemname = "item_kamen_boga", type='consumable'},
        [12] = {price = {don = 50,rp = 500}, itemname = "item_krest", type='consumable'},
        [13] = {price = {don = 25,rp = 250}, itemname = "item_str_atribute", type='consumable'},
        [14] = {price = {don = 25,rp = 250}, itemname = "item_agi_atribute", type='consumable'},
        [15] = {price = {don = 25,rp = 250}, itemname = "item_int_atribute", type='consumable'},
        [16] = {price = {don = 50,rp = 500}, itemname = "item_chest_d", type='consumable'},
        [17] = {price = {don = 3,rp = 30}, itemname = "item_ticket2", type='consumable'},
    },
	[3] = {
        name = 'tab_2',
        [1] = {price = {don = 8,rp = 400}, itemname = "item_mp_bag", type='item', can_upgrade=false},
		[2] = {price = {don = 8,rp = 400}, itemname = "item_health_bag", type='item', can_upgrade=false},
		[3] = {price = {don = 20,rp = 1000}, itemname = "item_book_of_knowledge", type='item', can_upgrade=false},
		[4] = {price = {don = 200,rp = 10000}, itemname = "item_dado_stone", type='item', can_upgrade=false, cant_take = true},
		[5] = {price = {don = 200,rp = 10000}, itemname = "item_triss_stone", type='item', can_upgrade=false, cant_take = true},
		[6] = {price = {don = 200,rp = 10000}, itemname = "item_destroyer_stone", type='item', can_upgrade=false, cant_take = true},
		[7] = {price = {don = 200,rp = 10000}, itemname = "item_fiddlesticks_stone", type='item', can_upgrade=false, cant_take = true},
    },
	[4] = {
        name = 'tab_3',
        [1] = {price = {don = 8,rp = 400}, itemname = "item_mana_plate", type='item', can_upgrade=true},
        [2] = {price = {don = 10,rp = 500}, itemname = "item_heavy_shield", type='item', can_upgrade=true},
        [3] = {price = {don = 12,rp = 600}, itemname = "item_heavy_plate", type='item', can_upgrade=true},
        [4] = {price = {don = 14,rp = 700}, itemname = "item_life_catcher", type='item', can_upgrade=true},
        [5] = {price = {don = 16,rp = 800}, itemname = "item_immune_mask", type='item', can_upgrade=true},
        [6] = {price = {don = 18,rp = 900}, itemname = "item_grave_shoulder", type='item', can_upgrade=true},
        [7] = {price = {don = 20,rp = 1000}, itemname = "item_armor_of_god", type='item', can_upgrade=true},
		
        [8] = {price = {don = 8,rp = 400}, itemname = "item_bloody_knife", type='item', can_upgrade=true},
        [9] = {price = {don = 10,rp = 500}, itemname = "item_winter_cloak", type='item', can_upgrade=true},
        [10] = {price = {don = 12,rp = 600}, itemname = "item_hell_blade", type='item', can_upgrade=true},
        [11] = {price = {don = 14,rp = 700}, itemname = "item_talisman_of_evasion_lua", type='item', can_upgrade=true},
        [12] = {price = {don = 16,rp = 800}, itemname = "item_blasting_shot", type='item', can_upgrade=true},
        [13] = {price = {don = 18,rp = 900}, itemname = "item_doom_sword", type='item', can_upgrade=true},
        [14] = {price = {don = 20,rp = 1000}, itemname = "item_doom_spear", type='item', can_upgrade=true},
		
		[15] = {price = {don = 8,rp = 400}, itemname = "item_gu", type='item', can_upgrade=true},
        [16] = {price = {don = 10,rp = 500}, itemname = "item_magic_boots", type='item', can_upgrade=true},
        [17] = {price = {don = 12,rp = 600}, itemname = "item_magic_amulet", type='item', can_upgrade=true},
        [18] = {price = {don = 14,rp = 700}, itemname = "item_magic_soul", type='item', can_upgrade=true},
        [19] = {price = {don = 16,rp = 800}, itemname = "item_critical_ring", type='item', can_upgrade=true},
        [20] = {price = {don = 18,rp = 900}, itemname = "item_dark_mist", type='item', can_upgrade=true},
        [21] = {price = {don = 20,rp = 1000}, itemname = "item_god_tribute", type='item', can_upgrade=true},
		
		[22] = {price = {don = 8,rp = 400}, itemname = "item_block_shield", type='item', can_upgrade=true},
		[23] = {price = {don = 10,rp = 500}, itemname = "item_power_pendant", type='item', can_upgrade=true},
        [24] = {price = {don = 12,rp = 600}, itemname = "item_dark_stick", type='item', can_upgrade=true},
        [25] = {price = {don = 14,rp = 700}, itemname = "item_physical_immune", type='item', can_upgrade=true},
        [26] = {price = {don = 16,rp = 800}, itemname = "item_crit_blade", type='item', can_upgrade=true},
        [27] = {price = {don = 18,rp = 900}, itemname = "item_des_blade", type='item', can_upgrade=true},
        [28] = {price = {don = 20,rp = 1000}, itemname = "item_universal_lua", type='item', can_upgrade=true},
    },
	[5] = {
 		name = "effects",
 		[1] = {itemname = "effect_7", particle="particles/econ/events/ti10/aghanim_aura_ti10/agh_aura_ti10.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_7.png", type = "effect"},
 		[2] = {itemname = "effect_8", particle="particles/effects/8_1.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_8.png", type = "effect"},
 		[3] = {itemname = "effect_23", particle="particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_23.png", type = "effect"},
 		[4] = {itemname = "effect_24", particle="particles/effects/24_1.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_24.png", type = "effect"},
 		[5] = {itemname = "effect_22", particle="particles/econ/items/skywrath_mage/manticore/wings_of_the_manticore_golden_ambientfx.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_22.png", type = "effect"},
 		[6] = {itemname = "effect_9", particle="particles/econ/events/ti10/fountain_regen_ti10_lvl3.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_9.png", type = "effect"},
 		[7] = {itemname = "effect_10", particle="particles/econ/events/ti10/mjollnir_shield_ti10.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_10.png", type = "effect"},
 		[8] = {itemname = "effect_13", particle="particles/econ/events/ti9/bottle_ti9.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_13.png", type = "effect"},
 		[9] = {itemname = "effect_14", particle="particles/econ/events/ti9/mjollnir_shield_ti9.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_14.png", type = "effect"},
 		[10] = {itemname = "effect_15", particle="particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl3.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_15.png", type = "effect"},
 		[11] = {itemname = "effect_6", particle="particles/frostivus_versus.vpcf", price = {don = 5, rp = 50}, image = "images/effect/effect_6.png", type = "effect"},
 		[12] = {itemname = "effect_11", particle="particles/effects/11.vpcf", price = {don = 10, rp = 100}, image = "images/effect/effect_11.png", type = "effect"},
 		[13] = {itemname = "effect_18", particle="particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_wings_ambient.vpcf", price = {don = 10, rp = 100}, image = "images/effect/effect_18.png", type = "effect"},
 		[14] = {itemname = "effect_19", particle="particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_wings_v2_ambient.vpcf", price = {don = 10, rp = 100}, image = "images/effect/effect_19.png", type = "effect"},
 		[15] = {itemname = "effect_21", particle="particles/econ/items/skywrath_mage/skywrath_ti9_immortal_back/skywrath_mage_ti9_golden_ambient_wings.vpcf", price = {don = 10, rp = 100}, image = "images/effect/effect_21.png", type = "effect"},
 		[16] = {itemname = "effect_1", particle="particles/econ/events/ti9/ti9_emblem_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_1.png", type = "effect"},
 		[17] = {itemname = "effect_12", particle="particles/econ/events/ti8/ti8_hero_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_12.png", type = "effect"},
 		[18] = {itemname = "effect_16", particle="particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_16.png", type = "effect"},
 		[19] = {itemname = "effect_25", particle="particles/econ/events/summer_2021/summer_2021_emblem_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_25.png", type = "effect"},
 		[20] = {itemname = "effect_17", particle="particles/econ/events/ti7/ti7_hero_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_17.png", type = "effect"},
 		[21] = {itemname = "effect_2", particle="particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_2.png", type = "effect"},
		[22] = {itemname = "effect_3", particle="particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_3.png", type = "effect"},
 		[23] = {itemname = "effect_4", particle="particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_4.png", type = "effect"},
		[24] = {itemname = "effect_5", particle="particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf", price = {don = 20, rp = 200}, image = "images/effect/effect_5.png", type = "effect"},
 	},
	[6] = {
        name = 'sprays',
 		[1] = {itemname = "spray_1", price = {don = 10, rp = 100}, particle = "particles/sprays/gg.vpcf", image = "images/spray/spray_1.png", type='spray'},
		[2] = {itemname = "spray_2", price = {don = 10, rp = 100}, particle = "particles/sprays/glomur.vpcf", image = "images/spray/spray_2.png", type='spray'},
		[3] = {itemname = "spray_3", price = {don = 10, rp = 100}, particle = "particles/sprays/guy2.vpcf", image = "images/spray/spray_3.png", type='spray'},
		[4] = {itemname = "spray_4", price = {don = 10, rp = 100}, particle = "particles/sprays/guy3.vpcf", image = "images/spray/spray_4.png", type='spray'},
		[5] = {itemname = "spray_5", price = {don = 10, rp = 100}, particle = "particles/sprays/tree.vpcf", image = "images/spray/spray_5.png", type='spray'},
		[6] = {itemname = "spray_6", price = {don = 10, rp = 100}, particle = "particles/sprays/smashed.vpcf", image = "images/spray/spray_6.png", type='spray'},
		[7] = {itemname = "spray_7", price = {don = 10, rp = 100}, particle = "particles/sprays/tickle.vpcf", image = "images/spray/spray_7.png", type='spray',},
		[8] = {itemname = "spray_8", price = {don = 10, rp = 100}, particle = "particles/sprays/9000.vpcf", image = "images/spray/spray_8.png", type='spray',},
		[9] = {itemname = "spray_9", price = {don = 10, rp = 100}, particle = "particles/sprays/axe.vpcf", image = "images/spray/spray_9.png", type='spray',},
		[10] = {itemname = "spray_10", price = {don = 10, rp = 100}, particle = "particles/sprays/ball.vpcf", image = "images/spray/spray_10.png", type='spray',},
		[11] = {itemname = "spray_11", price = {don = 10, rp = 100}, particle = "particles/sprays/bear.vpcf", image = "images/spray/spray_11.png", type='spray',},
		[12] = {itemname = "spray_12", price = {don = 10, rp = 100}, particle = "particles/sprays/guy1.vpcf", image = "images/spray/spray_12.png", type='spray',},		
		[13] = {itemname = "spray_13", price = {don = 10, rp = 100}, particle = "particles/sprays/hex.vpcf", image = "images/spray/spray_13.png", type='spray',},		
		[14] = {itemname = "spray_14", price = {don = 10, rp = 100}, particle = "particles/sprays/jug.vpcf", image = "images/spray/spray_14.png", type='spray',},		
		[15] = {itemname = "spray_15", price = {don = 10, rp = 100}, particle = "particles/sprays/lina.vpcf", image = "images/spray/spray_15.png", type='spray',},		
		[16] = {itemname = "spray_16", price = {don = 10, rp = 100}, particle = "particles/sprays/lion.vpcf", image = "images/spray/spray_16.png", type='spray',},		
		[17] = {itemname = "spray_17", price = {don = 10, rp = 100}, particle = "particles/sprays/pudge2.vpcf", image = "images/spray/spray_17.png", type='spray',},		
		[18] = {itemname = "spray_18", price = {don = 10, rp = 100}, particle = "particles/sprays/pudge.vpcf", image = "images/spray/spray_18.png", type='spray',},
		[19] = {itemname = "spray_19", price = {don = 10, rp = 100}, particle = "particles/sprays/ursa.vpcf", image = "images/spray/spray_19.png", type='spray',},
		[20] = {itemname = "spray_20", price = {don = 10, rp = 100}, particle = "particles/sprays/winner.vpcf", image = "images/spray/spray_20.png", type='spray',},
		[21] = {itemname = "spray_21", price = {don = 10, rp = 100}, particle = "particles/sprays/zuus.vpcf", image = "images/spray/spray_21.png", type='spray',},		
		[22] = {itemname = "spray_22", price = {don = 10, rp = 100}, particle = "particles/sprays/ogre.vpcf", image = "images/spray/spray_22.png", type='spray',},		
		[23] = {itemname = "spray_23", price = {don = 10, rp = 100}, particle = "particles/sprays/mirana.vpcf", image = "images/spray/spray_23.png", type='spray',},		
		[24] = {itemname = "spray_24", price = {don = 10, rp = 100}, particle = "particles/sprays/looser.vpcf", image = "images/spray/spray_24.png", type='spray',},		
		[25] = {itemname = "spray_25", price = {don = 10, rp = 100}, particle = "particles/sprays/sven.vpcf", image = "images/spray/spray_25.png", type='spray',},
		[26] = {itemname = "spray_26", price = {don = 10, rp = 100}, particle = "particles/sprays/push.vpcf", image = "images/spray/spray_26.png", type='spray',},
		[27] = {itemname = "spray_27", price = {don = 10, rp = 100}, particle = "particles/sprays/shaman.vpcf", image = "images/spray/spray_27.png", type='spray',},
		[28] = {itemname = "spray_28", price = {don = 10, rp = 100}, particle = "particles/sprays/tusk.vpcf", image = "images/spray/spray_28.png", type='spray',},				
		[29] = {itemname = "spray_29", price = {don = 10, rp = 100}, particle = "particles/sprays/boo.vpcf", image = "images/spray/spray_29.png", type='spray'},
		[30] = {itemname = "spray_30", price = {don = 10, rp = 100}, particle = "particles/sprays/earth.vpcf", image = "images/spray/spray_30.png", type='spray'},
		[31] = {itemname = "spray_31", price = {don = 10, rp = 100}, particle = "particles/sprays/egg.vpcf", image = "images/spray/spray_31.png", type='spray'},
		[32] = {itemname = "spray_32", price = {don = 10, rp = 100}, particle = "particles/sprays/fura.vpcf", image = "images/spray/spray_32.png", type='spray'},
		[33] = {itemname = "spray_33", price = {don = 10, rp = 100}, particle = "particles/sprays/hm.vpcf", image = "images/spray/spray_33.png", type='spray'},
		[34] = {itemname = "spray_34", price = {don = 10, rp = 100}, particle = "particles/sprays/invoker.vpcf", image = "images/spray/spray_34.png", type='spray'},
		[35] = {itemname = "spray_35", price = {don = 10, rp = 100}, particle = "particles/sprays/marci.vpcf", image = "images/spray/spray_35.png", type='spray'},
		[36] = {itemname = "spray_36", price = {don = 10, rp = 100}, particle = "particles/sprays/marci_meat.vpcf", image = "images/spray/spray_36.png", type='spray'},
		[37] = {itemname = "spray_37", price = {don = 10, rp = 100}, particle = "particles/sprays/marci2.vpcf", image = "images/spray/spray_37.png", type='spray'},
		[38] = {itemname = "spray_38", price = {don = 10, rp = 100}, particle = "particles/sprays/mars.vpcf", image = "images/spray/spray_38.png", type='spray'},
		[39] = {itemname = "spray_39", price = {don = 10, rp = 100}, particle = "particles/sprays/meatball.vpcf", image = "images/spray/spray_39.png", type='spray'},
		[40] = {itemname = "spray_40", price = {don = 10, rp = 100}, particle = "particles/sprays/monkey.vpcf", image = "images/spray/spray_40.png", type='spray'},
		[41] = {itemname = "spray_41", price = {don = 10, rp = 100}, particle = "particles/sprays/old_school.vpcf", image = "images/spray/spray_41.png", type='spray'},
		[42] = {itemname = "spray_42", price = {don = 10, rp = 100}, particle = "particles/sprays/phantom_lancer.vpcf", image = "images/spray/spray_42.png", type='spray'},
		[43] = {itemname = "spray_43", price = {don = 10, rp = 100}, particle = "particles/sprays/pvp.vpcf", image = "images/spray/spray_43.png", type='spray'},
		[44] = {itemname = "spray_44", price = {don = 10, rp = 100}, particle = "particles/sprays/rip.vpcf", image = "images/spray/spray_44.png", type='spray'},
		[45] = {itemname = "spray_45", price = {don = 10, rp = 100}, particle = "particles/sprays/rip2.vpcf", image = "images/spray/spray_45.png", type='spray'},
		[46] = {itemname = "spray_46", price = {don = 10, rp = 100}, particle = "particles/sprays/sf.vpcf", image = "images/spray/spray_46.png", type='spray'},
		[47] = {itemname = "spray_47", price = {don = 10, rp = 100}, particle = "particles/sprays/tide.vpcf", image = "images/spray/spray_47.png", type='spray'},	
		[48] = {itemname = "spray_48", price = {don = 10, rp = 100}, particle = "particles/sprays/troll.vpcf", image = "images/spray/spray_48.png", type='spray'},
		[49] = {itemname = "spray_49", price = {don = 10, rp = 100}, particle = "particles/sprays/ursa2.vpcf", image = "images/spray/spray_49.png", type='spray'},
		[50] = {itemname = "spray_50", price = {don = 10, rp = 100}, particle = "particles/sprays/wow.vpcf", image = "images/spray/spray_50.png", type='spray'},
    },
	[7] = {
        name = 'highfives',
 		[1] = {itemname = "highfive_1", price = {don = 10, rp = 100}, particle = "particles/econ/events/diretide_2020/high_five/high_five_lvl1_overhead.vpcf", image = "images/highfive/highfive_1.png", type='highfive'}, --zombie
		[2] = {itemname = "highfive_2", price = {don = 10, rp = 100}, particle = "particles/econ/events/fall_2021/high_five_fall_2021_overhead.vpcf", image = "images/highfive/highfive_2.png", type='highfive'}, --blue
		[3] = {itemname = "highfive_3", price = {don = 10, rp = 100}, particle = "particles/econ/events/fall_2022/high_five/high_five_fall_2022_overhead.vpcf", image = "images/highfive/highfive_3.png", type='highfive'}, --lava
		[4] = {itemname = "highfive_4", price = {don = 10, rp = 100}, particle = "particles/econ/events/fall_2022/high_five/high_five_foam_hand_overhead.vpcf", image = "images/highfive/highfive_4.png", type='highfive'}, --red
		[5] = {itemname = "highfive_5", price = {don = 10, rp = 100}, particle = "particles/econ/events/plus/high_five/high_five_lvl1_overhead.vpcf", image = "images/highfive/highfive_5.png", type='highfive'}, --water
		[6] = {itemname = "highfive_6", price = {don = 10, rp = 100}, particle = "particles/econ/events/plus/high_five/high_five_lvl2_overhead.vpcf", image = "images/highfive/highfive_6.png", type='highfive'}, --flame
		[7] = {itemname = "highfive_7", price = {don = 10, rp = 100}, particle = "particles/econ/events/plus/high_five/high_five_lvl3_overhead.vpcf", image = "images/highfive/highfive_7.png", type='highfive'}, --lapka
		[8] = {itemname = "highfive_8", price = {don = 10, rp = 100}, particle = "particles/econ/events/spring_2021/high_five_spring_2021_overhead.vpcf", image = "images/highfive/highfive_8.png", type='highfive'}, --gem
		[9] = {itemname = "highfive_9", price = {don = 10, rp = 100}, particle = "particles/econ/events/ti9/high_five/high_five_lvl2_overhead_2019.vpcf", image = "images/highfive/highfive_9.png", type='highfive'}, --snow
		[10] = {itemname = "highfive_10", price = {don = 10, rp = 100}, particle = "particles/econ/events/ti9/high_five/high_five_lvl3_overhead.vpcf", image = "images/highfive/highfive_10.png", type='highfive'}, --gold
		[11] = {itemname = "highfive_11", price = {don = 10, rp = 100}, particle = "particles/econ/misc/high_five/aghanim_puppet_2021/high_five_agh_2021_overhead.vpcf", image = "images/highfive/highfive_11.png", type='highfive'}, --aghanim
		[12] = {itemname = "highfive_12", price = {don = 10, rp = 100}, particle = "particles/econ/items/wraith_king/arcana/high_five_wk_arcana_overhead.vpcf", image = "images/highfive/highfive_12.png", type='highfive'}, --aghanim
    },
	[8] = {
 		name = "pets",
		[1] = {price = {don = 150}, itemname = "item_armor_pet", type='pet', boost={"arm"}, level="common"},
		[2] = {price = {don = 150}, itemname = "item_attackspeed_pet", type='pet', boost={"as"}, level="common"},
		[3] = {price = {don = 150}, itemname = "item_spell_pet", type='pet', boost={"sdm"}, level="common"},
		[4] = {price = {don = 150}, itemname = "item_hpmp_pet", type='pet', boost={"hpmp"}, level="common"},
		[5] = {price = {don = 150}, itemname = "item_stats_pet", type='pet', boost={"stats"}, level="common"},
		[6] = {price = {don = 150}, itemname = "item_dmg_pet", type='pet', boost={"dmg"}, level="common"},

		[7] = {price = {don = 300}, itemname = "item_armor_pet2", type='pet', boost={"arm", "ms"}, level="uncommon"},
		[8] = {price = {don = 300}, itemname = "item_attackspeed_pet2", type='pet', boost={"as", "sdm"}, level="uncommon"},
		[9] = {price = {don = 300}, itemname = "item_spell_pet2", type='pet', boost={"sdm", "arm"}, level="uncommon"},
		[10] = {price = {don = 300}, itemname = "item_hpmp_pet2", type='pet', boost={"hpmp", "cd"}, level="uncommon"},
		[11] = {price = {don = 300}, itemname = "item_stats_pet2", type='pet', boost={"stats", "mr"}, level="uncommon"},
		[12] = {price = {don = 300}, itemname = "item_dmg_pet2", type='pet', boost={"dmg", "hpr"}, level="uncommon"},

		[13] = {price = {don = 450}, itemname = "item_armor_pet3", type='pet', boost={"arm", "ms", "dmg"}, level="rare"},
		[14] = {price = {don = 450}, itemname = "item_attackspeed_pet3", type='pet', boost={"as", "sdm", "stats"}, level="rare"},
		[15] = {price = {don = 450}, itemname = "item_spell_pet3", type='pet', boost={"sdm", "arm", "ms"}, level="rare"},
		[16] = {price = {don = 450}, itemname = "item_hpmp_pet3", type='pet', boost={"hpmp", "cd", "mr"}, level="rare"},
		[17] = {price = {don = 450}, itemname = "item_stats_pet3", type='pet', boost={"stats", "mr", "cd"}, level="rare"},
		[18] = {price = {don = 450}, itemname = "item_dmg_pet3", type='pet', boost={"dmg", "hpr", "eva"}, level="rare"},

		[19] = {price = {don = 600}, itemname = "item_armor_pet4", type='pet', boost={"arm", "ms", "dmg", "hpr"}, level="mythical"},
		[20] = {price = {don = 600}, itemname = "item_attackspeed_pet4", type='pet', boost={"as", "sdm", "stats", "mr"}, level="mythical"},
		[21] = {price = {don = 600}, itemname = "item_spell_pet4", type='pet', boost={"sdm", "arm", "ms", "hpmp"}, level="mythical"},
		[22] = {price = {don = 600}, itemname = "item_hpmp_pet4", type='pet', boost={"hpmp", "cd", "mr","eva"}, level="mythical"},
		[23] = {price = {don = 600}, itemname = "item_stats_pet4", type='pet', boost={"stats", "mr", "cd", "as"}, level="mythical"},
		[24] = {price = {don = 600}, itemname = "item_dmg_pet4", type='pet', boost={"dmg", "hpr", "eva", "mr"}, level="mythical"},
		
		[25] = {price = {don = 1200}, itemname = "item_armor_pet5", type='pet', boost={"arm", "ms", "dmg", "hpr"}, level="legendary"},
		[26] = {price = {don = 1200}, itemname = "item_attackspeed_pet5", type='pet', boost={"as", "sdm", "stats", "hpmp"}, level="legendary"},
		[27] = {price = {don = 1200}, itemname = "item_spell_pet5", type='pet', boost={"sdm", "arm", "ms", "hpmp"}, level="legendary"},
		[28] = {price = {don = 1200}, itemname = "item_hpmp_pet5", type='pet', boost={"hpmp", "cd", "mr","eva"}, level="legendary"},
		[29] = {price = {don = 1200}, itemname = "item_stats_pet5", type='pet', boost={"stats", "mr", "cd", "as"}, level="legendary"},
		[30] = {price = {don = 1200}, itemname = "item_dmg_pet5", type='pet', boost={"dmg", "hpr", "eva", "mr"}, level="legendary"},
		
		[31] = {price = {don = 2400}, itemname = "item_armor_pet6", type='pet', boost={"arm", "ms", "dmg", "hpr", "crit"}, level="immortal"},
		[32] = {price = {don = 2400}, itemname = "item_attackspeed_pet6", type='pet', boost={"as", "sdm", "stats", "hpmp", "crit"}, level="immortal"},
		[33] = {price = {don = 2400}, itemname = "item_spell_pet6", type='pet', boost={"sdm", "arm", "ms", "hpmp", "crit"}, level="immortal"},
		[34] = {price = {don = 2400}, itemname = "item_hpmp_pet6", type='pet', boost={"hpmp", "cd", "mr","eva", "crit"}, level="immortal"},
		[35] = {price = {don = 2400}, itemname = "item_stats_pet6", type='pet', boost={"stats", "mr", "cd", "as", "crit"}, level="immortal"},
		[36] = {price = {don = 2400}, itemname = "item_dmg_pet6", type='pet', boost={"dmg", "hpr", "eva", "mr", "crit"}, level="immortal"},
		
		[37] = {price = {don = 10000}, itemname = "item_d_pet", type='pet', boost={"arm", "ms", "dmg", "hpr", "as", "sdm", "mr", "eva", "crit", "hpmp"}, level="ancient"},
		[38] = {price = {don = 10000}, itemname = "item_d2_pet", type='pet', boost={"arm", "ms", "dmg", "hpr", "as", "sdm", "mr", "eva", "crit", "hpmp"}, level="ancient"},
		[39] = {price = {don = 10000}, itemname = "item_d3_pet", type='pet', boost={"arm", "ms", "dmg", "hpr", "as", "sdm", "mr", "eva", "crit", "hpmp"}, level="ancient"},
		[40] = {price = {don = 10000}, itemname = "item_d4_pet", type='pet', boost={"arm", "ms", "dmg", "hpr", "as", "sdm", "mr", "eva", "crit", "hpmp"}, level="ancient"},
		[41] = {price = {don = 10000}, itemname = "item_d5_pet", type='pet', boost={"arm", "ms", "dmg", "hpr", "as", "sdm", "mr", "eva", "crit", "hpmp"}, level="ancient"},
		[42] = {price = {don = 10000}, itemname = "item_d6_pet", type='pet', boost={"arm", "ms", "dmg", "hpr", "as", "sdm", "mr", "eva", "crit", "hpmp"}, level="ancient"},
 	}
}

function Shop:init()
	_G.Shop.pShop = {}
	_G.Account_stats = {}
    CustomGameEventManager:RegisterListener("money_update", Dynamic_Wrap( Shop, 'money_update' ))
    CustomGameEventManager:RegisterListener("giveItem", Dynamic_Wrap( Shop, 'giveItem' ))
	CustomGameEventManager:RegisterListener("buyItem", Dynamic_Wrap( Shop, 'buyItem' ))
    CustomGameEventManager:RegisterListener("defaultCosmetic", Dynamic_Wrap( Shop, 'defaultCosmetic' ))
    CustomGameEventManager:RegisterListener("return_item", Dynamic_Wrap( Shop, 'return_item' ))
    CustomGameEventManager:RegisterListener("update_panels", Dynamic_Wrap( Shop, 'update_panels' ))
    CustomGameEventManager:RegisterListener("update_pets", Dynamic_Wrap( Shop, 'update_pets' ))
    CustomGameEventManager:RegisterListener("cas_init", Dynamic_Wrap( Shop, 'cas_init' ))
    CustomGameEventManager:RegisterListener("try_start_cas", Dynamic_Wrap( Shop, 'try_start_cas' ))
    CustomGameEventManager:RegisterListener("win_cas", Dynamic_Wrap( Shop, 'win_cas' ))
	CustomGameEventManager:RegisterListener("get_game_rating", Dynamic_Wrap( Shop, 'get_game_rating' ))
	CustomGameEventManager:RegisterListener("show_treasure", Dynamic_Wrap( Shop, 'show_treasure' ))
	CustomGameEventManager:RegisterListener("try_treasure", Dynamic_Wrap( Shop, 'try_treasure' ))
	CustomGameEventManager:RegisterListener("get_mails", Dynamic_Wrap( Shop, 'get_mails' ))
	CustomGameEventManager:RegisterListener("send_mail_read", Dynamic_Wrap( Shop, 'send_mail_read' ))
	CustomGameEventManager:RegisterListener("send_mail_reward", Dynamic_Wrap( Shop, 'send_mail_reward' ))
	CustomGameEventManager:RegisterListener("get_bp", Dynamic_Wrap( Shop, 'get_bp' ))
	CustomGameEventManager:RegisterListener("buy_bp", Dynamic_Wrap( Shop, 'buy_bp' ))
	CustomGameEventManager:RegisterListener("TakeReward", Dynamic_Wrap( Shop, 'TakeReward' ))
	CustomGameEventManager:RegisterListener("add_green_day_rewards", Dynamic_Wrap( Shop, 'add_green_day_rewards' ))
	CustomGameEventManager:RegisterListener("Use_buff", Dynamic_Wrap( Shop, 'Use_buff' ))
	CustomGameEventManager:RegisterListener("Use_buff_all", Dynamic_Wrap( Shop, 'Use_buff_all' ))
	
	CustomGameEventManager:RegisterListener("buy_discount_item", Dynamic_Wrap( Shop, 'buy_discount_item' ))
	CustomGameEventManager:RegisterListener("buy_unlock_difficulty", Dynamic_Wrap( Shop, 'buy_unlock_difficulty' ))
	
	
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( Shop, 'OnPlayerReconnected' ), self)
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( Shop, 'OnGameRulesStateChange'), self)
	CustomGameEventManager:RegisterListener("choise_diff", Dynamic_Wrap( Shop, 'choise_diff' ))
end

_G.Game_Difficulty = 1

function Shop:choise_diff(t)
	if t.PlayerID == 0 and GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		_G.Game_Difficulty = t.index
		CustomGameEventManager:Send_ServerToAllClients("update_diff", {id = t.id})
	end	
end

function Shop:Use_buff_all(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	local player = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	for k,v in pairs(t.item_use) do
		local i, n =  findItemByName(v)
		local product = Shop.pShop[sid][i][n]
		if product.now > 0 and not player:HasModifier("modifier_"..product.itemname.."_cd") then
			product.now = product.now - 1
			item = player:AddItemByName(product.itemname)
			item:UseResources(true, true, true, true)
			item:OnSpellStart()
		end
	end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "initShop2", Shop.pShop[sid])
end

function Shop:OnGameRulesStateChange(keys)
    local game_state = GameRules:State_Get()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2.5, function() 
			for i = 0, PlayerResource:GetPlayerCount() - 1 do
				if PlayerResource:IsValidPlayer(i) then
					print("OnGameRulesStateChange GetPlayerCount i=",i)
					GameRules:SendCustomMessage("Приятной игры!", 0, 0)
					local sid = PlayerResource:GetSteamAccountID(i)
					if sid == 393187346 then
						GameRules:SendCustomMessage("выполняю", 0, 0)
					end
					print("OnGameRulesStateChange GetPlayerCount sid=",sid)
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "initShop", Shop.pShop[sid] )
					guilds:get_start_game_guilds(i)
				end
			end
		end)
	end
end

------------------------------------------------------------------

function Shop:ban()	
	arr = {}
	players = {}
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(i) then 
			players[tostring(i)] = {sid = tostring(PlayerResource:GetSteamID(i))}
		end
	end
	
	arr['players'] = players

	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_ban/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			for i = 0, PlayerResource:GetPlayerCount() - 1 do
				if PlayerResource:IsValidPlayer(i) then 
					local hero = PlayerResource:GetSelectedHeroEntity(i)
					hero:AddNewModifier( hero, nil, "modifier_ban", {} )
				end
			end	
		else
			print("ERROR START GAME")
			print(res.StatusCode)
			print("ERROR START GAME")
		end
	end)
end

------------------------------------------------------------------

function Shop:get_db_info()	
	_G.SHOP = {}
	local arr = {}
	
	mode_ability = 0
	mode_simple = 0
	
	if GetMapName() == "ability_mode" then
		mode_ability = 1
	else
		mode_simple = 1
	end
	
	arr = {}
	players = {}
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(i) then 
			players[i] = {sid = tostring(PlayerResource:GetSteamID(i))}
		end
	end
	
	arr['players'] = players
	arr['mode_map_ability'] = mode_ability
	arr['mode_map_simple'] = mode_simple

	arr = json.encode(arr)
	print(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_game_start/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			_G.SHOP = json.decode(res.Body)
			Shop:createShop()
			unlock_heroes()
		else
			print("ERROR START GAME")
			print(res.StatusCode)
			print("ERROR START GAME")
		end
	end)
end

function unlock_heroes()
	local AllHeroPull = LoadKeyValues("scripts/npc/herolist2.txt")
	for iPlayerID = 0, PlayerResource:GetPlayerCount()-1 do
		GameRules:ClearPlayerHeroAvailability(iPlayerID)
		for k, v in pairs(AllHeroPull) do
			GameRules:AddHeroToPlayerAvailability(iPlayerID, DOTAGameManager:GetHeroIDByName(k))
		end
		local sid = PlayerResource:GetSteamAccountID(iPlayerID)
		findItemAndStart(Shop.pShop[sid], iPlayerID)
	end
end

function findItemAndStart(table, pid)
    for _, tab in ipairs(table) do
        for _, entry in ipairs(tab) do
            if entry.itemname == "item_dado_stone" and entry.onStart == 1 then
				GameRules:AddHeroToPlayerAvailability(pid, DOTAGameManager:GetHeroIDByName( "npc_dota_hero_dado" ) )
            end
			if entry.itemname == "item_triss_stone" and entry.onStart == 1 then
				GameRules:AddHeroToPlayerAvailability(pid, DOTAGameManager:GetHeroIDByName( "npc_dota_hero_triss" ) )
            end
			if entry.itemname == "item_destroyer_stone" and entry.onStart == 1 then
                GameRules:AddHeroToPlayerAvailability(pid, DOTAGameManager:GetHeroIDByName( "npc_dota_hero_destroyer" ) )-- GameRules:AddHeroToBlacklist("npc_dota_hero_destroyer")
            end
			if entry.itemname == "item_fiddlesticks_stone" and entry.onStart == 1 then
				GameRules:AddHeroToPlayerAvailability(pid, DOTAGameManager:GetHeroIDByName( "npc_dota_hero_fiddlesticks" ) )
            end
        end
    end
	if table.add_hero == true then
		 GameRules:AddHeroToPlayerAvailability(pid, DOTAGameManager:GetHeroIDByName( "npc_dota_hero_anakim" ) )
	end
end

function Shop:OnPlayerReconnected(keys)
	local sid = PlayerResource:GetSteamAccountID(keys.PlayerID)
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			local sid = PlayerResource:GetSteamAccountID( keys.PlayerID )
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "initShop", Shop.pShop[sid])
		end)
	end
end

function Shop:createShop()
    if SHOP then
        for i = 1, PlayerResource:GetPlayerCount() do
            if PlayerResource:IsValidPlayer(i-1) then
                local sid = PlayerResource:GetSteamAccountID(i-1)
                local arr = {}
                for sKey, sValue in pairs(_G.game_shop) do
                    if type(sValue) == 'table' then
                        arr[sKey] = {}
                        for oKey, oValue in pairs(sValue) do
                            arr[sKey][oKey] = {}
                            if type(oValue) == 'table' then
                                for pKey, pValue in pairs(oValue) do
                                    arr[sKey][oKey][pKey] = pValue
                                end
                                local item_found = false
									if SHOP[i].product then
                                    for _, item in pairs(SHOP[i].product) do
                                       if item.product == oValue.itemname then
										arr[sKey][oKey].onStart = tonumber(item.count)
										arr[sKey][oKey].now = tonumber(item.count)
										if arr[sKey][oKey].type == 'consumable' then
											if tonumber(item.count) > 0 then
												arr[sKey][oKey].status = 'take_consumable'	
											else
												arr[sKey][oKey].status = 'buy_consumable'
											end
										elseif arr[sKey][oKey].type == 'item' then
											if not item.can_upgrade then
												if tonumber(item.count) > 0 then
													arr[sKey][oKey].status = 'take_item'	
												else
													arr[sKey][oKey].status = 'buy'
												end
											else
												if tonumber(item.count) == 0 then
													arr[sKey][oKey].status = 'buy'
												else
													arr[sKey][oKey].status = 'take_item'	
												end
											end
										elseif arr[sKey][oKey].type == 'effect' then
											if tonumber(item.count) > 0 then
												arr[sKey][oKey].active = item.active
												if arr[sKey][oKey].active then
													CustomNetTables:SetTableValue("effect", tostring(i-1), {effect = arr[sKey][oKey].particle})
												end
												arr[sKey][oKey].status = 'take_item'
												if arr[sKey][oKey].active then
													arr[sKey][oKey].status = 'takeoff'
												end
											else
												arr[sKey][oKey].status = 'buy'
											end		
										elseif arr[sKey][oKey].type == 'spray' then
											if tonumber(item.count) > 0 then
												arr[sKey][oKey].active = item.active
												if arr[sKey][oKey].active then
													CustomNetTables:SetTableValue("sprays", tostring(i-1), {spray = arr[sKey][oKey].particle})
												end
												arr[sKey][oKey].status = 'take_item'
												if arr[sKey][oKey].active then
													arr[sKey][oKey].status = 'takeoff'
												end
											else
												arr[sKey][oKey].status = 'buy'
											end
										elseif arr[sKey][oKey].type == 'highfive' then
											if tonumber(item.count) > 0 then
												arr[sKey][oKey].active = item.active
												if arr[sKey][oKey].active then
													CustomNetTables:SetTableValue("highfive", tostring(i-1), {highfive = arr[sKey][oKey].particle})
												end
												arr[sKey][oKey].status = 'take_item'
												if arr[sKey][oKey].active then
													arr[sKey][oKey].status = 'takeoff'
												end
											else
												arr[sKey][oKey].status = 'buy'
											end
										elseif arr[sKey][oKey].type == 'pet' then
											if tonumber(item.count) > 0 then
												arr[sKey][oKey].active = item.active
												if arr[sKey][oKey].active then
													CustomNetTables:SetTableValue("pet", tostring(i-1), {pet = arr[sKey][oKey].itemname})
												end
												arr[sKey][oKey].status = 'take_item'
												if arr[sKey][oKey].active then
													arr[sKey][oKey].status = 'takeoff'
												end
											else
												arr[sKey][oKey].status = 'buy'
											end											
										end
										item_found = true
										break
                                        end
                                    end
                                end
								if not item_found then
									arr[sKey][oKey].onStart = 0
									arr[sKey][oKey].now = 0
									arr[sKey][oKey].status = 'buy'
								end
                            elseif type(oValue) == 'string' then
                                arr[sKey][oKey] = oValue
                            end
                        end
                    end
                end
                if SHOP[i].profile[1] then
                    _G.Account_stats[sid] = SHOP[i].profile[1]
                end
				
				if SHOP[i].links then
                    arr.link = SHOP[i].links
                end
				
				if SHOP[i].total_coins then
                    arr.total_coins = SHOP[i].total_coins
                end
				
				if SHOP[i].guild_id then
                    arr.guild_id = SHOP[i].guild_id
                end
				
                if SHOP[i].coins then
                    arr.coins = SHOP[i].coins
                else
                    arr.coins = 0
                end
                if SHOP[i].rp then
                    arr.mmrpoints = SHOP[i].rp
                else
                    arr.mmrpoints = 0
                end
				arr.boost_game = SHOP[i].boost_game
                arr.add_hero = SHOP[i].add_hero
                arr.ban_status = SHOP[i].ban_status
                Shop.pShop[sid] = arr
            end
        end
        -- acc:CreateAcc()
    end
	CustomGameEventManager:Send_ServerToAllClients("init_diff", {SHOP[1].profile[1].difficulty})
end

function Shop:money_update(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_money_update_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "updatecoins", new_data )
        else 
            print(res.StatusCode)
        end
	end)
end

---------------------------------------------------------------------------------------------

function Shop:buyItem(t)
    local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
    local i = tonumber(t.i)
    local n = tonumber(t.n)
    local product = Shop.pShop[sid][i][n]
	local count = tonumber(t.count_buy)
    local price = product.price[t.currency] * count
	
	if count < 1 then
		rules:DisplayError(t.PlayerID, "#cant_buy")
		return
	end

    if t.currency == 'rp' and price > tonumber(Shop.pShop[sid].mmrpoints) then
		rules:DisplayError(t.PlayerID, "#need_more_rp")
        return
    elseif t.currency == 'don' and price > tonumber(Shop.pShop[sid].coins) then
		rules:DisplayError(t.PlayerID, "#need_more_gems")
        return
    end

    if t.currency == 'rp' then
        Shop.pShop[sid].mmrpoints = Shop.pShop[sid].mmrpoints - price
    else
        Shop.pShop[sid].coins = Shop.pShop[sid].coins - price
    end
	
	product.now = product.now + count

	if product.type == 'item' then
		if product.now > 5 then return end
	end
	product.status = 'take_item'
	
    Shop:buyRequest({PlayerID = t.PlayerID, name = product.itemname, price = price, currency = t.currency, count = count})
end

function Shop:buyRequest(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		name = t.name,
		price = t.price,
		currency = t.currency,
		count = t.count,
	}
	arr = json.encode(arr)
	
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_buy_item_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "initShop", Shop.pShop[PlayerResource:GetSteamAccountID(t.PlayerID)] )
        else 
            print(res.StatusCode)
        end
	end)
end

-------------------------------------------------------------------------------

function Shop:giveItem(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	local player = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	local i = tonumber(t.i)
	local n = tonumber(t.n)
	local all = t.all
	local product = Shop.pShop[sid][i][n]
	if product.can_upgrade then 
		if product.now > 1 then
			player:AddItemByName(product.itemname..product.now)	
		else	
			player:AddItemByName(product.itemname)
		end	
		product.status = "takeoff"
	end
	if (product.type == "consumable") and product.now > 0 then 
		if t.all == "all" then 
			local item = Shop:item_search(player, product.itemname)
			if item then
				item:SetCurrentCharges(item:GetCurrentCharges() + product.now)
			else
				player:AddItemByName(product.itemname):SetCurrentCharges(product.now)
			end	
			product.now = 0
		else
			product.now = product.now - 1
			local created_item = CreateItem(product.itemname, player, player)
			if created_item:IsStackable() then
				created_item:SetCurrentCharges(1)
				local player_item = player:FindItemInInventory(product.itemname)
				if player_item and player_item:GetPurchaser() == player then
					player_item:SetCurrentCharges(player_item:GetCurrentCharges() + 1)
					UTIL_Remove( created_item )
				else
					player:AddItem(created_item)
				end
			else
				player:AddItem(created_item)
			end
		end
	end
	if product.type == 'item' and not product.can_upgrade then 
		if product.now > 0 then
			player:AddItemByName(product.itemname)	
			product.status = "takeoff"
		end
	end

	if product.type == "pet" then
		if player:HasModifier("modifier_pet_cd") then
			rules:DisplayError(t.PlayerID, "#pet_cd")
			return
		end
		product.status = 'takeoff'
		player:RemoveModifierByName("modifier_pet_owner")
		Timers:CreateTimer(0.1, function() 
			player:AddNewModifier(player, nil,"modifier_pet_owner", {pet = product.itemname})
			player:AddNewModifier(player, nil,"modifier_pet_cd", {duration = 2})
		end)
	end
	
	if product.type == "spray" then
		product.status = 'takeoff'
		CustomNetTables:SetTableValue("sprays", tostring(t.PlayerID), {spray = product.particle})	
	end	
	
	if product.type == "highfive" then
		product.status = 'takeoff'
		CustomNetTables:SetTableValue("highfive", tostring(t.PlayerID), {highfive = product.particle})	
	end	
	
	if product.type == "effect" then
		product.status = 'takeoff'
		player:RemoveModifierByName("modifier_effect")
		player:AddNewModifier(player, nil,"modifier_effect", {effect = product.particle})
	end
	
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "initShop", Shop.pShop[sid] )
end

----------------------------------------------------------------------------------------------------

function Shop:return_item(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	local player = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    local i = tonumber(t.i)
    local n = tonumber(t.n)
    local product = Shop.pShop[sid][i][n]
	local itemname = product.itemname
	
	if product.can_upgrade then
		if product.now > 1 then 
			itemname = product.itemname..product.now
		end
		local item = player:FindItemInInventory(itemname)
		if item then
			UTIL_Remove( item )
			product.status = 'take_item'
		end
	elseif product.type == 'item' and not product.can_upgrade then
		local item = player:FindItemInInventory(itemname)
		if item then
			if item:GetPurchaser() == player then	
				product.status = 'take_item'
				UTIL_Remove( item )
			end
		end
	elseif product.type == "effect" then
		product.status = 'take_item'
		player:RemoveModifierByName("modifier_effect")
	elseif product.type == "spray" then
		product.status = 'take_item'
		CustomNetTables:SetTableValue("sprays", tostring(t.PlayerID), {})	
	elseif product.type == "highfive" then
		product.status = 'take_item'
		CustomNetTables:SetTableValue("highfive", tostring(t.PlayerID), {})	
	elseif product.type == "pet" then
		if player:HasModifier("modifier_pet_cd") then
			rules:DisplayError(t.PlayerID, "#pet_cd")
			return
		end
		product.status = 'take_item'
		player:RemoveModifierByName("modifier_pet_owner")
	else
		local item = player:FindItemInInventory(itemname)
		if item then
			if item:GetPurchaser() == player then		
				local charges = item:GetCurrentCharges()
				if charges == 0 then 
					charges = 1
				end
				product.status = 'take_item'
				product.now = product.now + charges
				UTIL_Remove( item )
			end
		end
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "initShop", Shop.pShop[sid] )
end

-------------------------------------------------------------------------------

function Shop:update_panels(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
    local i = tonumber(t.i)
    local n = tonumber(t.n)
    local product = Shop.pShop[sid][i][n]
	if product.status == 'takeoff' then
		product.status = 'take_item'
		if product.type == "effect" then
			product.status = 'take_item'
			player:RemoveModifierByName("modifier_" .. product.itemname)
		elseif product.type == "spray" then
			product.status = 'take_item'
			CustomNetTables:SetTableValue("sprays", tostring(t.PlayerID), {})	
		elseif product.type == "highfive" then
			product.status = 'take_item'
			CustomNetTables:SetTableValue("highfive", tostring(t.PlayerID), {})	
		end
	end
end


function Shop:item_search(hero, item_name)
	for i = 0, 14 do
		local item = hero:GetItemInSlot(i)
		if item and item:GetName() == item_name and item:GetPurchaser() == hero then
			return item
		end
    end
    return false
end

function bot(nPlayerID)
	return PlayerResource:GetSteamAccountID(nPlayerID) < 1000
end

--------------------------------------------------------------

function Shop:defaultCosmetic(t)
    local i = tonumber(t.i)
    local n = tonumber(t.n)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		name = Shop.pShop[sid][i][n].itemname,
		status = t.status,
		type = Shop.pShop[sid][i][n].type
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST",_G.host.."/api_default_cosmetic/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print(res.StatusCode, res.Body)
        end
	end)
end

-------------------------------------------------------------- CASINO --------------------------------------------------

function Shop:cas_init(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_money_update_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "cas_init", new_data )
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:try_start_cas(t)
    local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
    local shopData = Shop.pShop[sid]

    local need = (t.type == 'rp') and 10 or 1
    local currency = (t.type == 'rp') and 'mmrpoints' or 'coins'

    if shopData[currency] < need then
        local errorMsg = (t.type == 'rp') and "#need_more_rp" or "#need_more_gems"
        rules:DisplayError(t.PlayerID, errorMsg)
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "no_spin", {} )
        return
    end

    shopData[currency] = shopData[currency] - need
	
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		currency = t.type
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/start_cas_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "start_spin", new_data )
        else 
            print(res.StatusCode)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "no_spin", {} )
        end
	end)
end

function Shop:win_cas(t)
	local i, n =  findItemByName(t.itemname)
    local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
    local product = Shop.pShop[sid][i][n]
	local count = tonumber(t.count)
	product.now = product.now + count
	product.status = 'take_item'
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "initShop2", Shop.pShop[sid] )
end

function findItemByName(itemname)
    for tabNumber, tab in pairs(_G.game_shop) do
        for itemNumber, item in pairs(tab) do
            if type(item) == "table" and item.itemname == itemname then
                return tabNumber, itemNumber
            end
        end
    end
    return nil, nil
end

-------------------------------------------------------------- TREASURES

function Shop:show_treasure(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_get_treasure_cout/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "show_treasure_rewards", {item = t.item, new_data})
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:try_treasure(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		itemname = t.name
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_try_treasure_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "srart_roll", new_data)
			if new_data.itemname ~= 'item_bless' then
				Shop:win_cas({itemname = new_data.itemname, PlayerID = t.PlayerID, count = 1})
			end
			Shop:spend_treasure({itemname = t.name, PlayerID = t.PlayerID, count = 1})
        else 
            print(res.StatusCode)
			rules:DisplayError(t.PlayerID, "#need_more_treasures")
        end
	end)
end

function Shop:spend_treasure(t)
	local i, n =  findItemByName(t.itemname)
    local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
    local product = Shop.pShop[sid][i][n]
	local count = tonumber(t.count)
	product.now = product.now - count
	product.status = 'take_item'
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "initShop2", Shop.pShop[sid] )
end

-------------------------------------------------------------- MAILS

function Shop:get_mails(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_get_mails/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "mail_init", new_data )
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:send_mail_read(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		id = t.id
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_mail_read/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "mail_init", new_data )
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:send_mail_reward(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		id = t.id,
		reward = t.reward
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_mail_reward/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local new_data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "mail_init", new_data)
			for k,v in pairs(t.reward) do
				Shop:win_cas({itemname = v, PlayerID = t.PlayerID, count = 1})
			end
        else 
            print(res.StatusCode)
        end
	end)
end

--------------------------------------------------------------
--------------------------------------------------------------

_G.heroes_creeps_kill = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

_G.heroes_game_time = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

_G.win_request = false

function Shop:add_pr(add_rp, add_exp, add_rating, win_status, boss, playerID, unit_name, guild_exp)
	if GameRules:IsCheatMode() and not IsInToolsMode() then return end
	local rp = 0
	local xp = 0
	local rating = 0
	local game_win = 0
	
	local scale_mode = 1
	if _G.ability_mode then
		scale_mode = 0.5
	end
	
	local add_rp = add_rp * scale_mode
	local add_exp = add_exp * scale_mode
	local add_rating = add_rating * scale_mode
	
	rp = math.ceil((0.9 + _G.Game_Difficulty / 10) * add_rp)
	xp = math.ceil((0.9 + _G.Game_Difficulty / 10) * add_exp)
	rating = math.ceil((0.9 + _G.Game_Difficulty / 10) * add_rating)
	
	if PlayerResource:IsValidPlayer(playerID) and PlayerResource:HasSelectedHero( playerID ) then
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local sid = PlayerResource:GetSteamAccountID(playerID)	
		local connection = PlayerResource:GetConnectionState(playerID)
		
		if hero:HasModifier("modifier_new_player") then
			rp = math.ceil(rp * 1.1)
			xp = math.ceil(xp * 1.1)
			rating = math.ceil(rating * 1.1)
		end
		
		if hero and not bot(playerID) and connection ~= DOTA_CONNECTION_STATE_ABANDONED then
			-- Shop.pShop[sid].mmrpoints = Shop.pShop[sid].mmrpoints + rp
			
			local total_creeps_kill = PlayerResource:GetLastHits(playerID)
			local creeps_kill_add = total_creeps_kill - _G.heroes_creeps_kill[playerID]
			_G.heroes_creeps_kill[playerID] = total_creeps_kill
			
			local boss_add = 0
			local golden_add = 0
			
			if boss == 1 then
				boss_add = 1
			end	
			if boss == 0 then
				golden_add = 1
			end
			
			if win_status == 1 and not _G.ability_mode then
				if _G.Account_stats[sid].difficulty == _G.Game_Difficulty and _G.Account_stats[sid].difficulty < 20 then
					_G.Account_stats[sid].difficulty = _G.Account_stats[sid].difficulty + 1
				end
			end	
				
			local total_game_time = math.floor(GameRules:GetGameTime()/60)
			local time_add = total_game_time - _G.heroes_game_time[playerID]
			_G.heroes_game_time[playerID] = total_game_time
			
			
			if not hero:HasModifier("modifier_guild") then
				guild_exp = 0
			end
			if hero:HasModifier("modifier_new_player") then
				guild_exp = guild_exp * 1.1
			end
			
			guild_exp = math.ceil(guild_exp * _G.Game_Difficulty / 10)
			
			guilds:add_guild_exp(playerID, guild_exp)
			
			-- CustomNetTables:SetTableValue("statistic","HeroList_"..sid, {_G.Account_stats[sid]});
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "updatemmr", {Shop.pShop[sid].mmrpoints} )
			Shop:exp_request({
				guild_exp = guild_exp,
				playerID = playerID,
				total_rp = rp,
				rp = rp,
				rating = rating,
				expa = xp,
				damage_deal = 0,
				damage_take = 0,
				creeps_kill = creeps_kill_add,
				boss = boss_add,
				golden = golden_add,
				time_min = time_add,
				win = win_status,
				difficulty = _G.Account_stats[sid].difficulty,
				mode = _G.ability_mode, 
				unit_name = unit_name,
				game_diff = _G.Game_Difficulty	
			})		
		end	
	end
	if win_status == 1 and _G.win_request == false then
		_G.win_request = true
		Shop:send_game_rating()
	end	
end

function Shop:exp_request(t)
	if GameRules:IsCheatMode() and not IsInToolsMode() then return end
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.playerID), "show_reward_notifications", {rp = t.rp, expa = t.expa, guild_exp = t.guild_exp } )
	
	local arr = {
		sid = tostring(PlayerResource:GetSteamID(t.playerID)),
		total_rp = t.total_rp,
		rp = t.rp,
		rating = t.rating,
		expa = t.expa,
		damage_deal = t.damage_deal,--
		damage_take = t.damage_take,--
		creeps_kill = t.creeps_kill,--
		boss = t.boss,--
		golden = t.golden,--
		time_min = t.time_min,--
		win = t.win,
		difficulty = t.difficulty,
		unit_name = t.unit_name,
		quest_progress = _G.player_quest[t.playerID],
		mode = t.mode,
		game_diff = t.game_diff
	}
	_G.player_quest[t.playerID] = {}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_statistic_request_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print(res.StatusCode, res.Body)
        end
	end)
end

function Shop:get_game_rating(t)
	local req = CreateHTTPRequestScriptVM( "GET", _G.host.."/api_save_rating_game_new/")
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			_G.Game_Rating = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "rating_init", _G.Game_Rating)
        else 
            print(res.StatusCode, res.Body)
        end
	end)
end

--------------------------------------------------------------

function Shop:send_game_rating()
	if GameRules:IsCheatMode() and not IsInToolsMode() then return end
	print("send game rating")
	arr = {}
	players = {}
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(i) and PlayerResource:HasSelectedHero( i ) then 
			local hero = PlayerResource:GetSelectedHeroEntity(i)
			local sid = PlayerResource:GetSteamAccountID(i)	
			local player_level = _G.Account_stats[sid].level
			local player_rating = _G.Account_stats[sid].rating
			players[i] = {sid = tostring(PlayerResource:GetSteamID(i)), hero = hero:GetUnitName(), player_level = player_level, player_rating = player_rating, items = GetEndGameItems(hero), ability = GetEndGameAbility(hero)}
		end
	end
	arr['players'] = players
	arr['game_time'] = math.floor(GameRules:GetGameTime())
	arr['game_difficulty'] = _G.Game_Difficulty
	arr['ability_mode'] = _G.ability_mode 
	arr['game_id'] = tostring(GameRules:Script_GetMatchID())
	arr = json.encode(arr)

	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_save_rating_game_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print(res.StatusCode, res.Body)
        end
	end)
end

function GetEndGameItems(hero)
	items = {}
	for i = 0, 5 do
		local item = hero:GetItemInSlot(i)
		if item then
			table.insert(items, item:GetAbilityName())
		end
	end
	return items
end

function GetEndGameAbility(hero)
	abilities = {}
	for i = 0, 5 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and not ability:IsNull() then
			local ability_name = ability:GetAbilityName()
			table.insert(abilities, ability_name)
		end
	end
	return abilities
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

function Shop:get_bp(t)
	arr = {
		sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
		quest_progress = _G.player_quest[t.PlayerID]
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_get_battle_pass_new/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			local rewards_list = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "bp_init", rewards_list)
			_G.player_quest[t.PlayerID] = {}
		else
			print(res.StatusCode)
		end
	end)
end	

function Shop:buy_bp(t)
	arr = {
		sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
		cur = t.cur,
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST",  _G.host.."/api_buy_battle_pass/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			Shop:get_bp(t)
		else
			print(res.StatusCode)
		end
	end)
end

function findItemByName(itemname)
    for tabNumber, tab in pairs(_G.game_shop) do
        for itemNumber, item in pairs(tab) do
            if type(item) == "table" and item.itemname == itemname then
                return tabNumber, itemNumber
            end
        end
    end
    return nil, nil
end

function Shop:TakeReward(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	local level = t.level
	local reward = t.reward --bless, 
	local rp = 0
	local acc_exp = 0
	local guild_exp = 0
	local bless = 0
	local soul = 0
	local items_rewards = {}
	
	local function addItem(itemNamePrefix, maxIndex, rpOnDuplicate)
		itemname = itemNamePrefix
		if maxIndex >= 1 then
			itemname = itemNamePrefix .. RandomInt(1, maxIndex)
		end		
		local i, n = findItemByName(itemname)
		local product = Shop.pShop[sid][i][n]
		
		if rpOnDuplicate == 0 then
			product.now = product.now + 1
			product.status = 'take_item'
			items_rewards[itemname] = 0
			EmitAnnouncerSoundForPlayer("playercard.dust_to_pack", t.PlayerID)
		else
			if product.now == 0 then
				product.now = 1
				product.status = 'take_item'
				items_rewards[itemname] = 0
				EmitAnnouncerSoundForPlayer("playercard.dust_to_pack", t.PlayerID)
			else
				EmitAnnouncerSoundForPlayer("playercard.pack_pickup", t.PlayerID)
				items_rewards[itemname] = rpOnDuplicate
			end
		end
	end
	
	if reward == "rp_25" then
		rp = 25
		EmitAnnouncerSoundForPlayer("playercard.pack_pickup", t.PlayerID)
		
	elseif reward == "account_exp_150" then
		acc_exp = 150
		EmitAnnouncerSoundForPlayer("playercard.pack_pickup", t.PlayerID)
		
	elseif reward == "guild_exp_50" then
		guild_exp = 50	
		EmitAnnouncerSoundForPlayer("playercard.pack_pickup", t.PlayerID)
		
	elseif reward == "bless" then
		bless = 1
		EmitAnnouncerSoundForPlayer("playercard.pack_pickup", t.PlayerID)
		
	elseif reward == "soul" then
		soul = 1
		EmitAnnouncerSoundForPlayer("playercard.pack_pickup", t.PlayerID)
	
	elseif string.find(reward, "item_treasure") or string.find(reward, "_aura") then
		addItem(reward, 0, 0)
		
	elseif string.find(reward, "_pet") then	
		addItem(reward, 0, 100)
	end
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "Show_reward", {items = items_rewards, rp = rp, acc_exp = acc_exp, guild_exp = guild_exp, bless = bless, soul = soul} )
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "initShop2", Shop.pShop[sid])
	Shop:RewardSendRequest(t.PlayerID, level, rp, acc_exp, guild_exp, items_rewards, bless, soul)
end


function Shop:RewardSendRequest(pid, level, rp, acc_exp, guild_exp, items, bless, soul)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID(pid)),
		level = level,
		rp = rp,
		acc_exp = acc_exp,
		guild_exp = guild_exp,
		items = items,
		bless = bless,
		soul = soul,
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_add_reward_battle_pass/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.StatusCode)
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:add_green_day_rewards(t)
	arr = {
		sid = tostring(PlayerResource:GetSteamID(t.PlayerID)),
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/add_day_rewards_battle_pass/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			print(res.Body)
		else
			print(res.StatusCode)
		end
	end)
end

function Shop:Use_buff(t)
	local i, n =  findItemByName(t.itemname)
    local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	local player = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    local product = Shop.pShop[sid][i][n]
	if product.now > 0 and not player:HasModifier("modifier_"..t.itemname.."_cd") then
		product.now = product.now - 1
		local item = player:AddItemByName(product.itemname)
		item:UseResources(true, true, true, true)
		item:OnSpellStart()
	end
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "initShop2", Shop.pShop[sid])
end

-------------------------------------------------------------------------------------------

function Shop:buy_discount_item(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		price = t.price,
		data = t.data,
	}
	arr = json.encode(arr)
		
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_buy_discount_item/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			if t.data == 'set_discount' then
				inventory:roll_discount(t.PlayerID)
			end
		elseif res.StatusCode == 300 then
			rules:DisplayError(t.PlayerID, "#need_more_slots")
        elseif res.StatusCode == 405 then
			rules:DisplayError(t.PlayerID, "#need_more_gems")
            print(res.StatusCode)
        end
	end)
end

function Shop:get_difficulty_data(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
	}
	arr = json.encode(arr)
		
	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_get_difficulty_data/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local data = json.decode(res.Body)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "difficulty_data_updated", data)
		else
			print(res.StatusCode)
			print(res.Body)
		end
	end)
end

function Shop:buy_unlock_difficulty(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
	}
	arr = json.encode(arr)

	local req = CreateHTTPRequestScriptVM( "POST", _G.host.."/api_buy_unlock_difficulty/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local data = json.decode(res.Body)
			local steam_id = PlayerResource:GetSteamAccountID(t.PlayerID)
			_G.Account_stats[steam_id].difficulty = data.current_difficulty
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "difficulty_data_updated", data)
		else
			print(res.StatusCode)
			print(res.Body)
		end
	end)
end