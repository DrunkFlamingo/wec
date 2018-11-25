-- -2 = off, -1 = low, 0 = normal, 1 = high, 2 = very high
local provinceTaxTiers = {} --: map<string, int>
local taxTierEffects = {
    [-1] = "wh2_vanish_tiered_tax_low",
    [1] = "wh2_vanish_tiered_tax_high",
    [2] = "wh2_vanish_tiered_tax_very_high"
} --: map<int, string>
local taxTierButtons = {
    [-1] = nil,
    [0] = nil,
    [1] = nil
} --: map<int, BUTTON>
local currentprovince = nil --: string
local uiOpen = false;
local ignoreTickboxClick = false;
local ignoreTickBoxStateCorrection = false;

--v function() --> string
function getCurrentprovince()
    if not currentprovince then
        out("Failed to find current province.")
        return nil;
    else
        return currentprovince;
    end
end

--v function(province: string) --> string
function getProvinceCapital(province)
    local regionManager = cm:model():world():region_manager();
    local regionList = regionManager:region_list();
    for i = 0, regionList:num_items() - 1 do
        local currentRegion = regionList:item_at(i);
        if currentRegion:province_name() == province then
            if currentRegion:is_province_capital() then
                return currentRegion:name();
            end
        end
    end
    out("Could not find province capital for province: " .. province);
    return nil;
end

--v function(province: string) --> vector<string>
function getRegionsForProvince(province)
    local regionManager = cm:model():world():region_manager();
    local regionList = regionManager:region_list();
    local regions = {} --: vector<string>
    for i = 0, regionList:num_items() - 1 do
        local currentRegion = regionList:item_at(i);
        if currentRegion:province_name() == province then
            table.insert(regions, currentRegion:name());
        end
    end
    return regions;
end

--v function(province: string) --> boolean
function factionOwnSettlementInProvince(province)
    local provinceRegions = getRegionsForProvince(province);
    local currentFaction = cm:get_faction(cm:get_local_faction(true));
    for i, region in ipairs(provinceRegions) do
        local resolvedRegion = cm:get_region(region);
        if resolvedRegion:owning_faction() == currentFaction then
            return true;
        end
    end
    return false;
end

--v function() --> CA_UIC
function getTaxPanel()
    return find_uicomponent(core:get_ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "panel", "frame_PO_income");
end

--v function() --> CA_UIC
function getProvincePanel()
    return find_uicomponent(core:get_ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "panel");
end

--v function() --> CA_UIC
function getTaxOnCheckBox()
    return find_uicomponent(core:get_ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "panel", "frame_PO_income", "header_taxes", "checkbox_tax_exempt");
end

--v function(componentName: string)
function deleteComponentWithName(componentName)
    local component = Util.getComponentWithName(componentName);
    if not component then
        out("Failed to delete component with name: " .. componentName);
        return;
    end
    --# assume component: BUTTON
    component:Delete();
end

--v function(province: string)
function removeEffectBundles(province)
    local provinceRegions = getRegionsForProvince(province);
    for i, effect in pairs(taxTierEffects) do
        for i, region in ipairs(provinceRegions) do
            cm:remove_effect_bundle_from_region(effect, region);
        end
    end
end

--v function(province: string, effectBundle: string)
function applyEffectBundleToProvince(province, effectBundle)
    local provinceRegions = getRegionsForProvince(province);
    local currentFaction = cm:get_faction(cm:get_local_faction(true));
    for i, region in ipairs(provinceRegions) do
        local resolvedRegion = cm:get_region(region);
        if resolvedRegion:owning_faction() == currentFaction then
            cm:apply_effect_bundle_to_region(effectBundle, region, -1);
            return;
        end
    end
end

--v function(shouldBeTicked: boolean)
function correctTaxCheckBoxState(shouldBeTicked)
    local taxCheckBox = getTaxOnCheckBox();
    if not factionOwnSettlementInProvince(getCurrentprovince()) then
        return;
    end
    local isTicked = taxCheckBox:CurrentState() == "selected";
    if isTicked ~= shouldBeTicked then
        ignoreTickboxClick = true;
        taxCheckBox:SimulateLClick();
        ignoreTickboxClick = false;
    end
end

--v function(tier: int)
function correctTaxButtonState(tier)
    for index, button in pairs(taxTierButtons) do
        if index ~= tier then
            button:SetState("active");
        else
            if not string.match(button:CurrentState(), "selected") then
                if button:CurrentState() == "hover" then
                    button:SetState("selected_hover");
                else
                    button:SetState("selected");
                end
            end
        end
    end
end

--v function(province: string, tier: int)
function updateEffectBundles(province, tier)
    removeEffectBundles(province);
    local tierEffect = taxTierEffects[tier];
    if tierEffect then
        applyEffectBundleToProvince(province, tierEffect);
    end
end

--v function(tab: any) --> string
local function GetTableSaveState(tab)
    local ret = "return {"..cm:process_table_save(tab).."}";
    return ret;
