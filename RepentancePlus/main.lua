----------------------------------------------------------------------------------------------
-- Welcome to main.lua, please make yourself comfortable while reading all of this bullshit --
-- Popcorn 100g: $5 350g: $10 ----------------------------------------------------------------
-- Nachos 100g, any dip: $6 --------------------- For Saver menus, allergens, other food -----
-- Soft-Drink, any  0.5l: $4 1l: $6 -------------- and further questions please ask our ------
-- Water, sparkling or still  0.5l: $2 1l: $3 ------------------ staff -----------------------
-- Beer 0.33l: $3 ------------------------------------------ Enjoy the show! -----------------
----------------------------------------------------------------------------------------------
									----- VARIABLES -----
									---------------------

local game = Game()
local rplus = RegisterMod("repentanceplus", 1)
local sfx = SFXManager()
local music = MusicManager()
local CustomData
--local json = require("json")

--[[ for displaying achievement papers
achievement = Sprite()
achievement:Load("gfx/ui/achievement/achievements.anm2", true)
--]]

-- used for rendering sprites on the floor/walls
CustomBackDropEntity = Isaac.GetEntityVariantByName("CustomBackDropEntity")

local BASEMENTKEY_CHANCE = 5			-- chance to replace golden chest with the old chest
local HEARTKEY_CHANCE = 5				-- chance for enemy to drop Scarlet chest on death
local CARDRUNE_REPLACE_CHANCE = 2		-- chance to replace vanilla card with card from our mod
local SUPERBERSERKSTATE_CHANCE = 25		-- chance to enter berserk state via Temper Tantrum
local SUPERBERSERK_DELETE_CHANCE = 7	-- chance to erase enemies while in this state
local TRASHBAG_BREAK_CHANCE = 1			-- chance of Bag o' Trash breaking
local CHERRY_SPAWN_CHANCE = 20			-- chance to spawn cherry friend on enemy death
local SLEIGHTOFHAND_CHANCE = 17			-- chance to save your consumable when using it via Sleight of Hand
local JACKOF_CHANCE = 60				-- chance for Jack cards to spawn their respective type of pickup
local BITTENPENNY_UPGRADECHANCE = 17	-- chance to 'upgrade' coins via Bitten Penny
local REDKEY_TURN_CHANCE = 12			-- chance for any pickup to turn into Cracked Key via Red Map trinket
local ENRAGED_SOUL_COOLDOWN = 420		-- 7 seconds in 60 FPS callback; cooldown for Enraged Soul familiar
local CEREM_DAGGER_LAUNCH_CHANCE = 5 	-- chance to launch a dagger
local NIGHT_SOIL_CHANCE = 40 			-- chance to negate curse
local TORNPAGE_CHANCE = 25				-- chance to trigger random book active on hit with Torn Page

Costumes = {
	-- add ONLY NON-PERSISTENT COSTUMES here, because persistent costumes now work without lua
	ORDLIFE = Isaac.GetCostumeIdByPath("gfx/characters/costume_001_ordinarylife.anm2"),
	BIRDOFHOPE = Isaac.GetCostumeIdByPath("gfx/characters/costume_004_birdofhope.anm2")
}

TearVariants = {
	CEREMDAGGER = Isaac.GetEntityVariantByName("Ceremonial Dagger Tear")
}

Familiars = {
	BAGOTRASH = Isaac.GetEntityVariantByName("Bag O' Trash"),
	ZENBABY = Isaac.GetEntityVariantByName("Zen Baby"),
	CHERRY = Isaac.GetEntityVariantByName("Cherry"),
	BIRD = Isaac.GetEntityVariantByName("Bird of Hope"),
	SOUL = Isaac.GetEntityVariantByName("Enraged Soul")
}

Collectibles = {
	ORDLIFE = Isaac.GetItemIdByName("Ordinary Life"),
	COOKIECUTTER = Isaac.GetItemIdByName("Cookie Cutter"),
	RUBIKSCUBE = Isaac.GetItemIdByName("Rubik's Cube"),
	MAGICCUBE = Isaac.GetItemIdByName("Magic Cube"),
	MAGICPEN = Isaac.GetItemIdByName("Magic Pen"),					
	SINNERSHEART = Isaac.GetItemIdByName("Sinner's Heart"),
	MARKCAIN = Isaac.GetItemIdByName("The Mark of Cain"),			
	BAGOTRASH = Isaac.GetItemIdByName("Bag-o-Trash"),
	TEMPERTANTRUM = Isaac.GetItemIdByName("Temper Tantrum"),
	CHERRYFRIENDS = Isaac.GetItemIdByName("Cherry Friends"),
	ZENBABY = Isaac.GetItemIdByName("Zen Baby"),
	BLACKDOLL = Isaac.GetItemIdByName("Black Doll"),
	BIRDOFHOPE = Isaac.GetItemIdByName("A Bird of Hope"),
	ENRAGEDSOUL = Isaac.GetItemIdByName("Enraged Soul"),
	CEREMDAGGER = Isaac.GetItemIdByName("Ceremonial Blade"),		-- LIMITED SECONDARY PLAYERS FUNCTIONALITY
	CEILINGSTARS = Isaac.GetItemIdByName("Ceiling With the Stars"),
	QUASAR = Isaac.GetItemIdByName("Quasar"),
	TWOPLUSONE = Isaac.GetItemIdByName("2+1"),
	REDMAP = Isaac.GetItemIdByName("Red Map"),
	CHEESEGRATER = Isaac.GetItemIdByName("Cheese Grater"),			-- MINOR COMPATIBILITY ISSUES
	DNAREDACTOR = Isaac.GetItemIdByName("DNA Redactor"),
	TOWEROFBABEL = Isaac.GetItemIdByName("Tower of Babel"),
	BLESSOTDEAD = Isaac.GetItemIdByName("Bless of the Dead")
}

Trinkets = {
	BASEMENTKEY = Isaac.GetTrinketIdByName("Basement Key"),
	KEYTOTHEHEART = Isaac.GetTrinketIdByName("Key to the Heart"),
	SLEIGHTOFHAND = Isaac.GetTrinketIdByName("Sleight of Hand"),
	JUDASKISS = Isaac.GetTrinketIdByName("Judas' Kiss"),			-- MINOR COMPATIBILITY ISSUES
	BITTENPENNY = Isaac.GetTrinketIdByName("Bitten Penny"),
	GREEDSHEART = Isaac.GetTrinketIdByName("Greed's Heart"),		-- MINOR COMPATIBILITY ISSUES
	ANGELSCROWN = Isaac.GetTrinketIdByName("Angel's Crown"),
	CHALKPIECE = Isaac.GetTrinketIdByName("A Piece of Chalk"),
	MAGICSWORD = Isaac.GetTrinketIdByName("Magic Sword"),			-- MINOR COMPATIBILITY ISSUES
	WAITNO = Isaac.GetTrinketIdByName("Wait, No!"),
	EDENSLOCK = Isaac.GetTrinketIdByName("Eden's Lock"),			-- MINOR COMPATIBILITY ISSUES
	ADAMSRIB = Isaac.GetTrinketIdByName("Adam's Rib"),				-- MINOR COMPATIBILITY ISSUES
	NIGHTSOIL = Isaac.GetTrinketIdByName("Night Soil"),
	TORNPAGE = Isaac.GetTrinketIdByName("Torn Page")
}

PocketItems = {
	RJOKER = Isaac.GetCardIdByName("Joker?"),
	SDDSHARD = Isaac.GetCardIdByName("Spindown Dice Shard"),
	REVERSECARD = Isaac.GetCardIdByName("Reverse Card"),
	REDRUNE = Isaac.GetCardIdByName("Red Rune"),
	KINGOFSPADES = Isaac.GetCardIdByName("King of Spades"),
	KINGOFCLUBS = Isaac.GetCardIdByName("King of Clubs"),
	KINGOFDIAMONDS = Isaac.GetCardIdByName("King of Diamonds"),
	NEEDLEANDTHREAD = Isaac.GetCardIdByName("Needle and Thread"),
	QUEENOFDIAMONDS = Isaac.GetCardIdByName("Queen of Diamonds"),
	QUEENOFCLUBS = Isaac.GetCardIdByName("Queen of Clubs"),
	BAGTISSUE = Isaac.GetCardIdByName("Bag Tissue"),
	LOADEDDICE = Isaac.GetCardIdByName("Loaded Dice"),
	JACKOFDIAMONDS = Isaac.GetCardIdByName("Jack of Diamonds"),
	JACKOFCLUBS = Isaac.GetCardIdByName("Jack of Clubs"),
	JACKOFSPADES = Isaac.GetCardIdByName("Jack of Spades"),
	JACKOFHEARTS = Isaac.GetCardIdByName("Jack of Hearts"),
	BEDSIDEQUEEN = Isaac.GetCardIdByName("Bedside Queen"),
	QUASARSHARD = Isaac.GetCardIdByName("Quasar Shard"),
	BUSINESSCARD = Isaac.GetCardIdByName("Business Card"),
	SACBLOOD = Isaac.GetCardIdByName("Sacrificial Blood"),			-- MINOR COMPATIBILITY ISSUES
	FLYPAPER = Isaac.GetCardIdByName("Flypaper"),
	LIBRARYCARD = Isaac.GetCardIdByName("Library Card")
}

PickUps = {
	SCARLETCHEST = Isaac.GetEntityVariantByName("Scarlet Chest")
}

Pills = {
	ESTROGEN = Isaac.GetPillEffectByName("Estrogen Up"),
	LAXATIVE = Isaac.GetPillEffectByName("Laxative")
}

