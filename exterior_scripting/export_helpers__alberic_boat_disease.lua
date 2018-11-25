
--[[--v function(faction: string, army: string, starting_traits: vector<string>, immortality_trait: string, region: string?, x: number?, y: number?)
local function replace_faction_leader(faction, army, starting_traits, immortality_trait, region, x, y)
    local dude = cm:get_faction(faction):faction_leader()
    if immortality_trait then
        if dude:has_trait(immortality_trait) then
            cm:force_rem
    if region then
    
    else

    end

end]]

function alberic_quest_fix()
    cm:set_saved_value("wh_dlc07_qb_brt_alberic_trident_of_bordeleaux_stage_1_issued", true)
    if not cm:get_saved_value("aberic_item_wili") then
        core:add_listener(
            "Wooo",
            "CharacterTurnStart",
            function(context) return (context:character():character_subtype("dlc07_brt_alberic") and context:character():rank() >= 3) 
            end,
            function(context)
                cm:force_add_and_equip_ancillary(cm:char_lookup_str(context:character():cqi()), "wh_dlc07_anc_weapon_trident_of_manann")
                cm:set_saved_value("aberic_item_wili", true)
            end,
            false
        )
    end
end
alberic_quest_fix()