end

--DRUNK FLAMINGO: this function is MP safe and should only be called from UICampaignEvents
--v function(province: string, tier: int, faction: string)
function applyTaxTier(province, tier, faction)
    updateEffectBundles(province, tier);
    if faction == cm:get_local_faction(true) then
        if not ignoreTickBoxStateCorrection then
            if tier == -2 then
                correctTaxCheckBoxState(false);
            else
                correctTaxCheckBoxState(true);
            end
        end
        cm:callback(
            function()
                correctTaxButtonState(tier);
            end, 0, "TaxTierCallback"
        )
    end
    provinceTaxTiers[province] = tier;
    cm:set_saved_value("provinceTaxTiers", GetTableSaveState(provinceTaxTiers));
end

--v function(buttonSize: number) --> vector<BUTTON>
function createButtons(buttonSize)
    local buttons = {} --: vector<BUTTON>
    local lowTaxButton = Button.new("lowTaxButton", core:get_ui_root(), "SQUARE_TOGGLE", "ui/skins/low_tax.png");
    taxTierButtons[-1] = lowTaxButton;
    lowTaxButton:RegisterForClick(
        function(context)
            --DF: changed this to a trigger
            CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction(true)):command_queue_index(), "TierTax|"..getCurrentprovince()..">-1")
        end
    );
    lowTaxButton:Resize(buttonSize, buttonSize);
    table.insert(buttons, lowTaxButton);
    local midTaxButton = Button.new("midTaxButton", core:get_ui_root(), "SQUARE_TOGGLE", "ui/skins/medium_tax.png");
    taxTierButtons[0] = midTaxButton;
    midTaxButton:Resize(buttonSize, buttonSize);
    midTaxButton:RegisterForClick(
        function(context)
            --DF: changed this to a trigger
            CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction(true)):command_queue_index(), "TierTax|"..getCurrentprovince()..">0")
        end
    );
    table.insert(buttons, midTaxButton);
    local highTaxButton = Button.new("highTaxButton", core:get_ui_root(), "SQUARE_TOGGLE", "ui/skins/high_tax.png");
    taxTierButtons[1] = highTaxButton;
    highTaxButton:Resize(buttonSize, buttonSize);
    highTaxButton:RegisterForClick(
        function(context)
            --DF: changed this to a trigger
            CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction(true)):command_queue_index(), "TierTax|"..getCurrentprovince()..">1")
        end
    );
    table.insert(buttons, highTaxButton);
    return buttons;
end

local dummy = nil --: DUMMY
--v function(size: number)
function expandProvincePanel(size)
    local provincePanel = getProvincePanel();
    dummy = Dummy.new(core:get_ui_root());
    dummy:Resize(10, size);
    provincePanel:Adopt(dummy.uic:Address());
end

--v function(gap: number)
function movePanelsBelowTax(gap)
    local provincePanel = getProvincePanel();
    local taxPanel = getTaxPanel();
    local taxFound = false;
    for i=0, provincePanel:ChildCount()-1  do
        local child = UIComponent(provincePanel:Find(i));
        if taxFound then
            local x, y = child:Position();
            child:MoveTo(x, y + gap);
        end
        if child == taxPanel then
            taxFound = true;
        end
    end
end

function addTaxTierButtons()
    out("Adding tier tax buttons");
    local provincePanel = getProvincePanel();
    local ppw, pph = provincePanel:Bounds();
    local buttonSize = ppw/7;
    local rowSize = buttonSize;

    expandProvincePanel(rowSize);

    Util.recurseThroughChildrenApplyingFunction(
        UIComponent(provincePanel:Parent()),
        function(child)
            child:SetCanResizeHeight(false);
            child:SetCanResizeWidth(false);
        end
    );

    local buttons = createButtons(buttonSize);
    local buttonContainer = Container.new(FlowLayout.HORIZONTAL);
    buttonContainer:AddGap(buttonSize);
    for i, button in ipairs(buttons) do
        provincePanel:Adopt(button.uic:Address());
        buttonContainer:AddComponent(button);
        buttonContainer:AddGap(buttonSize);
    end

    movePanelsBelowTax(rowSize);

    local taxPanel = getTaxPanel();
    local x, y = taxPanel:Position();
    local w, h = taxPanel:Bounds();

    buttonContainer:MoveTo(x, y + h);
end

function removeTaxTierButtons()
    deleteComponentWithName("lowTaxButton");
    deleteComponentWithName("midTaxButton");
    deleteComponentWithName("highTaxButton");
    if dummy then
        dummy:Delete();
    end
    core:remove_listener("TaxCheckBoxListener");
end