--[[
local Unlocks = { 
	["21"] = { --T.Isaac
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.REVERSECARD}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.ORDLIFE}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = Collectibles.RUBIKSCUBE}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = Trinkets.BASEMENTKEY}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.SDDSHARD}
	},
	["22"] = { --T.Maggy
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.QUEENOFDIAMONDS}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.CHERRYFRIENDS}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.COOKIECUTTER}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = 350, SubType = Trinkets.KEYTOTHEHEART}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.NEEDLEANDTHREAD}
	},
	["23"] = { --T.Cain
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.MARKCAIN}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = 350, SubType = Trinkets.BITTENPENNY}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = 350, SubType = Trinkets.SLEIGHTOFHAND}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.BAGTISSUE}
	},
	["24"] = { --T.Judas
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.JACKOFHEARTS}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.CEREMDAGGER}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = 350, SubType = Collectibles.BLACKDOLL}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = 350, SubType = Trinkets.JUDASKISS}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.SACBLOOD}
	},
	["25"] = {	--T.???
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.FLYPAPER}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.BAGOTRASH}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["26"] = {	--T.Eve
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.BEDSIDEQUEEN}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["27"] = {	--T.Samson
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.JACKOFCLUBS}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.TEMPERTANTRUM}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["28"] = {	--T.Azazel
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["29"] = {	--T.Lazarus
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.JACKOFSPADES}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["30"] = {	--T.Eden
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["31"] = {	--T.Lost
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["32"] = {	--T.Lilith
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = 300, SubType = PocketItems.QUEENOFCLUBS}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["33"] = {	--T.Keeper
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["34"] = {	--T.Appolyon
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.SINNERSHEART}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["35"] = {	--T.Forgor
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["36"] = {	--T.Bethany
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = 100, SubType = Collectibles.CEILINGSTARS}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	},
	["37"] = {	--T.Jacob
		["Boss Rush"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Satan"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Isaac"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Blue Baby"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}, 
		["Greed"] = {Unlocked = false, Type = 5, Variant = nil, SubType = nil}
	}

}
--]]

ScarletChestItems = { 
	16, --Raw Liver
	73, --Cube of Meat
	155, --The Peeper
	176, --Stem Cells
	214, --Anemic
	218, --Placenta
	236, --E. Coli
	253, --Magic Scab
	440, --Kidney Stone
	446, --Dead Tooth
	452, --Varicose Veins
	502, --Large Zit
	509, --Bloodshot Eye
	529, --Pop!
	541, --Marrow
	542, --Slipped Rib
	544, --Pointy Rib
	548, --Jaw Bone
	549, --Brittle Bones
	611, --Larynx
	639, --Yuck Heart
	642, --Magic Skin
	657, --Vasculitis
	676, --Empty Heart
	688, --Inner Child
	695  --Bloody Gust
}
ScarletChestHearts = {1, 2, 5, 10}

StatUps = {
	SINNERSHEART_DMG_MUL = 1.5,
	SINNERSHEART_DMG_ADD = 2,
	SINNERSHEART_SHSP = -0.3,
	SINNERSHEART_TEARHEIGHT = -3, -- negative TearHeight = positive Range
	MARKCAIN_DMG = 0.4,
	LOADEDDICE_LUCK = 10,
	CEREMDAGGER_DMG_MUL = 0.85,
	SACBLOOD_DMG = 1,
	MAGICSWORD_DMG_MUL = 2,
	GRATER_DMG = 0.5,
	BLESS_DMG = 0.5,
	ORDLIFE_TEARS = 0.8
}

-- used by Bag Tissue
PickupWeights = {
	[PickupVariant.PICKUP_HEART] = {
		[HeartSubType.HEART_FULL] = 1,
		[HeartSubType.HEART_HALF] = 1,
		[HeartSubType.HEART_SOUL] = 4,
		[HeartSubType.HEART_ETERNAL] = 6,
		[HeartSubType.HEART_DOUBLEPACK] = 2,
		[HeartSubType.HEART_BLACK] = 5,
		[HeartSubType.HEART_GOLDEN] = 5,
		[HeartSubType.HEART_HALF_SOUL] = 4,
		[HeartSubType.HEART_SCARED] = 1,
		[HeartSubType.HEART_BLENDED] = 3,
		[HeartSubType.HEART_BONE] = 5,
		[HeartSubType.HEART_ROTTEN] = 5 
	},
	[PickupVariant.PICKUP_COIN] = { 
		[CoinSubType.COIN_PENNY] = 1,
		[CoinSubType.COIN_NICKEL] = 3,
		[CoinSubType.COIN_DIME] = 5,
		[CoinSubType.COIN_DOUBLEPACK] = 2,
		[CoinSubType.COIN_LUCKYPENNY] = 7,
		[CoinSubType.COIN_GOLDEN] = 4
	},
	[PickupVariant.PICKUP_KEY] = {
		[KeySubType.KEY_NORMAL] = 1,
		[KeySubType.KEY_GOLDEN] = 5,
		[KeySubType.KEY_DOUBLEPACK] = 2,
		[KeySubType.KEY_CHARGED] = 5
	},
	[PickupVariant.PICKUP_BOMB] = {
		[BombSubType.BOMB_NORMAL] = 2,
		[BombSubType.BOMB_DOUBLEPACK] = 4,
		[BombSubType.BOMB_GOLDEN] = 6
	},
	[PickupVariant.PICKUP_LIL_BATTERY] = {
		[BatterySubType.BATTERY_NORMAL] = 4,
		[BatterySubType.BATTERY_MICRO] = 2,
		[BatterySubType.BATTERY_MEGA] = 8,
		[BatterySubType.BATTERY_GOLDEN] = 5
	}
}

-- Used to animate book usage with Torn Page
TornPageData = {
	TIMER = {0,0,0,0},
	BOOK = nil
}

DIRECTION_FLOAT_ANIM = {
	[Direction.NO_DIRECTION] = "FloatDown", 
	[Direction.LEFT] = "FloatLeft",
	[Direction.UP] = "FloatUp",
	[Direction.RIGHT] = "FloatRight",
	[Direction.DOWN] = "FloatDown"
}

DIRECTION_SHOOT_ANIM = {
	[Direction.NO_DIRECTION] = "FloatShootDown",
	[Direction.LEFT] = "FloatShootRight",
	[Direction.UP] = "FloatShootUp",
	[Direction.RIGHT] = "FloatShootLeft",
	[Direction.DOWN] = "FloatShootDown"
}

DIRECTION_VECTOR = {
	[Direction.NO_DIRECTION] = Vector(0, 1),	-- when you don't shoot or move, you default to HeadDown
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.UP] = Vector(0, -1),
	[Direction.RIGHT] = Vector(1, 0),
	[Direction.DOWN] = Vector(0, 1)
}							

								---------------------
								-- LOCAL FUNCTIONS --
								---------------------

-- Helper function to return a random custom Card to take place of the normal one.
local function GetRandomCustomCard()
	local keys = {}
	for k in pairs(PocketItems) do
	  if k ~= REDRUNE and k ~= QUASARSHARD then table.insert(keys, k) end
	end

	local random_key = keys[math.random(1, #keys)]
	return PocketItems[random_key]
end

--[[
-- Helpers for rendering unlock papers
local function Unlock(checkmark)
	local player = Isaac.GetPlayer(0)
	local playerType = player:GetPlayerType()
	local itemConfig = Isaac.GetItemConfig()
	
	if playerType > 20 then
		if playerType == 38 then 
			playerType = 29
		end
		if playerType == 39 then
			playerType = 37
		end
		playerType = tostring(playerType)
		if not Unlocks[playerType][checkmark].Unlocked and Unlocks[playerType][checkmark].Variant then
			Unlocks[playerType][checkmark].Unlocked = true
			local Variant = Unlocks[playerType][checkmark].Variant
			local SubType = Unlocks[playerType][checkmark].SubType
			local name
			if Variant == 100 then
				name = itemConfig:GetCollectible(SubType).Name
			elseif Variant == 300 then
				name = itemConfig:GetCard(SubType).Name
			elseif Variant == 70 then
				name = itemConfig:GetPillEffect(SubType).Name
			elseif Variant == 350 then
				name = itemConfig:GetTrinket(SubType).Name
			--elseif
				-- manual Name depending on which Pickup to choose from
			end
			
			achievement:ReplaceSpritesheet(3, "gfx/ui/achievement/achievement_" .. name .. ".png")
			achievement:LoadGraphics()
			flagRenderPaper = true
			paperRenderFrame = 0
			Isaac.SaveModData(rplus, json.encode(Unlocks, "Unlocks"))
		end
	end
end

local function RenderAchievementPapers()
	local roomCenter = room:GetCenterPos()
  	local roomTopLeft = room:GetTopLeftPos()
	local roomTypeToRenderPos = {
		[RoomShape.ROOMSHAPE_1x2] = {roomCenter.X, roomTopLeft.Y * 2},
		[RoomShape.ROOMSHAPE_1x1] = {roomCenter.X, roomCenter.Y},
		[RoomShape.ROOMSHAPE_2x2] = {roomTopLeft.X * 5.5, roomTopLeft.Y * 2}
	}
	
	pos = Isaac.WorldToRenderPosition(Vector(roomTypeToRenderPos[room:GetRoomShape()][1], roomTypeToRenderPos[room:GetRoomShape()][2]), true)
	if paperRenderFrame % 2 == 0 then
		achievement:SetFrame("Appear", paperRenderFrame / 2)
	end
	achievement:Render(pos, Vector.Zero, Vector.Zero)
	paperRenderFrame = paperRenderFrame + 1
	if paperRenderFrame >= 75 * 2 then flagRenderPaper = false end
end

function isUltraGreedRoom()
	return game.Difficulty >= 2 and game:GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_1x2 and game:GetLevel():GetStage() == LevelStage.STAGE7_GREED
end
--]]

-- Is this collectible unlocked?
local function IsCollectibleUnlocked(collectibleType)
    local isUnlocked = false
    local itemPool = game:GetItemPool()
    local player = Isaac.GetPlayer(0)
    
    player:AddCollectible(CollectibleType.COLLECTIBLE_CHAOS, 0, false)
    isUnlocked = itemPool:RemoveCollectible(collectibleType)
    player:RemoveCollectible(CollectibleType.COLLECTIBLE_CHAOS)
    
    return isUnlocked    
end

local function GetUnlockedVanillaCollectible(allPools)
	allPools = allPools or false
    local ID = 0
    local itemPool = game:GetItemPool()
    local player = Isaac.GetPlayer(0)
    
    if allPools then 
		player:AddCollectible(CollectibleType.COLLECTIBLE_CHAOS, 0, false) -- makes all items appear in the list
		ID = itemPool:GetCollectible(1, false) -- gets an item without removing it from the item pool
		player:RemoveCollectible(CollectibleType.COLLECTIBLE_CHAOS) -- removes chaos
	else
		local rt = game:GetRoom():GetType()
		local ip
		
		if rt == 2 or rt == 22 then ip = 1
		elseif rt == 5 then ip = 2
		elseif rt == 7 or rt == 8 then ip = 5
		elseif rt == 10 then ip = 12
		elseif rt == 12 then ip = 6
		elseif rt == 14 then ip = 3
		elseif rt == 15 or rt == 29 then ip = 4
		elseif rt == 24 then ip = 26
		else ip = 0
		end
		
		ID = itemPool:GetCollectible(ip, false)
	end
	
	return ID
end

-- Handle displaying error message advising players to restart
local function DisplayErrorMessage()
	local ErrorMessage = "! WARNING ! Custom Mod Data of Repentance Plus wasn't#loaded, the mod could work incorrectly. Our custom data#is loaded when starting a new run. Please restart#or turn off the mod."
	if not CustomData then
		YOffset = 0
		for line in string.gmatch(ErrorMessage, '([^#]+)') do 
			Isaac.RenderText(line, 50, 150 + YOffset, 1, 0.2, 0.2, 1) 
			YOffset = YOffset + 12
		end
	end
end

-- Helper to give proper IV frames on revival								
local function GiveRevivalIVFrames(p)	
	-- taking fake damage
	p:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(p), 1)
	-- stopping 'hit' animation
	local Sprite = p:GetSprite()
	if Sprite:IsPlaying("Hit") then Sprite:Stop() end
	-- stopping hit sound
	if sfx:IsPlaying(SoundEffect.SOUND_ISAAC_HURT_GRUNT) then sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT) end
end

-- Helpers for handling gulped trinkets
local function IsTrinketGulped(trinketType, player)
	player = player or Isaac.GetPlayer(0)
	return player:HasTrinket(trinketType) and player:GetTrinket(0) ~= trinketType and player:GetTrinket(1) ~= trinketType
end

local function GetTrinketGulped(trinketType, player)
	player = player or Isaac.GetPlayer(0)
	local currentTrinket = player:GetTrinket(0)
	local currentTrinket2 = player:GetTrinket(1)
	player:TryRemoveTrinket(currentTrinket)
	player:TryRemoveTrinket(currentTrinket2)
	player:AddTrinket(trinketType)
	player:UseActiveItem(479, false, false, false, false)
	player:AddTrinket(currentTrinket)
	player:AddTrinket(currentTrinket2)
end								
								
								----------------------
								-- GLOBAL FUNCTIONS --
								----------------------

						-- GAME STARTED --											
						------------------
function rplus:OnGameStart(Continued)
	--[[
	if Isaac.HasModData(rplus) then
		local data = Isaac.LoadModData(rplus)
		Unlocks = json.decode(data)
	else
		Isaac.SaveModData(rplus, json.encode(Unlocks, "Unlocks"))
	end
	--]]
	
	if not Continued then
		CustomData = {
			Items = {
				BIRDOFHOPE = {NumRevivals = 0, BirdCaught = true},
				RUBIKSCUBE = {Counter = 0},
				MARKCAIN = nil,
				BAGOTRASH = {Levels = 0},
				TEMPERTANTRUM = {ErasedEnemies = {}},
				ENRAGEDSOUL = {SoulLaunchCooldown = nil, AttachedEnemy = nil},
				CEILINGSTARS = {SleptInBed = false},
				TWOPLUSONE = {ItemsBought_COINS = 0, ItemsBought_HEARTS = 0},
				CHEESEGRATER = {NumUses = 0},
				BLESSOTDEAD = 0
			},
			Cards = {
				REVERSECARD = nil,
				JACK = nil,
				SACBLOOD = {Data = false, NumUses = 0}
			},
			Trinkets = {
				GREEDSHEART = "CoinHeartEmpty",
				CHALKPIECE = {RoomEnterFrame = 0}
			},
			Pills = {
				LAXATIVE = {LaxUseFrame = nil}
			}
		}
		
		if CustomData then print("Repentance+ Mod v1.4 Initialized") end

		-- recalculating cache, just in case
		Isaac.GetPlayer(0):AddCacheFlags(CacheFlag.CACHE_ALL)
		Isaac.GetPlayer(0):EvaluateItems()
		
		-- deleting Wait, No! from trinket pool
		game:GetItemPool():RemoveTrinket(Trinkets.WAITNO)
		
		--[[ Spawn items/trinkets or turn on debug commands for testing here if necessary
		! DEBUG: 3 - INFINITE HP, 4 - HIGH DAMAGE, 8 - INFINITE CHARGES, 10 - INSTAKILL ENEMIES !
		
		Isaac.Spawn(5, 350, Trinkets.TestTrinket, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.Spawn(5, 100, Collectibles.TestCollectible, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.ExecuteCommand("debug 0")
		
		--]]
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, rplus.OnGameStart)

						-- EVERY NEW LEVEL --										
						---------------------
function rplus:OnNewLevel()
	local level = game:GetLevel()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if CustomData then
			CustomData.Cards.JACK = nil
			
			CustomData.Items.CEILINGSTARS.SleptInBed = false
			
			if player:HasCollectible(Collectibles.BAGOTRASH) then
				CustomData.Items.BAGOTRASH.Levels = CustomData.Items.BAGOTRASH.Levels + 1
			end
		end
		
		if player:HasCollectible(Collectibles.REDMAP) then
			local USR = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, true, RNG(), true))
			
			if USR.Data and USR.Data.Type == RoomType.ROOM_ULTRASECRET and USR.DisplayFlags & 1 << 2 == 0 then
				USR.DisplayFlags = USR.DisplayFlags | 1 << 2
				level:UpdateVisibility()
			end
		end
		
		if player:HasCollectible(Collectibles.CEILINGSTARS) then
			for i = 1, 2 do
				repeat 
					newID = GetUnlockedVanillaCollectible()
				until Isaac.GetItemConfig():GetCollectible(newID).Type % 3 == 1
				player:AddItemWisp(newID, player.Position, true)
			end
		end
		
		if player:HasCollectible(Collectibles.TWOPLUSONE) then
			CustomData.Items.TWOPLUSONE.ItemsBought_COINS = 0
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, rplus.OnNewLevel)

						-- EVERY NEW ROOM --										
						--------------------
