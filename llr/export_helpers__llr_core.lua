cm = get_cm(); events = get_events(); llr = _G.llr;

--no checking this because of Kailua's annoying integer type
--v [NO_CHECK] function(level: number) --> number
function get_exp_for_level(level)
    local exp_to_levels_table = {
        0, 900,  1900,  3000, 4200,  5500,6870, 8370, 9940,
        11510,13080,14660, 16240,17820,19400, 20990,22580,24170,25770,27370,28980,30590,32210,
        33830,35460,37100,38740, 40390,42050,43710,45380,47060,48740,50430,52130, 53830, 55540,57260,58990,
        60730, 60730, 60730, 60730,  60730, 60730, 60730, 60730, 60730,  60730, 60730, 60730,
        60730,   60730, 60730, 60730, 60730,  60730, 60730, 60730, 60730, 60730,  60730, 60730, 60730,
        60730, 60730, 60730, 60730,  60730, 60730, 60730, 60730, 60730,  60730, 60730, 60730, }--:vector<number>
    return exp_to_levels_table[level]
end



--v function(cqi: CA_CQI, lord: LLR_LORD)
local function grant_quest_items(cqi, lord)
    local character = cm:get_character_by_cqi(cqi)
    local items = lord:get_completed_quests(lord:rank())
    for i = 1, #items do
        cm:force_add_and_equip_ancillary(cm:char_lookup_str(cqi), items[i])
    end
end

--v function(player_faction: string, lord: LLR_LORD)
local function setup_quest_listeners(player_faction, lord)

    for i = 1, #lord:quest_save_values() do
        cm:set_saved_value(lord:quest_save_values()[i], true)
        llr:log("applying saved value ["..lord:quest_save_values()[i].."] to block a quest!")
    end
    local quests = lord:get_future_quests(lord:rank())
    for i = 1, #quests do
        local quest = quests[i]
        llr:log(" starting a quest listener for ["..quest.."] ")
        local quest_info = {}
        quest_info.level = lord:get_level_for_quest(quest)
        quest_info.item = quest
        quest_info.subtype = lord:subtype()
        core:remove_listener(quest)
        llr:save_quest(player_faction, quest_info)
        llr:set_up_loaded_listeners()
    end
    
end



--v function(player_faction: string, lord: LLR_LORD, character: CA_CHAR)
local function respec_char_with_army(player_faction, lord, character)
    llr:log("Respecing lord with subtype ["..lord:subtype().."] who is active! ")
    --set the lord information to match the character
    lord:set_lord_rank(character:rank())
    lord:set_coordinates(character:logical_position_x(), character:logical_position_y())
    lord:set_unit_string_from_force(character:military_force())
    --if they are in a null interface region, we're just going to spawn them at the capital
    if character:region():is_null_interface() then
        lord:set_coordinates(character:faction():home_region():settlement():logical_position_x() + 1, character:faction():home_region():settlement():logical_position_y() + 1)
        lord:set_lord_region(character:faction():home_region():name())
    else
        lord:set_lord_region(character:region():name())
        lord:set_coordinates(character:logical_position_x(), character:logical_position_y())
    end
    cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
    --remove immortalitiy and registered traits
    cm:set_character_immortality(cm:char_lookup_str(character:command_queue_index()), false);
    for i = 1, #lord:traits() do
        if character:has_trait(lord:traits()[i]) then
            cm:force_remove_trait(cm:char_lookup_str(character:command_queue_index()), lord:traits()[i])
        end
    end
    --kill character
    cm:kill_character(character:command_queue_index(), true, true)
    --turn events back on
    cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
    --respawn the character
    cm:callback( function()
        llr:log("spawning lord for respec!")
        cm:create_force_with_general(
        player_faction,
        lord:unit_list(),
        lord:region(),
        lord:x(),
        lord:y(),
        "general",
        lord:subtype(),
        lord:forename(),
        "",
        lord:surname(),
        "",
        false,
        function(cqi) 
            llr:log("Levelling up the respec'd lord!")
            cm:set_character_immortality(cm:char_lookup_str(cqi), true);
            grant_quest_items(cqi, lord)
            for i = 1, #lord:traits() do
                cm:force_add_trait(cm:char_lookup_str(cqi), lord:traits()[i], true)
            end
            cm:add_agent_experience(cm:char_lookup_str(cqi), get_exp_for_level(lord:rank()))       
            llr:log("Levelling up the respec'd lord finished.")
        end)
    end,
    0.1
    );

end