function registerForTaxCheckbox()
    local taxCheckBox = getTaxOnCheckBox();
    Util.registerForClick(
        taxCheckBox, "TaxCheckBoxListener",
        function(context)
            if ignoreTickboxClick then
                return;
            end
            ignoreTickBoxStateCorrection = true;
            local province = getCurrentprovince();
            if taxCheckBox:CurrentState() == "selected_down" then
                CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction(true)):command_queue_index(), "TierTax|"..getCurrentprovince()..">-2")
            else
                CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction(true)):command_queue_index(), "TierTax|"..getCurrentprovince()..">0")
            end
            ignoreTickBoxStateCorrection = false;
        end
    );
end

--v function(province: string) --> int
function calculateCurrentTaxTier(province)
    if provinceTaxTiers[province] then
        return provinceTaxTiers[province];
    end
    local taxCheckBox = getTaxOnCheckBox();
    local isTicked = taxCheckBox:CurrentState() == "selected";
    if not isTicked then
        return -2;
    end
    return 0;
end

function applyCurrentTaxTier()
    local province = getCurrentprovince();
    --DF: changed this to a trigger
    CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction(true)):command_queue_index(), "TierTax|"..province..">"..calculateCurrentTaxTier(province))
end

--v function() --> boolean
function localFactionUsesTax()
    local playerFaction = cm:get_faction(cm:get_local_faction(true));
    if wh_faction_is_horde(playerFaction) then
        return false;
    end
    if playerFaction:subculture() == "wh2_main_sc_def_dark_elves" then
        return false;
    end
    return true;
end

function init()
    core:add_listener(
        "TaxTierButtonAdder",
        "PanelOpenedCampaign",
        function(context) 
            return context.string == "settlement_panel"; 
        end,
        function(context)
            uiOpen = true;
            addTaxTierButtons();
            registerForTaxCheckbox();
            applyCurrentTaxTier();
        end,
        true
    );
    
    core:add_listener(
        "TaxTierButtonRemover",
        "PanelClosedCampaign",
        function(context) 
            return context.string == "settlement_panel"; 
        end,
        function(context)
            uiOpen = false;
            removeTaxTierButtons();
        end,
        true
    );
    
    core:add_listener(
        "TieredTaxSettlementListener",
        "SettlementSelected",
        function()
            return true;
        end,
        function(context)
            --# assume context: CA_SETTLEMENT_CONTEXT
            currentprovince = context:garrison_residence():region():province_name();
            if uiOpen then
                if provinceTaxTiers[currentprovince] then
                    ignoreTickBoxStateCorrection = true;
                    applyCurrentTaxTier();
                    ignoreTickBoxStateCorrection = false;
                else
                    cm:callback(
                        function()
                            ignoreTickBoxStateCorrection = true;
                            applyCurrentTaxTier();
                            ignoreTickBoxStateCorrection = false;
                        end, 0, "TieredTaxSettlementChanged"
                    );
                end
            end
        end,
        true
    );
    
    core:add_listener(
        "TieredTaxGarrisonOccupiedListener",
        "GarrisonOccupiedEvent",
        function(context)
            return true;
        end,
        function(context)
            local province = context:garrison_residence():region():province_name();
            if not provinceTaxTiers[province] then
                return;
            end
            updateEffectBundles(province, provinceTaxTiers[province]);
        end,
        true
    );
    
    core:add_listener(
        "TieredTaxCharacterRazedListener",
        "CharacterRazedSettlement",
        function(context)
            return true;
        end,
        function(context)
            local region = context:character():region();
            local province = region:province_name();
            if not provinceTaxTiers[province] then
                return;
            end
            updateEffectBundles(province, provinceTaxTiers[province]);
        end,
        true
    );
    
    core:add_listener(
        "TieredTaxConfederationListener",
        "FactionJoinsConfederation",
        function(context)
            return true;
        end,
        function(context)
            local faction = context:confederation();
            local regionList = faction:region_list();
            
            for i = 0, regionList:num_items() - 1 do
                local region = regionList:item_at(i);
                local province = region:province_name();
                if provinceTaxTiers[province] then
                    updateEffectBundles(province, provinceTaxTiers[province]);
                end
            end
        end,
        true
    );

    --DRUNK FLAMINGO ADDITIONS
    core:add_listener(
        "TaxSetTierTax",
        "UITriggerScriptEvent",
        function(context)
            return context:trigger():starts_with("TierTax|")
        end,
        function(context)
            local str = context:trigger() --:string
            local info = string.gsub(str, "TierTax|", "")
            local province_end = string.find(info, ">")
            local province = string.sub(info, 1, province_end - 1)
            local level = tonumber(string.sub(info, province_end + 1))
            local faction = cm:model():faction_for_command_queue_index(context:faction_cqi()):name()
            --# assume level: integer
            applyTaxTier(province, level, faction)
        end,
        true
    )

    
    local tableString = cm:get_saved_value("provinceTaxTiers");
    if tableString then
        provinceTaxTiers = loadstring(cm:get_saved_value("provinceTaxTiers"))();
    end
end

if localFactionUsesTax() then
    out("Tiered Tax V2 init start");
    init();
    out("Tiered Tax V2 init end");
end