function rplus:OnNewRoom()
	local level = game:GetLevel()
	local room = game:GetRoom()
	local roomtype = room:GetType()

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasCollectible(Collectibles.BLACKDOLL) and room:IsFirstVisit() and Isaac.CountEnemies() > 1 then
			ABSepNumber = math.floor(Isaac.CountEnemies() / 2)
			EntitiesGroupA = {}
			EntitiesGroupB = {}
			local Count = 0
			
			for _, entity in pairs(Isaac.GetRoomEntities()) do
				if entity:IsActiveEnemy(false) and not entity:IsBoss() then
					Count = Count + 1
					if Count <= ABSepNumber then
						table.insert(EntitiesGroupA, entity)
					else
						table.insert(EntitiesGroupB, entity)
					end
				end
			end
		end
		
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 3 and entity.Variant == Familiars.SOUL then
				entity:Remove()
			end
		end
		
		if player:HasTrinket(Trinkets.ANGELSCROWN) and roomtype == RoomType.ROOM_TREASURE then
			if room:IsFirstVisit() then
				for _, entity in pairs(Isaac.GetRoomEntities()) do
					if entity.Type == 5 then entity:Remove() end
				end
				local AngelItem = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL, false, Random(), CollectibleType.COLLECTIBLE_NULL), Vector(320,280), Vector.Zero, nil):ToPickup()
				AngelItem.Price = 15
				AngelItem.ShopItemId = -777
			end
			
			for i = 1, room:GetGridSize() do
				if room:GetGridEntity(i) ~= nil 
				and room:GetGridEntity(i):GetType() ~= GridEntityType.GRID_DOOR and room:GetGridEntity(i):GetType() ~= GridEntityType.GRID_WALL then
					room:RemoveGridEntity(i, 0, false)
				end
			end
			
			if room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then
				AngelPos = Vector(320, 200)
				FloorPos = Vector(60, 140)
				WallPos = Vector(-20, 60)
			elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_IH then
				AngelPos = Vector(320, 240)
				FloorPos = Vector(60, 220)
				WallPos = Vector(-20, 138)
			elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_IV then
				AngelPos = Vector(320, 200)
				FloorPos = Vector(220, 140)
				WallPos = Vector(145, 60)
			end
			Isaac.GridSpawn(GridEntityType.GRID_STATUE, 1, AngelPos, false)
			FloorPiece = Isaac.Spawn(1000, CustomBackDropEntity, 0, FloorPos, Vector.Zero, nil)
			WallPiece = Isaac.Spawn(1000, CustomBackDropEntity, 0, WallPos, Vector.Zero, nil)
		end 
		
		if player:HasTrinket(Trinkets.CHALKPIECE) and not room:IsClear() and room:IsFirstVisit() then
			CustomData.Trinkets.CHALKPIECE.RoomEnterFrame = game:GetFrameCount()
		end
		
		if player:HasCollectible(Collectibles.TWOPLUSONE) and CustomData then
			CustomData.Items.TWOPLUSONE.ItemsBought_HEARTS = 0
		end
		
		player:GetData()['usedLoadedDice'] = false
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, rplus.OnNewRoom)

						-- ACTIVE ITEM USED --										
						----------------------
function rplus:OnItemUse(ItemUsed, _, Player, _, _, _)
	local level = game:GetLevel()
	local room = game:GetRoom()
	
	if ItemUsed == Collectibles.COOKIECUTTER then
		Player:AddMaxHearts(2, true)
		Player:AddBrokenHearts(1)
		sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 2, false, 1, 0)
		if Player:GetBrokenHearts() >= 12 then
			Player:Die()
		end
		return true
	end
	
	if ItemUsed == Collectibles.CHEESEGRATER and Player:GetMaxHearts() > 0 then
		Player:AddMaxHearts(-2, false)
		Player:AddMinisaac(Player.Position, true)
		Player:AddMinisaac(Player.Position, true)
		sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 2, false, 1, 0)
		Player:GetData()['graterUsed'] = true
		
		CustomData.Items.CHEESEGRATER.NumUses = CustomData.Items.CHEESEGRATER.NumUses + 1
		Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		Player:EvaluateItems()
	end
	
	if ItemUsed == Collectibles.RUBIKSCUBE then
		local SolveChance = math.random(100)
		
		if SolveChance <= 5 or CustomData.Items.RUBIKSCUBE.Counter == 20 then
			Player:RemoveCollectible(Collectibles.RUBIKSCUBE, true, ActiveSlot.SLOT_PRIMARY, true)
			Player:AddCollectible(Collectibles.MAGICCUBE, 4, true, ActiveSlot.SLOT_PRIMARY, 0)
			Player:AnimateHappy()
			CustomData.Items.RUBIKSCUBE.Counter = 0
			return false
		else
			CustomData.Items.RUBIKSCUBE.Counter = CustomData.Items.RUBIKSCUBE.Counter + 1
			return true
		end
	end
	
	if ItemUsed == Collectibles.MAGICCUBE then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 and entity.Variant == 100 and entity.SubType > 0 then
				entity:ToPickup():Morph(5, 100, GetUnlockedVanillaCollectible(true), true, false, true)
			end
		end
		return true
	end
	
	if ItemUsed == Collectibles.QUASAR then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 and entity.Variant == 100 and entity.SubType > 0 
			and entity:ToPickup() and entity:ToPickup().Price % 10 == 0 then
				for i = 1, 3 do
					repeat 
						newID = GetUnlockedVanillaCollectible()
					until Isaac.GetItemConfig():GetCollectible(newID).Type % 3 == 1
					Player:AddItemWisp(newID, Player.Position, true)
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
					entity:Remove()
				end
				sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 2, false, 1, 0)
			end
		end

		return true
	end
	
	if ItemUsed == Collectibles.TOWEROFBABEL then
		for g = 1, room:GetGridSize() do
			if room:GetGridEntity(g) then room:GetGridEntity(g):Destroy() end
		end
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 200, EntityPartition.ENEMY)) do
			if not enemy:IsBoss() then enemy:AddEntityFlags(EntityFlag.FLAG_CONFUSION) end
		end
		return {Discharge = true, Remove = false, ShowAnim = true}
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_ITEM, rplus.OnItemUse)

						-- EVERY FRAME --											
						-----------------
function rplus:OnFrame()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stage = level:GetStage()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local sprite = player:GetSprite()
		
		if CustomData and CustomData.Cards.REVERSECARD == "used" and sprite:IsFinished("PickupWalkDown") then
			local secondaryCard = player:GetCard(1)
			player:SetCard(1, 0)
			player:SetCard(0, secondaryCard)
			CustomData.Cards.REVERSECARD = nil
		end
		
		if player:HasCollectible(Collectibles.MAGICPEN) then
			-- taste the rainbow
			for _, entity in pairs(Isaac.GetRoomEntities()) do
				if entity.Type == 1000 and entity.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL and entity.SubType == 4 then
					local Frame = game:GetFrameCount() % 490 + 1
					
					if Frame <= 140 then
						entity:SetColor(Color(1, Frame / 140, 0), 1, 1, false, false)
					elseif Frame <= 210 then
						entity:SetColor(Color(1 - (Frame - 140) / 70, 1, 0), 1, 1, false, false)
					elseif Frame <= 280 then
						entity:SetColor(Color(0, 1 - (Frame - 210) / 70, (Frame - 210) / 70), 1, 1, false, false)
					elseif Frame <= 350 then
						entity:SetColor(Color((Frame - 280) / 70 * 75 / 255, 0, (Frame - 280) / 70 * 130 / 255), 1, 1, false, false)
					elseif Frame <= 420 then
						entity:SetColor(Color((75 + (Frame - 350) / 70 * 58) / 255, 0, (130 + (Frame - 350) / 70 * 125) / 255), 1, 1, false, false)
					else
						entity:SetColor(Color((143 + (Frame - 420) / 70 * 112) / 255, 0, 1 - (Frame - 420) / 70), 1, 1, false, false)
					end
				end
			end
		end
		
		if player:HasCollectible(Collectibles.MARKCAIN) 
		and player:GetExtraLives() == 0 then
			if sprite:IsPlaying("Death") and sprite:GetFrame() > 50 then
				MyFamiliars = {}
				
				for i = 1, 1000 do
					if Isaac.GetItemConfig():GetCollectible(i) and Isaac.GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_FAMILIAR and player:HasCollectible(i) then
						for j = 1, player:GetCollectibleNum(i, true) do
							table.insert(MyFamiliars, i)
						end
					end
				end
				if #MyFamiliars > 0 then
					player:RemoveCollectible(Collectibles.MARKCAIN)
					for i = 0, game:GetNumPlayers() - 1 do
						Isaac.GetPlayer(i):Revive()
						GiveRevivalIVFrames(Isaac.GetPlayer(i))
					end
					
					CustomData.Items.MARKCAIN = "player revived"
					sfx:Play(SoundEffect.SOUND_SUPERHOLY, 1, 2, false, 1, 0)
					
					for i = 1, #MyFamiliars do player:RemoveCollectible(MyFamiliars[i]) end
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
					player:EvaluateItems()
				end
			end
		end
		
		if player:HasCollectible(Collectibles.TEMPERTANTRUM) then
			if SUPERBERSERKSTATE and sfx:IsPlaying(SoundEffect.SOUND_BERSERK_END) then SUPERBERSERKSTATE = false end
		end
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity:IsActiveEnemy() and CustomData.Items.TEMPERTANTRUM.ErasedEnemies ~= nil then
				for i = 1, #CustomData.Items.TEMPERTANTRUM.ErasedEnemies do
					if entity.Type == CustomData.Items.TEMPERTANTRUM.ErasedEnemies[i] then
						entity:Kill()
						break
					end
				end
			end
		end
		
		if player:HasCollectible(Collectibles.CHERRYFRIENDS) and room:IsClear() then
			for _, entity in pairs(Isaac.GetRoomEntities()) do
				if entity.Type == 3 and entity.Variant == Familiars.CHERRY then
					entity:GetSprite():Play("Collect")
					if entity:GetSprite():IsFinished("Collect") then
						entity:Remove()
						Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, Vector.Zero, nil)
					end
				end
			end
		end
		
		if player:HasCollectible(Collectibles.BIRDOFHOPE) then
			if sprite:IsPlaying("Death") and CustomData.Items.BIRDOFHOPE.BirdCaught == true then
				CustomData.Items.BIRDOFHOPE.BirdCaught = false
				DieFrame = game:GetFrameCount()
				DiePos = player.Position
				CustomData.Items.BIRDOFHOPE.NumRevivals = CustomData.Items.BIRDOFHOPE.NumRevivals + 1
				
				dyingPlayer = player
				player:Revive()
				sprite:Stop()
				player:AddCollectible(185, 0, false, 0, 0)
				player:AddNullCostume(Costumes.BIRDOFHOPE)
				
				Birdy = Isaac.Spawn(3, Familiars.BIRD, 0, room:GetCenterPos(), Vector.FromAngle(math.random(360)) * CustomData.Items.BIRDOFHOPE.NumRevivals, nil) 
				Birdy:GetSprite():Play("Flying")
			elseif DieFrame and game:GetFrameCount() > DieFrame + 120 and not CustomData.Items.BIRDOFHOPE.BirdCaught then
				player:Die()
				CustomData.Items.BIRDOFHOPE.BirdCaught = "blah blah"	-- just so that it's not true and player doesn't die over and over 
				-- until all his extra lives are depleted
				-- !!! THIS IS A SERIOUS CROTCH !!! since you end up near the door when reviving, and the bird familiar doesn't despawn if you don't catch her,
				-- you automatically pick her up and this allows you to repeat the cycle (since it switches data to true) and doesn't take away your extra lives
				-- so don't touch it if you don't think it through. like, for real.
			end
		end
		
		if player:HasTrinket(Trinkets.CHALKPIECE) and CustomData then
			if CustomData.Trinkets.CHALKPIECE.RoomEnterFrame and game:GetFrameCount() <= CustomData.Trinkets.CHALKPIECE.RoomEnterFrame + 150 then
				local Powder = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 5, player.Position, Vector.Zero, nil):ToEffect()
				
				Powder.Scale = 0.75
				Powder.Timeout = 600
				Powder:SetColor(Color(0, 1, 1, 1, 255, 255, 255), 610, 1, false, false)
				Powder:Update()
			end
		end
		
		if CustomData and CustomData.Cards.SACBLOOD.Data then
			if game:GetFrameCount() % math.floor(1 + 11 / CustomData.Cards.SACBLOOD.NumUses) == 0 then
				Step = Step + 1
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
				if Step == 50 * CustomData.Cards.SACBLOOD.NumUses then 
					CustomData.Cards.SACBLOOD.Data = false 
					CustomData.Cards.SACBLOOD.NumUses = 0
				end
			end
		end
		
		if player:HasTrinket(Trinkets.ADAMSRIB) then
			if sprite:IsPlaying("Death") and sprite:GetFrame() > 50 then
				player:TryRemoveTrinket(Trinkets.ADAMSRIB)
				for i = 0, game:GetNumPlayers() - 1 do
					Isaac.GetPlayer(i):Revive()
					GiveRevivalIVFrames(Isaac.GetPlayer(i))
				end
				player:ChangePlayerType(PlayerType.PLAYER_EVE)
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then player:AddCollectible(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) end
				player:AddMaxHearts(-24, false)
				player:AddSoulHearts(6)
			end
		end
		
		if player:HasCollectible(Collectibles.TWOPLUSONE) then
			for _, entity in pairs(Isaac.GetRoomEntities()) do
				if entity.Type == 5 then
					EntPickup = entity:ToPickup()
					if EntPickup.Price > 0 and CustomData.Items.TWOPLUSONE.ItemsBought_COINS == 2  then
						EntPickup.Price = 1
						EntPickup.AutoUpdatePrice = false
					elseif EntPickup.Price > -1000 and EntPickup.Price < 0 and CustomData.Items.TWOPLUSONE.ItemsBought_HEARTS == 2  then
						EntPickup.Price = 0
					end
				end
			end
		end
		
		if CustomData and CustomData.Pills.LAXATIVE.LaxUseFrame and player:GetData()['pill'] == "used lax" then
			if game:GetFrameCount() <= CustomData.Pills.LAXATIVE.LaxUseFrame + 90 and game:GetFrameCount() % 4 == 0 then
				local vector = Vector.FromAngle(DIRECTION_VECTOR[player:GetMovementDirection()]:GetAngleDegrees() + math.random(-30, 30)):Resized(-7.5)
				local SCorn = Isaac.Spawn(2, 0, 0, player.Position, vector, nil):GetSprite()
				
				SCorn:Load("gfx/002.122_corn_tear.anm2", true)
				SCorn:Play("Big0" .. math.random(4))
				SCorn.Scale = Vector(0.75, 0.75)
			elseif game:GetFrameCount() > CustomData.Pills.LAXATIVE.LaxUseFrame + 90 then
				CustomData.Pills.LAXATIVE.LaxUseFrame = nil
				player:GetData()['pill'] = nil
			end
		end
		
		if player:HasCollectible(Collectibles.REDMAP) and not room:IsFirstVisit() and room:GetType() < 6 and room:GetType() > 3 then
			for _, entity in pairs(Isaac.FindInRadius(player.Position, 560, EntityPartition.PICKUP)) do
				if entity.Variant == 350 then
					entity:ToPickup():Morph(5, 300, Card.CARD_CRACKED_KEY, true, true, true)
				end
			end
		end
		
		-- delays Torn Page book usage animation by a frame so it overrides the damage taken animation
		if TornPageData.TIMER[i + 1] == 1 then
			if player:HasTrinket(Trinkets.TORNPAGE) then
				player:AnimateCollectible(TornPageData.BOOK)
			end
		end
		if TornPageData.TIMER[i + 1] > 0 then
			TornPageData.TIMER[i + 1] = TornPageData.TIMER[i + 1] - 1
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_UPDATE, rplus.OnFrame)

						-- POST PLAYER UPDATE --									
						------------------------
