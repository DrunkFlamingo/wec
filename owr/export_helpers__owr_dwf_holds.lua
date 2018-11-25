


--v function(faction: CA_FACTION)
local function dwf_holds_listeners(faction)
OWRLOG("began dwarf hold for "..tostring(faction:name()).." applying the effect bundles");
local current_faction = cm:get_faction((faction:name()));
local region_list = current_faction:region_list();


for i = 0, region_list:num_items() - 1 do
    local current_region = region_list:item_at(i);
    local current_region_name = current_region:name();
    OWRLOG("applying to "..tostring(current_region_name).." for dwf_holds");		
    cm:apply_effect_bundle_to_region("wh_main_ritual_dwf_holds_movement", current_region_name, 5);
end

end



core:add_listener(
	"OWR_external_functions",
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_category() == "STANDARD_RITUAL";
	end,
	function(context)
		local ritual = context:ritual();
		local ritual_key = ritual:ritual_key();
        local faction = context:performing_faction();
        
		if ritual_key == "wh_main_ritual_dwf_holds" then
            dwf_holds_listeners(faction)
		end
	end,
	true);
		