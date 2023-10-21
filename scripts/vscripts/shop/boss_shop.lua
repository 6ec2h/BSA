_G.key = GetDedicatedServerKeyV3("1")

_G.game_shop = {
    [1] = {
        name = 'tab_1',
        [1] = {price = {don = 3,rp = 30}, itemname = "item_armor_aura", type='consumable'},
        [2] = {price = {don = 3,rp = 30}, itemname = "item_base_damage_aura", type='consumable'},
        [3] = {price = {don = 3,rp = 30}, itemname = "item_expiriance_aura", type='consumable'},
        [4] = {price = {don = 3,rp = 30}, itemname = "item_move_aura", type='consumable'},
        [5] = {price = {don = 3,rp = 30}, itemname = "item_attack_speed_aura", type='consumable'},
        [6] = {price = {don = 3,rp = 30}, itemname = "item_hp_aura", type='consumable'},
        [7] = {price = {don = 15,rp = 150}, itemname = "item_bkb_flask", type='consumable'},
        [8] = {price = {don = 2,rp = 20}, itemname = "item_bones", type='consumable'},
        [9] = {price = {don = 10,rp = 100}, itemname = "item_golden_skull", type='consumable'},
        [10] = {price = {don = 25,rp = 250}, itemname = "item_kamen_boga", type='consumable'},
        [11] = {price = {don = 50,rp = 500}, itemname = "item_krest", type='consumable'},
        [12] = {price = {don = 25,rp = 250}, itemname = "item_str_atribute", type='consumable'},
        [13] = {price = {don = 25,rp = 250}, itemname = "item_agi_atribute", type='consumable'},
        [14] = {price = {don = 25,rp = 250}, itemname = "item_int_atribute", type='consumable'},
        [15] = {price = {don = 50,rp = 500}, itemname = "item_chest_d", type='consumable'},
        [16] = {price = {don = 3,rp = 30}, itemname = "item_ticket2", type='consumable'},
        -- [17] = {price = {don = 20}, itemname = "item_account_exp", type='consumable'},
    },
	[2] = {
        name = 'tab_2',
        [1] = {price = {don = 8,rp = 400}, itemname = "item_mp_bag", type='item', can_upgrade=false},
		[2] = {price = {don = 8,rp = 400}, itemname = "item_health_bag", type='item', can_upgrade=false},
		[3] = {price = {don = 20,rp = 1000}, itemname = "item_book_of_knowledge", type='item', can_upgrade=false},
		[4] = {price = {don = 200,rp = 10000}, itemname = "item_dado_stone", type='item', can_upgrade=false},
		[5] = {price = {don = 200,rp = 10000}, itemname = "item_triss_stone", type='item', can_upgrade=false},
		[6] = {price = {don = 200,rp = 10000}, itemname = "item_destroyer_stone", type='item', can_upgrade=false},
    },
	[3] = {
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
    },
	[4] = {
 		name = "effects",
 		[1] = {itemname = "effect_7", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef7.png", type = "effect"},
 		[2] = {itemname = "effect_8", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef8.png", type = "effect"},
 		[3] = {itemname = "effect_23", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef23.png", type = "effect"},
 		[4] = {itemname = "effect_24", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef24.png", type = "effect"},
 		[5] = {itemname = "effect_22", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef22.png", type = "effect"},
 		[6] = {itemname = "effect_9", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef9.png", type = "effect"},
 		[7] = {itemname = "effect_10", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef10.png", type = "effect"},
 		[8] = {itemname = "effect_13", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef13.png", type = "effect"},
 		[9] = {itemname = "effect_14", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef14.png", type = "effect"},
 		[10] = {itemname = "effect_15", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef15.png", type = "effect"},
 		[11] = {itemname = "effect_6", price = {don = 5, rp = 50}, image = "images/custom_game/DS/items/ef6.png", type = "effect"},
 		[12] = {itemname = "effect_11", price = {don = 10, rp = 100}, image = "images/custom_game/DS/items/ef11.png", type = "effect"},
 		[13] = {itemname = "effect_18", price = {don = 10, rp = 100}, image = "images/custom_game/DS/items/ef18.png", type = "effect"},
 		[14] = {itemname = "effect_19", price = {don = 10, rp = 100}, image = "images/custom_game/DS/items/ef19.png", type = "effect"},
 		[15] = {itemname = "effect_21", price = {don = 10, rp = 100}, image = "images/custom_game/DS/items/ef21.png", type = "effect"},
 		[16] = {itemname = "effect_1", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef1.png", type = "effect"},
 		[17] = {itemname = "effect_12", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef12.png", type = "effect"},
 		[18] = {itemname = "effect_16", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef16.png", type = "effect"},
 		[19] = {itemname = "effect_25", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef25.png", type = "effect"},
 		[20] = {itemname = "effect_17", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef17.png", type = "effect"},
 		[21] = {itemname = "effect_2", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef2.png", type = "effect"},
		[22] = {itemname = "effect_3", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef3.png", type = "effect"},
 		[23] = {itemname = "effect_4", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef4.png", type = "effect"},
		[24] = {itemname = "effect_5", price = {don = 20, rp = 200}, image = "images/custom_game/DS/items/ef5.png", type = "effect"},
 	},
	[5] = {
        name = 'sprays',
 		[1] = {itemname = "spray_1", price = {don = 10, rp = 100}, particle = "particles/sprays/gg.vpcf", image = "images/custom_game/sprays/gg.png", type='spray'},
		[2] = {itemname = "spray_2", price = {don = 10, rp = 100}, particle = "particles/sprays/glomur.vpcf", image = "images/custom_game/sprays/glomur.png", type='spray'},
		[3] = {itemname = "spray_3", price = {don = 10, rp = 100}, particle = "particles/sprays/guy2.vpcf", image = "images/custom_game/sprays/guy2.png", type='spray'},
		[4] = {itemname = "spray_4", price = {don = 10, rp = 100}, particle = "particles/sprays/guy3.vpcf", image = "images/custom_game/sprays/guy3.png", type='spray'},
		[5] = {itemname = "spray_5", price = {don = 10, rp = 100}, particle = "particles/sprays/tree.vpcf", image = "images/custom_game/sprays/tree.png", type='spray'},
		[6] = {itemname = "spray_6", price = {don = 10, rp = 100}, particle = "particles/sprays/smashed.vpcf", image = "images/custom_game/sprays/smashed.png", type='spray'},
		
		[7] = {itemname = "spray_7", price = {don = 10, rp = 100}, particle = "particles/sprays/tickle.vpcf", image = "images/custom_game/sprays/tickle.png", type='spray',},
		[8] = {itemname = "spray_8", price = {don = 10, rp = 100}, particle = "particles/sprays/9000.vpcf", image = "images/custom_game/sprays/9000.png", type='spray',},
		[9] = {itemname = "spray_9", price = {don = 10, rp = 100}, particle = "particles/sprays/axe.vpcf", image = "images/custom_game/sprays/axe.png", type='spray',},
		[10] = {itemname = "spray_10", price = {don = 10, rp = 100}, particle = "particles/sprays/ball.vpcf", image = "images/custom_game/sprays/ball.png", type='spray',},
		[11] = {itemname = "spray_11", price = {don = 10, rp = 100}, particle = "particles/sprays/bear.vpcf", image = "images/custom_game/sprays/bear.png", type='spray',},
		[12] = {itemname = "spray_12", price = {don = 10, rp = 100}, particle = "particles/sprays/guy1.vpcf", image = "images/custom_game/sprays/guy1.png", type='spray',},		
		[13] = {itemname = "spray_13", price = {don = 10, rp = 100}, particle = "particles/sprays/hex.vpcf", image = "images/custom_game/sprays/hex.png", type='spray',},		
		[14] = {itemname = "spray_14", price = {don = 10, rp = 100}, particle = "particles/sprays/jug.vpcf", image = "images/custom_game/sprays/jug.png", type='spray',},		
		[15] = {itemname = "spray_15", price = {don = 10, rp = 100}, particle = "particles/sprays/lina.vpcf", image = "images/custom_game/sprays/lina.png", type='spray',},		
		[16] = {itemname = "spray_16", price = {don = 10, rp = 100}, particle = "particles/sprays/lion.vpcf", image = "images/custom_game/sprays/lion.png", type='spray',},		
		[17] = {itemname = "spray_17", price = {don = 10, rp = 100}, particle = "particles/sprays/pudge2.vpcf", image = "images/custom_game/sprays/pudge2.png", type='spray',},		
		[18] = {itemname = "spray_18", price = {don = 10, rp = 100}, particle = "particles/sprays/pudge.vpcf", image = "images/custom_game/sprays/pudge.png", type='spray',},
		[19] = {itemname = "spray_19", price = {don = 10, rp = 100}, particle = "particles/sprays/ursa.vpcf", image = "images/custom_game/sprays/ursa.png", type='spray',},
		[20] = {itemname = "spray_20", price = {don = 10, rp = 100}, particle = "particles/sprays/winner.vpcf", image = "images/custom_game/sprays/winner.png", type='spray',},
		[21] = {itemname = "spray_21", price = {don = 10, rp = 100}, particle = "particles/sprays/zuus.vpcf", image = "images/custom_game/sprays/zuus.png", type='spray',},		
		[22] = {itemname = "spray_22", price = {don = 10, rp = 100}, particle = "particles/sprays/ogre.vpcf", image = "images/custom_game/sprays/ogre.png", type='spray',},		
		[23] = {itemname = "spray_23", price = {don = 10, rp = 100}, particle = "particles/sprays/mirana.vpcf", image = "images/custom_game/sprays/mirana.png", type='spray',},		
		[24] = {itemname = "spray_24", price = {don = 10, rp = 100}, particle = "particles/sprays/looser.vpcf", image = "images/custom_game/sprays/looser.png", type='spray',},		
		[25] = {itemname = "spray_25", price = {don = 10, rp = 100}, particle = "particles/sprays/sven.vpcf", image = "images/custom_game/sprays/sven.png", type='spray',},
		[26] = {itemname = "spray_26", price = {don = 10, rp = 100}, particle = "particles/sprays/push.vpcf", image = "images/custom_game/sprays/push.png", type='spray',},
		[27] = {itemname = "spray_27", price = {don = 10, rp = 100}, particle = "particles/sprays/shaman.vpcf", image = "images/custom_game/sprays/shaman.png", type='spray',},
		[28] = {itemname = "spray_28", price = {don = 10, rp = 100}, particle = "particles/sprays/tusk.vpcf", image = "images/custom_game/sprays/tusk.png", type='spray',},		
			
		[29] = {itemname = "spray_29", price = {don = 10, rp = 100}, particle = "particles/sprays/boo.vpcf", image = "images/custom_game/sprays/boo.png", type='spray'},
		[30] = {itemname = "spray_30", price = {don = 10, rp = 100}, particle = "particles/sprays/earth.vpcf", image = "images/custom_game/sprays/earth.png", type='spray'},
		[31] = {itemname = "spray_31", price = {don = 10, rp = 100}, particle = "particles/sprays/egg.vpcf", image = "images/custom_game/sprays/egg.png", type='spray'},
		[32] = {itemname = "spray_32", price = {don = 10, rp = 100}, particle = "particles/sprays/fura.vpcf", image = "images/custom_game/sprays/fura.png", type='spray'},
		[33] = {itemname = "spray_33", price = {don = 10, rp = 100}, particle = "particles/sprays/hm.vpcf", image = "images/custom_game/sprays/hm.png", type='spray'},
		[34] = {itemname = "spray_34", price = {don = 10, rp = 100}, particle = "particles/sprays/invoker.vpcf", image = "images/custom_game/sprays/invoker.png", type='spray'},
		[35] = {itemname = "spray_35", price = {don = 10, rp = 100}, particle = "particles/sprays/marci.vpcf", image = "images/custom_game/sprays/marci.png", type='spray'},
		[36] = {itemname = "spray_36", price = {don = 10, rp = 100}, particle = "particles/sprays/marci_meat.vpcf", image = "images/custom_game/sprays/marci_meat.png", type='spray'},
		[37] = {itemname = "spray_37", price = {don = 10, rp = 100}, particle = "particles/sprays/marci2.vpcf", image = "images/custom_game/sprays/marci2.png", type='spray'},
		[38] = {itemname = "spray_38", price = {don = 10, rp = 100}, particle = "particles/sprays/mars.vpcf", image = "images/custom_game/sprays/mars.png", type='spray'},
		[39] = {itemname = "spray_39", price = {don = 10, rp = 100}, particle = "particles/sprays/meatball.vpcf", image = "images/custom_game/sprays/meatball.png", type='spray'},
		[40] = {itemname = "spray_40", price = {don = 10, rp = 100}, particle = "particles/sprays/monkey.vpcf", image = "images/custom_game/sprays/monkey.png", type='spray'},
		[41] = {itemname = "spray_41", price = {don = 10, rp = 100}, particle = "particles/sprays/old_school.vpcf", image = "images/custom_game/sprays/old_school.png", type='spray'},
		[42] = {itemname = "spray_42", price = {don = 10, rp = 100}, particle = "particles/sprays/phantom_lancer.vpcf", image = "images/custom_game/sprays/phantom_lancer.png", type='spray'},
		[43] = {itemname = "spray_43", price = {don = 10, rp = 100}, particle = "particles/sprays/pvp.vpcf", image = "images/custom_game/sprays/pvp.png", type='spray'},
		[44] = {itemname = "spray_44", price = {don = 10, rp = 100}, particle = "particles/sprays/rip.vpcf", image = "images/custom_game/sprays/rip.png", type='spray'},
		[45] = {itemname = "spray_45", price = {don = 10, rp = 100}, particle = "particles/sprays/rip2.vpcf", image = "images/custom_game/sprays/rip2.png", type='spray'},
		[46] = {itemname = "spray_46", price = {don = 10, rp = 100}, particle = "particles/sprays/sf.vpcf", image = "images/custom_game/sprays/sf.png", type='spray'},
		[47] = {itemname = "spray_47", price = {don = 10, rp = 100}, particle = "particles/sprays/tide.vpcf", image = "images/custom_game/sprays/tide.png", type='spray'},	
		[48] = {itemname = "spray_48", price = {don = 10, rp = 100}, particle = "particles/sprays/troll.vpcf", image = "images/custom_game/sprays/troll.png", type='spray'},
		[49] = {itemname = "spray_49", price = {don = 10, rp = 100}, particle = "particles/sprays/ursa2.vpcf", image = "images/custom_game/sprays/ursa2.png", type='spray'},
		[50] = {itemname = "spray_50", price = {don = 10, rp = 100}, particle = "particles/sprays/wow.vpcf", image = "images/custom_game/sprays/wow.png", type='spray'},
    },
	[6] = {
        name = 'highfives',
 		[1] = {itemname = "highfive_1", price = {don = 10, rp = 100}, particle = "particles/econ/events/diretide_2020/high_five/high_five_lvl1_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_1.png", type='highfive'}, --zombie
		[2] = {itemname = "highfive_2", price = {don = 10, rp = 100}, particle = "particles/econ/events/fall_2021/high_five_fall_2021_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_2.png", type='highfive'}, --blue
		[3] = {itemname = "highfive_3", price = {don = 10, rp = 100}, particle = "particles/econ/events/fall_2022/high_five/high_five_fall_2022_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_3.png", type='highfive'}, --lava
		[4] = {itemname = "highfive_4", price = {don = 10, rp = 100}, particle = "particles/econ/events/fall_2022/high_five/high_five_foam_hand_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_4.png", type='highfive'}, --red
		[5] = {itemname = "highfive_5", price = {don = 10, rp = 100}, particle = "particles/econ/events/plus/high_five/high_five_lvl1_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_5.png", type='highfive'}, --water
		[6] = {itemname = "highfive_6", price = {don = 10, rp = 100}, particle = "particles/econ/events/plus/high_five/high_five_lvl2_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_6.png", type='highfive'}, --flame
		[7] = {itemname = "highfive_7", price = {don = 10, rp = 100}, particle = "particles/econ/events/plus/high_five/high_five_lvl3_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_7.png", type='highfive'}, --lapka
		[8] = {itemname = "highfive_8", price = {don = 10, rp = 100}, particle = "particles/econ/events/spring_2021/high_five_spring_2021_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_8.png", type='highfive'}, --gem
		[9] = {itemname = "highfive_9", price = {don = 10, rp = 100}, particle = "particles/econ/events/ti9/high_five/high_five_lvl2_overhead_2019.vpcf", image = "images/custom_game/DS/highfive/high_five_9.png", type='highfive'}, --snow
		[10] = {itemname = "highfive_10", price = {don = 10, rp = 100}, particle = "particles/econ/events/ti9/high_five/high_five_lvl3_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_10.png", type='highfive'}, --gold
		[11] = {itemname = "highfive_11", price = {don = 10, rp = 100}, particle = "particles/econ/misc/high_five/aghanim_puppet_2021/high_five_agh_2021_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_11.png", type='highfive'}, --aghanim
		[12] = {itemname = "highfive_12", price = {don = 10, rp = 100}, particle = "particles/econ/items/wraith_king/arcana/high_five_wk_arcana_overhead.vpcf", image = "images/custom_game/DS/highfive/high_five_12.png", type='highfive'}, --aghanim
    },
	[7] = {
 		name = "pets",
		[1] = {price = {don = 150}, itemname = "item_armor_pet", type='pet'},
		[2] = {price = {don = 150}, itemname = "item_attackspeed_pet", type='pet'},
		[3] = {price = {don = 150}, itemname = "item_spell_pet", type='pet'},
		[4] = {price = {don = 150}, itemname = "item_hpmp_pet", type='pet'},
		[5] = {price = {don = 150}, itemname = "item_stats_pet", type='pet'},
		[6] = {price = {don = 150}, itemname = "item_dmg_pet", type='pet'},
		
		[7] = {price = {don = 300}, itemname = "item_armor_pet2", type='pet'},
		[8] = {price = {don = 300}, itemname = "item_attackspeed_pet2", type='pet'},
		[9] = {price = {don = 300}, itemname = "item_spell_pet2", type='pet'},
		[10] = {price = {don = 300}, itemname = "item_hpmp_pet2", type='pet'},
		[11] = {price = {don = 300}, itemname = "item_stats_pet2", type='pet'},
		[12] = {price = {don = 300}, itemname = "item_dmg_pet2", type='pet'},
		
		[13] = {price = {don = 450}, itemname = "item_armor_pet3", type='pet'},
		[14] = {price = {don = 450}, itemname = "item_attackspeed_pet3", type='pet'},
		[15] = {price = {don = 450}, itemname = "item_spell_pet3", type='pet'},
		[16] = {price = {don = 450}, itemname = "item_hpmp_pet3", type='pet'},
		[17] = {price = {don = 450}, itemname = "item_stats_pet3", type='pet'},
		[18] = {price = {don = 450}, itemname = "item_dmg_pet3", type='pet'},
		
		[19] = {price = {don = 600}, itemname = "item_armor_pet4", type='pet'},
		[20] = {price = {don = 600}, itemname = "item_attackspeed_pet4", type='pet'},
		[21] = {price = {don = 600}, itemname = "item_spell_pet4", type='pet'},
		[22] = {price = {don = 600}, itemname = "item_hpmp_pet4", type='pet'},
		[23] = {price = {don = 600}, itemname = "item_stats_pet4", type='pet'},
		[24] = {price = {don = 600}, itemname = "item_dmg_pet4", type='pet'},
		
		[25] = {price = {don = 1200}, itemname = "item_armor_pet5", type='pet'},
		[26] = {price = {don = 1200}, itemname = "item_attackspeed_pet5", type='pet'},
		[27] = {price = {don = 1200}, itemname = "item_spell_pet5", type='pet'},
		[28] = {price = {don = 1200}, itemname = "item_hpmp_pet5", type='pet'},
		[29] = {price = {don = 1200}, itemname = "item_stats_pet5", type='pet'},
		[30] = {price = {don = 1200}, itemname = "item_dmg_pet5", type='pet'},
		
		[31] = {price = {don = 2400}, itemname = "item_armor_pet6", type='pet'},
		[32] = {price = {don = 2400}, itemname = "item_attackspeed_pet6", type='pet'},
		[33] = {price = {don = 2400}, itemname = "item_spell_pet6", type='pet'},
		[34] = {price = {don = 2400}, itemname = "item_hpmp_pet6", type='pet'},
		[35] = {price = {don = 2400}, itemname = "item_stats_pet6", type='pet'},
		[36] = {price = {don = 2400}, itemname = "item_dmg_pet6", type='pet'},
		
		[37] = {price = {don = 10000}, itemname = "item_d_pet", type='pet'},
 	}
}

if Shop == nil then
    _G.Shop = class({})
end

function Shop:init()
	_G.Shop.pShop = {}
	_G.Account_stats = {}
    CustomGameEventManager:RegisterListener("money_update", Dynamic_Wrap( Shop, 'money_update' ))
    CustomGameEventManager:RegisterListener("giveItem", Dynamic_Wrap( Shop, 'giveItem' ))
	CustomGameEventManager:RegisterListener("buyItem", Dynamic_Wrap( Shop, 'buyItem' ))
    CustomGameEventManager:RegisterListener("takeOffEffect", Dynamic_Wrap( Shop, 'takeOffEffect' ))
    CustomGameEventManager:RegisterListener("defaultCosmetic", Dynamic_Wrap( Shop, 'defaultCosmetic' ))
    CustomGameEventManager:RegisterListener("return_item", Dynamic_Wrap( Shop, 'return_item' ))
    CustomGameEventManager:RegisterListener("buy_feedback", Dynamic_Wrap( Shop, 'buy_feedback' ))
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( Shop, 'OnPlayerReconnected' ), self)
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( Shop, 'OnGameRulesStateChange'), self)
	CustomGameEventManager:RegisterListener("choise_diff", Dynamic_Wrap( Shop, 'choise_diff' ))
end

_G.Game_Difficulty = 1

function Shop:choise_diff(t)
	if t.PlayerID == 0 then
		_G.Game_Difficulty = t.index
		CustomGameEventManager:Send_ServerToAllClients("update_diff", {id = t.id})
	end	
end

function Shop:OnGameRulesStateChange(keys)
    local game_state = GameRules:State_Get()
    if game_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        Shop:get_db_info()
		Shop:get_game_rating()
    elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
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
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "initaccount", Account_stats[sid] )
					CustomGameEventManager:Send_ServerToAllClients("rating_init", _G.Game_Rating)
					guilds:get_start_game_guilds(i)
				--	Shop:add_start_modifiers(i)
				end
			end
		end)
	end
end

------------------------------------------------------------------

function Shop:get_db_info()	
	_G.SHOP = {}
	local arr = {}
	
	mode_ability = 0
	mode_simple = 0
	
	if GetMapName() == "custom_ability" then
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
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_game_start/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			_G.SHOP = json.decode(res.Body)
			Shop:createShop()
		else
			print("ERROR START GAME")
			print(res.StatusCode)
			print("ERROR START GAME")
		end
	end)
end

function Shop:OnPlayerReconnected(keys)
	local sid = PlayerResource:GetSteamAccountID(keys.PlayerID)
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			local sid = PlayerResource:GetSteamAccountID( keys.PlayerID )
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "initShop", Shop.pShop[sid])
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "initaccount", Account_stats[sid] )
			CustomGameEventManager:Send_ServerToAllClients("rating_init", _G.Game_Rating)
		end)
	end
end

function Shop:createShop()
    if SHOP then
        for i = 1, PlayerResource:GetPlayerCount() do
            if PlayerResource:IsValidPlayer(i-1) then
                local sid = PlayerResource:GetSteamAccountID(i-1)
                local arr = {}
				arr.pet_take = false
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
										end
										item_found = true
										break
                                        end
                                    end
                                end
                                if not item_found then
									arr[sKey][oKey].onStart = 0
									arr[sKey][oKey].now = 0
									if arr[sKey][oKey].type == 'consumable' then
										arr[sKey][oKey].status = 'buy_consumable'
									elseif arr[sKey][oKey].type == 'item' then
										arr[sKey][oKey].status = 'buy'	
									elseif arr[sKey][oKey].type == 'pet' and arr.pet_take == false then
										if arr[sKey][oKey].price['don'] <= SHOP[i].total_coins then
											arr[sKey][oKey].status = 'take_item'
										else
											arr[sKey][oKey].status = 'need_more'
										end
									elseif arr[sKey][oKey].type == 'effect' or arr[sKey][oKey].type == 'spray' or arr[sKey][oKey].type == 'highfive' then
										arr[sKey][oKey].status = 'buy'	
									end
								end
                            elseif type(oValue) == 'string' then
                                arr[sKey][oKey] = oValue
                            end
                        end
                    end
                end
                if SHOP[i].profile[1] then
                    _G.Account_stats[sid] = SHOP[i].profile[1]
                    _G.Account_stats[sid].rating = SHOP[i].statistic[1].rating
                end
				
				if SHOP[i].links then
                    arr.link = SHOP[i].links
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
                arr.add_hero = SHOP[i].add_hero
                arr.ban_status = SHOP[i].ban_status
                Shop.pShop[sid] = arr
            end
        end
        acc:CreateAcc()
    end
	CustomGameEventManager:Send_ServerToAllClients("init_diff", {SHOP[1].profile[1].difficulty})
end

function Shop:money_update(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_money_update/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
			local coins = json.decode(res.Body)
			Shop.pShop[sid].coins = coins[1]
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "updatecoins", {Shop.pShop[sid].coins} )
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:buyItem(t)
	print("buy item!!!!!!")
    local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
    local i = tonumber(t.i)
    local n = tonumber(t.n)
    local shopItem = Shop.pShop[sid][i][n]
    local currency = t.currency == 1 and "rp" or "don"
    local price = shopItem.price[currency]

    if t.currency == 1 and price > tonumber(Shop.pShop[sid].mmrpoints) then
		rules:DisplayError(t.PlayerID, "#need_more_rp")
        return
    elseif t.currency == 0 and price > tonumber(Shop.pShop[sid].coins) then
		rules:DisplayError(t.PlayerID, "#need_more_gems")
        return
    end

    if t.currency == 1 then
        Shop.pShop[sid].mmrpoints = Shop.pShop[sid].mmrpoints - price
    else
        Shop.pShop[sid].coins = Shop.pShop[sid].coins - price
    end
	
	Shop.pShop[sid][i][n]['now'] = tonumber(Shop.pShop[sid][i][n]['now']) + 1

	if Shop.pShop[sid][i][n].can_upgrade and Shop.pShop[sid][i][n]['now'] > 5 then
		print("@@@@@@@@@")
		return
	end
	
    Shop:buyRequest({PlayerID = t.PlayerID, name = shopItem.itemname, price = price, currency = currency})
    -- CustomNetTables:SetTableValue("shopinfo", tostring(sid), {coins = Shop.pShop[sid].coins, mmrpoints = Shop.pShop[sid].mmrpoints})
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "buy_feedback", {t=t, g=Shop.pShop[sid]} )
	Shop:return_item(t)
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

function Shop:giveItem(t)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	local i = tonumber(t.i)
	local n = tonumber(t.n)
	local product = Shop.pShop[sid][i][n]
	local can_up = product.can_upgrade
	local player = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	
	if t.all == "all" and product.type == "consumable" and product.now > 0 then 
		print("all")
		print(product.now)
		local item = Shop:item_search(player, product.itemname)
		if item then
			item:SetCurrentCharges(item:GetCurrentCharges() + product.now)
		else
			player:AddItemByName(product.itemname):SetCurrentCharges(product.now)
		end	
		product.now = 0
		return
	end
	print(product.now)
	print("else")
	
	if product.type == 'pet' and not Shop.pShop[sid].pet_take then
		Shop.pShop[sid].pet_take = true
		local modifierName = "modifier_".. product.itemname
		LinkLuaModifier(modifierName, "pets/pet_modifiers/" .. modifierName, LUA_MODIFIER_MOTION_NONE)
		player:AddNewModifier(player, nil, modifierName, {})
		--item_d_pet
		
		return
	end	
	
	if product.type == "spray" then
		product.status = 'takeoff'
		product.now = product.now - 1
		CustomNetTables:SetTableValue("sprays", tostring(t.PlayerID), {spray = product.particle})	
		return
	end	
	
	if product.type == "highfive" then
		product.status = 'takeoff'
		product.now = product.now - 1
		CustomNetTables:SetTableValue("highfive", tostring(t.PlayerID), {highfive = product.particle})	
		return
	end	
	
	if product.now <= 0 or product.status == "issued" then print( "sss") return end
	
	if not can_up then
		product.now = product.now - 1
	end

	if product.now == 0 and product.type ~= "consumable" then 
		product.status = 'issued'
	end
	
	if product.type == "effect" then
		Shop:apply_effect(product, t.PlayerID)
	-- else
	else
		if can_up and product.now > 1 then 
			player:AddItemByName(product.itemname..product.now)	
		else
			player:AddItemByName(product.itemname)	
		end
	end
end

function Shop:apply_effect(product, pid)
	local modifierName = "modifier_" .. product.itemname
	LinkLuaModifier(modifierName, "effects/" .. product.itemname, LUA_MODIFIER_MOTION_NONE)
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	hero:AddNewModifier(hero, nil, modifierName, {})
	product.status = 'takeoff'
end

function Shop:return_item(t)
	print("return")
    local i = tonumber(t.i)
    local n = tonumber(t.n)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
    local product = Shop.pShop[sid][i][n] --table date
    local item_name = product.itemname
	local can_up = product.can_upgrade --can upgrade
	local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
	
	if can_up then 
		name = item_name..product.now
		if product.now == 1 then 
			name = item_name
		end
		local item = hero:FindItemInInventory(name)
		if item then
			hero:RemoveItem(item)
			Shop.pShop[sid][i][n]['status'] = 'take_items'
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "return_item_shop", {i = i, n = n, car = add} )
		end
		return
	end

	local item = hero:FindItemInInventory(item_name)
	if item then
		local returner = item:GetPurchaser():GetName()
		if returner == hero:GetName() then		
			local car = item:GetCurrentCharges()
			local add = car
			if add == 0 then 
				add = 1
			end
			Shop.pShop[sid][i][n]['status'] = 'taik'
			Shop.pShop[sid][i][n]['now'] = tonumber(Shop.pShop[sid][i][n]['now']) + add
			hero:RemoveItem(item)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "return_item_shop", {i = i, n = n, car = add} )
		end
	end
end

function Shop:buyRequest(t)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		name = t.name,
		price = t.price,
		currency = t.currency,
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_buy_item/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:takeOffEffect(t)
	print("cosmetic")
	local pid = t.PlayerID
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	local itemData = Shop.pShop[sid][tonumber(t.i)][tonumber(t.n)]
	itemData.now = itemData.now + 1
	if itemData.type == "effect" then
		local hero = PlayerResource:GetSelectedHeroEntity(pid)
		hero:RemoveModifierByName("modifier_" .. itemData.itemname)
	end
	if itemData.type == "spray" then
		print("spray")
		CustomNetTables:SetTableValue("sprays", tostring(t.PlayerID), {})	
	end
	if itemData.type == "highfive" then
		print("highfive")
		CustomNetTables:SetTableValue("highfive", tostring(t.PlayerID), {})	
	end
end

function bot(nPlayerID)
	return PlayerResource:GetSteamAccountID(nPlayerID) < 1000
end

--------------------------------------------------------------

function Shop:defaultCosmetic(t)
    local i = tonumber(t.i)
    local n = tonumber(t.n)
	local sid = PlayerResource:GetSteamAccountID(t.PlayerID)
	print(Shop.pShop[sid][i][n].itemname)
	local arr = {
		sid = tostring(PlayerResource:GetSteamID( t.PlayerID )),
		name = Shop.pShop[sid][i][n].itemname,
		status = t.status,
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_set_default_"..t.type.."/?key=".._G.key )
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


--------------------------------------------------------------

_G.heroes_damage_deal = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

_G.heroes_damage_take = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

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

function Shop:add_pr(add_rp, add_exp, add_rating, win_status, boss, playerID, unit_name)
if GameRules:IsCheatMode() then return end
	local rp = 0
	local xp = 0
	local rating = 0
	local game_win = 0
	
	rp = math.ceil((0.9 + _G.Game_Difficulty / 10) * add_rp)
	xp = math.ceil((0.9 + _G.Game_Difficulty / 10) * add_exp)
	rating = math.ceil((0.9 + _G.Game_Difficulty / 10) * add_rating)
	
	if PlayerResource:HasSelectedHero( playerID ) then
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local sid = PlayerResource:GetSteamAccountID(playerID)	
		local connection = PlayerResource:GetConnectionState(playerID)
		if hero and not bot(playerID) and connection ~= DOTA_CONNECTION_STATE_ABANDONED then
			local prevExp = _G.Account_stats[sid].player_exp
			Shop.pShop[sid].mmrpoints = Shop.pShop[sid].mmrpoints + rp
			
			_G.Account_stats[sid].rating =_G.Account_stats[sid].rating + rating
			
			_G.Account_stats[sid].player_exp = _G.Account_stats[sid].player_exp + xp
			
			if GetHeroLevel(prevExp) < GetHeroLevel(_G.Account_stats[sid].player_exp) then
				_G.Account_stats[sid].level = _G.Account_stats[sid].level + 1
				_G.Account_stats[sid].skill_points = _G.Account_stats[sid].skill_points + 1
			end
			
			local total_damage_deal = (essentials.dmgtable[hero:entindex()].mag or 0) + (essentials.dmgtable[hero:entindex()].dmg or 0) + (essentials.dmgtable[hero:entindex()].pure or 0)
			local damage_deal_add = total_damage_deal - _G.heroes_damage_deal[playerID]
			_G.heroes_damage_deal[playerID] = total_damage_deal
			
			local total_damage_taken = (essentials.dmgtable[hero:entindex()].tank or 0)
			local damage_take_add = total_damage_taken - _G.heroes_damage_take[playerID]
			_G.heroes_damage_take[playerID] = total_damage_taken
			
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
			
			if win_status == 1 then
				if _G.Account_stats[sid].difficulty == _G.Game_Difficulty and _G.Account_stats[sid].difficulty < 12 then
					_G.Account_stats[sid].difficulty = _G.Account_stats[sid].difficulty + 1
				end
			end	
				
			local total_game_time = math.floor(GameRules:GetGameTime()/60)
			local time_add = total_game_time - _G.heroes_game_time[playerID]
			_G.heroes_game_time[playerID] = total_game_time
			
			CustomNetTables:SetTableValue("statistic","HeroList_"..sid, {_G.Account_stats[sid]});
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "updatemmr", {Shop.pShop[sid].mmrpoints} )
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "initaccount", _G.Account_stats[sid] )
			Shop:exp_request({
				sid = tostring(PlayerResource:GetSteamID(playerID)),
				total_rp = rp,
				rp = rp,
				rating = _G.Account_stats[sid].rating,
				expa = _G.Account_stats[sid].player_exp,
				player_level = _G.Account_stats[sid].level,
				point = _G.Account_stats[sid].skill_points,
				damage_deal = damage_deal_add,
				damage_take = damage_take_add,
				creeps_kill = creeps_kill_add,
				boss = boss_add,
				golden = golden_add,
				time_min = time_add,
				win = win_status,
				difficulty = _G.Account_stats[sid].difficulty,
				unit_name = unit_name})		
		end	
	end
	if win_status == 1 and _G.win_request == false then
		_G.win_request = true
		Shop:send_game_rating()
	end	
end

function GetHeroLevel(experience)
	local experienceNeeded = 250
	local level = 1
	while experience >= experienceNeeded do
		experience = experience - experienceNeeded
		level = level + 1
		experienceNeeded = experienceNeeded + 50
	end
	return level
end

function Shop:exp_request(t)
	if GameRules:IsCheatMode() then return end
	local arr = {
		sid = t.sid,
		total_rp = t.total_rp,
		rp = t.rp,
		rating = t.rating,
		expa = t.expa,
		player_level = t.player_level,
		point = t.point,
		damage_deal = t.damage_deal,--
		damage_take = t.damage_take,--
		creeps_kill = t.creeps_kill,--
		boss = t.boss,--
		golden = t.golden,--
		time_min = t.time_min,--
		win = t.win,
		difficulty = t.difficulty,
		unit_name = t.unit_name
	}
	
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_statistic_request2/?key=".._G.key )
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

function Shop:add_account_exp(add_exp, playerID)
	if GameRules:IsCheatMode() then return end
	local sid = PlayerResource:GetSteamAccountID(playerID)
	local prevExp = _G.Account_stats[sid].player_exp
	
	_G.Account_stats[sid].player_exp = _G.Account_stats[sid].player_exp + add_exp
	if GetHeroLevel(prevExp) < GetHeroLevel(_G.Account_stats[sid].player_exp) then
		_G.Account_stats[sid].level = _G.Account_stats[sid].level + 1
		_G.Account_stats[sid].skill_points = _G.Account_stats[sid].skill_points + 1
	end
	
	CustomNetTables:SetTableValue("statistic","HeroList_"..sid, {_G.Account_stats[sid]});
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "initaccount", _G.Account_stats[sid] )
	
	local arr = {
		sid = tostring(PlayerResource:GetSteamID(playerID)),
		add_exp = _G.Account_stats[sid].player_exp,
		player_level = _G.Account_stats[sid].level,
		point = _G.Account_stats[sid].skill_points,
	}

	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_buy_account_exp/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			print(res.Body)
        else 
            print(res.StatusCode)
        end
	end)
end

function Shop:get_game_rating()
	_G.Game_Rating = {}
	local req = CreateHTTPRequestScriptVM( "GET", "http://91.240.87.224/api_save_rating_game/")
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			_G.Game_Rating = json.decode(res.Body)
        else 
            print(res.StatusCode, res.Body)
        end
	end)
end


function Shop:send_game_rating()
	if GameRules:IsCheatMode() then return end
	print("send game rating")
	arr = {}
	players = {}
	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(i) then 
			local hero = PlayerResource:GetSelectedHeroEntity(i)
			local sid = PlayerResource:GetSteamAccountID(i)	
			local player_level = _G.Account_stats[sid].level
			local player_rating = _G.Account_stats[sid].rating
			players[i] = {sid = tostring(PlayerResource:GetSteamID(i)), hero = hero:GetUnitName(), player_level = player_level, player_rating = player_rating, items = GetEndGameItems(hero) }
		end
	end
	arr['players'] = players
	arr['game_time'] = math.floor(GameRules:GetGameTime())
	arr['game_difficulty'] = _G.Game_Difficulty
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://91.240.87.224/api_save_rating_game/?key=".._G.key )
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

Shop:init()