function rplus:PostPlayerUpdate(Player)
	-- this callback handles inputs, because it rolls in 60 fps, unlike MC_POST_UPDATE, so inputs won't be missed out
	if Player:HasCollectible(Collectibles.ENRAGEDSOUL) then
		for i = 4, 7 do -- shooting left, right, up, down; reading first input
			if Input.IsActionTriggered(i, Player.ControllerIndex) and not ButtonState then
				ButtonPressed = i
				ButtonState = "listening for second tap"
				PressFrame = game:GetFrameCount()
				--print('button ' .. ButtonPressed .. ' is pressed on frame ' .. PressFrame)
			end
		end
		
		if PressFrame and game:GetFrameCount() <= PressFrame + 6 then -- listening for next inputs in the next 4 frames
			if not Input.IsActionTriggered(ButtonPressed, Player.ControllerIndex) and ButtonState == "listening for second tap" then
				ButtonState = "button released"
			end
			
			if ButtonState == "button released" and Input.IsActionTriggered(ButtonPressed, Player.ControllerIndex) and 
			(not CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown or CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown <= 0) then
				--print('button ' .. ButtonPressed .. ' double tapped')
				-- spawning the soul
				if ButtonPressed == 4 then
					Velocity = DIRECTION_VECTOR[Direction.LEFT]
					DashAnim = "DashHoriz"
				elseif ButtonPressed == 5 then
					Velocity = DIRECTION_VECTOR[Direction.RIGHT]
					DashAnim = "DashHoriz"
				elseif ButtonPressed == 6 then
					Velocity = DIRECTION_VECTOR[Direction.UP]
					DashAnim = "DashUp"
				else
					Velocity = DIRECTION_VECTOR[Direction.DOWN]
					DashAnim = "DashDown"
				end
				CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown = ENRAGED_SOUL_COOLDOWN
				local SoulSprite = Isaac.Spawn(3, Familiars.SOUL, 0, Player.Position, Velocity * 12, nil):GetSprite()
				
				SoulSprite:Load("gfx/003.214_enragedsoul.anm2", true)
				if ButtonPressed == 4 then SoulSprite.FlipX = true end
				SoulSprite:Play(DashAnim, true)
				sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A, 1, 2, false, 1, 0)
				
				ButtonState = nil
			end
		else
			ButtonState = nil
		end
		
		if CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown then 
			CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown = CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown - 1 
			if CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown == 0 then
				sfx:Play(SoundEffect.SOUND_ANIMA_BREAK, 1, 2, false, 1, 0)
			end
		end
	end
	
	if Player:GetSprite():IsPlaying("Appear") and Player:GetSprite():IsEventTriggered("FX") and level:GetCurses() ~= 0 then
		if Player:HasTrinket(Trinkets.NIGHTSOIL) and math.random(100) < NIGHT_SOIL_CHANCE then
			level:RemoveCurses(level:GetCurses())
			game:GetHUD():ShowFortuneText("Night Soil protects you")
			Player:AnimateHappy()
		end
		
		if Player:HasCollectible(Collectibles.BLESSOTDEAD) then 
			CustomData.Items.BLESSOTDEAD = CustomData.Items.BLESSOTDEAD + 0.5
			game:GetHUD():ShowFortuneText("The Dead protect you")
			level:RemoveCurses(level:GetCurses())
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			Player:EvaluateItems()
		end
	end
	
	if Player:HasTrinket(Trinkets.MAGICSWORD) then 
		Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE) 
		Player:EvaluateItems() 
	end
	
	if Player:HasCollectible(Collectibles.ORDLIFE) then 
		Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY) 
		Player:EvaluateItems() 
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, rplus.PostPlayerUpdate)

						-- POST RENDERING --										
						--------------------
function rplus:OnGameRender()
	local level = game:GetLevel()
	local room = game:GetRoom()
	
	if game:GetFrameCount() % 540 < 180 then DisplayErrorMessage() end
	--[[ rendering achievement papers
	if flagRenderPaper then RenderAchievementPapers() end
	--]]
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Trinkets.GREEDSHEART) and not (player:GetPlayerType() == 10 or player:GetPlayerType() == 31) then
			CoinHeartSprite = Sprite()
			
			CoinHeartSprite:Load("gfx/ui/ui_coinhearts.anm2", true)
			if level:GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN ~= LevelCurse.CURSE_OF_THE_UNKNOWN then
				CoinHeartSprite:SetFrame(CustomData.Trinkets.GREEDSHEART, 0)	-- custom data value is either "CoinHeartEmpty" or "CoinHeartFull"
			else
				CoinHeartSprite:SetFrame("CoinHeartUnknown", 0)
			end
			CoinHeartSprite:Render(Vector(134, 18), Vector.Zero, Vector.Zero)
		end
		
		if player:HasTrinket(Trinkets.ANGELSCROWN) and room:GetType() == RoomType.ROOM_TREASURE then
			FloorPiece:GetSprite().Scale = Vector(0.25, 0.25)
			FloorPiece:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
			FloorPiece:GetSprite():Load("gfx/backdrop/angel_treasure_room_backdrops.anm2", true)
			FloorPiece:GetSprite():Play("Floor_" .. room:GetRoomShape(), true)
			
			WallPiece:AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)
			WallPiece:GetSprite():Load("gfx/backdrop/angel_treasure_room_backdrops.anm2", true)
			WallPiece:GetSprite():Play("Walls_" .. room:GetRoomShape(), true)
		end
		
		if player:HasCollectible(Collectibles.CEILINGSTARS) and (room:GetType() == 18 or room:GetType() == 19 or level:GetCurrentRoomIndex() == level:GetStartingRoomIndex()) then
			if not StarCeiling then StarCeiling = Sprite() end
			StarCeiling:Load("gfx/ui/ui_starceiling.anm2", true)
			StarCeiling:SetFrame("Idle", game:GetFrameCount() % 65)
			StarCeiling.Scale = Vector(1.5, 1.5)
			StarCeiling:Render(Vector(300, 200), Vector.Zero, Vector.Zero)
		end
		
		if player:HasCollectible(Collectibles.DNAREDACTOR) then
			for _, pickupPill in pairs(Isaac.FindInRadius(player.Position, 150, EntityPartition.PICKUP)) do
				if pickupPill.Variant == 70 then
					DNAPillIcon = Sprite()
					DNAPillIcon:Load("gfx/ui/ui_dnapillhelper.anm2", true)
					DNAPillIcon.Scale = Vector(0.5, 0.5)
					
					DNAPillIcon:SetFrame("pill_" .. tostring(pickupPill.SubType), 0)
					DNAPillIcon:Render(Isaac.WorldToRenderPosition(pickupPill.Position + Vector(15, -15)), Vector.Zero, Vector.Zero)
				end
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_RENDER, rplus.OnGameRender)

						-- WHEN NPC DIES --											
						-------------------
function rplus:OnNPCDeath(NPC)
	local level = game:GetLevel()
	local room = game:GetRoom()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Trinkets.KEYTOTHEHEART) and math.random(100) <= HEARTKEY_CHANCE * player:GetTrinketMultiplier(Trinkets.KEYTOTHEHEART) then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickUps.SCARLETCHEST, 0, NPC.Position, NPC.Velocity, nil)
		end
		
		if player:HasCollectible(Collectibles.CHERRYFRIENDS) and math.random(100) <= CHERRY_SPAWN_CHANCE then
			Isaac.Spawn(3, Familiars.CHERRY, 1, NPC.Position, Vector.Zero, nil)
			sfx:Play(SoundEffect.SOUND_BABY_HURT, 1, 2, false, 1, 0)
		end
		
		if player:HasCollectible(Collectibles.CEREMDAGGER) and not NPC:IsBoss() and NPC:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT) then
			Isaac.Spawn(5, 300, PocketItems.SACBLOOD, NPC.Position, Vector.Zero, nil)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rplus.OnNPCDeath)

						-- ON PICKUP INIT -- 										
						--------------------
function rplus:OnPickupInit(Pickup)	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if Pickup.Variant == PickUps.SCARLETCHEST and Pickup.SubType == 1 and type(Pickup:GetData()["IsRoom"]) == type(nil) then
			Pickup:Remove()
		end
		
		if game:GetRoom():IsFirstVisit() then
			if player:HasTrinket(Trinkets.BASEMENTKEY) and Pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST 
			and math.random(100) <= BASEMENTKEY_CHANCE * player:GetTrinketMultiplier(Trinkets.BASEMENTKEY) then
				Pickup:Morph(5, PickupVariant.PICKUP_OLDCHEST, 0, true, true, false)
			end
			
			local CoinSubTypesByVal = {1, 4, 6, 2, 3, 5, 7} -- penny, doublepack, sticky nickel, nickel, dime, lucky penny, golden penny
			if Pickup.Variant == 20 and Pickup.SubType ~= 7 and player:HasTrinket(Trinkets.BITTENPENNY) 
			and math.random(100) <= BITTENPENNY_UPGRADECHANCE * player:GetTrinketMultiplier(Trinkets.BITTENPENNY) then
				player:AnimateHappy()
				for i = 1, #CoinSubTypesByVal do
					if CoinSubTypesByVal[i] == Pickup.SubType then CurType = i break end
				end
				Pickup:Morph(5, 20, CoinSubTypesByVal[CurType + 1], true, true, false)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, rplus.OnPickupInit)

						-- ON GETTING A CARD --										
						-----------------------
