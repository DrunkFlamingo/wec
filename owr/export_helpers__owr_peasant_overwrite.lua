
---Overwritin' here instead of there, gotta add them peasants!
--v [NO_CHECK] function(faction: CA_FACTION)
function Calculate_Economy_Penalty(faction)
    if Is_Bretonnian(faction:name()) and faction:is_human() then
        output_P("---- Calculate_Economy_Penalty ----");
        local peasant_count = 0;
        local force_list = faction:military_force_list();
        local region_count = faction:region_list():num_items();
        
        for i = 0, force_list:num_items() - 1 do
            local force = force_list:item_at(i);
            
            -- Make sure this isn't a garrison!
            if force:is_armed_citizenry() == false and force:has_general() == true then
                local unit_list = force:unit_list();
                
                for j = 0, unit_list:num_items() - 1 do
                    local unit = unit_list:item_at(j);
                    local key = unit:unit_key();
                    local val = Bretonnia_Peasant_Units[key] or 0;
                    
                    output_P("\t"..key.." - "..val);
                    peasant_count = peasant_count + val;
                end
            end
        end
        
        if cm:is_multiplayer() == false then
            if PEASANTS_WARNING_COOLDOWN > 0 then
                PEASANTS_WARNING_COOLDOWN = PEASANTS_WARNING_COOLDOWN - 1;
            end
        end
        
        output_P("\tPeasants: "..peasant_count);
        Remove_Economy_Penalty(faction);
        
    
    
        local peasants_per_region_fac = PEASANTS_PER_REGION;
        local peasants_base_amount_fac = PEASANTS_BASE_AMOUNT;
        
        -- Peasants Per Region Modifiers
        if faction:name() == "wh_main_brt_carcassonne" then
            peasants_base_amount_fac = peasants_base_amount_fac + 5;
        end
        if faction:has_technology("tech_dlc07_brt_economy_farm_4") then
            peasants_per_region_fac = peasants_per_region_fac + 1;
        end
        
        -- Make sure player has regions
        if faction:region_list():num_items() < 1 then
            peasants_base_amount_fac = 0;
        end
        
        --------------------------
        ----OWR INJECTION HERE----
        --------------------------
        
        if faction:has_effect_bundle("wh_main_ritual_brt_peasants") then
            peasants_base_amount_fac = peasants_base_amount_fac + 10;
        end
        
        
        --------------------------
        ----OWR INJECTION END-----
        --------------------------
        
        local free_peasants = (region_count * peasants_per_region_fac) + peasants_base_amount_fac;
        free_peasants = math.max(1, free_peasants);
        output_P("Free Peasants: "..free_peasants);
        local peasant_percent = (peasant_count / free_peasants) * 100;
        output_P("Peasant Percent: "..peasant_percent.."%");
        peasant_percent = RoundUp(peasant_percent);
        output_P("Peasant Percent Rounded: "..peasant_percent.."%");
        peasant_percent = math.min(peasant_percent, 200);
        output_P("Peasant Percent Clamped: "..peasant_percent.."%");
        
        if peasant_percent > 100 then
            peasant_percent = peasant_percent - 100;
            output_P("Peasant Percent Final: "..peasant_percent);
            cm:apply_effect_bundle(PEASANTS_EFFECT_PREFIX..peasant_percent, faction:name(), 0);
            
            if cm:get_saved_value("ScriptEventNegativePeasantEconomy") ~= true and faction:is_human() then
                core:trigger_event("ScriptEventNegativePeasantEconomy");
                cm:set_saved_value("ScriptEventNegativePeasantEconomy", true);
            end
            if cm:is_multiplayer() == false then
                if PEASANTS_RATIO_POSITIVE == true and PEASANTS_WARNING_COOLDOWN < 1 then
                    Show_Peasant_Warning(faction:name());
                    PEASANTS_WARNING_COOLDOWN = 25;
                end
            end
            
            PEASANTS_RATIO_POSITIVE = false;
        else
            output_P("Peasant Percent Final: 0");
            cm:apply_effect_bundle(PEASANTS_EFFECT_PREFIX.."0", faction:name(), 0);
            
            if cm:get_saved_value("ScriptEventNegativePeasantEconomy") == true and cm:get_saved_value("ScriptEventPositivePeasantEconomy") ~= true and faction:is_human() then
                core:trigger_event("ScriptEventPositivePeasantEconomy");
                cm:set_saved_value("ScriptEventPositivePeasantEconomy", true);
            end
            PEASANTS_RATIO_POSITIVE = true;
        end
    end
end;
    