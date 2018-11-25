local vandy_effects_list_wh_main_ritual_chs_gods = {
	"wh_main_ritual_chs_gods_slaanesh",
	"wh_main_ritual_chs_gods_tzeentch",
	"wh_main_ritual_chs_gods_khorne",
	"wh_main_ritual_chs_gods_nurgle"
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
        local index = cm:random_number(#vandy_effects_list_wh_main_ritual_chs_gods);
        if ritual_key == "wh_main_ritual_chs_gods" then
            if faction:is_human() then 
                cm:trigger_dilemma(faction_name, "wh_main_ritual_chs_gods", true);
            else 
                cm:apply_effect_bundle(vandy_effects_list_wh_main_ritual_chs_gods[index], faction_name, 10);
            end
        end
    end,
    true);