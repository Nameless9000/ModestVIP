util.require_natives("3095a", "g")

local TITLE_TEXT ="Kiddion's VIP Menu v1.0.0"

local root = menu.ref_by_path("Stand>Modest VIP")

local game = root:list("Game")
local player = root:list("Player")
local vehicle = root:list("Vehicle")
local weapon = root:list("Weapon")
local world = root:list("World")
local teleport = root:list("Teleport")
local tunables = root:list("Tunables")
local unlocks = root:list("Unlocks")
local story_mode = root:list("Story Mode")
local online_players = root:list("Online Players")
local online_services = root:list("Online Services")
local online_vehicle_spawn = root:list("Online Vehicle Spawn")
local online_protection = root:list("Online Protection")
local scripts = root:list("Scripts")
local menu_settings = root:list("Menu Settings")

-- // Online Players \\ --
online_players:onFocus(function()
	for online_players:getChildren() as ref do
		if ref:getType() ~= COMMAND_DIVIDER then continue end
		
		menu.delete(ref)
	end
end)

local menus = {}
local player_scripts = {}
local function player_list(player_id)
    if not NETWORK_IS_SESSION_ACTIVE() or menus[player_id] then return end
	if player_id in menus:map(|k|->k,true) then return end
	
	local player_name = players.get_name(player_id)
	local player_root = menu.player_root(player_id)
	
	menus[player_id] = online_players:list(player_name, {}, "")
	
	local root = menus[player_id]
	
	root:toggle("Quick Spectate", {}, "", function(on)
		menu.ref_by_rel_path(player_root, "Spectate>Legit Method").value = on
	end)

	root:action("CEO Ammo Drop", {}, "", function()
	
	end)
	root:action("CEO Armor Drop", {}, "", function()
	
	end)
	root:action("CEO BST Drop", {}, "", function()
	
	end)
	root:action("CEO Molotov Drop", {}, "", function()
	
	end)
	root:action("CEO Chocolat Drop", {}, "", function()
	
	end)
	root:action("Teleport", {}, "", function()
		menu.ref_by_rel_path(player_root, "Teleport>Teleport To Them"):trigger()
	end)
	
	player_scripts[player_id] = root:list("Scripts")
end

local function handle_player_list(player_id)
    local ref = menus[player_id]
    if players.exists(player_id) then return end
    if not ref then return end
	
	pcall(menu.delete, ref)
	menus[player_id] = nil
	player_scripts[player_id] = nil
end

players.on_join(player_list)
players.on_leave(handle_player_list)
players.dispatch_on_join()

-- // Online Protection \\ --
online_protection:toggle("Disable Freeze", {}, "", function()end)
online_protection:toggle("Disable PTFX", {}, "", function()end)
online_protection:toggle("Disable Remote Alter Wanted Level", {}, "", function()end)
online_protection:toggle("Disable Remote Control", {}, "", function()end)
online_protection:toggle("Disable Remote Ragdoll", {}, "", function()end)
online_protection:toggle("Disable Remote Sound", {}, "", function()end)
online_protection:toggle("Disable Remote Teleport", {}, "", function()end)
online_protection:toggle("Disable Remove All Weapons", {}, "", function()end)
online_protection:toggle("Disable Remove Weapon", {}, "", function()end)
online_protection:toggle("Disable Camera Control", {}, "", function()end)
online_protection:toggle("Disable Send to Island", {}, "", function()end)
online_protection:toggle("Disable Send to Job", {}, "", function()end)
online_protection:toggle("Disable Apartment Teleport", {}, "", function()end)
online_protection:toggle("Disable Vehicle Kick", {}, "", function()end)
online_protection:toggle("Disable Weather Control", {}, "", function()end)
online_protection:toggle("Report Protection", {}, "", function()end, true)
online_protection:action("Detach Objects", {}, "", function()end)

-- // Menu Settings \\ --
local streamproof_rendering = menu.ref_by_path("Stand>Settings>Appearance>Stream-Proof Rendering")
menu_settings:toggle("Exclude from Capture", {}, "", function(on)
	streamproof_rendering.value = on
end, streamproof_rendering.value)

local menu_x_positon = menu.ref_by_path("Stand>Settings>Appearance>Position>X")
menu_settings:slider("Menu X position", {}, "", 0, 4096, menu_x_positon.value, 1, function(x)
	menu_x_positon.value = x
end)

local menu_y_positon = menu.ref_by_path("Stand>Settings>Appearance>Position>X")
menu_settings:slider("Menu Y position", {}, "", 0, 4096, menu_y_positon.value, 1, function(y)
	menu_y_positon.value = y
end)

local max_viewable_commands = menu.ref_by_path("Stand>Settings>Appearance>Max Visible Commands")
menu_settings:slider("Max viewable items", {}, "", 0, 100, max_viewable_commands.value, 1, function(max)
	max_viewable_commands.value = max
end)

menu_settings:slider("Opacity", {}, "", 0, 255, 192, 0, function()end)
menu_settings:textslider("Select Theme", {}, "", {"[Default]"}, function()end)
menu_settings:toggle("Disable Handling Restore", {}, "", function()end)
menu_settings:toggle("Disable Weapon Restore", {}, "", function()end)
menu_settings:action("Enable Lua Debug Console", {}, "", function()end)

menu_settings:action("Save Config", {}, "", function()
	menu.ref_by_path("Stand>Profiles>ModestVIP>Save"):trigger()
end)

menu_settings:action("Reload Config",{},"",function()
	menu.ref_by_path("Stand>Profiles>ModestVIP>Load"):trigger()
end)

menu_settings:action("Reload Scripts", {}, "", function()
	-- wip
end)

menu_settings:action("Reload Themes", {}, "", function()
	menu.ref_by_path("Stand>Lua Scripts>ModestVIP>InitialMenu>Restart Menu"):trigger()
end)

menu_settings:action("Quit", {}, "", function()
	menu.ref_by_path("Stand>Unload Stand"):trigger()
end)

-- update number
local no_tab_list = 0
util.create_tick_handler(function()
	local current_list = menu.get_current_menu_list()
	local children = current_list:getChildren()
	
	if current_list == no_tab_list then
		return
	end
	
	if #children == 0 then
		return
	end

	if children[1].menu_name ~= TITLE_TEXT then
		local success, _ = pcall(menu.attach_before, children[1], menu.shadow_root():divider(TITLE_TEXT))
		if not success then
			no_tab_list = current_list
		end
		return
	end
	
	local counter = children[#children]
	
	local max_index = #children-2
	local current_index = 1
	for i, item in ipairs(children) do
		if not item:isFocused() then continue end
		
		current_index = i
	end
	
	if children[#children]:getType() ~= COMMAND_DIVIDER then
		counter = children[#children]:attachAfter(menu.shadow_root():divider("Loading..."))
	end
	
	counter.menu_name = $"{current_index - 1} / {max_index}"
end)
