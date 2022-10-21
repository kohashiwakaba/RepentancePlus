-- A lot of this code is based on Antibirth Announcer+ Dead Sea Scrolls Menu 
-- Thanks to Jerb for making it possible!! <3
--
local DSSModName = "Dead Sea Scrolls (Repentance Plus)"
local mod = RepentancePlusMod

local bossMarks = {
    "Boss Rush",
    "Mom's Heart",
    "Blue Baby",
    "Satan",
    "Isaac",
    "Greed",
    "Character Unlock"
}

local specialUnlocks = {
    "Black Chest",
    "Scarlet Chest",
    "Flesh Chest",
    "Coffin",
    "Stargazer",
    "Tainted Rocks",
    "Birth Certificate"
}

local specialUnlocksDescriptions = {
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

local heartTypeToName = {
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
    mod.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return mod.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    mod.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return mod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        mod.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return mod.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    mod.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return mod.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    mod.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return mod.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    mod.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return mod.GetSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    mod.GetSaveData().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return mod.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    mod.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return mod.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    mod.GetSaveData().MenusPoppedUp = var
end

local DSSInitializerFunction = include("scripts.dssmenucore")
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

-- Some configs are wrong and cause errors, this is a handler for them
local function getNameFromConfig(desc)
    if desc then
        return desc.Name
    end

    return "error string"
end

local modDirectory = {
    main = {
        title = 'repentance plus',
        buttons = {
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
            {str = 'resume game', action = 'resume'},
            {str = 'unlocks', dest = 'unlocks'},
            {
                str = 'fart button',
                func = function(button, item, menuObj)
                    SFXManager():Play(SoundEffect.SOUND_FART , 1, 0, false, math.random(11, 13) / 10)
                end
            }
        },
        tooltip = dssmod.menuOpenToolTip
    },
    unlocks = {
        title = 'unlocks',
        buttons = {}
    }
}

for p = 21, 37 do
	local characterName = playerTypeToName[p]

	modDirectory[characterName] = {
        title = characterName,
        buttons = {}
    }
	modDirectory.unlocks.buttons[#modDirectory.unlocks.buttons + 1] = {str = 'tainted '..characterName, dest = characterName}
    modDirectory.unlocks.buttons[#modDirectory.unlocks.buttons + 1] = {str = "", fsize = 1, nosel = true}

    for _, boss in pairs(bossMarks) do
        local itemname = "???"
        local text = {
            'defeat',
            string.lower(boss),
            'as',
            't. ' .. characterName
        }
        local variant = mod.GetSaveData()[tostring(p)][boss].Variant
        local subtype = mod.GetSaveData()[tostring(p)][boss].SubType

        if variant == 100 then
            itemname = getNameFromConfig(Isaac.GetItemConfig():GetCollectible(subtype))
        elseif variant == 350 then
            itemname = getNameFromConfig(Isaac.GetItemConfig():GetTrinket(subtype))
        elseif variant == 10 then
            itemname = heartTypeToName[subtype]
            text = {'unlock', 't. ' .. characterName}
        elseif variant == 300 then
            itemname = getNameFromConfig(Isaac.GetItemConfig():GetCard(subtype))
        else
            itemname = getNameFromConfig(Isaac.GetItemConfig():GetPillEffect(subtype))
        end

        modDirectory[characterName].buttons[#modDirectory[characterName].buttons + 1] = {
            str = string.lower(itemname),
            choices = {'locked', 'unlocked'},
            variable = tostring(p).. "_" .. boss,
            setting = 2,
            load = function()
                return mod.savedata[tostring(p)][boss].Unlocked and 2 or 1
            end,
            store = function(var)
                mod.savedata[tostring(p)][boss].Unlocked = var == 2
            end,
            tooltip = {strset = text}
        }

    end
end

modDirectory["special"] = {
    title = 'special unlocks',
    buttons = {}
}
modDirectory.unlocks.buttons[#modDirectory.unlocks.buttons + 1] = {str = "-----------------", fsize = 3, nosel = true}
modDirectory.unlocks.buttons[#modDirectory.unlocks.buttons + 1] = {str = "", fsize = 1, nosel = true}
modDirectory.unlocks.buttons[#modDirectory.unlocks.buttons + 1] = {str = 'special unlocks', dest = "special"}

for _, unlock in pairs(specialUnlocks) do
    modDirectory["special"].buttons[#modDirectory["special"].buttons + 1] = {
        str = string.lower(unlock),
        choices = {'locked', 'unlocked'},
        variable = unlock,
        setting = 2,
        load = function()
            return mod.savedata["Special"][unlock].Unlocked and 2 or 1
        end,
        store = function(var)
            mod.savedata["Special"][unlock].Unlocked = var == 2
        end,
        tooltip = {strset = specialUnlocksDescriptions[unlock]}
    }
end

local modDirectorykey = {
    Item = modDirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

-- add the menu
DeadSeaScrollsMenu.AddMenu(
    "Repentance Plus",
    {
        Run = dssmod.runMenu,
        Open = dssmod.openMenu,
        Close = dssmod.closeMenu,
        Directory = modDirectory,
        DirectoryKey = modDirectorykey
    }
)