function rplus:OnCardInit(_, _, PlayingCards, Runes, OnlyRunes)
	if (PlayingCards or Runes) and not OnlyRunes then
		if math.random(100) <= CARDRUNE_REPLACE_CHANCE then
			GetRandomCustomCard()
		end
	end
	if OnlyRunes and math.random(100) <= CARDRUNE_REPLACE_CHANCE then 
		if math.random(10) <= 5 then return PocketItems[REDRUNE] else return PocketItems[QUASARSHARD] end
	end
end
rplus:AddCallback(ModCallbacks.MC_GET_CARD, rplus.OnCardInit)

						-- ON USING CARD -- 										
						-------------------
function rplus:CardUsed(Card, Player, _)	
	if Card == PocketItems.RJOKER then
		game:StartRoomTransition(-6, -1, RoomTransitionAnim.TELEPORT, Player, -1)
	end
	
	if Card == PocketItems.SDDSHARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_SPINDOWN_DICE, UseFlag.USE_NOANIM, -1)
	end
	
	if Card == PocketItems.BUSINESSCARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, UseFlag.USE_NOANIM, -1)
	end
	
	if Card == PocketItems.REDRUNE then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_ABYSS, false, false, true, false, -1)
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, false, false, true, false, -1)
		local locustRNG = RNG()
		
		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.PICKUP)) do
			if ((entity.Variant < 100 and entity.Variant > 0) or entity.Variant == 300 or entity.Variant == 350 or entity.Variant == 360) 
			and entity:ToPickup() and entity:ToPickup().Price % 10 == 0 then
				local pos = entity.Position
				
				entity:Remove()
				if math.random(100) <= 50 then
					Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, locustRNG:RandomInt(5) + 1, pos, Vector.Zero, nil)
				end
			end
		end
	end
	
	if Card == PocketItems.REVERSECARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1)
		CustomData.Cards.REVERSECARD = "used"
	end
	
	if Card == PocketItems.KINGOFSPADES then
		sfx:Play(SoundEffect.SOUND_GOLDENKEY, 1, 2, false, 1, 0)
		local NumPickups = math.floor(Player:GetNumKeys() / 4)
		Player:AddKeys(-Player:GetNumKeys())
		if Player:HasGoldenKey() then Player:RemoveGoldenKey() NumPickups = NumPickups + 2 end
		for i = 1, NumPickups do
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SIN, false, false, true, false, -1)
		end
		if NumPickups >= 3 then Isaac.Spawn(5, 350, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
		if NumPickups >= 7 then Isaac.Spawn(5, 100, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
	end
	
	if Card == PocketItems.KINGOFCLUBS then
		local NumPickups = math.floor(Player:GetNumBombs() / 4)
		Player:AddBombs(-Player:GetNumBombs())
		if Player:HasGoldenBomb() then Player:RemoveGoldenBomb() NumPickups = NumPickups + 2 end
		for i = 1, NumPickups do
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SIN, false, false, true, false, -1)
		end
		if NumPickups >= 3 then Isaac.Spawn(5, 350, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
		if NumPickups >= 7 then Isaac.Spawn(5, 100, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
	end
	
	if Card == PocketItems.KINGOFDIAMONDS then
		local NumPickups = math.floor(Player:GetNumCoins() / 5)
		Player:AddCoins(-Player:GetNumCoins())
		for i = 1, NumPickups do
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SIN, false, false, true, false, -1)
		end
		if NumPickups >= 3 then Isaac.Spawn(5, 350, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
		if NumPickups >= 7 then Isaac.Spawn(5, 100, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
	end
	
	if Card == PocketItems.NEEDLEANDTHREAD then
		if Player:GetBrokenHearts() > 0 then
			Player:AddBrokenHearts(-1)
			Player:AddMaxHearts(2, true)
			Player:AddHearts(2)
		end
	end
	
	if Card == PocketItems.QUEENOFDIAMONDS then
		for i = 1, math.random(12) do
			local QueenOfDiamondsRandom = math.random(100)
			local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false)
			
			if QueenOfDiamondsRandom <= 92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 1, spawnPos, Vector.Zero, nil)
			elseif QueenOfDiamondsRandom <= 98 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 2, spawnPos, Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 3, spawnPos, Vector.Zero, nil)
			end
		end
	end
	
	if Card == PocketItems.QUEENOFCLUBS then
		for i = 1, math.random(12) do
			local QueenOfClubsRandom = math.random(100)
			local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false)
			
			if QueenOfClubsRandom <= 92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, 1, spawnPos, Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, 2, spawnPos, Vector.Zero, nil)
			end
		end
	end
	
	if Card == PocketItems.BAGTISSUE then
		local Weights = {}
		local SumWeight = 0
		local EnoughConsumables = true
		
		-- getting total weight of 8 most valuable pickups in a room
		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.PICKUP)) do
			if entity:ToPickup() and entity:ToPickup().Price % 10 == 0 then
				if PickupWeights[entity.Variant] and PickupWeights[entity.Variant][entity.SubType] then
					table.insert(Weights, PickupWeights[entity.Variant][entity.SubType])
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
					entity:Remove()
				elseif entity.Variant == 70 then
					table.insert(Weights, 2)
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
					entity:Remove()
				elseif entity.Variant == 300 then
					table.insert(Weights, 3)
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
					entity:Remove()
				end
			end
		end
		
		table.sort(Weights, function(a,b) return a>b end)
		for i = 1, 8 do
			if not Weights[i] then
				EnoughConsumables = false Player:AnimateSad() break
			end
			SumWeight = SumWeight + Weights[i]
		end


		if EnoughConsumables then
			-- defining item quality 
			DesiredQuality = math.floor(SumWeight / 9)
			if DesiredQuality > 4 then
				DesiredQuality = 4
			end
			
			-- trying to get random (not story-related!!) item with desired quality
			repeat
				ID = GetUnlockedVanillaCollectible(true)
			until Isaac.GetItemConfig():GetCollectible(ID).Quality == DesiredQuality
			
			-- spawning the item
			Player:AnimateHappy()
			Isaac.Spawn(5, 100, ID, Isaac.GetFreeNearPosition(Player.Position, 5.0), Vector.Zero, nil)
		end
	end
	
	if Card == PocketItems.LOADEDDICE then
		Player:GetData()['usedLoadedDice'] = true
		
		Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		Player:EvaluateItems()
	end
	
	-- jacks
	if Card == PocketItems.JACKOFDIAMONDS then
		CustomData.Cards.JACK = "Diamonds"
	elseif Card == PocketItems.JACKOFCLUBS then
		CustomData.Cards.JACK = "Clubs"
	elseif Card == PocketItems.JACKOFSPADES then
		CustomData.Cards.JACK = "Spades"	
	elseif Card == PocketItems.JACKOFHEARTS then
		CustomData.Cards.JACK = "Hearts"
	end
	
	if Card == PocketItems.BEDSIDEQUEEN then
		local numKeys = math.random(12)
		
		for i = 1, numKeys do
			if math.random(100) <= 95 then
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 1, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 4, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil)
			end
		end
	end
	
	if Card == PocketItems.QUASARSHARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM, -1)
		
		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.PICKUP)) do
			if entity.Variant == 100 and entity.SubType > 0
			and entity:ToPickup() and entity:ToPickup().Price % 10 == 0 then
				for i = 1, 3 do
					repeat 
						newID = GetUnlockedVanillaCollectible()
					until Isaac.GetItemConfig():GetCollectible(newID).Type % 3 == 1
					Player:AddItemWisp(newID, Player.Position, true)
				end
				Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
				entity:Remove()
				sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 2, false, 1, 0)
			end
		end
	end
	
	if Card == PocketItems.SACBLOOD and CustomData then
		CustomData.Cards.SACBLOOD.Data = true
		CustomData.Cards.SACBLOOD.NumUses = CustomData.Cards.SACBLOOD.NumUses + 1
		Step = 0
		Player:GetData()['usedBlood'] = true
		
		sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 2, false, 1, 0)
		if Player:HasCollectible(216) then Player:AddHearts(2) end		-- bonus for ceremonial robes ;)
	end
	
	if Card == PocketItems.FLYPAPER then
		for i = 1, 9 do
			Player:AddSwarmFlyOrbital(Player.Position)
		end
	end
	
	if Card == PocketItems.LIBRARYCARD then
		Player:UseActiveItem(game:GetItemPool():GetCollectible(ItemPoolType.POOL_LIBRARY, false, Random(), 0), true, false, true, true, -1)
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_CARD, rplus.CardUsed)

						-- ON PICKUP COLLISION --									
						-------------------------
function rplus:PickupCollision(Pickup, Collider, _)	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Trinkets.GREEDSHEART) and CustomData.Trinkets.GREEDSHEART == "CoinHeartEmpty" and Pickup.Variant == 20 and Pickup.SubType ~= 6 
		and not (player:GetPlayerType() == 10 or player:GetPlayerType() == 31) 
		-- if player's Keeper, they should be at full health to gain a new coin heart
		and (player:GetHearts() == player:GetMaxHearts() or (player:GetPlayerType() ~= 14 and player:GetPlayerType() ~= 33)) then
			player:AddCoins(-1)
			CustomData.Trinkets.GREEDSHEART = "CoinHeartFull"
		end
		
		-- this monster is able to 100% (so far) detect whether we buy something and whether we don't
		-- mad? cry about it
		if player:HasCollectible(Collectibles.TWOPLUSONE) 
		and Pickup.Price > -6 and Pickup.Price ~= 0 	-- this pickup costs something
		and not player:IsHoldingItem()		-- we're not holding another pickup right now
		then
			if (Pickup.Price == -1 and player:GetMaxHearts() >= 2)
			or (Pickup.Price == -2 and player:GetMaxHearts() >= 4)
			or (Pickup.Price == -3 and player:GetSoulHearts() >= 6)
			or (Pickup.Price == -4 and player:GetMaxHearts() >= 2 and player:GetSoulHearts() >= 4)	-- this devil deal is affordable
			then
				CustomData.Items.TWOPLUSONE.ItemsBought_HEARTS = CustomData.Items.TWOPLUSONE.ItemsBought_HEARTS + 1
			elseif Pickup.Price > 0 and player:GetNumCoins() >= Pickup.Price	-- this shop item is affordable
			and not (Pickup.Variant == 90 and not (player:NeedsCharge(0) or player:NeedsCharge(1) or player:NeedsCharge(2)))
			and not (Pickup.Variant == 10 and Pickup.SubType == 1 and not player:CanPickRedHearts())
			and not (Pickup.Variant == 10 and Pickup.SubType == 3 and not player:CanPickSoulHearts())
			then
				if CustomData.Items.TWOPLUSONE.ItemsBought_COINS == 2 then
					CustomData.Items.TWOPLUSONE.ItemsBought_COINS = 0
					for _, entity in pairs(Isaac.GetRoomEntities()) do
						if entity.Type == 5 then
							if entity:ToPickup().Price == 1 then
								entity:ToPickup().AutoUpdatePrice = true
							end
						end
					end
				else
					CustomData.Items.TWOPLUSONE.ItemsBought_COINS = CustomData.Items.TWOPLUSONE.ItemsBought_COINS + 1
				end
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, rplus.PickupCollision)

						-- ON UPDATING PICKUPS --									
						-------------------------
function rplus:PickupUpdate(Pickup)
	if Pickup.Type == 5 and Pickup.Variant == 100 and Pickup.SpawnerVariant == 392 then
		for i = 3, 5 do 
			Pickup:GetSprite():ReplaceSpritesheet(i,"gfx/items/slots/levelitem_scarletchest_itemaltar_dlc4.png") 
		end
		Pickup:GetSprite():LoadGraphics()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, rplus.PickupUpdate)

						-- ON TEAR UPDATE --
						--------------------
