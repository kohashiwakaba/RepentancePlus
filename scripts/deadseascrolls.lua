-- A lot of this code is based on Antibirth Announcer+ Dead Sea Scrolls Menu 
-- Thanks to Jerb for making it possible!! <3
local DSSModName = "Dead Sea Scrolls (Repentance Plus)"
local mod = RepentancePlusMod
local json = require("json")

local bossMarks = {
    "Boss Rush",
    "Mom's Heart",
    "Blue Baby",
    "Satan",
    "Isaac",
    "Greed",
    "Character Unlock"
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

local function getDssSettings()
	return CustomData.DssSettings
end
mod.getDssSettings = getDssSettings

local function storeDssSettings()
	Isaac.SaveModData(mod, json.encode(CustomData))
end
mod.storeDssSettings = storeDssSettings

function MenuProvider.SaveSaveData()
    mod.storeDssSettings()
end

--[[
    SETTERS AND GETTERS
]]

function MenuProvider.GetPaletteSetting()
    return mod.getDssSettings().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    mod.getDssSettings().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return mod.getDssSettings().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        mod.getDssSettings().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return mod.getDssSettings().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    mod.getDssSettings().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return mod.getDssSettings().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    mod.getDssSettings().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return mod.getDssSettings().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    mod.getDssSettings().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return mod.getDssSettings().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    mod.getDssSettings().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return mod.getDssSettings().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    mod.getDssSettings().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return mod.getDssSettings().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    mod.getDssSettings().MenusPoppedUp = var
end

--[[
    CORE
]]

local DSSInitializerFunction = include("scripts.dssmenucore")
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

-- Some configs are wrong and cause errors, this is a handler for them
local function getConfigName(desc)
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
            dssmod.menuHintButton,
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
	table.insert(modDirectory.unlocks.buttons, {str = 'tainted '..characterName, dest = characterName})
    table.insert(modDirectory.unlocks.buttons, {str = "", fsize = 1, nosel = true})

    for _, boss in pairs(bossMarks) do
        table.insert(modDirectory[characterName].buttons, {
            str = "???",
            choices = {'locked', 'unlocked'},
            variable = tostring(p).. "_" .. boss,
            setting = 2,
            load = function()
                return CustomData.Unlocks[tostring(p)][boss].Unlocked and 2 or 1
            end,
            store = function(var)
                CustomData.Unlocks[tostring(p)][boss].Unlocked = var == 2
            end,
            generate = function(button, item, tbl)
                local itemname
                local v = CustomData.Unlocks[tostring(p)][boss].Variant
                local s = CustomData.Unlocks[tostring(p)][boss].SubType
                local text = {
                    'defeat',
                    string.lower(boss),
                    'as',
                    't. ' .. characterName
                }

                if v == 100 then
                    itemname = getConfigName(Isaac.GetItemConfig():GetCollectible(s))
                elseif v == 350 then
                    itemname = getConfigName(Isaac.GetItemConfig():GetTrinket(s))
                elseif v == 10 then
                    itemname = heartTypeToName[s]
                    text = {'unlock', 't. ' .. characterName}
                elseif v == 300 then
                    itemname = getConfigName(Isaac.GetItemConfig():GetCard(s))
                else
                    itemname = getConfigName(Isaac.GetItemConfig():GetPillEffect(s))
                end

                button.str = string.lower(itemname)
                button.tooltip = {strset = text}
            end
        })
    end
end

modDirectory["special"] = {
    title = 'special unlocks',
    buttons = {}
}

table.insert(modDirectory.unlocks.buttons, {
    str = "-----------------",
    fsize = 3,
    nosel = true
})
table.insert(modDirectory.unlocks.buttons, {
    str = 'special unlocks',
    dest = "special"
})

for _, unlock in pairs({"Black Chest", "Scarlet Chest", "Flesh Chest", "Coffin", "Stargazer", "Tainted Rocks", "Birth Certificate"}) do
    table.insert(modDirectory["special"].buttons, {
        str = string.lower(unlock),
        choices = {'locked', 'unlocked'},
        variable = unlock,
        setting = 2,
        load = function()
            return CustomData.Unlocks["Special"][unlock].Unlocked and 2 or 1
        end,
        store = function(var)
            CustomData.Unlocks["Special"][unlock].Unlocked = var == 2
        end,
        tooltip = {strset = specialUnlocksDescriptions[unlock]}
    })
end

local modDirectoryKey = {
    Item = modDirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu(
    "Repentance Plus",
    {
        Run = dssmod.runMenu,
        Open = dssmod.openMenu,
        Close = dssmod.closeMenu,
        Directory = modDirectory,
        DirectoryKey = modDirectoryKey
    }
)


