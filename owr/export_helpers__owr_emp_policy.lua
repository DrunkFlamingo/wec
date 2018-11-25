--v function(faction: CA_FACTION)
local function OWR_emp_policy(faction)
    if faction:is_human() then
        local dilemma_list = {
            "wh_main_ritual_emp_policy_cults",
            "wh_main_ritual_emp_policy_enemies",
            "wh_main_ritual_emp_policy_friends",
            "wh_main_ritual_emp_policy_leaders"
        }--:vector<string>
        
        local index = cm:random_number(#dilemma_list);
        
        cm:trigger_dilemma(faction:name(), dilemma_list[index], true);
    else
        local effect_bundle_list = {
            "wh_main_ritual_emp_policy_cults_taal",
            "wh_main_ritual_emp_policy_cults_sigmar",
            "wh_main_ritual_emp_policy_cults_ulric",
            "wh_main_ritual_emp_policy_cults_varena",
            "wh_main_ritual_emp_policy_enemies_vmp",
            "wh_main_ritual_emp_policy_enemies_chs",
            "wh_main_ritual_emp_policy_enemies_grn",
            "wh_main_ritual_emp_policy_enemies_emp",
            "wh_main_ritual_emp_policy_friends_brt",
            "wh_main_ritual_emp_policy_friends_hef",
            "wh_main_ritual_emp_policy_friends_dwf",
            "wh_main_ritual_emp_policy_friends_ksl",
            "wh_main_ritual_emp_policy_leaders_necessary_evils",
            "wh_main_ritual_emp_policy_leaders_army",
            "wh_main_ritual_emp_policy_leaders_cults",
            "wh_main_ritual_emp_policy_leaders_cities"
        }--: vector<string>
        
        local index = cm:random_number(#effect_bundle_list);
        local faction_name = faction:name();
        
        cm:apply_effect_bundle(effect_bundle_list[index], faction_name, 10);
    end;
end;

	
core:add_listener(
	"OWR_emp_policy",
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_category() == "STANDARD_RITUAL";
	end,
	function(context)
		local ritual = context:ritual();
		local ritual_key = ritual:ritual_key();
		local faction = context:performing_faction();
		
        if ritual_key == "wh_main_ritual_emp_policy" then
			OWR_emp_policy(faction)
		end;
	end,
	true);