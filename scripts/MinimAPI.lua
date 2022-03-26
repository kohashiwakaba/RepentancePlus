--MinimapAPI:AddPickup(id, Icon, EntityType, number variant, number subtype, function, icongroup, number priority)
--MinimapAPI:AddIcon(id, Sprite, string animationName, number frame, (optional) Color color)

local Icons = Sprite()
Icons:Load("gfx/ui/ui_minimapi_icons_rplus.anm2", true)

-- stargazer beggar
MinimapAPI:AddIcon("stargazerslot", Icons, "stargazerslot", 0)
MinimapAPI:AddPickup("stargazerslot", "stargazerslot", 6, 335, -1, MinimapAPI.PickupSlotMachineNotBroken, "slots", 0)

-- chests
MinimapAPI:AddIcon("scarletchest", Icons, "scarletchest", 0)
MinimapAPI:AddPickup("scarletchest", "scarletchest", 5, 512, -1, MinimapAPI.PickupNotCollected, "chests", 7550)

MinimapAPI:AddIcon("fleshchest", Icons, "fleshchest", 0)
MinimapAPI:AddPickup("fleshchest", "fleshchest", 5, 513, -1, MinimapAPI.PickupNotCollected, "chests", 7050)

MinimapAPI:AddIcon("blackchest", Icons, "blackchest", 0)
MinimapAPI:AddPickup("blackchest", "blackchest", 5, 514, -1, MinimapAPI.PickupNotCollected, "chests", 7450)

MinimapAPI:AddIcon("coffin", Icons, "coffin", 0)
MinimapAPI:AddPickup("coffin", "coffin", 5, 515, -1, MinimapAPI.PickupNotCollected, "chests", 7650)

-- tainted hearts
MinimapAPI:AddIcon("brokenheart", Icons, "brokenheart", 0)
MinimapAPI:AddPickup("brokenheart", "brokenheart", 5, 10, 84, MinimapAPI.PickupNotCollected, "hearts", 10750)

MinimapAPI:AddIcon("dauntlessheart", Icons, "dauntlessheart", 0)
MinimapAPI:AddPickup("dauntlessheart", "dauntlessheart", 5, 10, 85, MinimapAPI.PickupNotCollected, "hearts", 10750)

MinimapAPI:AddIcon("hoardedheart", Icons, "hoardedheart", 0)
MinimapAPI:AddPickup("hoardedheart", "hoardedheart", 5, 10, 86, MinimapAPI.PickupNotCollected, "hearts", 10250)

MinimapAPI:AddIcon("soiledheart", Icons, "soiledheart", 0)
MinimapAPI:AddPickup("soiledheart", "soiledheart", 5, 10, 88, MinimapAPI.PickupNotCollected, "hearts", 10350)

MinimapAPI:AddIcon("curdledheart", Icons, "curdledheart", 0)
MinimapAPI:AddPickup("curdledheart", "curdledheart", 5, 10, 89, MinimapAPI.PickupNotCollected, "hearts", 10450)

MinimapAPI:AddIcon("savageheart", Icons, "savageheart", 0)
MinimapAPI:AddPickup("savageheart", "savageheart", 5, 10, 90, MinimapAPI.PickupNotCollected, "hearts", 10450)

MinimapAPI:AddIcon("benightedheart", Icons, "benightedheart", 0)
MinimapAPI:AddPickup("benightedheart", "benightedheart", 5, 10, 91, MinimapAPI.PickupNotCollected, "hearts", 10650)

MinimapAPI:AddIcon("enigmaheart", Icons, "enigmaheart", 0)
MinimapAPI:AddPickup("enigmaheart", "enigmaheart", 5, 10, 92, MinimapAPI.PickupNotCollected, "hearts", 10750)

MinimapAPI:AddIcon("capriciousheart", Icons, "capriciousheart", 0)
MinimapAPI:AddPickup("capriciousheart", "capriciousheart", 5, 10, 93, MinimapAPI.PickupNotCollected, "hearts", 10750)

MinimapAPI:AddIcon("emptyheart", Icons, "emptyheart", 0)
MinimapAPI:AddPickup("emptyheart", "emptyheart", 5, 10, 97, MinimapAPI.PickupNotCollected, "hearts", 10650)

MinimapAPI:AddIcon("fetteredheart", Icons, "fetteredheart", 0)
MinimapAPI:AddPickup("fetteredheart", "fetteredheart", 5, 10, 98, MinimapAPI.PickupNotCollected, "hearts", 10550)

MinimapAPI:AddIcon("zealotheart", Icons, "zealotheart", 0)
MinimapAPI:AddPickup("zealotheart", "zealotheart", 5, 10, 99, MinimapAPI.PickupNotCollected, "hearts", 10650)

MinimapAPI:AddIcon("desertedheart", Icons, "desertedheart", 0)
MinimapAPI:AddPickup("desertedheart", "desertedheart", 5, 10, 100, MinimapAPI.PickupNotCollected, "hearts", 10450)	