function rplus:OnTearUpdate(Tear)	
	if Tear.Parent and Tear.Parent:ToPlayer() and Tear.Parent:ToPlayer():HasCollectible(Collectibles.MAGICPEN) then
		local CreepTrail = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 4, Tear.Position, Vector.Zero, nil):ToEffect()
		CreepTrail.Scale = 0.4
		CreepTrail:Update()
	end
	
	if Tear.Variant == TearVariants.CEREMDAGGER then
		local TX = Tear.Velocity:Normalized().X
		local TY = Tear.Velocity:Normalized().Y
		
		if TY > 0 and TX <= TY and TX >= -TY then	-- down
			Tear:GetSprite().FlipY = true
		elseif TX > 0 and TY < TX and TY > -TX then		-- right
			Tear:GetSprite().Rotation = 90.0
		elseif TX <= 0 and TY < -TX and TY > TX then	-- left	
			Tear:GetSprite().Rotation = -90.0
		end
	end
	
	if Tear.Parent and Tear.Parent:ToPlayer() and Tear.Parent:ToPlayer():HasCollectible(Collectibles.SINNERSHEART) and Tear.Variant ~= TearVariants.CEREMDAGGER then
		local SHeart = Tear:GetSprite()
		SHeart.Scale = Vector(0.66, 0.66)
		
		SHeart:Load("gfx/002.121_sinners_heart_tear.anm2", true)
		local TX = Tear.Velocity:Normalized().X
		local TY = Tear.Velocity:Normalized().Y
		
		if TY > 0 and TX <= TY and TX >= -TY then	-- down
			SHeart:Play("MoveVert")
		elseif TX > 0 and TY < TX and TY > -TX then		-- right
			SHeart:Play("MoveHori")
		elseif TX <= 0 and TY < -TX and TY > TX then	-- left	
			SHeart.FlipX = true
			SHeart:Play("MoveHori")
		else										-- up
			SHeart.FlipY = true
			SHeart:Play("MoveVert")
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, rplus.OnTearUpdate)

						-- ON TEAR INIT --											
						------------------
function rplus:OnTearInit(Tear)
	-- if Tear.Parent then local player = Tear.Parent:ToPlayer() end
	local player = Isaac.GetPlayer(0)
	
	if player:HasCollectible(Collectibles.CEREMDAGGER) and EntityRef(Tear).Entity.SpawnerType == EntityType.ENTITY_PLAYER then
		if math.random(100) <= CEREM_DAGGER_LAUNCH_CHANCE then
			-- launching the dagger
			local SBlade = Isaac.Spawn(2, TearVariants.CEREMDAGGER, 0, player.Position, Tear.Velocity, nil):GetSprite()
			SBlade:Load("gfx/002.120_ceremonial_blade_tear.anm2", true)
			SBlade:Play("Idle")
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, rplus.OnTearInit)

						-- UPDATING CACHE --							
						--------------------
function rplus:UpdateStats(Player, Flag) 
	-- If any Stat-Changes are done, just check for the collectible in the cacheflag (be sure to set the cacheflag in the items.xml)
	if Flag == CacheFlag.CACHE_DAMAGE then
		if Player:HasCollectible(Collectibles.SINNERSHEART) then
			Player.Damage = Player.Damage + StatUps.SINNERSHEART_DMG_ADD
			Player.Damage = Player.Damage * StatUps.SINNERSHEART_DMG_MUL
		end
		
		if CustomData and CustomData.Items.MARKCAIN == "player revived" then
			Player.Damage = Player.Damage + #MyFamiliars * StatUps.MARKCAIN_DMG
		end
		
		if Player:HasCollectible(Collectibles.CEREMDAGGER) then
			Player.Damage = Player.Damage * StatUps.CEREMDAGGER_DMG_MUL
		end
		
		if CustomData and CustomData.Cards.SACBLOOD.Data then
			if Player:GetData()['usedBlood'] then
				Player.Damage = Player.Damage + StatUps.SACBLOOD_DMG * (CustomData.Cards.SACBLOOD.NumUses - Step / 50)
			end
		end
		
		if Player:HasTrinket(Trinkets.MAGICSWORD) then
			Player.Damage = Player.Damage * StatUps.MAGICSWORD_DMG_MUL * Player:GetTrinketMultiplier(Trinkets.MAGICSWORD)
		end
		
		if CustomData and CustomData.Items.CHEESEGRATER.NumUses then
			if Player:GetData()['graterUsed'] == true then
				Player.Damage = Player.Damage + CustomData.Items.CHEESEGRATER.NumUses * StatUps.GRATER_DMG
			end
		end
		if Player:HasCollectible(Collectibles.BLESSOTDEAD) and CustomData then
			Player.Damage = Player.Damage + CustomData.Items.BLESSOTDEAD * StatUps.BLESS_DMG
		end
	end
	
	if Flag == CacheFlag.CACHE_FIREDELAY then
		if Player:HasCollectible(Collectibles.ORDLIFE) then
			Player.MaxFireDelay = Player.MaxFireDelay * StatUps.ORDLIFE_TEARS
		end
	end
	
	if Flag == CacheFlag.CACHE_TEARFLAG then
		if Player:HasCollectible(Collectibles.SINNERSHEART) then
			Player.TearFlags = Player.TearFlags | TearFlags.TEAR_HOMING
		end
	end
	
	if Flag == CacheFlag.CACHE_SHOTSPEED then
		if Player:HasCollectible(Collectibles.SINNERSHEART)  then
			Player.ShotSpeed = Player.ShotSpeed + StatUps.SINNERSHEART_SHSP
		end
	end
	
	if Flag == CacheFlag.CACHE_RANGE then 
		-- Range currently not functioning, blame Edmund
		if Player:HasCollectible(Collectibles.SINNERSHEART)  then
			Player.TearHeight = Player.TearHeight + StatUps.SINNERSHEART_TEARHEIGHT
		end
	end
	
	if Flag == CacheFlag.CACHE_FAMILIARS then
		Player:CheckFamiliar(Familiars.BAGOTRASH, Player:GetCollectibleNum(Collectibles.BAGOTRASH), Player:GetCollectibleRNG(Collectibles.BAGOTRASH))
		Player:CheckFamiliar(Familiars.ZENBABY, Player:GetCollectibleNum(Collectibles.ZENBABY), Player:GetCollectibleRNG(Collectibles.ZENBABY))
	end
	
	if Flag == CacheFlag.CACHE_LUCK then
		if Player:GetData()['usedLoadedDice'] then
			Player.Luck = Player.Luck + StatUps.LOADEDDICE_LUCK
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rplus.UpdateStats)

						-- ENTITY TAKES DAMAGE --									
						-------------------------
function rplus:EntityTakeDmg(Entity, Amount, Flags, Source, CDFrames)	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasCollectible(Collectibles.MAGICPEN) and Source.Entity and Source.Entity.Type == 1000 and Source.Entity.SubType == 4 then
			if math.random(100) == 1 then 
				local Flags = {
					EntityFlag.FLAG_POISON, 
					EntityFlag.FLAG_SLOW, 
					EntityFlag.FLAG_CHARM, 
					EntityFlag.FLAG_CONFUSION, 
					EntityFlag.FLAG_FEAR, 
					EntityFlag.FLAG_BURN
				}
				
				Entity:AddEntityFlags(Flags[math.random(#Flags)])
			end
			return false
		end
		
		if player:HasTrinket(Trinkets.CHALKPIECE) and Source.Entity and Source.Entity.Type == 1000 and Source.Entity.SubType == 5 then
			Entity.Velocity = Entity.Velocity:Resized(-2.5)
			return false
		end
		
		if player:HasCollectible(Collectibles.TEMPERTANTRUM) then 
			if Entity.Type == 1 and math.random(100) <= SUPERBERSERKSTATE_CHANCE then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_BERSERK, true, true, false, true, -1)
				SUPERBERSERKSTATE = true
			elseif SUPERBERSERKSTATE and Entity:IsActiveEnemy(false) and not Entity:IsBoss() and math.random(100) <= SUPERBERSERK_DELETE_CHANCE then
				table.insert(CustomData.Items.TEMPERTANTRUM.ErasedEnemies, Entity.Type)
			end
		end
		
		if player:HasTrinket(Trinkets.TORNPAGE) then
			if Entity.Type == 1 and math.random(100) <= TORNPAGE_CHANCE then
				TornPageData.BOOK = game:GetItemPool():GetCollectible(ItemPoolType.POOL_LIBRARY, false, Random(), 0)
				TornPageData.TIMER[i + 1] = 2
				player:UseActiveItem(TornPageData.BOOK, true, false, true, true, -1)
			end
		end
		
		if player:HasTrinket(Trinkets.JUDASKISS) and Entity.Type == 1 and Source.Entity:IsActiveEnemy(false) then
			Source.Entity:AddEntityFlags(EntityFlag.FLAG_BAITED)
		end
		
		if player:HasCollectible(Collectibles.BLACKDOLL) and ABSepNumber then
			for i = 1, #EntitiesGroupA do 
				if Entity:GetData() == EntitiesGroupA[i]:GetData() and EntitiesGroupB[i] and Source.Entity and Source.Entity.Type < 9 then 
					EntitiesGroupB[i]:TakeDamage(player.Damage / 2, 0, EntityRef(Entity), 0)
				end 
			end
			for i = 1, #EntitiesGroupB do 
				if Entity:GetData() == EntitiesGroupB[i]:GetData() and EntitiesGroupA[i] and Source.Entity and Source.Entity.Type < 9 then 
					EntitiesGroupA[i]:TakeDamage(player.Damage / 2, 0, EntityRef(Entity), 0)
				end 
			end
		end
		
		if player:HasTrinket(Trinkets.GREEDSHEART) and CustomData.Trinkets.GREEDSHEART == "CoinHeartFull" and Entity.Type == 1 
		and not (player:GetPlayerType() == 10 or player:GetPlayerType() == 31) then
			sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 1, 2, false, 1, 0)
			CustomData.Trinkets.GREEDSHEART = "CoinHeartEmpty"
			Entity:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(Entity), 24)
			return false
		end
		
		if player:HasCollectible(Collectibles.CEREMDAGGER) and Source.Entity and Source.Entity.Type == 2 and Source.Entity.Variant == TearVariants.CEREMDAGGER 
		and Entity:IsActiveEnemy(true) and Entity:IsVulnerableEnemy() then
			Entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
			sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 1, 2, false, 1, 0)
			return false
		end
		
		if player:HasCollectible(Collectibles.BIRDOFHOPE) and CustomData and CustomData.Items.BIRDOFHOPE.BirdCaught == false and Entity.Type == 1 then
			return false
		end
		
		if player:HasTrinket(Trinkets.MAGICSWORD, false) and Entity.Type == 1 and not player:HasTrinket(TrinketType.TRINKET_DUCT_TAPE) then
			sfx:Play(SoundEffect.SOUND_BONE_SNAP, 1, 2, false, 1, 0)
			if IsTrinketGulped(Trinkets.MAGICSWORD, player) then
				player:TryRemoveTrinket(Trinkets.MAGICSWORD)
				GetTrinketGulped(Trinkets.WAITNO, player)
			else
				player:TryRemoveTrinket(Trinkets.MAGICSWORD)
				player:AddTrinket(Trinkets.WAITNO)
			end
		end
		
		if player:HasTrinket(Trinkets.EDENSLOCK) and Entity.Type == 1 then
			local freezePreventChecker = 0
				
			repeat
				ID = player:GetDropRNG():RandomInt(728) + 1
				freezePreventChecker = freezePreventChecker + 1
			until (player:HasCollectible(ID, true)
			and Isaac.GetItemConfig():GetCollectible(ID).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
			and Isaac.GetItemConfig():GetCollectible(ID).Type % 3 == 1)	-- passive or familiar (1 or 4)
			or freezePreventChecker == 10000
			
			if freezePreventChecker < 10000 then
				player:RemoveCollectible(ID, true, -1, true)
			else 
				return true
			end
			
			repeat 
				newID = GetUnlockedVanillaCollectible(true)
			until Isaac.GetItemConfig():GetCollectible(newID).Type % 3 == 1
			player:AddCollectible(newID, 0, false, -1, 0)
			
			sfx:Play(SoundEffect.SOUND_EDEN_GLITCH, 1, 2, false, 1, 0)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, rplus.EntityTakeDmg)

						-- ON FAMILIAR INIT --										
						----------------------
function rplus:TrashBagInit(Familiar)
	CustomData.Items.BAGOTRASH.Levels = 1
	Familiar:AddToFollowers()
	Familiar.IsFollower = true
	Familiar:GetSprite():Play("FloatDown")
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, rplus.TrashBagInit, Familiars.BAGOTRASH)

function rplus:ZenBabyInit(Familiar)
	Familiar:AddToFollowers()
	Familiar.IsFollower = true
	Familiar:GetSprite():Play("FloatDown")
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, rplus.ZenBabyInit, Familiars.ZENBABY)

						-- ON FAMILIAR UPDATE --	 								
						------------------------
function rplus:TrashBagUpdate(Familiar)
	Familiar:FollowParent()
	if Familiar:GetSprite():IsFinished("Spawn") then
		Familiar:GetSprite().PlaybackSpeed = 1.0
		Familiar:GetSprite():Play("FloatDown")
	end
	
	if Familiar.RoomClearCount == 1 then
		local NumFlies = math.random(CustomData.Items.BAGOTRASH.Levels * 2)
		if Isaac.GetPlayer(0):HasCollectible(CollectibleType.COLLECTIBLE_BFFS, true) then NumFlies = NumFlies + math.random(2) end
		
		Familiar:GetSprite().PlaybackSpeed = 0.5
		Familiar:GetSprite():Play("Spawn")
		for _ = 1, NumFlies do Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, Familiar.Position, Vector.Zero, nil) end
		Familiar.RoomClearCount = 0
	end
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, rplus.TrashBagUpdate, Familiars.BAGOTRASH)

