mcm = _G.mcm
--# assume io.remove: function(string)
local BasicSettingsMod = mcm:register_mod("mcm_basic", "Basic Mod Settings", "Contains basic settings for using mods")
local BasicSettingsWarnings = BasicSettingsMod:add_tweaker("basic_warning", "Warn on Lua Error", "Create an event popup warning the player if a lua runtime error is encountered in a mod file")
BasicSettingsWarnings:add_option("false", "Don't warn me", "Disable this option")
BasicSettingsWarnings:add_option("true", "Warn me", "Enable this option")


mcm:add_post_process_callback(function()
    if cm:get_saved_value("mcm_tweaker_mcm_basic_basic_warning_value") == true then
        mcm:set_should_warn()
        mcm:error_checker()
    end
end)

--for patreon demo: remove from release

local AIConfederationsMod = mcm:register_mod("confed_tweaks", "Confederation Tweaks", "Tweak how confederations happen on the map!")

local dwarfs = AIConfederationsMod:add_tweaker("dwf", "Dwarfs", "Allow the Dwarfs to confederate")
dwarfs:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
dwarfs:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
dwarfs:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
dwarfs:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")


local high_elves = AIConfederationsMod:add_tweaker("hef", "High Elves", "Allow the High Elves to confederate")
high_elves:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
high_elves:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
high_elves:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
high_elves:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")


local empire = AIConfederationsMod:add_tweaker("emp", "Empire", "Allow the Empire to confederate")
empire:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
empire:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
empire:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
empire:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")


local bret = AIConfederationsMod:add_tweaker("brt", "Bretonnia", "Allow the Bretonnia Dukedoms to confederate")
bret:add_option("yeild", "Vanilla", "Allow Bretonnia to confederate only through technology")
bret:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate through technology")
bret:add_option("false", "No Confederations", "Allow no factions of this race to confederate")

local norsca = AIConfederationsMod:add_tweaker("nor", "Norsca", "Allow the Norsca to confederate")
norsca:add_option("yeild", "Normal Confederation", "Allow any faction of this race to confederate through defeating faction leaders")
norsca:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
norsca:add_option("false", "No Confederations", "Allow no factions of this race to confederate")

local vamps = AIConfederationsMod:add_tweaker("vmp", "Vampire Counts", "Allow the Vampire Counts to confederate")
vamps:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
vamps:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
vamps:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
vamps:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")

local def = AIConfederationsMod:add_tweaker("def", "Dark Elves", "Allow the Dark Elves to confederate")
def:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
def:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
def:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
def:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")

local Lizardmen = AIConfederationsMod:add_tweaker("liz", "Lizardmen", "Allow the Lizardmen to confederate")
Lizardmen:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
Lizardmen:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
Lizardmen:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
Lizardmen:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")

local Skaven = AIConfederationsMod:add_tweaker("skv", "Skaven", "Allow the Skaven to confederate")
Skaven:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
Skaven:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
Skaven:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
Skaven:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")

local Greenskins = AIConfederationsMod:add_tweaker("grn", "Greenskins", "Allow the Greenskins to confederate")
Greenskins:add_option("true", "Free Confederation", "Allow any faction of this race to confederate")
Greenskins:add_option("player_only", "Player Only", "Only allow player factions of this race to confederate")
Greenskins:add_option("false", "No Confederations", "Allow no factions of this race to confederate")
Greenskins:add_option("yeild", "Don't Tweak", "If you have other mods which control confederation, you may wish to select this option")