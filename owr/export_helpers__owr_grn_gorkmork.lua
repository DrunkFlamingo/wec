local vandy_effects_list_wh_main_ritual_grn_gorknmork = {
	"wh_main_ritual_grn_gorknmork_gork",
	"wh_main_ritual_grn_gorknmork_mork"
	} --: vector<string>


core:add_listener(
    "OWR_Dilemma_Listener",
    "RitualCompletedEvent",
    function(context)
        return context:ritual():ritual_category() == "STANDARD_RITUAL";
    end,
    function(context)
        local ritual = context:ritual();
        local ritual_key = ritual:ritual_key();
        local faction = context:performing_faction();
        local faction_name = faction:name();
        local waaaagh = cm:random_number(#vandy_effects_list_wh_main_ritual_grn_gorknmork);
        if ritual_key == "wh_main_ritual_grn_gorknmork" then
            if faction:is_human() then
                cm:trigger_dilemma(faction_name, "wh_main_ritual_grn_gorknmork", true);
            else
                cm:apply_effect_bundle(vandy_effects_list_wh_main_ritual_grn_gorknmork[waaaagh], faction_name, 5);
            end
        end
    end,
    true);