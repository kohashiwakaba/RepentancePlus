-- A lot of this code is based on Antibirth Announcer+ Dead Sea Scrolls Menu 
-- Thanks to Jerb for making it possible
--
local DSSModName = "Dead Sea Scrolls (Repentance Plus)"

local bossMarks = {
    "Boss Rush",
    "Mom's Heart",
    "Blue Baby",
    "Satan",
    "Isaac",
    "Greed",
    "Character Unlock"
}

local specialunlocks = {"Black Chest", "Scarlet Chest", "Flesh Chest", "Coffin", "Stargazer", "Tainted Rocks", "Birth Certificate"}

local specialunlockdescriptions = {
    ["Black Chest"] = {"enter a", "devil room", "5 times"}, 
    ["Scarlet Chest"] = {"enter an", "ultra secret", "room", "3 times"}, 
    ["Flesh Chest"] = {"enter a", "curse room", "10 times"},
    ["Coffin"] = {"enter a", "secret room", "10 times"},
    ["Stargazer"] = {"enter a", "planetarium", "3 times"}, 
    ["Tainted Rocks"] = {"enter a", "super secret", "room", "5 times"},
    ["Birth Certificate"] = {"earn all", "repentance+", "unlocks"}
}

local playerTypeToName = {
    [21] = "isaac",
    [22] = "magdalene",
    [23] = "cain",
    [24] = "judas",
    [25] = "???",
    [26] = "eve",
    [27] = "samson",
    [28] = "azazel",
    [29] = "lazarus",
    [30] = "eden",
    [31] = "lost",
    [32] = "lilith",
    [33] = "keeper",
    [34] = "apollyon",
    [35] = "forgotten",
    [36] = "bethany",
    [37] = "jacob"
}

local heartnames = {
    [84] = "broken heart",
    [85] = "dauntless heart",
    [86] = "hoarder heart",
    [87] = "deceiver heart",
    [88] = "soiled heart",
    [89] = "curdled heart",
    [90] = "savage heart",
    [91] = "benighted heart",
    [92] = "enigma heart",
    [93] = "capricious heart",
    [94] = "baleful heart",
    [95] = "harlot heart",
    [96] = "miser heart",
    [97] = "empty heart",
    [98] = "fettered heart",
    [99] = "zealot heart",
    [100] = "deserter heart"
}

local DSSCoreVersion = 6

local MenuProvider = {}

function MenuProvider.SaveSaveData()
    rplus.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return rplus.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    rplus.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return rplus.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        rplus.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return rplus.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    rplus.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return rplus.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    rplus.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return rplus.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    rplus.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return rplus.GetSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    rplus.GetSaveData().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return rplus.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    rplus.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return rplus.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    rplus.GetSaveData().MenusPoppedUp = var
end

local DSSInitializerFunction = include("scripts.dssmenucore")
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

local rplusdirectory = {
    main = {
    title = 'repentance plus',
        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'unlocks', dest = 'unlocks'},
            {str = 'fart button',
            func = function(button, item, menuObj)
                SFXManager():Play(SoundEffect.SOUND_FART , 1, 0, false, math.random(11, 13) / 10)
            end}
        },
        tooltip = dssmod.menuOpenToolTip
    },
    unlocks = {
        title = 'unlocks',
        buttons = {
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,

        }
    }
}


for p = 21, 37 do
	local Charactername = playerTypeToName[p]
	if Charactername == "???" then Charactername = "bluebaby" end
	local unlockpage = {
        title = playerTypeToName[p],
        buttons = {
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
        }
    }
	rplusdirectory[Charactername] = unlockpage
	rplusdirectory.unlocks.buttons[#rplusdirectory.unlocks.buttons+1] = {str = 'tainted '..playerTypeToName[p], dest = Charactername}
    rplusdirectory.unlocks.buttons[#rplusdirectory.unlocks.buttons+1] = {str = "", fsize = 1, nosel = true}
    for _, boss in pairs(bossMarks) do
        local button
        local itemname 
        local text = {'defeat', string.lower(boss), 'as', 't. '..playerTypeToName[p]}
        local variant = rplus.GetSaveData()[tostring(p)][boss].Variant
        local subtype = rplus.GetSaveData()[tostring(p)][boss].SubType
        if variant == 100 then 
            itemname = Isaac.GetItemConfig():GetCollectible(subtype).Name
        elseif variant == 350 then 
            itemname = Isaac.GetItemConfig():GetTrinket(subtype).Name
        elseif variant == 10 then  
            itemname = heartnames[subtype]
            text = {'unlock', 't. '..playerTypeToName[p]}
        elseif variant == 300 then 
            itemname = Isaac.GetItemConfig():GetCard(subtype).Name
        else
            itemname = Isaac.GetItemConfig():GetPillEffect(subtype).Name
        end
        
        button = {
            str = string.lower(itemname),
            choices = {'locked', 'unlocked'},
            variable = tostring(p).."_"..boss,
            setting = 2,
            load = function()
                return rplus.savedata[tostring(p)][boss].Unlocked and 2 or 1
            end,
            store = function(var)
                rplus.savedata[tostring(p)][boss].Unlocked = var == 2
            end,
            tooltip = {strset = text}
        }
        rplusdirectory[Charactername].buttons[#rplusdirectory[Charactername].buttons+1] = button 

    end
     
end

local unlockpage = {
    title = 'special unlocks',
    buttons = {
        dssmod.gamepadToggleButton,
        dssmod.menuKeybindButton,
        dssmod.paletteButton,
    }
}
rplusdirectory["special"] = unlockpage
rplusdirectory.unlocks.buttons[#rplusdirectory.unlocks.buttons+1] = {str = "-----------------", fsize = 3, nosel = true}
rplusdirectory.unlocks.buttons[#rplusdirectory.unlocks.buttons+1] = {str = "", fsize = 1, nosel = true}
rplusdirectory.unlocks.buttons[#rplusdirectory.unlocks.buttons+1] = {str = 'special unlocks', dest = "special"}

for _, unlock in pairs(specialunlocks) do
    local button = {
        str = string.lower(unlock),
        choices = {'locked', 'unlocked'},
        variable = unlock,
        setting = 2,
        load = function()
            return rplus.savedata["Special"][unlock].Unlocked and 2 or 1
        end,
        store = function(var)
            rplus.savedata["Special"][unlock].Unlocked = var == 2
        end,
        tooltip = {strset = specialunlockdescriptions[unlock]}
    }
    rplusdirectory["special"].buttons[#rplusdirectory["special"].buttons+1] = button 
end

local rplusdirectorykey = {
    Item = rplusdirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}



DeadSeaScrollsMenu.AddMenu("Repentance Plus", {Run = dssmod.runMenu, Open = dssmod.openMenu, Close = dssmod.closeMenu, Directory = rplusdirectory, DirectoryKey = rplusdirectorykey})