--v function(player_faction: string, lord: LLR_LORD, character: CA_CHAR, do_not_wound: boolean?)
local function respec_wounded_character(player_faction, lord, character, do_not_wound)
    llr:log("Respecing lord with subtype ["..lord:subtype().."] who is wounded ")
    lord:set_lord_rank(character:rank())
    lord:set_coordinates(character:faction():home_region():settlement():logical_position_x() + 1, character:faction():home_region():settlement():logical_position_y() + 1)
    lord:set_lord_region(character:faction():home_region():name())
    lord:set_spawn_string_to_subculture_default(character:faction():subculture())
    cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "");
    --remove immortalitiy and registered traits
    cm:set_character_immortality(cm:char_lookup_str(character:command_queue_index()), false);
    for i = 1, #lord:traits() do
        if character:has_trait(lord:traits()[i]) then
            cm:force_remove_trait(cm:char_lookup_str(character:command_queue_index()), lord:traits()[i])
        end
    end
    --kill character
    cm:kill_character(character:command_queue_index(), true, true)
    --turn events back on
    cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 1);
    cm:callback( function()
        llr:log("spawning lord for respec!")
        cm:create_force_with_general(
        player_faction,
        lord:unit_list(),
        lord:region(),
        lord:x(),
        lord:y(),
        "general",
        lord:subtype(),
        lord:forename(),
        "",
        lord:surname(),
        "",
        false,
        function(cqi) 
            llr:log("Levelling up the respec'd lord!")
            cm:set_character_immortality(cm:char_lookup_str(cqi), true);
            grant_quest_items(cqi, lord)
            for i = 1, #lord:traits() do
                cm:force_add_trait(cm:char_lookup_str(cqi), lord:traits()[i], true)
            end
            cm:add_agent_experience(cm:char_lookup_str(cqi), get_exp_for_level(lord:rank()))       
            llr:log("Levelling up the respec'd lord finished.")
            lord._newCQI = cqi

        end)
    end,
    0.1
    );
    --wound the character again!
    if not do_not_wound then
        cm:callback(function()
            cm:kill_character(lord._newCQI, true, true)
        end, 0.5)
    end
end

--v function(human_faction_name: string, lord: LLR_LORD)
local function respawn_to_pool(human_faction_name, lord)
    llr:log("Respawning a lord ["..lord:subtype().."] to the pool of ["..human_faction_name.."]")
    cm:spawn_character_to_pool(human_faction_name, lord:forename(), lord:surname(), "", "", 18, true, "general", lord:subtype(), true, "");
end




--v function(confederation_name: string, subtype: string) --> CA_CHAR
function lord_survived_confederation(confederation_name, subtype)
    local faction = cm:get_faction(confederation_name)
    local character_list = faction:character_list()
    for i = 0, character_list:num_items() - 1 do
        local character = character_list:item_at(i)
        if character:character_subtype_key() == subtype then
            return character
        end
    end
    return nil
end





--v function(faction_name: string, confederation_name: string)
local function player_faction_confederation(faction_name, confederation_name)
    llr:log("Evaluating a confederation involving the player!")
    local lords = llr:get_lords_for_faction(faction_name)
    for i = 1, #lords do
        local current_lord = lords[i]
        llr:log("evaluating lord with subtype ["..current_lord:subtype().."]")
        local character = lord_survived_confederation(confederation_name, current_lord:subtype())
        if character then
            if character:is_wounded() then
                respec_wounded_character(confederation_name, current_lord, character)
                setup_quest_listeners(confederation_name, current_lord)
            else
                if character:has_military_force() then
                    respec_char_with_army(confederation_name, current_lord, character)
                    setup_quest_listeners(confederation_name, current_lord)
                else
                    respec_wounded_character(confederation_name, current_lord, character, true)
                    setup_quest_listeners(confederation_name, current_lord)
                end
            end
        else
            respawn_to_pool(confederation_name, current_lord)
            setup_quest_listeners(confederation_name, current_lord)
        end
    end
end


core:add_listener(
    "llr_manager_confedation",
    "FactionJoinsConfederation",
    function(context)
        local sc = context:faction():subculture() --:string
        local faction = context:faction():name() --:string
        --make sure we are listening for this sub and faction
        return llr:is_tracking_faction(faction) and llr:is_tracking_subculture(sc)
    end,
    function(context)
        local faction_name = context:faction():name() --:string
        local confederation_name = context:confederation():name() --:string
        if cm:get_faction(confederation_name):is_human() then
            player_faction_confederation(faction_name, confederation_name)
            llr:move_faction(faction_name, confederation_name)
        else
            llr:move_faction(faction_name, confederation_name)
        end
    end,
    true)
    
cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context)
    llr:activate()
end

