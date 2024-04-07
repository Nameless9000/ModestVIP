local stand = menu.ref_by_path("Stand")
stand:list("Modest VIP",{},"")

menu.my_root():action("Restart Menu", {"restartmodestvip"}, "", function()
	menu.trigger_commands("stoplua mainmenu")
	stand:focus()
	util.yield(500)
	menu.trigger_commands("startlua mainmenu")
end)
