local bundle_range_minimum = {(-100), (-75), (-50), -(25), 0, 25, 50, 75, 100} --:vector<number>
local bundle_range_maximum = {(-100), (-75), (-50), -(25), 0, 25, 50, 75, 100} --:vector<number>
local po_bundles = {"my_bundle", "my_bundle", "my_bundle", "my_bundle", "my_bundle", "my_bundle", "my_bundle", "my_bundle", "my_bundle"} --:vector<string>

--v function(public_order: number, province: string, region: string, faction: string)
function apply_po_bundle_for_province(public_order, province, region, faction)
    if #bundle_range_maximum ~= #bundle_range_minimum or #bundle_range_maximum ~= #po_bundles then
        out("PUBORDER SETUP ERROR: number of ranges and number of bundles aren't equal!")
        return
    end
    for i = 1, #bundle_range_minimum do
        if public_order > bundle_range_minimum[i] and public_order < bundle_range_maximum[i] then
            --we've found our bundle!
            local bundle = po_bundles[i]
            local last_capital = cm:get_saved_value("public_order_"..province.."_"..faction.."_last_capital")
            local last_bundle = cm:get_saved_value("public_order_"..province.."_"..faction.."_last_bundle")
            if last_capital and last_bundle then
                --we've applied something here before!
                cm:remove_effect_bundle_from_region(last_bundle, last_capital)
            end
            cm:apply_effect_bundle_to_region(bundle, region, 0)
            cm:set_saved_value("public_order_"..province.."_"..faction.."_last_capital", region)
            cm:set_saved_value("public_order_"..province.."_"..faction.."_last_bundle", bundle)
            break
        end
    end
end

local prov_to_capital = {} --:map<string, string>

cm.first_tick_callbacks[#cm.first_tick_callbacks] = function(context)
    local region_list = cm:model():world():region_manager():region_list()
    for i = 0, region_list:num_items() - 1 do
        local region = region_list:item_at(i)
        if region:is_province_capital() then
            prov_to_capital[region:province_name()] = region:name()
        end
    end
    local humans = cm:get_human_factions() 
    for j = 1, #humans do
        local processed_provinces = {} --:map<string, boolean>
        local faction = cm:get_faction(humans[j])
        local region_list = faction:region_list()
        local ok, err = pcall(function()
            for i = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(i)
                local province = region:province_name()
                if not processed_provinces[province] then
                    if prov_to_capital[province] then
                        --is this region the province capital?
                        if region:is_province_capital() then
                            --we own the region
                            processed_provinces[province] = true
                            apply_po_bundle_for_province(region:public_order(), province, region:name(), faction:name())
                        elseif cm:get_region(prov_to_capital[province]):owning_faction():name() == faction:name() then
                            --we own the capital of this region
                            --we can just ignore them for now.
                        else
                            --we can treat this region as the capital of this province!
                            processed_provinces[province] = true
                            apply_po_bundle_for_province(region:public_order(), province, region:name(), faction:name())
                        end
                    else
                        return
                    end
                end
            end
        end)
        if not ok then
            out("PUBORDER: script error!")
            out(tostring(err))
        end
    end

end



core:add_listener(
    "POFactionTurnStart",
    "FactionTurnStart",
    function(context)
        return context:faction():name() ~= "rebels"
    end,
    function(context)
        local processed_provinces = {} --:map<string, boolean>
        local region_list = context:faction():region_list() --: CA_REGION_LIST
        local faction = context:faction() --:CA_FACTION
        local ok, err = pcall(function()
            for i = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(i)
                local province = region:province_name()
                if not processed_provinces[province] then
                    if prov_to_capital[province] then
                        --is this region the province capital?
                        if region:is_province_capital() then
                            --we own the region
                            processed_provinces[province] = true
                            apply_po_bundle_for_province(region:public_order(), province, region:name(), faction:name())
                        elseif cm:get_region(prov_to_capital[province]):owning_faction():name() == faction:name() then
                            --we own the capital of this region
                            --we can just ignore them for now.
                        else
                            --we can treat this region as the capital of this province!
                            processed_provinces[province] = true
                            apply_po_bundle_for_province(region:public_order(), province, region:name(), faction:name())
                        end
                    else
                        return
                    end
                end
            end
        end)
        if not ok then
            out("PUBORDER: script error!")
            out(tostring(err))
        end
    end,
    true
)