function rplus:ZenBabyUpdate(Familiar)
	Familiar:FollowParent()
	local Sprite = Familiar:GetSprite()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasCollectible(Collectibles.ZENBABY) then
			if player:GetFireDirection() == Direction.NO_DIRECTION then
				Sprite:Play(DIRECTION_FLOAT_ANIM[player:GetMovementDirection()], false)
			else
				local TearVector = DIRECTION_VECTOR[player:GetFireDirection()]

				if Familiar.FireCooldown <= 0 then
					local Tear = Familiar:FireProjectile(TearVector):ToTear()
					Tear.TearFlags = TearFlags.TEAR_GLOW | TearFlags.TEAR_HOMING
					Tear:Update()

					if player:HasTrinket(Isaac.GetTrinketIdByName("Forgotten Lullaby")) then
						Familiar.FireCooldown = 10
					else
						Familiar.FireCooldown = 16
					end
				end

				Sprite:Play(DIRECTION_SHOOT_ANIM[player:GetFireDirection()], false)
			end

			Familiar.FireCooldown = Familiar.FireCooldown - 1
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, rplus.ZenBabyUpdate, Familiars.ZENBABY)

function rplus:SoulUpdate(Familiar)
	if CustomData.Items.ENRAGEDSOUL.AttachedEnemy then
		if CustomData.Items.ENRAGEDSOUL.AttachedEnemy:IsActiveEnemy() and AttachFrames >= 0 then
			Familiar.Position = CustomData.Items.ENRAGEDSOUL.AttachedEnemy.Position
			AttachFrames = AttachFrames - 1
		else 	
			Familiar:Kill()
			CustomData.Items.ENRAGEDSOUL.AttachedEnemy = nil
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, rplus.SoulUpdate, Familiars.SOUL)

						-- FAMILIAR COLLISION --									
						------------------------
function rplus:CherryCollision(Familiar, Collider, _)
	if Collider:IsActiveEnemy(true) and not Collider:IsBoss() and game:GetFrameCount() % 10 == 0 then
		game:CharmFart(Familiar.Position, 10.0, Familiar)
		sfx:Play(SoundEffect.SOUND_FART, 1, 2, false, 1, 0)
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, rplus.CherryCollision, Familiars.CHERRY)

function rplus:BirdCollision(Familiar, Collider, _)
	if Collider.Type == 1 then
		sfx:Play(SoundEffect.SOUND_SUPERHOLY, 1, 2, false, 1, 0)
		Isaac.Spawn(1000, EffectVariant.POOF01, 0, Familiar.Position, Vector.Zero, nil)
		Familiar:Remove()
		dyingPlayer.Position = DiePos
		dyingPlayer:TryRemoveNullCostume(Costumes.BIRDOFHOPE)
		dyingPlayer:RemoveCollectible(185, true, 0, true)
		CustomData.Items.BIRDOFHOPE.BirdCaught = true
		GiveRevivalIVFrames(dyingPlayer)
		dyingPlayer = nil
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, rplus.BirdCollision, Familiars.BIRD)

function rplus:SoulCollision(Familiar, Collider, _)
	if Collider:IsActiveEnemy(true) and not Collider:HasEntityFlags(EntityFlag.FLAG_CHARM) and not CustomData.Items.ENRAGEDSOUL.AttachedEnemy then
		Familiar.Velocity = Vector.Zero
		CustomData.Items.ENRAGEDSOUL.AttachedEnemy = Collider
		AttachFrames = ENRAGED_SOUL_COOLDOWN / 2
		Familiar:GetSprite():Play("Idle", true)
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, rplus.SoulCollision, Familiars.SOUL)

						-- PROJECTILE COLLISION --									
						--------------------------
function rplus:ProjectileCollision(Projectile, Collider, _)
	if Collider.Variant == Familiars.BAGOTRASH then
		Projectile:Remove()
		
		if math.random(100) <= TRASHBAG_BREAK_CHANCE then
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 1, false, 1, 0)
			Isaac.GetPlayer(0):RemoveCollectible(Collectibles.BAGOTRASH)
			if math.random(100) <= 66 then
				Isaac.Spawn(5, 100, CollectibleType.COLLECTIBLE_BREAKFAST, Collider.Position, Vector.Zero, nil)
			else
				Isaac.Spawn(5, 350, Trinkets.NIGHTSOIL, Collider.Position, Vector.Zero, nil)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, rplus.ProjectileCollision)

						-- PLAYER COLLISION --										
						----------------------
function rplus:playerCollision(Player, Collider, _)
	if Collider.Variant == PickUps.SCARLETCHEST and Collider.SubType == 0 then
		Collider.SubType = 1
		Collider:GetSprite():Play("Open")
		Collider:GetData()["IsRoom"] = true
		sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 2, false, 1, 0)
		Player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(Collider), 30)
		local DieRoll = math.random(100)
		
		if DieRoll < 15 then
			local freezePreventChecker = 0
			
			repeat
				Item = ScarletChestItems[math.random(#ScarletChestItems)]
				freezePreventChecker = freezePreventChecker + 1
			until IsCollectibleUnlocked(Item) or freezePreventChecker == 1000
			
			if freezePreventChecker < 1000 then
				Isaac.Spawn(5, 100, Item, Collider.Position, Vector(0, 0), Collider)
			else 
				EntityNPC.ThrowSpider(Collider.Position, Collider, Collider.Position + Vector.FromAngle(math.random(360)) * 200, false, 0) 
			end
			
			Collider:Remove()
		elseif DieRoll < 85 then
			local NumOfPickups = RNG():RandomInt(4) + 1 -- 1 to 4 pickups
			
			for i = 1, NumOfPickups do
				local variant = nil
				local subtype = nil
				
				if math.random(100) < 66 then
					variant = 10
					subtype = ScarletChestHearts[math.random(#ScarletChestHearts)]
				else
					variant = 70
					subtype = 0
				end
				Isaac.Spawn(5, variant, subtype, Collider.Position, Vector.FromAngle(math.random(360)) * 5, Collider)
			end
		else
			EntityNPC.ThrowSpider(Collider.Position, Collider, Collider.Position + Vector.FromAngle(math.random(360)) * 200, false, 0)
		end
	end

	if Player:HasTrinket(Trinkets.SLEIGHTOFHAND) and math.random(100) <= SLEIGHTOFHAND_CHANCE * Player:GetTrinketMultiplier(Trinkets.SLEIGHTOFHAND) then
		-- cuz slots don't have their own collision callback, thanks api lmao
		if Collider.Type == 6 then
			local S = Collider:GetSprite()
			
			-- make sure that we don't infinitely collide with them, results in infinite consumables!!!
			if S:GetFrame() == 1 and 
			(S:IsPlaying("PayPrize") or S:IsPlaying("PayNothing") or S:IsPlaying("PayShuffle") or S:IsPlaying("Initiate")) then
				if Player:GetNumCoins() > 0 and		-- slots that take your money
				(Collider.Variant == 1 or Collider.Variant == 3 or Collider.Variant == 4 or Collider.Variant == 6 or Collider.Variant == 10 or Collider.Variant == 13 or Collider.Variant == 18) then 
					Player:AddCoins(1)
				end
				if Player:GetNumBombs() > 0 and Collider.Variant == 9 then	-- that was bomb bum, simple stuff
					Player:AddBombs(1)
				end
				if Player:GetNumKeys() > 0 and Collider.Variant == 7 then	-- and that was a key master
					Player:AddKeys(1)
				end
			end
		elseif Collider.Type == 5 then
			local S = Collider:GetSprite()
			
			if S:GetFrame() == 1 and (S:IsPlaying("Open") or S:IsPlaying("UseKey")) and 	-- chests that require a key to open
			(Collider.Variant == 53 or Collider.Variant == 55 or Collider.Variant == 57 or Collider.Variant == 60) and	-- no golden keys or lockpicks allowed!
			not Player:HasGoldenKey() and not Player:HasTrinket(TrinketType.TRINKET_PAPER_CLIP) then 
				Player:AddKeys(1) 
			end
		end
	end
	
	if Player:HasCollectible(Collectibles.CEILINGSTARS) and Collider.Type == 5 and Collider.Variant == 380 and not CustomData.Items.CEILINGSTARS.SleptInBed then
		CustomData.Items.CEILINGSTARS.SleptInBed = true
		for i = 1, 2 do
			repeat 
				newID = GetUnlockedVanillaCollectible()
			until Isaac.GetItemConfig():GetCollectible(newID).Type % 3 == 1
			Player:AddItemWisp(newID, Player.Position, true)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, rplus.playerCollision, 0)

						-- PRE ROOM CLEAR AWARD SPAWN --							
						--------------------------------
function rplus:PickupAwardSpawn(_, Pos)
	local room = game:GetRoom()
	local level = game:GetLevel()
	
	--[[ Unlocking stuff
	if room:GetType() == RoomType.ROOM_BOSS and game.Difficulty <= 1 then
		if level:GetStage() == LevelStage.STAGE5 then
			if level:GetStageType() == StageType.STAGETYPE_ORIGINAL then
				Unlock("Satan")
			else
				Unlock("Isaac")
			end
		elseif level:GetStage() == LevelStage.STAGE6 and level:GetStageType() == StageType.STAGETYPE_WOTL then
			Unlock("Blue Baby")
		end
	elseif room:GetType() == RoomType.ROOM_BOSSRUSH then
		Unlock("Boss Rush")
	elseif isUltraGreedRoom() then
		Unlock("Greed")
	end
	--]]
	
	if CustomData and math.random(100) < JACKOF_CHANCE and CustomData.Cards.JACK and room:GetType() ~= RoomType.ROOM_BOSS then
		local Variant = nil
		local SubType = nil
		
		dieroll = math.random(100)
		
		if CustomData.Cards.JACK == "Diamonds" then
			Variant = 20
			
			if dieroll <= 90 then
				SubType = 1 --penny
			elseif dieroll <= 98 then
				SubType = 2 --nickel 
			else
				SubType = 3 --dime
			end
		elseif CustomData.Cards.JACK == "Clubs" then
			Variant = 40
			
			if dieroll <= 80 then
				SubType = 1 --bomb
			else
				SubType = 2	--double bomb
			end
		elseif CustomData.Cards.JACK == "Spades" then
			Variant = 30
			
			if dieroll <= 80 then
				SubType = 1 --key
			elseif dieroll <= 90 then
				SubType = 3	--double key
			elseif dieroll <= 98 then
				SubType = 4 --charged key
			end
		elseif CustomData.Cards.JACK == "Hearts" then
			Variant = 10
			
			if dieroll <= 40 then
				SubType = 1 --Heart
			elseif dieroll <= 70 then
				SubType = 2 --Half Heart
			elseif dieroll <= 80 then
				SubType = 5 --Double Heart
			elseif dieroll <= 90 then
				SubType = 3 --Soul Heart
			elseif dieroll <= 96 then
				SubType = 10 --Blended Heart
			elseif dieroll <= 99 then
				SubType = 6  --Black Heart
			else
				SubType = 4  --Eternal Heart
			end
		end
		
		Isaac.Spawn(5, Variant, SubType, game:GetRoom():FindFreePickupSpawnPosition(Pos, 0, true, false), Vector.Zero, nil)
		return true
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, rplus.PickupAwardSpawn)

						-- ON USING PILL --	
						-------------------
function rplus:usePill(pillEffect, Player, _)	
	if pillEffect == Pills.ESTROGEN then
		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1, 2, false, 1, 0)
		local BloodClots = Player:GetHearts() - 2 
		
		Player:AddHearts(-BloodClots)
		for i = 1, BloodClots do
			Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, 0, Player.Position, Vector.Zero, nil)
		end
	end
	
	if pillEffect == Pills.LAXATIVE then
		Player:GetData()['pill'] = "used lax"
		CustomData.Pills.LAXATIVE.LaxUseFrame = game:GetFrameCount()
		sfx:Play(SoundEffect.SOUND_FART, 1, 2, false, 1, 0)
		Player:AnimateSad()
	end
	
	if Player:HasCollectible(Collectibles.DNAREDACTOR) then
		local pillColor = game:GetItemPool():ForceAddPillEffect(pillEffect) % 2407 -- include horse pills too

		if pillColor == PillColor.PILL_BLUE_BLUE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_CLICKER, true, true, false, false, -1)			-- change character
		elseif pillColor == PillColor.PILL_WHITE_BLUE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, true, true, false, false, -1)	-- restart the floor
		elseif pillColor == PillColor.PILL_ORANGE_ORANGE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_D100, true, true, false, false, -1)			-- D100 use
		elseif pillColor == PillColor.PILL_WHITE_WHITE then
			Player:AddPill(pillColor)																		-- the pill replicates itself constantly
		elseif pillColor == PillColor.PILL_REDDOTS_RED then
			Isaac.Explode(Player.Position, Player, 110)														-- explosion
			Player:TakeDamage(1, 0, EntityRef(Player), 30)
		elseif pillColor == PillColor.PILL_PINK_RED then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_BERSERK, true, true, false, false, -1)			-- Berserk mode
		elseif pillColor == PillColor.PILL_BLUE_CADETBLUE then
			game:StartRoomTransition(-2, -1, RoomTransitionAnim.TELEPORT, Player, -1)						-- teleport to the Error room
		elseif pillColor == PillColor.PILL_YELLOW_ORANGE then
			Player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)												-- discharge your active item
		elseif pillColor == PillColor.PILL_ORANGEDOTS_WHITE then
			Player:UseCard(Card.CARD_GET_OUT_OF_JAIL, UseFlag.USE_NOANIM)									-- open all doors
		elseif pillColor == PillColor.PILL_WHITE_AZURE then
			Player:UseCard(Card.CARD_REVERSE_FOOL, UseFlag.USE_NOANIM)										-- reverse Fool (drop all your stuff)
		elseif pillColor == PillColor.PILL_BLACK_YELLOW then
			Player:UseCard(Card.CARD_HUMANITY, UseFlag.USE_NOANIM)											-- Card against humanity (shit on the floor)
		elseif pillColor == PillColor.PILL_WHITE_BLACK then
			Isaac.Spawn(5, 350, 0, Player.Position, Vector.Zero, nil)										-- spawn a random trinket
		elseif pillColor == PillColor.PILL_WHITE_YELLOW then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, true, true, false, false, -1)			-- restart the run (R key)
			Player:RemoveCollectible(Collectibles.DNAREDACTOR)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_PILL, rplus.usePill)

								-----------------------------------------
								--- EXTERNAL ITEM DESCRIPTIONS COMPAT ---
								-----------------------------------------
								
