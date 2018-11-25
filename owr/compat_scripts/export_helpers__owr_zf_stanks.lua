


local stanks = 
    {
        "wh_emp_steam_tank_deliverance",
        "wh_emp_steam_tank_alter",
        "wh_emp_steam_tank_sigmar",
        "wh_emp_steam_tank_implacable",
        "wh_emp_steam_tank_invincible"
    } --:vector<string>
core:add_listener(
	"OWR_emp_gunpowder",
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_category() == "STANDARD_RITUAL";
	end,
	function(context)
		local ritual = context:ritual()
		local ritual_key = ritual:ritual_key() --:string
		local faction = context:performing_faction() --:CA_FACTION
		
        if ritual_key == "wh_main_ritual_emp_gunpowder" then
            local char_list = faction:character_list()
            local home_region = faction:home_region():name()
            for i = 0, char_list:num_items() - 1 do
                local char = char_list:item_at(i)
                if char:has_military_force() and char:region():name() == home_region then
                    if char:military_force():unit_list():num_items() < 3 and char:military_force():unit_list():has_unit("wh_main_emp_veh_steam_tank") then
                        if cm:random_number(10) > 4 then
                            cm:remove_unit_from_character(cm:char_lookup_str(char:cqi()), "wh_main_emp_veh_steam_tank")
                            cm:grant_unit_to_character(cm:char_lookup_str(char:cqi()), stanks[cm:random_number(#stanks)])
                            break
                        end
                    end
                end
            end
		end;
	end,
	true);