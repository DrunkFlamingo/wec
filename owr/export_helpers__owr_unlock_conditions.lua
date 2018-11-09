

--this function uses CA's rite condition loading function to load custom conditions for OWR.
local function owr_rite_unlock_listeners()
    out("test1");
    
    OWRLOG("Starting Rite Unlocks");
    out("test2");
    local rite_templates = {

        --BEASTMEN--
        --Vicious Shadows--
        --win an ambush battle
        {
            ["subculture"] = "wh_dlc03_sc_bst_beastmen",
            ["rite_name"] = "wh_main_ritual_bst_vicious_shadows",
            ["event_name"] = "CharacterCompletedBattle",
            ["condition"] =
            function(context, --: WHATEVER
            faction_name --: string 	
            )
                    local character = context:character() --:CA_CHAR
                    local pb = context:pending_battle() --:CA_PENDING_BATTLE
                    --# assume character: CA_CHAR
                    --# assume pb: CA_PENDING_BATTLE
                    return character:faction():name() == faction_name and pb:ambush_battle() and character == pb:attacker() and character:won_battle();
            end
        },

        --Vicious Heart--
        --get bray shaman to level 10
        {
            ["subculture"] = "wh_dlc03_sc_bst_beastmen",
            ["rite_name"] = "wh_main_ritual_bst_vicious_heart",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character() --:CA_CHAR
                    
                    return character:faction():name() == faction_name and character:character_type("wizard") and character:rank() >= 10;
                end
        },
        --Vicious Herd--
        --build wh_dlc03_horde_beastmen_gors_4
        {
            ["subculture"] = "wh_dlc03_sc_bst_beastmen",
            ["rite_name"] = "wh_main_ritual_bst_vicious_herd",
            ["event_name"] = "MilitaryForceBuildingCompleteEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    return context:building() == "wh_dlc03_horde_beastmen_gors_4" and context:character():faction():is_human();
                end
        },

        --Vicious Demise--
        --raze 10 settlements
        {
            ["subculture"] = "wh_dlc03_sc_bst_beastmen",
            ["rite_name"] = "wh_main_ritual_bst_vicious_demise",
            ["event_name"] = "CharacterRazedSettlement",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                
                    if context:character():faction():name() == faction_name then
                
                        local raze_count = cm:get_saved_value("wh_main_ritual_bst_vicious_demise_count");
                        if raze_count == nil then raze_count = 0 end
                        raze_count = raze_count + 1;
                        cm:set_saved_value("wh_main_ritual_bst_vicious_demise_count", raze_count);
                
                        return raze_count >= 10
                    end
                    return false; 
                
                end
        },

        --VAMPIRES--
        --Intrigue--
        --NAP w/ Emp
        {
            ["subculture"] = "wh_main_sc_vmp_vampire_counts",
            ["rite_name"] = "wh_main_ritual_vmp_intrigue",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                                    
                    return context:faction():name() == faction_name and context:faction():has_technology("tech_vmp_blood_07")
                end
        },
        
        --Willpower--
        --build wh_main_vmp_balefire_3
        {
            ["subculture"] = "wh_main_sc_vmp_vampire_counts",
            ["rite_name"] = "wh_main_ritual_vmp_willpower",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building() --:CA_BUILDING
                    
                    return building:faction():name() == faction_name and building:name() == "wh_main_vmp_balefire_3";
                end
        },
        {
            ["subculture"] = "wh_main_sc_vmp_vampire_counts",
            ["rite_name"] = "wh_main_ritual_vmp_willpower",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region() --:CA_REGION
                    
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_vmp_balefire_3");
                end
        },
        
        --Strength--
        --win 5 battles	
        {
            ["subculture"] = "wh_main_sc_vmp_vampire_counts",
            ["rite_name"] = "wh_main_ritual_vmp_strength",
            ["event_name"] = "CharacterCompletedBattle",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local victory_count = cm:get_saved_value("wh_main_ritual_vmp_strength_count");
                    if victory_count == nil then victory_count = 0 end
                    
                    if context:character():faction():name() == faction_name and context:character():won_battle() then
                        victory_count = victory_count + 1;
                        cm:set_saved_value("wh_main_ritual_vmp_strength_count", victory_count);
                    end
                
                    return victory_count >= 5;
                end
        },

        --Dominance--
        --level 7 faction leader
        {
            ["subculture"] = "wh_main_sc_vmp_vampire_counts",
            ["rite_name"] = "wh_main_ritual_vmp_dominance",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character() --:CA_CHAR
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end
        },
        
        --DWARFS--
        --Guilds--
        --research tech_dwf_civ_3_3
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_guilds",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                                    
                    return context:faction():name() == faction_name and context:faction():has_technology("tech_dwf_civ_3_3")
                end
        },

        --Holds--
        --own 6 settlements
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_holds",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local faction = context:character():faction() --:CA_FACTION
                    
                    return faction:name() == faction_name and faction:region_list():num_items() >= 6;
                end
        },		
        
        --Underway--
        --level 7 faction leader
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_underway",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character() --:CA_CHAR
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end
        },		
        
        --Oath--
        --build wh_main_dwf_slayer_2
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_oath",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building() --:CA_BUILDING
                    
                    return building:faction():name() == faction_name and building:name() == "wh_main_dwf_slayer_2";
                end
        },
        --Oath secondary--
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_oath",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region() --:CA_REGION
                    
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_dwf_slayer_2");
                end
        },


        -------Temporarily removed due to some tech issues

        --KRAKA DRAK--
        --Guilds--
        --research kraka_tech4_ancestors
        --[[{
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_guilds",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                                    
                    return context:faction():name() == faction_name and context:faction():has_technology("kraka_tech4_ancestors")
                end,
            ["faction_name"] = "wh_main_dwf_kraka_drak"
        },

        --Holds--
        --own 6 settlements
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_holds",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local faction = context:character():faction();
                    
                    return faction:name() == faction_name and faction:region_list():num_items() >= 6;
                end,
            ["faction_name"] = "wh_main_dwf_kraka_drak"
        },		
        
        --Underway--
        --level 7 faction leader
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_underway",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end,
            ["faction_name"] = "wh_main_dwf_kraka_drak"
        },		
        
        --Oath--
        --build wh_main_dwf_slayer_2
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_oath",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    
                    return building:faction():name() == faction_name and building:name() == "wh_main_dwf_slayer_2";
                end,
            ["faction_name"] = "wh_main_dwf_kraka_drak"
        },
        --Oath secondary--
        {
            ["subculture"] = "wh_main_sc_dwf_dwarfs",
            ["rite_name"] = "wh_main_ritual_dwf_oath",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region();
                    
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_dwf_slayer_2");
                end,
            ["faction_name"] = "wh_main_dwf_kraka_drak"
        },]]		


        ---EMPIRE---
        --Gunpowder
        --build wh_main_emp_forges_3
        {
            ["subculture"] = "wh_main_sc_emp_empire",
            ["rite_name"] = "wh_main_ritual_emp_gunpowder",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building() --:CA_BUILDING
                    
                    return building:faction():name() == faction_name and building:name() == "wh_main_emp_forges_3";
                end
        },
        --Gunpowder secondary--
        {
            ["subculture"] = "wh_main_sc_emp_empire",
            ["rite_name"] = "wh_main_ritual_emp_gunpowder",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region() --:CA_REGION
                    
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_emp_forges_3");
                end
        },		
        
        --Faith
        --perform action w/ wizard
        {
            ["subculture"] = "wh_main_sc_emp_empire",
            ["rite_name"] = "wh_main_ritual_emp_faith",
            ["event_name"] = "CharacterCharacterTargetAction",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character() --:CA_CHAR
                    
                    return character:faction():name() == faction_name and character:character_type("wizard");
                end
        },
        {
            ["subculture"] = "wh_main_sc_emp_empire",
            ["rite_name"] = "wh_main_ritual_emp_faith",
            ["event_name"] = "CharacterGarrisonTargetAction",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character() --:CA_CHAR
                    
                    return character:faction():name() == faction_name and character:character_type("wizard");
                end
        },
        
        --Steel
        --own 20 units
        {
            ["subculture"] = "wh_main_sc_emp_empire",
            ["rite_name"] = "wh_main_ritual_emp_steel",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local faction = context:faction() --:CA_FACTION
                    
                    if faction:name() == faction_name then
                        local mf_list = faction:military_force_list();
                        local units = 0 --:number
                        
                        for i = 0, mf_list:num_items() - 1 do
                            local current_mf = mf_list:item_at(i);
                            
                            if current_mf:has_general() and not current_mf:is_armed_citizenry() then
                                units = units + current_mf:unit_list():num_items();
                            end;
                        end;
                        
                        return units > 19;
                    end;
                end
        },

        --Policy
        --faction leader rank 7
        {
            ["subculture"] = "wh_main_sc_emp_empire",
            ["rite_name"] = "wh_main_ritual_emp_policy",			
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end
        },

        ----------------
        ---GREENSKINS---
        ----------------
        
        --WAAAAGH!
        --own 40 units
        {
            ["subculture"] = "wh_main_sc_grn_greenskins",
            ["rite_name"] = "wh_main_ritual_grn_waaagh",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local faction = context:faction();
                    
                    if faction:name() == faction_name then
                        local mf_list = faction:military_force_list();
                        local units = 0;
                        
                        for i = 0, mf_list:num_items() - 1 do
                            local current_mf = mf_list:item_at(i);
                            
                            if current_mf:has_general() and not current_mf:is_armed_citizenry() then
                                units = units + current_mf:unit_list():num_items();
                            end;
                        end;
                        
                        return units > 39;
                    end;
                end
        },
        
        --Da Bad Moon
        --fight ambush battle
        {
            ["subculture"] = "wh_main_sc_grn_greenskins",
            ["rite_name"] = "wh_main_ritual_grn_badmoon",
            ["event_name"] = "CharacterCompletedBattle",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    local pb = context:pending_battle();
                    
                    return character:faction():name() == faction_name and pb:ambush_battle() and character == pb:attacker() and character:won_battle();
                end
        },			
        
        
        --Gork n' Mork
        --LL rank 7
        {
            ["subculture"] = "wh_main_sc_grn_greenskins",
            ["rite_name"] = "wh_main_ritual_grn_gorknmork",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();

                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end
        },
        
        --Spider God
        --build wh_main_grn_forest_beasts_3
        {
            ["subculture"] = "wh_main_sc_grn_greenskins",
            ["rite_name"] = "wh_main_ritual_grn_spidergod",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    
                    return building:faction():name() == faction_name and building:name() == "wh_main_grn_forest_beasts_3";
                end
        },
        --Spider God secondary--
        {
            ["subculture"] = "wh_main_sc_grn_greenskins",
            ["rite_name"] = "wh_main_ritual_grn_spidergod",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region();
                    
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_grn_forest_beasts_3");
                end
        },
            
        --KISLEV--

        --Winter
        --build wh_main_emp_settlement_major_5
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_winter",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    --return false;
                    return building:faction():name() == faction_name and building:name() == "wh_main_emp_settlement_major_5";
                end,
            ["faction_name"] = "wh_main_ksl_kislev"
        },	
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_winter",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    --return false;
                    return building:faction():name() == faction_name and building:name() == "wh_main_emp_settlement_major_5";
                end,
            ["faction_name"] = "wh_main_ksl_erengrad"			
        },
        --Winter secondary--
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_winter",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region();
                    --return false;
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_emp_settlement_major_5");
                end,
            ["faction_name"] = "wh_main_ksl_kislev"				
        },
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_winter",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region();
                    --return false;
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_emp_settlement_major_5");
                end,
            ["faction_name"] = "wh_main_ksl_erengrad"	
        },	
        --War
        --own 20 units; maybe change to tech?
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_levy",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local faction = context:faction();
                    
                    if faction:name() == faction_name then
                        local mf_list = faction:military_force_list();
                        local units = 0;
                        
                        for i = 0, mf_list:num_items() - 1 do
                            local current_mf = mf_list:item_at(i);
                            
                            if current_mf:has_general() and not current_mf:is_armed_citizenry() then
                                units = units + current_mf:unit_list():num_items();
                            end;
                        end;
                        
                        return units > 19;
                    end;
                end,
            ["faction_name"] = "wh_main_ksl_kislev"				
        },
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_levy",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local faction = context:faction();
                    
                    if faction:name() == faction_name then
                        local mf_list = faction:military_force_list();
                        local units = 0;
                        
                        for i = 0, mf_list:num_items() - 1 do
                            local current_mf = mf_list:item_at(i);
                            
                            if current_mf:has_general() and not current_mf:is_armed_citizenry() then
                                units = units + current_mf:unit_list():num_items();
                            end;
                        end;
                        
                        return units > 19;
                    end;
                end,
            ["faction_name"] = "wh_main_ksl_erengrad"				
        },		
        
        --Tides
        --LL rank 7
        
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_tide",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end,
            ["faction_name"] = "wh_main_ksl_kislev"					
        },
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_tide",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end,
            ["faction_name"] = "wh_main_ksl_erengrad"				
        },		
        
        --Envoys
        --war with chaos
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_emissaries",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local human_factions = cm:get_human_factions();
                    local chaos = cm:get_faction("wh_main_chs_chaos");
                    for i = 1, #human_factions do 
                        local current_human = cm:get_faction(human_factions[i]);
                        if current_human:subculture() == "wh_main_sc_ksl_kislev" and current_human:at_war_with(chaos) then 
                            return true;
                        end
                    end
                    return false;
                end,
            ["faction_name"] = "wh_main_ksl_kislev"				
        },	
        {
            ["subculture"] = "wh_main_sc_ksl_kislev",
            ["rite_name"] = "wh_main_ritual_ksl_emissaries",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local human_factions = cm:get_human_factions();
                    local chaos = cm:get_faction("wh_main_chs_chaos");
                    for i = 1, #human_factions do 
                        local current_human = cm:get_faction(human_factions[i]);
                        if current_human:subculture() == "wh_main_sc_ksl_kislev" and current_human:at_war_with(chaos) then 
                            return true;
                        end
                    end
                    return false;
                end,
            ["faction_name"] = "wh_main_ksl_erengrad"				
        },			
        
        ---WOOD ELVES---
        
        --Athel Loren
        --build wh_dlc05_wef_oak_of_ages_2
        {
            ["subculture"] = "wh_dlc05_sc_wef_wood_elves",
            ["rite_name"] = "wh_main_ritual_wef_athelloren",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    
                    return building:faction():name() == faction_name and building:name() == "wh_dlc05_wef_oak_of_ages_2";
                end
        },
        --Athel Loren secondary--
        {
            ["subculture"] = "wh_dlc05_sc_wef_wood_elves",
            ["rite_name"] = "wh_main_ritual_wef_athelloren",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region();
                    
                    return context:character():faction():name() == faction_name and (region:building_exists("wh_dlc05_wef_oak_of_ages_2") or region:building_exists("wh_dlc05_wef_oak_of_ages_3") or region:building_exists("wh_dlc05_wef_oak_of_ages_4") or region:building_exists("wh_dlc05_wef_oak_of_ages_5"));
                end
        },		
        
        --Anath Raema
        --slaughter 10 sets of prisoners
        {
            ["subculture"] = "wh_dlc05_sc_wef_wood_elves",
            ["rite_name"] = "wh_main_ritual_wef_anathraema",
            ["event_name"] = "CharacterPostBattleSlaughter",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    if context:character():faction():name() == faction_name then
                        local slaughter_count = cm:get_saved_value("wh_main_ritual_wef_anathraema_count");
                        if slaughter_count == nil then slaughter_count = 0 end
                        
                        slaughter_count = slaughter_count + 1;
                        
                        cm:set_saved_value("wh_main_ritual_wef_anathraema_count", slaughter_count);
                        
                        return slaughter_count >= 10;
                    end
                end;
        },		
        
        --Loec
        --research tech_dlc05_1_loec
        
        {
            ["subculture"] = "wh_dlc05_sc_wef_wood_elves",
            ["rite_name"] = "wh_main_ritual_wef_loec",
            ["event_name"] = "FactionTurnStart",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                                    
                    return context:faction():name() == faction_name and context:faction():has_technology("tech_dlc05_1_loec")
                end
        },
        
        --Isha
        --NAP w/ High Elves
        
        {
            ["subculture"] = "wh_dlc05_sc_wef_wood_elves",
            ["rite_name"] = "wh_main_ritual_wef_isha",
            ["event_name"] = "PositiveDiplomaticEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local proposer = context:proposer();
                    local recipient = context:recipient();
                    
                    return ((proposer:is_human() and recipient:subculture() == "wh2_main_sc_hef_high_elves") or (recipient:is_human() and proposer:subculture() == "wh2_main_sc_hef_high_elves")) and cm:faction_has_trade_agreement_with_faction(proposer, recipient);
                    
                end
        },

        ---CHAOS---
        
        --Gods
        --slaughter 10 sets of prisoners
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_gods",
            ["event_name"] = "CharacterPostBattleSlaughter",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    if context:character():faction():name() == faction_name then
                        local slaughter_count = cm:get_saved_value("wh_main_ritual_chs_gods_count");
                        if slaughter_count == nil then slaughter_count = 0 end
                        
                        slaughter_count = slaughter_count + 1;
                        
                        cm:set_saved_value("wh_main_ritual_chs_gods_count", slaughter_count);
                        
                        return slaughter_count >= 10;
                    end
                end,
            ["faction_name"] = "wh_main_chs_chaos"
        },
        
        --Storms
        --build wh_main_horde_chaos_magic_2
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_storms",
            ["event_name"] = "MilitaryForceBuildingCompleteEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    return context:building() == "wh_main_horde_chaos_magic_2" and context:character():faction():is_human();
                    --return false;
                end,
            ["faction_name"] = "wh_main_chs_chaos"
        },
        
        --Tides
        --LL rank 7
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_tides",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end,
            ["faction_name"] = "wh_main_chs_chaos"
        },
        
        --Cults
        --raze five cities
        
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_cults",
            ["event_name"] = "CharacterRazedSettlement",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                        
                local raze_count = cm:get_saved_value("wh_main_ritual_chs_cults_count");
                    if raze_count == nil then raze_count = 0 end
                    if context:character():faction():name() == faction_name then
                        raze_count = raze_count + 1;
                        cm:set_saved_value("wh_main_ritual_chs_cults_count", raze_count);
                    end
                    
                    return raze_count >= 5
                
                
                end,
            ["faction_name"] = "wh_main_chs_chaos"
        },	
        
        --SARTH--
        --Gods
        --slaughter 10 sets of prisoners
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_gods",
            ["event_name"] = "CharacterPostBattleSlaughter",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    if context:character():faction():name() == faction_name then
                        local slaughter_count = cm:get_saved_value("wh_main_ritual_chs_sarth_gods_count");
                        if slaughter_count == nil then slaughter_count = 0 end
                        
                        slaughter_count = slaughter_count + 1;
                        
                        cm:set_saved_value("wh_main_ritual_chs_sarth_gods_count", slaughter_count);
                        
                        return slaughter_count >= 10;
                    end
                end,
            ["faction_name"] = "wh_main_chs_chaos_separatists"
        },		
        
        --Storms
        --build wh_main_horde_chaos_magic_2
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_storms",
            ["event_name"] = "MilitaryForceBuildingCompleteEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    return context:building() == "wh_main_horde_chaos_magic_2" and context:character():faction():is_human();
                    --return false;
                end,
            ["faction_name"] = "wh_main_chs_chaos_separatists"
        },
        
        --Tides
        --LL rank 7
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_tides",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end,
            ["faction_name"] = "wh_main_chs_chaos_separatists"
        },
        
        --Cults
        --raze five cities
        
        {
            ["subculture"] = "wh_main_sc_chs_chaos",
            ["rite_name"] = "wh_main_ritual_chs_cults",
            ["event_name"] = "CharacterRazedSettlement",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                        
                local raze_count = cm:get_saved_value("wh_main_ritual_chs_sarth_cults_count");
                    if raze_count == nil then raze_count = 0 end
                    if context:character():faction():name() == faction_name then
                        raze_count = raze_count + 1;
                        cm:set_saved_value("wh_main_ritual_chs_sarth_cults_count", raze_count);
                    end
                    
                    return raze_count >= 5
                
                
                end,
            ["faction_name"] = "wh_main_chs_chaos_separatists"
        },		
        
        
        ---BRETONNIA---
        
        --Peasant
        --build 3x wh_main_brt_farm_3
        {
            ["subculture"] = "wh_main_sc_brt_bretonnia",
            ["rite_name"] = "wh_main_ritual_brt_peasants",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                local building = context:building()
                --# assume building: CA_BUILDING
                    if building:faction():name() == faction_name and building:name() == "wh_main_brt_farm_3" then
                        local buillding_count = cm:get_saved_value("wh_main_ritual_brt_peasants_count");
                        if buillding_count == nil then buillding_count = 0 end
                        
                        buillding_count = buillding_count + 1;
                        
                        cm:set_saved_value("wh_main_ritual_brt_peasants_count", buillding_count);
                        
                        return buillding_count >= 3;
                    end
                end;
        },
        --Peasant secondary
        {
            ["subculture"] = "wh_main_sc_brt_bretonnia",
            ["rite_name"] = "wh_main_ritual_brt_peasants",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                local region = context:region()
                --# assume region: CA_REGION
                    if context:character():faction():name() == faction_name and region:building_exists("wh_main_brt_farm_3") then
                        local buillding_count = cm:get_saved_value("wh_main_ritual_brt_peasants_count");
                        if buillding_count == nil then buillding_count = 0 end
                        
                        buillding_count = buillding_count + 1;
                        
                        cm:set_saved_value("wh_main_ritual_brt_peasants_count", buillding_count);
                        
                        return buillding_count >= 3;
                    end
                end;
        },		
        
        --Errantry
        --fight battle outside Bretonnia
        {
            ["subculture"] = "wh_main_sc_brt_bretonnia",
            ["rite_name"] = "wh_main_ritual_brt_errantry",
            ["event_name"] = "CharacterCompletedBattle",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                        return context:character():faction():name() == faction_name and not (context:character():region():owning_faction():subculture() == "wh_main_sc_brt_bretonnia" or context:character():region():owning_faction() == cm:get_faction("wh_main_vmp_mousillon"));
                end;
        },	
        
        --Blessing
        --build wh_main_brt_worship_3

        {
            ["subculture"] = "wh_main_sc_brt_bretonnia",
            ["rite_name"] = "wh_main_ritual_brt_blessing",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    
                    return building:faction():name() == faction_name and building:name() == "wh_main_brt_worship_3";
                end
        },
        --Blessing secondary--
        {
            ["subculture"] = "wh_main_sc_brt_bretonnia",
            ["rite_name"] = "wh_main_ritual_brt_blessing",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
                function(context --: WHATEVER
                    ,faction_name --: string 	
                )
                    local region = context:garrison_residence():region();
                    
                    return context:character():faction():name() == faction_name and region:building_exists("wh_main_brt_worship_3");
                end
        },

        --Invaders
        --LL rank 7		
        {
            ["subculture"] = "wh_main_sc_brt_bretonnia",
            ["rite_name"] = "wh_main_ritual_brt_invaders",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
                function(context --: WHATEVER 	
                    , faction_name --: string 	
                )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end
        },
        
        --NORSCA

        --Kharnath
        --execute 10 sets of prisoners
        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_men",
            ["event_name"] = "CharacterPostBattleSlaughter",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    if context:character():faction():name() == faction_name then
                        local slaughter_count = cm:get_saved_value("wh_main_ritual_nor_men_count");
                        if slaughter_count == nil then slaughter_count = 0 end
                        
                        slaughter_count = slaughter_count + 1;
                        
                        cm:set_saved_value("wh_main_ritual_nor_men_count", slaughter_count);
                        
                        return slaughter_count >= 10;
                    end
                end,
                ["faction_name"] = "wh_dlc08_nor_wintertooth"
        },
        
        --Mermedus
        --level 5 main settlement

        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_ships",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    
                    return building:faction():name() == faction_name and (building:name() == "wh_main_nor_settlement_major_5" or building:name() == "wh_main_nor_settlement_major_5_coast");
                end,
                ["faction_name"] = "wh_dlc08_nor_wintertooth"
        },
        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_ships",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region();
                    
                    return context:character():faction():name() == faction_name and (region:building_exists("wh_main_nor_settlement_major_5") or region:building_exists("wh_main_nor_settlement_major_5_coast"));
                end,
                ["faction_name"] = "wh_dlc08_nor_wintertooth"
        },

        --Shornaal
        --raze 5 settlements, dawg

        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_goods",
            ["event_name"] = "CharacterRazedSettlement",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                
                    if context:character():faction():name() == faction_name then
                
                        local raze_count = cm:get_saved_value("wh_main_ritual_nor_goods_count");
                        if raze_count == nil then raze_count = 0 end
                        raze_count = raze_count + 1;
                        cm:set_saved_value("wh_main_ritual_nor_goods_count", raze_count);
                
                        return raze_count >= 5
                    end
                    return false; 
                
                end,
                ["faction_name"] = "wh_dlc08_nor_wintertooth"
        },

        --Troll-King
        --level 7 faction leader, dawg
        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_throgg",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end,
            ["faction_name"] = "wh_dlc08_nor_wintertooth"
        },
        
        --Kharnath
        --execute 10 sets of prisoners
        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_men",
            ["event_name"] = "CharacterPostBattleSlaughter",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    if context:character():faction():name() == faction_name then
                        local slaughter_count = cm:get_saved_value("wh_main_ritual_nor_men_count");
                        if slaughter_count == nil then slaughter_count = 0 end
                        
                        slaughter_count = slaughter_count + 1;
                        
                        cm:set_saved_value("wh_main_ritual_nor_men_count", slaughter_count);
                        
                        return slaughter_count >= 10;
                    end
                end,
                ["faction_name"] = "wh_dlc08_nor_norsca"
        },
        
        --Mermedus
        --level 5 main settlement

        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_ships",
            ["event_name"] = "BuildingCompleted",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local building = context:building();
                    
                    return building:faction():name() == faction_name and (building:name() == "wh_main_nor_settlement_major_5" or building:name() == "wh_main_nor_settlement_major_5_coast");
                end,
                ["faction_name"] = "wh_dlc08_nor_norsca"
        },
        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_ships",
            ["event_name"] = "GarrisonOccupiedEvent",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local region = context:garrison_residence():region();
                    
                    return context:character():faction():name() == faction_name and (region:building_exists("wh_main_nor_settlement_major_5") or region:building_exists("wh_main_nor_settlement_major_5_coast"));
                end,
                ["faction_name"] = "wh_dlc08_nor_norsca"
        },

        --Shornaal
        --raze 5 settlements, dawg

        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_goods",
            ["event_name"] = "CharacterRazedSettlement",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                
                    if context:character():faction():name() == faction_name then
                
                        local raze_count = cm:get_saved_value("wh_main_ritual_nor_goods_count");
                        if raze_count == nil then raze_count = 0 end
                        raze_count = raze_count + 1;
                        cm:set_saved_value("wh_main_ritual_nor_goods_count", raze_count);
                
                        return raze_count >= 5
                    end
                    return false; 
                
                end,
                ["faction_name"] = "wh_dlc08_nor_norsca"
        },
        --Wulfrik
        --level 7 faction leader
        {
            ["subculture"] = "wh_main_sc_nor_norsca",
            ["rite_name"] = "wh_main_ritual_nor_wulfrik",
            ["event_name"] = "CharacterRankUp",
            ["condition"] =
            function(context --: WHATEVER
                ,faction_name --: string 	
            )
                    local character = context:character();
                    
                    return character:faction():name() == faction_name and tonumber(character:rank()) >= 7;
                end,
                ["faction_name"] = "wh_dlc08_nor_norsca"
        }


    
    }--:vector<{subculture: string, rite_name: string, event_name: string, condition: function(context: WHATEVER, faction_name: string) --> boolean, faction_name: string?}>
    local was_new_game = false
    local human_factions = cm:get_human_factions();
    local ok, err = pcall(function() 
    for i = 1, #human_factions do
        for j = 1, #rite_templates do
            local current_rite_template = rite_templates[j];
            if cm:get_faction(human_factions[i]):subculture() == current_rite_template.subculture then
                --# assume rite_unlock: RITE_UNLOCK
                OWRLOG("Adding Rite Unlock Condition for ["..human_factions[i].."] with rite key ["..current_rite_template.rite_name.."] and event name ["..current_rite_template.event_name.."] ")
                local rite = rite_unlock:new(
                    current_rite_template.rite_name,
                    current_rite_template.event_name,
                    current_rite_template.condition,
                    current_rite_template.faction_name
                )
                
                rite:start(human_factions[i]);
                if not cm:get_saved_value("owr_unlock_init") then
                    was_new_game = true
                    local cqi = cm:get_faction(human_factions[i]):command_queue_index();
                    cm:set_ritual_unlocked(cqi, current_rite_template.rite_name, false);
                end
            end;
        end;
    end;
    if was_new_game then
        cm:set_saved_value("owr_unlock_init", true)
    end
    end)
    if not ok then
        OWRLOG("ERRORLOLOLOL")
        OWRLOG(tostring(err))
    end
end

cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context)
    owr_rite_unlock_listeners()
end