if EID then
	EID:addCollectible(Collectibles.ORDLIFE, "{{ArrowUp}} Tears up")	
	EID:addCollectible(Collectibles.COOKIECUTTER, "Gives you one {{Heart}} heart container and one broken heart #{{Warning}} Having 12 broken hearts kills you!")
	EID:addCollectible(Collectibles.SINNERSHEART, "{{ArrowUp}} Damage +2 then x1.5 #{{ArrowDown}} Shot speed down #Homing tears")
	EID:addCollectible(Collectibles.RUBIKSCUBE, "After each use, has a 5% (100% on 20-th use) chance to be 'solved', removed from the player and be replaced with a Magic Cube item")
	EID:addCollectible(Collectibles.MAGICCUBE, "{{DiceRoom}} Rerolls item pedestals #Rerolled items can be drawn from any item pool")
	EID:addCollectible(Collectibles.MAGICPEN, "Tears leave {{ColorRainbow}}rainbow{{CR}} creep underneath them #Random permanent status effects is applied to enemies walking over that creep")
	EID:addCollectible(Collectibles.MARKCAIN, "On death, if you have any familiars, removes them instead and revives you #On revival, you keep your heart containers, gain +0.4 DMG for each consumed familiar and gain invincibility #{{Warning}} Works only once!")
	EID:addCollectible(Collectibles.TEMPERTANTRUM, "Upon taking damage, there is a 25% chance to enter a Berserk state #While in this state, every enemy damaged has a 10% chance to be erased for the rest of the run")
	EID:addCollectible(Collectibles.BAGOTRASH, "A familiar that creates blue flies upon clearing a room #Blocks enemy projectiles, and after blocking it has a chance to be destroyed and drop Breakfast or Nightsoil trinket #The more floors it is not destroyed, the more flies it spawns")
	EID:addCollectible(Collectibles.ZENBABY, "A familiar that shoots Godhead tears at a fast firerate")
	EID:addCollectible(Collectibles.CHERRYFRIENDS, "Killing an enemy has a 20% chance to drop cherry familiar on the ground #Those cherries emit a charming fart when an enemy walks over them, and drop half a heart when a room is cleared")
	EID:addCollectible(Collectibles.BLACKDOLL, "Upon entering a new room, all enemies will be split in pairs. Dealing damage to one enemy in each pair will deal half of that damage to another enemy in that pair")
	EID:addCollectible(Collectibles.BIRDOFHOPE, "Upon dying you turn into invincible ghost and a bird flies out of room center in a random direction. Catching the bird in 5 seconds will save you and get you back to your death spot, otherwise you will die #{{Warning}} Every time you die, the bird will fly faster and faster, making it harder to catch her")
	EID:addCollectible(Collectibles.ENRAGEDSOUL, "Double tap shooting button to launch a ghost familiar in the direction you are firing #The ghost will latch onto the first enemy it collides with, dealing damage over time for 7 seconds or until that enemy is killed #The ghost can latch onto bosses aswell #{{Warning}} Has a 7 seconds cooldown")
	EID:addCollectible(Collectibles.CEREMDAGGER, "{{ArrowDown}} Damage x0.85 #When shooting, 5% chance to launch a dagger that does no damage, but inflicts bleed on enemies #All enemies that die while bleeding will drop Sacrificial Blood Consumable that gives you temporary DMG up")
	EID:addCollectible(Collectibles.CEILINGSTARS, "Grants you two Lemegeton wisps at the beginning of each floor and when sleeping in bed")
	EID:addCollectible(Collectibles.QUASAR, "Consumes all item pedestals in the room and gives you 3 Lemegeton wisps for each item consumed")
	EID:addCollectible(Collectibles.TWOPLUSONE, "Every third shop item on the current floor will cost 1 {{Coin}} penny #Buying two items with hearts in one room makes all other items free")
	EID:addCollectible(Collectibles.REDMAP, "Reveals location of Ultra Secret Room on all subsequent floors #Any trinket left in a boss or treasure room will turn into Cracked Key")
	EID:addCollectible(Collectibles.CHEESEGRATER, "Removes one red heart container and gives you {{ArrowUp}} +0.5 Damage up and two Minisaacs")
	EID:addCollectible(Collectibles.DNAREDACTOR, "Pills now have additional effects based on their color")
	EID:addCollectible(Collectibles.TOWEROFBABEL, "Destroys all obstacles in the current room and applies confusion to enemies in small radius around you #Also blows the doors open and opens secret room entrances")
	EID:addCollectible(Collectibles.BLESSOTDEAD, "Prevents curses from appearing for the rest of the run #Preventing a curse grants you {{ArrowUp}} +0.5 Damage up")
	
	EID:addTrinket(Trinkets.BASEMENTKEY, "{{ChestRoom}} While held, every Golden Chest has a 5% chance to be replaced with Old Chest")
	EID:addTrinket(Trinkets.KEYTOTHEHEART, "While held, every enemy has a chance to drop Scarlet Chest upon death #Scarlet Chests can contain 1-4 {{Heart}} heart/{{Pill}} pills or a random body-related item")
	EID:addTrinket(Trinkets.JUDASKISS, "Enemies touching you become targeted by other enemies (effect similar to Rotten Tomato)")
	EID:addTrinket(Trinkets.SLEIGHTOFHAND, "Using coin, bomb or key on slots, beggars or locked chests has a 17% chance to not subtract it from your inventory count")
	EID:addTrinket(Trinkets.BITTENPENNY, "Upon spawning, every coin has a 20% chance to be upgraded to a higher value: #penny -> doublepack pennies -> sticky nickel -> nickel -> dime -> lucky penny -> golden penny")
	EID:addTrinket(Trinkets.GREEDSHEART, "Gives you one empty coin heart #It is depleted before any of your normal hearts and can only be refilled by directly picking up money")
	EID:addTrinket(Trinkets.ANGELSCROWN, "All new treasure rooms will have an angel item for sale instead of a normal item #Angels spawned from statues will not drop Key Pieces!")
	EID:addTrinket(Trinkets.MAGICSWORD, "{{ArrowUp}} x2 DMG up while held #Breaks when you take damage #{{ArrowUp}} Having Duct Tape prevents it from breaking")
	EID:addTrinket(Trinkets.WAITNO, "Does nothing, it's broken")
	EID:addTrinket(Trinkets.EDENSLOCK, "Upon taking damage, one of your items rerolls into another random item #Doesn't take away nor give you story items")
	EID:addTrinket(Trinkets.CHALKPIECE, "When entering uncleared room, you will leave a trail of powder underneath for 5 seconds #Enemies walking over this trail will be pushed back")
	EID:addTrinket(Trinkets.ADAMSRIB, "Revives you as Eve when you die")
	EID:addTrinket(Trinkets.NIGHTSOIL, "40% chance to prevent a curse when entering a new floor")
	EID:addTrinket(Trinkets.TORNPAGE, "25% chance to activate a random book effect upon taking damage")
	
	EID:addCard(PocketItems.SDDSHARD, "Invokes the effect of Spindown Dice")
	EID:addCard(PocketItems.REDRUNE, "Damages all enemies in a room, turns item pedestals into red locusts and turns pickups into random locusts with a 50% chance")
	EID:addCard(PocketItems.NEEDLEANDTHREAD, "Removes one broken heart and grants one {{Heart}} heart container")
	EID:addCard(PocketItems.QUEENOFDIAMONDS, "Spawns  1-12 random {{Coin}} coins (those can be nickels or dimes as well)")
	EID:addCard(PocketItems.KINGOFSPADES, "Lose all your keys and spawn a number of pickups proportional to the amount of keys lost #At least 12 {{Key}} keys is needed for a trinket, and at least 28 for an item #If Isaac has {{GoldenKey}} Golden key, it is removed too and significantly increases total value")
	EID:addCard(PocketItems.KINGOFCLUBS, "Lose all your bombs and spawn a number of pickups proportional to the amount of bombs lost #At least 12 {{Bomb}} bombs is needed for a trinket, and at least 28 for an item #If Isaac has {{GoldenBomb}} Golden bomb, it is removed too and significantly increases total value")
	EID:addCard(PocketItems.KINGOFDIAMONDS, "Lose all your coins and spawn a number of pickups proportional to the amount of coins lost #At least 12 {{Coin}} coins is needed for a trinket, and at least 28 for an item")
	EID:addCard(PocketItems.BAGTISSUE, "All pickups in a room are destroyed, and 8 most valuables pickups form an item quality based on their total weight; the item of such quality is then spawned #The most valuable pickups are the rarest ones, e.g. {{EthernalHeart}} Eternal hearts or {{Battery}} Mega batteries #{{Warning}} If used in a room with less then 8 pickups, no item will spawn!")
	EID:addCard(PocketItems.RJOKER, "Teleports Isaac to a {{SuperSecretRoom}} Black Market")
	EID:addCard(PocketItems.REVERSECARD, "Invokes the effect of Glowing Hourglass")
	EID:addCard(PocketItems.LOADEDDICE, "{{ArrowUp}}  grants 10 Luck for the current room")
	EID:addCard(PocketItems.BEDSIDEQUEEN, "Spawns 1-12 random {{Key}} keys #There is a small chance to spawn a charged key")
	EID:addCard(PocketItems.QUEENOFCLUBS, "Spawns 1-12 random {{Bomb}} bombs #There is a small chance to spawn a double-pack bomb")
	EID:addCard(PocketItems.JACKOFCLUBS, "Bombs will drop more often from clearing rooms for current floor, and the average quality of bombs is increased")
	EID:addCard(PocketItems.JACKOFDIAMONDS, "Coins will drop more often from clearing rooms for current floor, and the average quality of coins is increased")
	EID:addCard(PocketItems.JACKOFSPADES, "Keys will drop more often from clearing rooms for current floor, and the average quality of keys is increased")
	EID:addCard(PocketItems.JACKOFHEARTS, "Hearts will drop more often from clearing rooms for current floor, and the average quality of hearts is increased")
	EID:addCard(PocketItems.QUASARSHARD, "Damages all enemies in a room and turns every item pedestal into 3 Lemegeton wisps")
	EID:addCard(PocketItems.BUSINESSCARD, "Summons a random monster, like ones from Friend Finder")
	EID:addCard(PocketItems.SACBLOOD, "{{ArrowUp}} Gives +1 DMG up that depletes over the span of 25 seconds #Stackable #{{ArrowUp}} Heals you for one red heart if you have Ceremonial Robes #{{Warning}} Damage depletes quicker the more Blood you used subsequently")
	EID:addCard(PocketItems.LIBRARYCARD, "Activates a random book effect")
	
	EID:addPill(Pills.ESTROGEN, "Turns all your red health into blood clots #Leaves you at one red heart, doesn't affect soul/black hearts")
	EID:addPill(Pills.LAXATIVE, "Makes you shoot out corn tears from behind for 3 seconds")
end






































