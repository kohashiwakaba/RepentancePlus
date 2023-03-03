----------------------------------------------------------------------------------------------
-- Welcome to main.lua, please make yourself comfortable while reading all of this bullshit --
-- Popcorn 100g: $5 350g: $10 ----------------------------------------------------------------
-- Nachos 100g, any dip: $6 --------------------- For Saver menus, allergens, other food -----
-- Soft-Drink, any  0.5l: $4 1l: $6 -------------- and further questions please ask our ------
-- Water, sparkling or still  0.5l: $2 1l: $3 ------------------ staff -----------------------
-- Beer 0.33l: $3 ------------------------------------------ Enjoy the show! -----------------
----------------------------------------------------------------------------------------------

									---------------------
									----- VARIABLES -----
									---------------------

local game = Game()
local hud = game:GetHUD()
local rplus = RegisterMod("Repentance Plus", 1)
RepentancePlusMod = rplus
local json = require("json")
CustomData = {}
local MOD_VERSION = "1.33"
local sfx = SFXManager()
local rng = RNG()
local HUDValueRenderOffset = Vector(20, 12)
local FLAG_NO_TAINTED_HEARTS = false
RepentancePlusMod.FLAG_NO_TAINTED_HEARTS = FLAG_NO_TAINTED_HEARTS
local FLAG_CONNECT_MCM = true
local FLAG_PRINT_INIT_MESSAGE = true
-- for Hand-Me-Downs
local HAND_ME_DOWNS_GAMEOVER = {Stage = 0, Items = {}}

-- for unlock system
local bossMarks = {
	"Boss Rush",
	"Mom's Heart",
	"Blue Baby",
	"Satan",
	"Isaac",
	"Greed",
	"Character Unlock"
}

local playerTypeToName = {
	[21] = "Isaac",
	[22] = "Magdalene",
	[23] = "Cain",
	[24] = "Judas",
	[25] = "???",
	[26] = "Eve",
	[27] = "Samson",
	[28] = "Azazel",
	[29] = "Lazarus",
	[30] = "Eden",
	[31] = "Lost",
	[32] = "Lilith",
	[33] = "Keeper",
	[34] = "Apollyon",
	[35] = "Forgotten",
	[36] = "Bethany",
	[37] = "Jacob"
}

-- effect helpers
local HelperEffects = {
	CRIPPLING_HANDS = Isaac.GetEntityVariantByName("Crippling Hands Helper"),
	FALLING_KNIFE = Isaac.GetEntityVariantByName("Falling Knife Helper"),
	ANIMATED_ITEM_DUMMY = Isaac.GetEntityVariantByName("Animated Item Dummy Entity"),
	PURE_SOUL_GHOST = Isaac.GetEntityVariantByName("Pure Soul"),
	HANDICAPPED_PLACARD_AOE = Isaac.GetEntityVariantByName("Handicapped Placard Effect Border"),
	BROKEN_HEART_PEDESTAL_PRE_REROLL = Isaac.GetEntityVariantByName("Pedestal Broken Heart Helper")
}
RepentancePlusMod.HelperEffect = HelperEffects

-- helpers for rendering
local FLAG_DISPLAY_UNLOCKS_TIP = false	-- display tips on the screen for the first launch of v1.27 with the unlocks system
local UnlocksTip = "PLEASE TAKE A MOMENT TO READ THIS MESSAGE. # #Hello! Repentance Plus was updated to include the #unlocks and achievements system! You now need #to gain completion marks with tainted characters #to unlock modded content. # #You can also track your progress, or #unlock marks, in two ways: #  1. Using console commands (type #rplus_help into the console for help); #  2. Using mod menus. # #IMPORTANT NOTE: your unlock progress is saved #ONLY when you exit a run!!! #Press Space, E or Enter to close this message"
local tipPaper = Sprite()
tipPaper:Load("gfx/ui/achievement/achievements_plus.anm2", true)
tipPaper:Play("Idle", false)
tipPaper.Scale = Vector(1.5, 1.5)

--
local FLAG_HIDE_ERROR_MESSAGE
local ErrorMessage = "Warning! Custom Mod Data of Repentance Plus #wasn't loaded, the mod could work incorrectly. #Custom Mod Data will be properly loaded next time you start a new run. #(Type 'hide' into the console or press H to hide this message)"

--
local achievementPaper = Sprite()
achievementPaper:Load("gfx/ui/achievement/achievements_plus.anm2", true)
achievementPaper:Play("Appear", false)
local FLAG_RENDER_PAPER = false
--

local PenIcon = Sprite()
PenIcon:Load("gfx/ui/ui_visual_clues.anm2", true)
PenIcon:Play("PenReady", false)
PenIcon.PlaybackSpeed = 0.5

local CoinHeartSprite = Sprite()
CoinHeartSprite:Load("gfx/ui/ui_coinhearts.anm2", true)
local HeartRenderPos = Vector(122, 11)

local SoulIcon = Sprite()
SoulIcon:Load("gfx/ui/ui_visual_clues.anm2", true)
SoulIcon:Play("SoulReady", false)
SoulIcon.PlaybackSpeed = 0.5

local RedMapIcon = Sprite()
RedMapIcon:Load("gfx/ui/ui_visual_clues.anm2", true)

local DNAPillIcon = Sprite()
DNAPillIcon:Load("gfx/ui/ui_dnapillhelper.anm2", true)
DNAPillIcon.Scale = Vector(0.5, 0.5)

local DogmaAttackIcon = Sprite()
DogmaAttackIcon:Load("gfx/ui/ui_visual_clues.anm2", true)
DogmaAttackIcon:Play("DogmaReady")
DogmaAttackIcon.PlaybackSpeed = 0.5

local LineOfSightEyes = Sprite()
LineOfSightEyes:Load("gfx/ui/ui_lineofsight_eyes.anm2", true)

local LeviathanGiantBookAnim = Sprite()	-- used not only for Book of Leviathan, but for imitating Berkano rune pop up
local animLength
local FLAG_FAKE_POPUP_PAUSE

									---------------------
									----- CONSTANTS -----
									---------------------
local ModConstants = {
	-- All in %
	Chances = {
		BASEMENT_KEY = 25,
		KEY_TO_THE_HEART = 2,
		TEMPER_TANTRUM = {
			STATE_ENTER = 25,
			STATE_ERASE_ENEMY = 7.5
		},
		BAG_O_TRASH_BREAK = 1.25,
		CHERRY_FRIENDS_SPAWN = 20,
		SLEIGHT_OF_HAND_UPGRADE = 20,
		JACK_EXTRA_DROP = 25,
		TRICK_PENNY = 20,
		CEREMONIAL_DAGGER_LAUNCH = 7.5,
		NIGHT_SOIL_NEGATE_CURSE = 66,
		NERVE_PINCH_USE_ACTIVE = 80,
		FLESH_CHEST = {
			REPLACE = 20,
			OPEN = 33
		},
		STARGAZER_ITEM_PAYOUT = 20,
		TAINTED_ROCKS_REPLACE = 10,
		CROSS_OF_CHAOS_TEAR_CRIPPLE = 2,	-- increases with luck up to a maximum of 7%
		KEY_KNIFE_SHADOW_ENTER = 10,
		SOUL_BOND_DROP_HEART = 33,
		SINS_JEWEL_BASE_DROP = 15,
		WHITE_SACK_REPLACE = 1,
		STOMACK_REPLACE = 1,
		HEARTTERY_REPLACE = 0.625
	},
	-- In frames; divided by 30 or 60, depending on what callback it's used from
	Cooldowns = {
		ENRAGED_SOUL_LAUNCH = 6 * 60,
		RED_BOMBER_BOMB_THROW = 1.5 * 60,
		MAGIC_PEN_CREEP_SPEW = 4 * 60,
		NERVE_PINCH_TRIGGER = 2.5 * 60,
		SIBLING_RIVALRY_STATE_SWITCH = 15 * 30,
		ANGELS_WINGS_NEW_ATTACK = 6 * 60
	}
}
RepentancePlusMod.ModConstants = ModConstants

									-----------------
									----- ENUMS -----
									-----------------

-- Only non-persistent costumes are here, because persistent costumes work without lua
local CustomCostumes = {
	BIRD_OF_HOPE = Isaac.GetCostumeIdByPath("gfx/characters/costume_004_birdofhope.anm2")
}

local CustomTearVariants = {
	CEREMONIAL_BLADE = Isaac.GetEntityVariantByName("Ceremonial Dagger Tear"),
	SINNERS_HEART = Isaac.GetEntityVariantByName("Sinner's Heart Tear"),
	CORN = Isaac.GetEntityVariantByName("Corn Tear"),
	ANTIMATERIAL_CARD = Isaac.GetEntityVariantByName("Antimaterial Card Tear"),
	REJECTED_BABY = Isaac.GetEntityVariantByName("Rejected Baby Tear"),
	DOGMA_FEATHER = Isaac.GetEntityVariantByName("Dogma Feather Tear"),
	VALENTINES_CARD = Isaac.GetEntityVariantByName("Valentine's Card Tear"),
	KEY_TO_THE_HEART = Isaac.GetEntityVariantByName("Key to the Heart Tear")
}

local CustomFamiliars = {
	BAG_O_TRASH = Isaac.GetEntityVariantByName("Bag-o-Trash"),
	CHERUBIM = Isaac.GetEntityVariantByName("Cherubim"),
	CHERRY = Isaac.GetEntityVariantByName("Cherry"),
	BIRD = Isaac.GetEntityVariantByName("Bird of Hope"),
	ENRAGED_SOUL = Isaac.GetEntityVariantByName("Enraged Soul"),
	TOY_HELICOPTER_TANK = Isaac.GetEntityVariantByName("Toy Tank 1"),
	SIBLING_1 = Isaac.GetEntityVariantByName("Peaceful Sibling 1"),
	SIBLING_2 = Isaac.GetEntityVariantByName("Peaceful Sibling 2"),
	FIGHTING_SIBLINGS = Isaac.GetEntityVariantByName("Fighting Siblings"),
	REJECTION_FETUS = Isaac.GetEntityVariantByName("Rejection Fetus"),
	ENOCH = Isaac.GetEntityVariantByName("Enoch"),
	ENOCH_B = Isaac.GetEntityVariantByName("Enoch (tainted)"),
	ORBITAL_GHOST = Isaac.GetEntityVariantByName("Spiritual Reserves (Sun)"),
	FRIENDLY_SACK = Isaac.GetEntityVariantByName("Friendly Sack"),
	ULTRA_FLESH_KID_L1 = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 1"),
	ULTRA_FLESH_KID_L2 = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 2"),
	ULTRA_FLESH_KID_L3 = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 3"),
	ULTRA_FLESH_KID_L3_HEAD = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 3 (head)"),
	HANDICAPPED_PLACARD = Isaac.GetEntityVariantByName("Handicapped Placard"),
	DEAD_WEIGHT = Isaac.GetEntityVariantByName("Dead Weight"),
	KEEPERS_ANNOYING_FLY = Isaac.GetEntityVariantByName("Keeper's Annoying Fly"),
	-- Custom clots produced by tainted hearts
	ClotSubtype = {
		DAUNTLESS = 20,
		SOILED = 21,
		EMPTY = 22,
		ZEALOT = 23
	}
}
RepentancePlusMod.ClotIds = CustomFamiliars.ClotSubtype

local CustomCollectibles = {
	ORDINARY_LIFE = Isaac.GetItemIdByName("Ordinary Life"),
	COOKIE_CUTTER = Isaac.GetItemIdByName("Cookie Cutter"),
	RUBIKS_CUBE = Isaac.GetItemIdByName("Rubik's Cube"),
	MAGIC_CUBE = Isaac.GetItemIdByName("Magic Cube"),
	MAGIC_PEN = Isaac.GetItemIdByName("Magic Pen"),
	SINNERS_HEART = Isaac.GetItemIdByName("Sinner's Heart"),
	MARK_OF_CAIN = Isaac.GetItemIdByName("The Mark of Cain"),
	BAG_O_TRASH = Isaac.GetItemIdByName("Bag-o-Trash"),
	TEMPER_TANTRUM = Isaac.GetItemIdByName("Temper Tantrum"),
	CHERRY_FRIENDS = Isaac.GetItemIdByName("Cherry Friends"),
	CHERUBIM = Isaac.GetItemIdByName("Cherubim"),
	BLACK_DOLL = Isaac.GetItemIdByName("Black Doll"),
	BIRD_OF_HOPE = Isaac.GetItemIdByName("A Bird of Hope"),
	ENRAGED_SOUL = Isaac.GetItemIdByName("Enraged Soul"),
	CEREMONIAL_BLADE = Isaac.GetItemIdByName("Ceremonial Blade"),
	CEILING_WITH_THE_STARS = Isaac.GetItemIdByName("Ceiling with the Stars"),
	QUASAR = Isaac.GetItemIdByName("Quasar"),
	TWO_PLUS_ONE = Isaac.GetItemIdByName("2+1"),
	RED_MAP = Isaac.GetItemIdByName("Red Map"),
	CHEESE_GRATER = Isaac.GetItemIdByName("Cheese Grater"),
	DNA_REDACTOR = Isaac.GetItemIdByName("DNA Redactor"),
	TOWER_OF_BABEL = Isaac.GetItemIdByName("Tower of Babel"),
	BLESS_OF_THE_DEAD = Isaac.GetItemIdByName("Bless of the Dead"),		-- cry about it
	TANK_BOYS = Isaac.GetItemIdByName("Tank Boys"),
	GUSTY_BLOOD = Isaac.GetItemIdByName("Gusty Blood"),
	RED_BOMBER = Isaac.GetItemIdByName("Red Bomber"),
	MOTHERS_LOVE = Isaac.GetItemIdByName("Mother's Love"),
	CAT_IN_A_BOX = Isaac.GetItemIdByName("A Cat in the Box"),
	BOOK_OF_GENESIS = Isaac.GetItemIdByName("The Book of Genesis"),
	SCALPEL = Isaac.GetItemIdByName("A Scalpel"),
	KEEPERS_PENNY = Isaac.GetItemIdByName("Keeper's Penny"),
	NERVE_PINCH = Isaac.GetItemIdByName("Nerve Pinch"),
	BLOOD_VESSELS = {
		Isaac.GetItemIdByName("Blood Vessel"),
		Isaac.GetItemIdByName("Empty Blood Vessel"),
		Isaac.GetItemIdByName("Stained Blood Vessel"),
		Isaac.GetItemIdByName("Half Empty Blood Vessel"),
		Isaac.GetItemIdByName("Brimming Blood Vessel"),
		Isaac.GetItemIdByName("Full Blood Vessel"),
		Isaac.GetItemIdByName("Overflowing Blood Vessel")
	},
	SIBLING_RIVALRY = Isaac.GetItemIdByName("Sibling Rivalry"),
	RED_KING = Isaac.GetItemIdByName("Red King"),
	STARGAZERS_HAT = Isaac.GetItemIdByName("Stargazer's Hat"),
	BOTTOMLESS_BAG = Isaac.GetItemIdByName("Bottomless Bag"),
	BOTTOMLESS_BAG_OPENED = Isaac.GetItemIdByName("Opened Bottomless Bag"),
	CROSS_OF_CHAOS = Isaac.GetItemIdByName("The Cross of Chaos"),
	REJECTION = Isaac.GetItemIdByName("Rejection"),
	REJECTION_P = Isaac.GetItemIdByName("Rejection (passive)"),
	AUCTION_GAVEL = Isaac.GetItemIdByName("Auction Gavel"),
	SOUL_BOND = Isaac.GetItemIdByName("Soul Bond"),
	ANGELS_WINGS = Isaac.GetItemIdByName("Angel's Wings"),
	HAND_ME_DOWNS = Isaac.GetItemIdByName("Hand-Me-Downs"),
	VAULT_OF_HAVOC = Isaac.GetItemIdByName("Vault of Havoc"),
	FRIENDLY_SACK = Isaac.GetItemIdByName("Friendly Sack"),
	ULTRA_FLESH_KID = Isaac.GetItemIdByName("Ultra Flesh Kid!"),
	BOOK_OF_LEVIATHAN = Isaac.GetItemIdByName("Book of Leviathan"),
	BOOK_OF_LEVIATHAN_UNCHAINED = Isaac.GetItemIdByName("Unchained Book of Leviathan"),
	BOOK_OF_LEVIATHAN_OPEN = Isaac.GetItemIdByName("Open Book of Leviathan"),
	MAGIC_MARKER = Isaac.GetItemIdByName("Magic Marker"),
	PURE_SOUL = Isaac.GetItemIdByName("Pure Soul"),
	BOOK_OF_JUDGES = Isaac.GetItemIdByName("Book of Judges"),
	HANDICAPPED_PLACARD = Isaac.GetItemIdByName("Handicapped Placard"),
	BIRTH_CERTIFICATE = Isaac.GetItemIdByName("Birth Certificate"),
	-- EXTRAS
	HELICOPTER_BOYS = Isaac.GetItemIdByName("Helicopter Boys"),
	THE_HOOD = Isaac.GetItemIdByName("The Hood"),
	SPIRITUAL_AMENDS = Isaac.GetItemIdByName("Spiritual Amends"),
	BAG_OF_JEWELS = Isaac.GetItemIdByName("Bag of Jewels"),
	DEAD_WEIGHT = Isaac.GetItemIdByName("Dead Weight"),
	DEAD_WEIGHT_HELD_SKELETON = Isaac.GetItemIdByName("Dead Weight (Held Skeleton)"),
	KEEPERS_ANNOYING_FLY = Isaac.GetItemIdByName("Keeper's Annoying Fly"),
	WE_NEED_TO_GO_SIDEWAYS = Isaac.GetItemIdByName("We Need To Go Sideways"),

	-- NULLS
	LOADED_DICE_NULL = Isaac.GetItemIdByName("loaded dice"),
	APPLE_OF_PRIDE_NULL = Isaac.GetItemIdByName("apple of pride"),
	DEMON_FORM_NULL = Isaac.GetItemIdByName("demon form"),
	HEART_BENIGHTED_NULL = Isaac.GetItemIdByName("benighted hearts boost"),
	CROWN_OF_GREED_NULL = Isaac.GetItemIdByName("crown of greed"),
	CURSED_CARD_NULL = Isaac.GetItemIdByName("cursed card"),
	CHEESE_GRATER_NULL = Isaac.GetItemIdByName("cheese grater damage"),
	ORBITAL_GHOSTS = Isaac.GetItemIdByName("orbital ghosts"),
	HARLOT_FETUS = Isaac.GetItemIdByName("harlot fetus"),
	YUM_DAMAGE_NULL = Isaac.GetItemIdByName("yum damage"),
	YUM_TEARS_NULL = Isaac.GetItemIdByName("yum tears"),
	YUM_RANGE_NULL = Isaac.GetItemIdByName("yum range"),
	YUM_LUCK_NULL = Isaac.GetItemIdByName("yum luck"),
	YUM_SPEED_NULL = Isaac.GetItemIdByName("yum speed")
}
RepentancePlusMod.CustomCollectibles = CustomCollectibles

local BlacklistedCollectibles = {
	-- {moddedCollectible, vanillaCollectibles, replaceCollectibles}
	-- collectibles that don't go very well together, and here's why:

	-- no synergy
	{CustomCollectibles.RED_BOMBER, {CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR}, CollectibleType.COLLECTIBLE_BOMBER_BOY},

	-- no way to apply the effect correctly since pill colors and effects are mashed
	{CustomCollectibles.DNA_REDACTOR, {CollectibleType.COLLECTIBLE_PHD, CollectibleType.COLLECTIBLE_FALSE_PHD,
	CollectibleType.COLLECTIBLE_VIRGO, CollectibleType.COLLECTIBLE_LUCKY_FOOT}, CollectibleType.COLLECTIBLE_FORGET_ME_NOW},

	-- no synergy and no resprite for a sword
	{CustomCollectibles.CEREMONIAL_BLADE, {CollectibleType.COLLECTIBLE_SPIRIT_SWORD}, CollectibleType.COLLECTIBLE_BETRAYAL},

	-- pretty self explanatory, you can't rewind your mod's code with this lol
	{CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, {CustomCollectibles.SCALPEL,
	CustomCollectibles.CHEESE_GRATER, CustomCollectibles.BIRD_OF_HOPE}, CollectibleType.COLLECTIBLE_BROKEN_MODEM}
}

local PocketBlacklistedCollectibles = {
	CollectibleType.COLLECTIBLE_GLASS_CANNON,
	CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON,
	CollectibleType.COLLECTIBLE_D_INFINITY,
	CollectibleType.COLLECTIBLE_ERASER,
	CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
	CollectibleType.COLLECTIBLE_TELEKINESIS,
	CollectibleType.COLLECTIBLE_SPIN_TO_WIN,
	CollectibleType.COLLECTIBLE_DECAP_ATTACK,
	CollectibleType.COLLECTIBLE_PLACEBO,
	CollectibleType.COLLECTIBLE_BLANK_CARD,
	CollectibleType.COLLECTIBLE_CLEAR_RUNE,
	CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
	CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP,
	CollectibleType.COLLECTIBLE_VOID,
	CustomCollectibles.STARGAZERS_HAT,
}

local CustomTrinkets = {
	BASEMENT_KEY = Isaac.GetTrinketIdByName("Basement Key"),
	KEY_TO_THE_HEART = Isaac.GetTrinketIdByName("Key to the Heart"),
	TRICK_PENNY = Isaac.GetTrinketIdByName("Trick Penny"),
	JUDAS_KISS = Isaac.GetTrinketIdByName("Judas' Kiss"),
	SLEIGHT_OF_HAND = Isaac.GetTrinketIdByName("Sleight of Hand"),
	GREEDS_HEART = Isaac.GetTrinketIdByName("Greed's Heart"),
	ANGELS_CROWN = Isaac.GetTrinketIdByName("Angel's Crown"),
	PIECE_OF_CHALK = Isaac.GetTrinketIdByName("A Piece of Chalk"),
	MAGIC_SWORD = Isaac.GetTrinketIdByName("Magic Sword"),
	WAIT_NO = Isaac.GetTrinketIdByName("Wait, No!"),
	EDENS_LOCK = Isaac.GetTrinketIdByName("Eden's Lock"),
	ADAMS_RIB = Isaac.GetTrinketIdByName("Adam's Rib"),
	NIGHT_SOIL = Isaac.GetTrinketIdByName("Night Soil"),
	TORN_PAGE = Isaac.GetTrinketIdByName("Torn Page"),
	BONE_MEAL = Isaac.GetTrinketIdByName("Bone Meal"),
	EMPTY_PAGE = Isaac.GetTrinketIdByName("Empty Page"),
	BABY_SHOES = Isaac.GetTrinketIdByName("Baby Shoes"),
	KEY_KNIFE = Isaac.GetTrinketIdByName("Key Knife"),
	SHATTERED_STONE = Isaac.GetTrinketIdByName("Shattered Stone"),

	-- EXTRAS
	CRACKED_CROSS = Isaac.GetTrinketIdByName("Cracked Cross"),
	MY_SOUL = Isaac.GetTrinketIdByName("My Soul"),
	HEAVENLY_KEYS = Isaac.GetTrinketIdByName("Heavenly Keys"),
	JEWEL_DIADEM = Isaac.GetTrinketIdByName("Jewel Diadem")
}
RepentancePlusMod.CustomTrinkets = CustomTrinkets

local CustomConsumables = {
	JOKER_Q = Isaac.GetCardIdByName("Joker?"),
	SPINDOWN_DICE_SHARD = Isaac.GetCardIdByName("Spindown Dice Shard"),
	UNO_REVERSE_CARD = Isaac.GetCardIdByName("Reverse Card"),
	RED_RUNE = Isaac.GetCardIdByName("Red Rune"),
	KING_OF_SPADES = Isaac.GetCardIdByName("King of Spades"),
	KING_OF_CLUBS = Isaac.GetCardIdByName("King of Clubs"),
	KING_OF_DIAMONDS = Isaac.GetCardIdByName("King of Diamonds"),
	NEEDLE_AND_THREAD = Isaac.GetCardIdByName("Needle and Thread"),
	QUEEN_OF_DIAMONDS = Isaac.GetCardIdByName("Queen of Diamonds"),
	QUEEN_OF_CLUBS = Isaac.GetCardIdByName("Queen of Clubs"),
	BAG_TISSUE = Isaac.GetCardIdByName("Bag Tissue"),
	LOADED_DICE = Isaac.GetCardIdByName("Loaded Dice"),
	JACK_OF_DIAMONDS = Isaac.GetCardIdByName("Jack of Diamonds"),
	JACK_OF_CLUBS = Isaac.GetCardIdByName("Jack of Clubs"),
	JACK_OF_SPADES = Isaac.GetCardIdByName("Jack of Spades"),
	JACK_OF_HEARTS = Isaac.GetCardIdByName("Jack of Hearts"),
	BEDSIDE_QUEEN = Isaac.GetCardIdByName("Bedside Queen"),
	QUASAR_SHARD = Isaac.GetCardIdByName("Quasar Shard"),
	BUSINESS_CARD = Isaac.GetCardIdByName("Business Card"),
	SACRIFICIAL_BLOOD = Isaac.GetCardIdByName("Sacrificial Blood"),
	FLY_PAPER = Isaac.GetCardIdByName("Flypaper"),
	LIBRARY_CARD = Isaac.GetCardIdByName("Library Card"),
	MOMS_ID = Isaac.GetCardIdByName("Mom's ID"),
	FUNERAL_SERVICES = Isaac.GetCardIdByName("Funeral Services"),
	ANTIMATERIAL_CARD = Isaac.GetCardIdByName("Antimaterial Card"),
	FIEND_FIRE = Isaac.GetCardIdByName("Fiend Fire"),
	DEMON_FORM = Isaac.GetCardIdByName("Demon Form"),
	VALENTINES_CARD = Isaac.GetCardIdByName("Valentine's Card"),
	SPIRITUAL_RESERVES = Isaac.GetCardIdByName("Spiritual Reserves"),
	MIRRORED_LANDSCAPE = Isaac.GetCardIdByName("Mirrored Landscape"),
	CURSED_CARD = Isaac.GetCardIdByName("Cursed Card"),
	-- Sin's Jewels
	CANINE_OF_WRATH = Isaac.GetCardIdByName("Canine of Wrath"),
	CROWN_OF_GREED = Isaac.GetCardIdByName("Crown of Greed"),
	FLOWER_OF_LUST = Isaac.GetCardIdByName("Flower of Lust"),
	MASK_OF_ENVY = Isaac.GetCardIdByName("Mask of Envy"),
	APPLE_OF_PRIDE = Isaac.GetCardIdByName("Apple of Pride"),
	VOID_OF_GLUTTONY = Isaac.GetCardIdByName("Void of Gluttony"),
	ACID_OF_SLOTH = Isaac.GetCardIdByName("Acid of Sloth"),

	-- EXTRAS
	DARK_REMNANTS = Isaac.GetCardIdByName("Dark Remnants"),
	FUNERAL_SERVICES_Q = Isaac.GetCardIdByName("Funeral Services?")
}
RepentancePlusMod.CustomConsumables = CustomConsumables

-- extras: Jewel Crawler - enemy
local Enemies = {
	JEWEL_CRAWLER = {
		Type = Isaac.GetEntityTypeByName("Jewel Crawler (Random)"),
		Variants = {
		},
		SubTypes = {
			CustomConsumables.CANINE_OF_WRATH,
			CustomConsumables.CROWN_OF_GREED,
			CustomConsumables.FLOWER_OF_LUST,
			CustomConsumables.MASK_OF_ENVY,
			CustomConsumables.APPLE_OF_PRIDE,
			CustomConsumables.VOID_OF_GLUTTONY,
			CustomConsumables.ACID_OF_SLOTH
		},
		Sprites = {
			"canine_of_wrath",
			"crown_of_greed",
			"flower_of_lust",
			"mask_of_envy",
			"apple_of_pride",
			"void_of_gluttony",
			"acid_of_sloth"
		}
	}
}

local CustomSounds = {
	CANINE_OF_WRATH = Isaac.GetSoundIdByName("Canine of Wrath"),
	CROWN_OF_GREED = Isaac.GetSoundIdByName("Crown of Greed"),
	FLOWER_OF_LUST = Isaac.GetSoundIdByName("Flower of Lust"),
	MASK_OF_ENVY = Isaac.GetSoundIdByName("Mask of Envy"),
	APPLE_OF_PRIDE = Isaac.GetSoundIdByName("Apple of Pride"),
	VOID_OF_GLUTTONY = Isaac.GetSoundIdByName("Void of Gluttony"),
	ACID_OF_SLOTH = Isaac.GetSoundIdByName("Acid of Sloth"),
	--
	PILL_YUM = Isaac.GetSoundIdByName("Yum"),
	PILL_YUCK = Isaac.GetSoundIdByName("Yuck"),
	PILL_PHANTOM_PAINS = Isaac.GetSoundIdByName("Phantom Pains"),
	PILL_LAXATIVE = Isaac.GetSoundIdByName("Laxative"),
	PILL_ESTROGEN_UP = Isaac.GetSoundIdByName("Estrogen Up"),
	PILL_SUPPOSITORY = Isaac.GetSoundIdByName("Suppository"),
	PILL_YUM_HORSE = Isaac.GetSoundIdByName("Horse Yum"),
	PILL_YUCK_HORSE = Isaac.GetSoundIdByName("Horse Yuck"),
	PILL_PHANTOM_PAINS_HORSE = Isaac.GetSoundIdByName("Horse Phantom Pains"),
	PILL_LAXATIVE_HORSE = Isaac.GetSoundIdByName("Horse Laxative"),
	PILL_ESTROGEN_UP_HORSE = Isaac.GetSoundIdByName("Horse Estrogen Up"),
	PILL_SUPPOSITORY_HORSE = Isaac.GetSoundIdByName("Horse Suppository"),
	--
	BAG_TISSUE = Isaac.GetSoundIdByName("Bag Tissue"),
	LOADED_DICE = Isaac.GetSoundIdByName("Loaded Dice"),
	NEEDLE_AND_THREAD = Isaac.GetSoundIdByName("Needle and Thread"),
	QUASAR_SHARD = Isaac.GetSoundIdByName("Quasar Shard"),
	RED_RUNE = Isaac.GetSoundIdByName("Red Rune"),
	SACRIFICIAL_BLOOD = Isaac.GetSoundIdByName("Sacrificial Blood"),
	SPINDOWN_DICE_SHARD = Isaac.GetSoundIdByName("Spindown Dice Shard"),
	DARK_REMNANTS = Isaac.GetSoundIdByName("Dark Remnants"),
	--
	JOKER_Q = Isaac.GetSoundIdByName("Joker?"),
	KING_OF_SPADES = Isaac.GetSoundIdByName("King of Spades"),
	KING_OF_CLUBS = Isaac.GetSoundIdByName("King of Clubs"),
	KING_OF_DIAMONDS = Isaac.GetSoundIdByName("King of Diamonds"),
	JACK_OF_SPADES = Isaac.GetSoundIdByName("Jack of Spades"),
	JACK_OF_CLUBS = Isaac.GetSoundIdByName("Jack of Clubs"),
	JACK_OF_HEARTS = Isaac.GetSoundIdByName("Jack of Hearts"),
	JACK_OF_DIAMONDS = Isaac.GetSoundIdByName("Jack of Diamonds"),
	QUEEN_OF_DIAMONDS = Isaac.GetSoundIdByName("Queen of Diamonds"),
	QUEEN_OF_CLUBS = Isaac.GetSoundIdByName("Queen of Clubs"),
	BEDSIDE_QUEEN = Isaac.GetSoundIdByName("Bedside Queen"),
	--
	BUSINESS_CARD = Isaac.GetSoundIdByName("Business Card"),
	UNO_REVERSE_CARD = Isaac.GetSoundIdByName("Reverse Card"),
	FLY_PAPER = Isaac.GetSoundIdByName("Flypaper"),
	LIBRARY_CARD = Isaac.GetSoundIdByName("Library Card"),
	MOMS_ID = Isaac.GetSoundIdByName("Mom's ID"),
	FUNERAL_SERVICES = Isaac.GetSoundIdByName("Funeral Services"),
	FUNERAL_SERVICES_Q = Isaac.GetSoundIdByName("Funeral Services?"),
	ANTIMATERIAL_CARD = Isaac.GetSoundIdByName("Antimaterial Card"),
	FIEND_FIRE = Isaac.GetSoundIdByName("Fiend Fire"),
	DEMON_FORM = Isaac.GetSoundIdByName("Demon Form"),
	VALENTINES_CARD = Isaac.GetSoundIdByName("Valentine's Card"),
	SPIRITUAL_RESERVES = Isaac.GetSoundIdByName("Spiritual Reserves"),
	MIRRORED_LANDSCAPE = Isaac.GetSoundIdByName("Mirrored Landscape"),
	CURSED_CARD = Isaac.GetSoundIdByName("Cursed Card")
}
RepentancePlusMod.CustomSounds = CustomSounds

local delayedSounds = {}
local SoundDelays = {
	[CustomSounds.CANINE_OF_WRATH] = 45,
	[CustomSounds.CROWN_OF_GREED] = 60,
	[CustomSounds.FLOWER_OF_LUST] = 30,
	--
	[CustomSounds.PILL_YUM] = 45,
	[CustomSounds.PILL_YUCK] = 45,
	[CustomSounds.PILL_PHANTOM_PAINS] = 60,
	[CustomSounds.PILL_ESTROGEN_UP] = 30,
	[CustomSounds.PILL_LAXATIVE] = 60,
	[CustomSounds.PILL_YUM_HORSE] = 45,
	[CustomSounds.PILL_YUCK_HORSE] = 45,
	[CustomSounds.PILL_PHANTOM_PAINS_HORSE] = 60,
	[CustomSounds.PILL_ESTROGEN_UP_HORSE] = 30,
	[CustomSounds.PILL_LAXATIVE_HORSE] = 120,
	--
	[CustomSounds.QUASAR_SHARD] = 45,
	[CustomSounds.SACRIFICIAL_BLOOD] = 30,
	--
	[CustomSounds.JOKER_Q] = 30,
	[CustomSounds.KING_OF_SPADES] = 60,
	--
	[CustomSounds.UNO_REVERSE_CARD] = 45,
	[CustomSounds.FUNERAL_SERVICES] = 30,
	[CustomSounds.FUNERAL_SERVICES_Q] = 30,
	[CustomSounds.FIEND_FIRE] = 60,
	[CustomSounds.VALENTINES_CARD] = 30,
	[CustomSounds.CURSED_CARD] = 30,
	[CustomSounds.LIBRARY_CARD] = 30
}

local CustomPickups = {
	FLESH_CHEST = Isaac.GetEntityVariantByName("Flesh Chest"),
	SCARLET_CHEST = Isaac.GetEntityVariantByName("Scarlet Chest"),
	BLACK_CHEST = Isaac.GetEntityVariantByName("Black Chest"),
	COFFIN = Isaac.GetEntityVariantByName("Coffin"),
	TaintedHearts = {
		HEART_BROKEN  = 84,
		HEART_DAUNTLESS = 85,
		HEART_HOARDED  = 86,
		HEART_DECEIVER = 87,
		HEART_SOILED = 88,
		HEART_CURDLED = 89,
		HEART_SAVAGE = 90,
		HEART_BENIGHTED  = 91,
		HEART_ENIGMA  = 92,
		HEART_CAPRICIOUS  = 93,
		HEART_BALEFUL = 94,
		HEART_HARLOT = 95,
		HEART_MISER = 96,
		HEART_EMPTY = 97,
		HEART_FETTERED  = 98,
		HEART_ZEALOT = 99,
		HEART_DESERTED  = 100,
		HEART_DAUNTLESS_HALF = 101
	},
	WHITE_SACK = 7,
	STOMACK = 8,
	HEARTTERY_RED = 51,
	HEARTTERY_SOUL = 52
}
RepentancePlusMod.CustomPickups = CustomPickups

local CustomSlots = {
	SLOT_STARGAZER = Isaac.GetEntityVariantByName("Stargazer"),
	SLOT_RED_KING_CRAWLSPACE = Isaac.GetEntityVariantByName("Red Trapdoor")
}
RepentancePlusMod.CustomSlots = CustomSlots

local CustomPills = {
	ESTROGEN_UP = Isaac.GetPillEffectByName("Estrogen Up"),
	LAXATIVE = Isaac.GetPillEffectByName("Laxative"),
	PHANTOM_PAINS = Isaac.GetPillEffectByName("Phantom Pains"),
	YUM = Isaac.GetPillEffectByName("Yum!"),
	YUCK = Isaac.GetPillEffectByName("Yuck!"),
	SUPPOSITORY = Isaac.GetPillEffectByName("Suppository")
}
RepentancePlusMod.CustomPills = CustomPills

local pillCounterparts = {
	-- Ph.D., Lucky Foot and Virgo
	POSITIVE = {
		-- misc
		[PillEffect.PILLEFFECT_AMNESIA] = PillEffect.PILLEFFECT_SEE_FOREVER,
		[PillEffect.PILLEFFECT_QUESTIONMARK] = PillEffect.PILLEFFECT_TELEPILLS,
		[PillEffect.PILLEFFECT_ADDICTED] = PillEffect.PILLEFFECT_PERCS,
		[PillEffect.PILLEFFECT_IM_EXCITED] = PillEffect.PILLEFFECT_IM_DROWSY,
		[PillEffect.PILLEFFECT_PARALYSIS] = PillEffect.PILLEFFECT_PHEROMONES,
		[PillEffect.PILLEFFECT_RETRO_VISION] = PillEffect.PILLEFFECT_SEE_FOREVER,
		[PillEffect.PILLEFFECT_WIZARD] = PillEffect.PILLEFFECT_POWER,
		[PillEffect.PILLEFFECT_X_LAX] = PillEffect.PILLEFFECT_SOMETHINGS_WRONG,
		[PillEffect.PILLEFFECT_BAD_TRIP] = PillEffect.PILLEFFECT_BALLS_OF_STEEL,
		-- stats
		[PillEffect.PILLEFFECT_HEALTH_DOWN] = PillEffect.PILLEFFECT_HEALTH_UP,
		[PillEffect.PILLEFFECT_RANGE_DOWN] = PillEffect.PILLEFFECT_RANGE_UP,
		[PillEffect.PILLEFFECT_SPEED_DOWN] = PillEffect.PILLEFFECT_SPEED_UP,
		[PillEffect.PILLEFFECT_TEARS_DOWN] = PillEffect.PILLEFFECT_TEARS_UP,
		[PillEffect.PILLEFFECT_LUCK_DOWN] = PillEffect.PILLEFFECT_LUCK_UP,
		[PillEffect.PILLEFFECT_SHOT_SPEED_DOWN] = PillEffect.PILLEFFECT_SHOT_SPEED_UP,
		-- custom
		[CustomPills.PHANTOM_PAINS] = PillEffect.PILLEFFECT_FULL_HEALTH
	},
	-- False Ph.D.
	NEGATIVE = {
		-- misc
		[PillEffect.PILLEFFECT_BAD_GAS] = PillEffect.PILLEFFECT_HEALTH_DOWN,
		[PillEffect.PILLEFFECT_FRIENDS_TILL_THE_END] = PillEffect.PILLEFFECT_HEALTH_DOWN,
		[PillEffect.PILLEFFECT_SEE_FOREVER] = PillEffect.PILLEFFECT_AMNESIA,
		[PillEffect.PILLEFFECT_LEMON_PARTY] = PillEffect.PILLEFFECT_AMNESIA,
		[PillEffect.PILLEFFECT_EXPLOSIVE_DIARRHEA] = PillEffect.PILLEFFECT_RANGE_DOWN,
		[PillEffect.PILLEFFECT_LARGER] = PillEffect.PILLEFFECT_RANGE_DOWN,
		[PillEffect.PILLEFFECT_BOMBS_ARE_KEYS] = PillEffect.PILLEFFECT_TEARS_DOWN,
		[PillEffect.PILLEFFECT_INFESTED_EXCLAMATION] = PillEffect.PILLEFFECT_TEARS_DOWN,
		[PillEffect.PILLEFFECT_48HOUR_ENERGY] = PillEffect.PILLEFFECT_SPEED_DOWN,
		[PillEffect.PILLEFFECT_SMALLER] = PillEffect.PILLEFFECT_SPEED_DOWN,
		[PillEffect.PILLEFFECT_INFESTED_QUESTION] = PillEffect.PILLEFFECT_LUCK_DOWN,
		[PillEffect.PILLEFFECT_PRETTY_FLY] = PillEffect.PILLEFFECT_LUCK_DOWN,
		[PillEffect.PILLEFFECT_BALLS_OF_STEEL] = PillEffect.PILLEFFECT_BAD_TRIP,
		[PillEffect.PILLEFFECT_FULL_HEALTH] = PillEffect.PILLEFFECT_BAD_TRIP,
		[PillEffect.PILLEFFECT_HEMATEMESIS] = PillEffect.PILLEFFECT_BAD_TRIP,
		[PillEffect.PILLEFFECT_PHEROMONES] = PillEffect.PILLEFFECT_PARALYSIS,
		[PillEffect.PILLEFFECT_TELEPILLS] = PillEffect.PILLEFFECT_QUESTIONMARK,
		[PillEffect.PILLEFFECT_IM_DROWSY] = PillEffect.PILLEFFECT_IM_EXCITED,
		[PillEffect.PILLEFFECT_PERCS] = PillEffect.PILLEFFECT_ADDICTED,
		[PillEffect.PILLEFFECT_SUNSHINE] = PillEffect.PILLEFFECT_RETRO_VISION,
		[PillEffect.PILLEFFECT_POWER] = PillEffect.PILLEFFECT_WIZARD,
		[PillEffect.PILLEFFECT_SOMETHINGS_WRONG] = PillEffect.PILLEFFECT_X_LAX,
		[PillEffect.PILLEFFECT_GULP] = PillEffect.PILLEFFECT_HORF,
		[PillEffect.PILLEFFECT_VURP] = PillEffect.PILLEFFECT_HORF,
		-- stats
		[PillEffect.PILLEFFECT_HEALTH_UP] = PillEffect.PILLEFFECT_HEALTH_DOWN,
		[PillEffect.PILLEFFECT_RANGE_UP] = PillEffect.PILLEFFECT_RANGE_DOWN,
		[PillEffect.PILLEFFECT_SPEED_UP] = PillEffect.PILLEFFECT_SPEED_DOWN,
		[PillEffect.PILLEFFECT_TEARS_UP] = PillEffect.PILLEFFECT_TEARS_DOWN,
		[PillEffect.PILLEFFECT_LUCK_UP] = PillEffect.PILLEFFECT_LUCK_DOWN,
		[PillEffect.PILLEFFECT_SHOT_SPEED_UP] = PillEffect.PILLEFFECT_SHOT_SPEED_DOWN,
		-- custom
		[CustomPills.ESTROGEN_UP] = PillEffect.PILLEFFECT_ADDICTED,
		[CustomPills.YUM] = PillEffect.PILLEFFECT_ADDICTED,
		[CustomPills.YUCK] = PillEffect.PILLEFFECT_ADDICTED
	},
	LOCKED = {
		[CustomPills.ESTROGEN_UP] = PillEffect.PILLEFFECT_PHEROMONES,
		[CustomPills.LAXATIVE] = PillEffect.PILLEFFECT_BAD_GAS,
		[CustomPills.PHANTOM_PAINS] = PillEffect.PILLEFFECT_PARALYSIS,
		[CustomPills.YUM] = PillEffect.PILLEFFECT_EXPERIMENTAL,
		[CustomPills.YUCK] = PillEffect.PILLEFFECT_EXPERIMENTAL,
		[CustomPills.SUPPOSITORY] = PillEffect.PILLEFFECT_BAD_GAS
	}
}
local antiPillCheckRecursion = false

local CustomItempools = {
	FLESH_CHEST = {
		15, -- <3
		16, -- Raw Liver
		36, -- Poop
		45, -- Yum Heart
		46, -- Lucky Foot
		55,	-- Mom's Eye
		73, -- Cube of Meat
		103, -- Common Cold
		155, -- The Peeper
		157, -- Bloody Lust
		176, -- Stem Cells
		218, -- Placenta
		253, -- Magic Scab
		254, -- Blood Clot
		273, -- Bob's Brain
		276, -- Isaac's Heart
		319, -- Cain's Other Eye
		440, -- Kidney Stone
		446, -- Dead Tooth
		452, -- Varicose Veins
		453, -- Compound Fracture
		454, -- Polydactyly
		458, -- Belly Button
		460, -- Glaucoma
		467, -- Finger
		502, -- Large Zit
		509, -- Bloodshot Eye
		525, -- Leprosy
		529, -- Pop!
		531, -- Haemolacria
		541, -- Marrow
		542, -- Slipped Rib
		544, -- Pointy Rib
		548, -- Jaw Bone
		549, -- Brittle Bones
		558, -- Eye Sore
		611, -- Larynx
		639, -- Yuck Heart
		641, -- Akeldama
		642, -- Magic Skin
		657, -- Vasculitis
		658, -- Giant Cell
		676, -- Empty Heart
		680, -- Montezuma's Revenge
		683, -- Bone Spurs
		695, -- Bloody Gust
		725, -- IBS
		729, -- Decap Attack
		731  -- Stye
	},
	FLESH_CHEST_TRINKETS = {
		TrinketType.TRINKET_PINKY_EYE,
		TrinketType.TRINKET_UMBILICAL_CORD,
		TrinketType.TRINKET_CHILDS_HEART,
		TrinketType.TRINKET_CANCER,
		TrinketType.TRINKET_LUCKY_TOE,
		TrinketType.TRINKET_ISAACS_HEAD,
		TrinketType.TRINKET_JUDAS_TONGUE,
		TrinketType.TRINKET_CAINS_EYE,
		TrinketType.TRINKET_LEFT_HAND,
		TrinketType.TRINKET_TONSIL,
		TrinketType.TRINKET_NOSE_GOBLIN,
		TrinketType.TRINKET_STEM_CELL,
		TrinketType.TRINKET_PETRIFIED_POOP,
		TrinketType.TRINKET_CALLUS,
		TrinketType.TRINKET_MECONIUM,
		TrinketType.TRINKET_FINGER_BONE,
		TrinketType.TRINKET_BLISTER
	},
	MOM_AND_DAD = {
		175, -- Dad's Key
		102, -- Mom's Bottle of Pills
		439, -- Mom's Box
		604, -- Mom's Bracelet
		455, -- Dad's Lost Coin
		547, -- Divorce Papers
		195, -- Mom's Coin Purse
		110, -- Mom's Contacts
		55,  -- Mom's Eye
		199, -- Mom's Key
		355, -- Mom's Pearls
		228, -- Mom's Perfume
		139, -- Mom's Purse
		217, -- Mom's Wig
		546, -- Dad's Ring
		732  -- Mom's Ring (added in v1.7.5 patch)
	},
	-- not technically an itempool, but still useful
	EMPTY_PAGE_ACTIVES = {
		130, -- pony
		136, -- best friends
		42,	 -- bob's head
		288, -- box of spiders
		160, -- crack the sky
		158, -- crystal ball
		166, -- D20
		175, -- dad's key
		85,  -- deck of cards
		291, -- flush
		145, -- guppy's head
		293, -- head of krampus
		102, -- bottle of pills
		39,  -- bra
		41,  -- pad
		37,  -- mr. boom
		77,  -- my little unicorn
		146, -- prayer card
		49,  -- shoop
		171, -- spider butt
		38,  -- tammy's head
		93,  -- gamekid
		66,  -- hourglass
		83,  -- nail
		107, -- pinking shears
		181, -- white pony
		45,  -- yum heart
		357, -- box of friends
		347, -- diplopia
		422, -- glowing hourglass
		439, -- mom's box
		521, -- coupon
		476, -- D1
		479, -- smelter
		516, -- sprinkler
		722, -- anima sola
		557, -- fortune cookie
		687, -- friend finder
		719, -- keeper's box
		650, -- plum flute
		556, -- sulfur
		605, -- the scooper
		638  -- yuck heart
	},
	COFFIN = {
		CollectibleType.COLLECTIBLE_DRY_BABY,
		CollectibleType.COLLECTIBLE_DOG_TOOTH,
		CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
		CollectibleType.COLLECTIBLE_MARROW,
		CollectibleType.COLLECTIBLE_SLIPPED_RIB,
		CollectibleType.COLLECTIBLE_POINTY_RIB,
		CollectibleType.COLLECTIBLE_JAW_BONE,
		CollectibleType.COLLECTIBLE_BRITTLE_BONES,
		CollectibleType.COLLECTIBLE_BONE_SPURS,
		CollectibleType.COLLECTIBLE_BERSERK,
		CollectibleType.COLLECTIBLE_SKELETON_KEY,
		CollectibleType.COLLECTIBLE_HOST_HAT
	}
}
RepentancePlusMod.CustomItempools = CustomItempools

local DropTables = {
	BLACK_CHEST = {
		{40, {{PickupVariant.PICKUP_GRAB_BAG, 2}}},
		{65, {{PickupVariant.PICKUP_TAROTCARD, 0}}},
		{85, {{PickupVariant.PICKUP_GRAB_BAG, 2}, {300, CustomConsumables.SPINDOWN_DICE_SHARD}}},
		{100, {{PickupVariant.PICKUP_GRAB_BAG, 2}, {300, Card.RUNE_BLACK}}}
	},
	TAINTED_ROCKS = {
		{10, {{300, Card.CARD_CRACKED_KEY}, {300, CustomConsumables.RED_RUNE}}},
		{30, {{300, CustomConsumables.RED_RUNE}, {10, HeartSubType.HEART_FULL}}},
		{50, {{10, HeartSubType.HEART_FULL}, {10, HeartSubType.HEART_FULL}}},
		{100, {{10, HeartSubType.HEART_FULL}, {300, Card.CARD_CRACKED_KEY}}},
	},
	WHITE_SACK = {
		{10, {{PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_KEY, 0}}},
		{20, {{PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_KEY, 0}}},
		{30, {{PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_TAROTCARD, 0}, {PickupVariant.PICKUP_TAROTCARD, 0}}},
		{40, {{PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_TAROTCARD, 0}}},
		{50, {{PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_TAROTCARD, 0}}},
		{60, {{10, HeartSubType.HEART_HALF_SOUL}, {PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_TAROTCARD, 0}}},
		{70, {{10, HeartSubType.HEART_HALF_SOUL}, {PickupVariant.PICKUP_KEY, 0}}},
		{80, {{10, HeartSubType.HEART_HALF_SOUL}, {PickupVariant.PICKUP_TAROTCARD, 0}}},
		{90, {{10, HeartSubType.HEART_ETERNAL}, {PickupVariant.PICKUP_KEY, 0}}},
		{95, {{10, HeartSubType.HEART_ETERNAL}, {PickupVariant.PICKUP_TAROTCARD, 0}}},
		{100, {{10, HeartSubType.HEART_ETERNAL}, {PickupVariant.PICKUP_KEY, 0}, {PickupVariant.PICKUP_TAROTCARD, 0}}}
	},
	STOMACK = {
		{10, {{PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_PILL, 0}}},
		{30, {{PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_PILL, 0}}},
		{45, {{PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}}},
		{60, {{PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN}}},
		{70, {{PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE}}},
		{80, {{PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE}}},
		{90, {{PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE}}},
		{95, {{PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}}},
		{100, {{PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_PILL, 0}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN}}},
	}
}

local CustomStatups = {
	Damage = {
		SINNERS_HEART_ADD = 2,
		SINNERS_HEART_MUL = 1.5,
		MAGIC_SWORD_MUL = 2,
		CHEESE_GRATER_MUL = 1.07,
		BLESS_OF_THE_DEAD_MUL = 1.15,
		PILL_YUM = 0.05,
		BONE_MEAL_MUL = 1.1,
		MOTHERS_LOVE = 0.2,
		DEMON_FORM = 0.1,
		APPLE_OF_PRIDE_MUL = 1.25,
		--
		DMG_TEMPORARY = 1.25
	},
	Luck = {
		LOADED_DICE = 10,
		PILL_YUM = 0.08,
		MOTHERS_LOVE = 0.2,
		APPLE_OF_PRIDE = 2
	},
	Tears = {
		ORDINARY_LIFE_MUL = 0.8,
		GUSTY_BLOOD = 0.16,
		PILL_YUM = 0.05,
		MOTHERS_LOVE = 0.1,
		CURSED_CARD = 0.17,
		APPLE_OF_PRIDE_MUL = 0.85
	},
	Speed = {
		GUSTY_BLOOD = 0.07,
		MOTHERS_LOVE = 0.05,
		NERVE_PINCH = -0.03,
		HAND_ME_DOWNS = 0.2,
		APPLE_OF_PRIDE = 0.3,
		PILL_YUM = 0.05
	},
	Range = {
		SINNERS_HEART = 2,
		PILL_YUM = 0.09,
		MOTHERS_LOVE = 0.25,
		APPLE_OF_PRIDE = 1.5
	},
	ShotSpeed = {
		SINNERS_HEART = -0.2,
		ANGELS_WINGS = 0.3
	},
}
RepentancePlusMod.CustomStatups = CustomStatups

local CustomChallenges = {
	THE_COMMANDER = Isaac.GetChallengeIdByName("The Commander"),
	JUDGEMENT = Isaac.GetChallengeIdByName("Judgement"),
	BLOOD = Isaac.GetChallengeIdByName("The Sacrifice"),
	IN_THE_LIGHT = Isaac.GetChallengeIdByName("Living in the Light")
}
RepentancePlusMod.CustomChallenges = CustomChallenges

-- used by Bag Tissue and Shattered Stone
local PickupWeights = {
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
		[HeartSubType.HEART_ROTTEN] = 5,
		[CustomPickups.TaintedHearts.HEART_BROKEN] = 6,
		[CustomPickups.TaintedHearts.HEART_HOARDED] = 4,
		[CustomPickups.TaintedHearts.HEART_BENIGHTED] = 6,
		[CustomPickups.TaintedHearts.HEART_CAPRICIOUS] = 6,
		[CustomPickups.TaintedHearts.HEART_ENIGMA] = 6,
		[CustomPickups.TaintedHearts.HEART_EMPTY] = 7,
		[CustomPickups.TaintedHearts.HEART_FETTERED] = 5,
		[CustomPickups.TaintedHearts.HEART_ZEALOT] = 7,
		[CustomPickups.TaintedHearts.HEART_DESERTED] = 4,
		[CustomPickups.TaintedHearts.HEART_DECEIVER] = 2,
		[CustomPickups.TaintedHearts.HEART_DAUNTLESS] = 6,
		[CustomPickups.TaintedHearts.HEART_SOILED] = 4,
		[CustomPickups.TaintedHearts.HEART_MISER] = 6,
		[CustomPickups.TaintedHearts.HEART_HARLOT] = 3,
		[CustomPickups.TaintedHearts.HEART_BALEFUL] = 5,
		[CustomPickups.TaintedHearts.HEART_CURDLED] = 4,
		[CustomPickups.TaintedHearts.HEART_SAVAGE] = 3
	},
	[PickupVariant.PICKUP_COIN] = {
		[CoinSubType.COIN_PENNY] = 1,
		[CoinSubType.COIN_NICKEL] = 3,
		[CoinSubType.COIN_DIME] = 5,
		[CoinSubType.COIN_DOUBLEPACK] = 2,
		[CoinSubType.COIN_LUCKYPENNY] = 7,
		[CoinSubType.COIN_GOLDEN] = 5
	},
	[PickupVariant.PICKUP_KEY] = {
		[KeySubType.KEY_NORMAL] = 1,
		[KeySubType.KEY_GOLDEN] = 5,
		[KeySubType.KEY_DOUBLEPACK] = 3,
		[KeySubType.KEY_CHARGED] = 5
	},
	[PickupVariant.PICKUP_BOMB] = {
		[BombSubType.BOMB_NORMAL] = 1,
		[BombSubType.BOMB_DOUBLEPACK] = 2,
		[BombSubType.BOMB_GOLDEN] = 5
	},
	[PickupVariant.PICKUP_LIL_BATTERY] = {
		[BatterySubType.BATTERY_NORMAL] = 4,
		[BatterySubType.BATTERY_MICRO] = 2,
		[BatterySubType.BATTERY_MEGA] = 8,
		[BatterySubType.BATTERY_GOLDEN] = 5
	}
}

local MothersLoveMultipliers = {
	[FamiliarVariant.BROTHER_BOBBY] = 1,
	[FamiliarVariant.DEMON_BABY] = 1,
	[FamiliarVariant.LITTLE_CHUBBY] = 1,
	[FamiliarVariant.LITTLE_GISH] = 1,
	[FamiliarVariant.LITTLE_STEVEN] = 1,
	[FamiliarVariant.ROBO_BABY] = 1,
	[FamiliarVariant.SISTER_MAGGY] = 1,
	[FamiliarVariant.ABEL] = 1,
	[FamiliarVariant.GHOST_BABY] = 1,
	[FamiliarVariant.HARLEQUIN_BABY] = 1,
	[FamiliarVariant.RAINBOW_BABY] = 1,
	[FamiliarVariant.DADDY_LONGLEGS] = 1,
	[FamiliarVariant.PEEPER] = 1,
	[FamiliarVariant.BOMB_BAG] = 1,
	[FamiliarVariant.SACK_OF_PENNIES] = 1,
	[FamiliarVariant.LITTLE_CHAD] = 1,
	[FamiliarVariant.RELIC] = 1.25,
	[FamiliarVariant.BUM_FRIEND] = 1,
	[FamiliarVariant.HOLY_WATER] = 1,
	[FamiliarVariant.FOREVER_ALONE] = 1,
	[FamiliarVariant.DISTANT_ADMIRATION] = 1,
	[FamiliarVariant.GUARDIAN_ANGEL] = 1,
	[FamiliarVariant.SACRIFICIAL_DAGGER] = 1,
	[FamiliarVariant.DEAD_CAT] = 1,
	[FamiliarVariant.ONE_UP] = 1.25,
	[FamiliarVariant.GUPPYS_HAIRBALL] = 1,
	[FamiliarVariant.CUBE_OF_MEAT_1] = 1,
	[FamiliarVariant.CUBE_OF_MEAT_2] = 1.25,
	[FamiliarVariant.CUBE_OF_MEAT_3] = 1.5,
	[FamiliarVariant.CUBE_OF_MEAT_4] = 1.75,
	[FamiliarVariant.SMART_FLY] = 1,
	[FamiliarVariant.DRY_BABY] = 1.25,
	[FamiliarVariant.JUICY_SACK] = 1,
	[FamiliarVariant.ROBO_BABY_2] = 1,
	[FamiliarVariant.ROTTEN_BABY] = 1,
	[FamiliarVariant.HEADLESS_BABY] = 1,
	[FamiliarVariant.LEECH] = 1,
	[FamiliarVariant.MYSTERY_SACK] = 1,
	[FamiliarVariant.BBF] = 1,
	[FamiliarVariant.BOBS_BRAIN] = 1,
	[FamiliarVariant.BEST_BUD] = 1,
	[FamiliarVariant.LIL_BRIMSTONE] = 1.25,
	[FamiliarVariant.ISAACS_HEART] = 2,
	[FamiliarVariant.LIL_HAUNT] = 1,
	[FamiliarVariant.DARK_BUM] = 1.25,
	[FamiliarVariant.BIG_FAN] = 1,
	[FamiliarVariant.SISSY_LONGLEGS] = 1,
	[FamiliarVariant.PUNCHING_BAG] = 1,
	[FamiliarVariant.BALL_OF_BANDAGES_1] = 1,
	[FamiliarVariant.BALL_OF_BANDAGES_2] = 1.25,
	[FamiliarVariant.BALL_OF_BANDAGES_3] = 1.5,
	[FamiliarVariant.BALL_OF_BANDAGES_4] = 1.75,
	[FamiliarVariant.MONGO_BABY] = 1.25,
	[FamiliarVariant.SAMSONS_CHAINS] = 1,
	[FamiliarVariant.CAINS_OTHER_EYE] = 1,
	[FamiliarVariant.BLUEBABYS_ONLY_FRIEND] = 1,
	[FamiliarVariant.GEMINI] = 1,
	[FamiliarVariant.INCUBUS] = 1.25,
	[FamiliarVariant.FATES_REWARD] = 1,
	[FamiliarVariant.LIL_CHEST] = 1,
	[FamiliarVariant.SWORN_PROTECTOR] = 1,
	[FamiliarVariant.FRIEND_ZONE] = 1,
	[FamiliarVariant.LOST_FLY] = 1,
	[FamiliarVariant.CHARGED_BABY] = 1,
	[FamiliarVariant.LIL_GURDY] = 1,
	[FamiliarVariant.BUMBO] = 1,
	[FamiliarVariant.CENSER] = 1,
	[FamiliarVariant.KEY_BUM] = 1,
	[FamiliarVariant.RUNE_BAG] = 1.25,
	[FamiliarVariant.SERAPHIM] = 1.25,
	[FamiliarVariant.GB_BUG] = math.random(75, 125) / 100,	-- like, glitch reference, get it guys?..
	[FamiliarVariant.SPIDER_MOD] = 1,
	[FamiliarVariant.FARTING_BABY] = 1,
	[FamiliarVariant.SUCCUBUS] = 1.25,
	[FamiliarVariant.LIL_LOKI] = 1,
	[FamiliarVariant.OBSESSED_FAN] = 1,
	[FamiliarVariant.PAPA_FLY] = 1,
	[FamiliarVariant.MILK] = 1,
	[FamiliarVariant.MULTIDIMENSIONAL_BABY] = 1,
	[FamiliarVariant.SUPER_BUM] = 3,
	[FamiliarVariant.BIG_CHUBBY] = 1,
	[FamiliarVariant.DEPRESSION] = 1,
	[FamiliarVariant.SHADE] = 1,
	[FamiliarVariant.HUSHY] = 1,
	[FamiliarVariant.LIL_MONSTRO] = 1,
	[FamiliarVariant.KING_BABY] = 1,
	[FamiliarVariant.YO_LISTEN] = 1,
	[FamiliarVariant.ACID_BABY] = 1,
	[FamiliarVariant.SPIDER_BABY] = 2,
	[FamiliarVariant.SACK_OF_SACKS] = 1,
	[FamiliarVariant.BLOODSHOT_EYE] = 1,
	[FamiliarVariant.MOMS_RAZOR] = 1,
	[FamiliarVariant.ANGRY_FLY] = 1,
	[FamiliarVariant.BUDDY_IN_A_BOX] = 1,
	[FamiliarVariant.LIL_HARBINGERS] = 1,
	[FamiliarVariant.ANGELIC_PRISM] = 1,
	[FamiliarVariant.LIL_SPEWER] = 1,
	[FamiliarVariant.SLIPPED_RIB] = 1,
	[FamiliarVariant.POINTY_RIB] = 1,
	[FamiliarVariant.HALLOWED_GROUND] = 1,
	[FamiliarVariant.JAW_BONE] = 1,
	[FamiliarVariant.INTRUDER] = 1,
	[FamiliarVariant.PSY_FLY] = 1.5,
	[FamiliarVariant.BOILED_BABY] = 1,
	[FamiliarVariant.FREEZER_BABY] = 1,
	[FamiliarVariant.LOST_SOUL] = 1.5,
	[FamiliarVariant.LIL_DUMPY] = 1,
	[FamiliarVariant.TINYTOMA] = 1,
	[FamiliarVariant.BOT_FLY] = 1,
	[FamiliarVariant.PASCHAL_CANDLE] = 1.25,
	[FamiliarVariant.FRUITY_PLUM] = 1,
	[FamiliarVariant.LIL_ABADDON] = 1,
	[FamiliarVariant.LIL_PORTAL] = 1,
	[FamiliarVariant.WORM_FRIEND] = 1,
	[FamiliarVariant.TWISTED_BABY] = 0.75,
	[FamiliarVariant.STAR_OF_BETHLEHEM] = 1,
	[FamiliarVariant.CUBE_BABY] = 1,
	[FamiliarVariant.BLOOD_PUPPY] = 1,
	[FamiliarVariant.VANISHING_TWIN] = 1.25,
	-- Repentance+
	[CustomFamiliars.BAG_O_TRASH] = 1,
	[CustomFamiliars.CHERUBIM] = 1.25,
	[CustomFamiliars.CHERRY] = 0,
	[CustomFamiliars.BIRD] = 0,
	[CustomFamiliars.ENRAGED_SOUL] = 0,
	[CustomFamiliars.TOY_HELICOPTER_TANK] = 0.75,
	[CustomFamiliars.SIBLING_1] = 0.75,
	[CustomFamiliars.SIBLING_2] = 0.75,
	[CustomFamiliars.FIGHTING_SIBLINGS] = 1.5,
}

local PlayerSelfDamageFlags = {
	['IVBag'] = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG,
	['Confessional'] = DamageFlag.DAMAGE_RED_HEARTS,
	['DemonBeggar'] = DamageFlag.DAMAGE_RED_HEARTS,
	['BloodDonationMachine'] = DamageFlag.DAMAGE_RED_HEARTS,
	['HellGame'] = DamageFlag.DAMAGE_RED_HEARTS,
	['CurseRoom'] = DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CURSED_DOOR,
	['MausoleumDoor'] = DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS,
	['SacrificeRoom'] = DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES,
	['SpikedChest'] = DamageFlag.DAMAGE_CHEST | DamageFlag.DAMAGE_NO_PENALTIES
}
RepentancePlusMod.PlayerSelfDamageFlags = PlayerSelfDamageFlags

-- Directions to directional vectors or anims
-- When the entity doesn't shoot or move, it defaults to HeadDown
local DIRECTION_FLOAT_ANIM = {
	[Direction.NO_DIRECTION] = "FloatDown",
	[Direction.LEFT] = "FloatLeft",
	[Direction.UP] = "FloatUp",
	[Direction.RIGHT] = "FloatRight",
	[Direction.DOWN] = "FloatDown"
}
local DIRECTION_SHOOT_ANIM = {
	[Direction.NO_DIRECTION] = "FloatShootDown",
	[Direction.LEFT] = "FloatShootLeft",
	[Direction.UP] = "FloatShootUp",
	[Direction.RIGHT] = "FloatShootRight",
	[Direction.DOWN] = "FloatShootDown"
}
local DIRECTION_VECTOR = {
	[Direction.NO_DIRECTION] = Vector(0, 1),
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.UP] = Vector(0, -1),
	[Direction.RIGHT] = Vector(1, 0),
	[Direction.DOWN] = Vector(0, 1)
}


						----------------------
						-- HELPER FUNCTIONS --
						----------------------
--[[
	UNLOCK AND ACHIEVEMENT SYSTEM MANAGEMENT	--]]

-- Clean table that holds all the unlock requirements.
-- Used twice: when starting to play the mod, and when using the `rplus_reset` console command.
local MOD_UNLOCKS_TABLE = {
	["21"] = { --T.Isaac
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_BROKEN, paper = "1-1"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.BASEMENT_KEY, paper = "2-1"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.UNO_REVERSE_CARD, paper = "3-1"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.ORDINARY_LIFE, paper = "4-1"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.RUBIKS_CUBE, paper = "5-1"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.RED_BOMBER, paper = "6-1"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.SPINDOWN_DICE_SHARD, paper = "7-1"}
    },
    ["22"] = { --T.Maggy
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_DAUNTLESS, paper = "1-2"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.KEY_TO_THE_HEART, paper = "2-2"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.QUEEN_OF_DIAMONDS, paper = "3-2"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.CHERRY_FRIENDS, paper = "4-2"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.COOKIE_CUTTER, paper = "5-2"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BLOOD_VESSELS[1], paper = "6-2"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.NEEDLE_AND_THREAD, paper = "7-2"}
    },
    ["23"] = { --T.Cain
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_HOARDED, paper = "1-3"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.RED_MAP, paper = "2-3"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.JACK_OF_DIAMONDS, paper = "3-3"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.MARK_OF_CAIN, paper = "4-3"},
        ["Isaac"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.TRICK_PENNY, paper = "5-3"},
        ["Blue Baby"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.SLEIGHT_OF_HAND, paper = "6-3"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.BAG_TISSUE, paper = "7-3"}
    },
    ["24"] = { --T.Judas
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_DECEIVER, paper = "1-4"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.KEY_KNIFE, paper = "2-4"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.JACK_OF_HEARTS, paper = "3-4"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.CEREMONIAL_BLADE, paper = "4-4"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BLACK_DOLL, paper = "5-4"},
        ["Blue Baby"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.JUDAS_KISS, paper = "6-4"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.SACRIFICIAL_BLOOD, paper = "7-4"}
    },
    ["25"] = {	--T.???
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_SOILED, paper = "1-5"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.NIGHT_SOIL, paper = "2-5"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.FLY_PAPER, paper = "3-5"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BLESS_OF_THE_DEAD, paper = "4-5"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BAG_O_TRASH, paper = "5-5"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.HAND_ME_DOWNS, paper = "6-5"},
        ["Greed"] = {Unlocked = false, Variant = 70, SubType = CustomPills.LAXATIVE, paper = "7-5"}
    },
    ["26"] = {	--T.Eve
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_CURDLED, paper = "1-6"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.ADAMS_RIB, paper = "2-6"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.BEDSIDE_QUEEN, paper = "3-6"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BIRD_OF_HOPE, paper = "4-6"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.TOWER_OF_BABEL, paper = "5-6"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.ULTRA_FLESH_KID, paper = "6-6"},
        ["Greed"] = {Unlocked = false, Variant = 70, SubType = CustomPills.ESTROGEN_UP, paper = "7-6"}
    },
    ["27"] = {	--T.Samson
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_SAVAGE, paper = "1-7"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.MAGIC_SWORD, paper = "2-7"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.JACK_OF_CLUBS, paper = "3-7"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.TEMPER_TANTRUM, paper = "4-7"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.GUSTY_BLOOD, paper = "5-7"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BOOK_OF_JUDGES, paper = "6-7"},
        ["Greed"] = {Unlocked = false, Variant = 70, SubType = CustomPills.PHANTOM_PAINS, paper = "7-7"}
    },
	["28"] = {	--T.Azazel
		["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_BENIGHTED, paper = "1-8"},
		["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.ANGELS_CROWN, paper = "2-8"},
		["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.JOKER_Q, paper = "3-8"},
		["Satan"] = {Unlocked = false, Variant =  100, SubType = CustomCollectibles.CROSS_OF_CHAOS, paper = "4-8"},
		["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.SCALPEL, paper = "5-8"},
		["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BOOK_OF_LEVIATHAN, paper = "6-8"},
		["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.FIEND_FIRE, paper = "7-8"},
		["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.DEMON_FORM, paper = "7-8"}
	},
    ["29"] = {	--T.Lazarus
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_ENIGMA, paper = "1-9"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.TORN_PAGE, paper = "2-9"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.JACK_OF_SPADES, paper = "3-9"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.DNA_REDACTOR, paper = "4-9"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.CAT_IN_A_BOX, paper = "5-9"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.NERVE_PINCH, paper = "6-9"},
        ["Greed"] = {Unlocked = false, Variant = 70, SubType = CustomPills.YUCK, paper = "7-9"},
        ["Greed"] = {Unlocked = false, Variant = 70, SubType = CustomPills.YUM, paper = "7-9"}
    },
    ["30"] = {	--T.Eden
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_CAPRICIOUS, paper = "1-10"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.EDENS_LOCK, paper = "2-10"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.VALENTINES_CARD, paper = "3-10"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BOOK_OF_GENESIS, paper = "4-10"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.MAGIC_PEN, paper = "5-10"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.MAGIC_MARKER, paper = "6-10"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.MIRRORED_LANDSCAPE, paper = "7-10"}
    },
    ["31"] = {	--T.Lost
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_BALEFUL, paper = "1-11"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.PIECE_OF_CHALK, paper = "2-11"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.CURSED_CARD, paper = "3-11"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.CHERUBIM, paper = "4-11"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.SOUL_BOND, paper = "5-11"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.ANGELS_WINGS, paper = "6-11"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.SPIRITUAL_RESERVES, paper = "7-11"}
    },
    ["32"] = {	--T.Lilith
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_HARLOT, paper = "1-12"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.BABY_SHOES, paper = "2-12"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.QUEEN_OF_CLUBS, paper = "3-12"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.REJECTION, paper = "4-12"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.MOTHERS_LOVE, paper = "5-12"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.FRIENDLY_SACK, paper = "6-12"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.MOMS_ID, paper = "7-12"}
    },
    ["33"] = {	--T.Keeper
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_MISER, paper = "1-13"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.GREEDS_HEART, paper = "2-13"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.KING_OF_DIAMONDS, paper = "3-13"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.TWO_PLUS_ONE, paper = "4-13"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.AUCTION_GAVEL, paper = "5-13"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.KEEPERS_PENNY, paper = "6-13"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.LOADED_DICE, paper = "7-13"}
    },
    ["34"] = {	--T.Apollyon
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_EMPTY, paper = "1-14"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.SHATTERED_STONE, paper = "2-14"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.KING_OF_SPADES, paper = "3-14"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.SINNERS_HEART, paper = "4-14"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.BOTTOMLESS_BAG, paper = "5-14"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.VAULT_OF_HAVOC, paper = "6-14"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.RED_RUNE, paper = "7-14"}
    },
    ["35"] = {	--T.Forgor
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_FETTERED, paper = "1-15"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.BONE_MEAL, paper = "2-15"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.KING_OF_CLUBS, paper = "3-15"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.ENRAGED_SOUL, paper = "4-15"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.PURE_SOUL, paper = "5-15"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.HANDICAPPED_PLACARD, paper = "6-15"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.FUNERAL_SERVICES, paper = "7-15"}
    },
    ["36"] = {	--T.Bethany
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_ZEALOT, paper = "1-16"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 350, SubType = CustomTrinkets.EMPTY_PAGE, paper = "2-16"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.LIBRARY_CARD, paper = "3-16"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.CEILING_WITH_THE_STARS, paper = "4-16"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.QUASAR, paper = "5-16"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.STARGAZERS_HAT, paper = "6-16"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.QUASAR_SHARD, paper = "7-16"}
    },
    ["37"] = {	--T.Jacob
        ["Character Unlock"] = {Unlocked = false, Variant = 10, SubType = CustomPickups.TaintedHearts.HEART_DESERTED, paper = "1-17"},
        ["Mom's Heart"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.SIBLING_RIVALRY, paper = "2-17"},
        ["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.BUSINESS_CARD, paper = "3-17"},
        ["Satan"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.CHEESE_GRATER, paper = "4-17"},
        ["Isaac"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.RED_KING, paper = "5-17"},
        ["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = CustomCollectibles.TANK_BOYS, paper = "6-17"},
        ["Greed"] = {Unlocked = false, Variant = 300, SubType = CustomConsumables.ANTIMATERIAL_CARD, paper = "7-17"}
    },
    ["Special"] = {
        ["Black Chest"] = {Unlocked = false, paper = "9-6", requiredNum = 5, num = 0},
        ["Scarlet Chest"] = {Unlocked = false, paper = "9-5", requiredNum = 3, num = 0},
        ["Flesh Chest"] = {Unlocked = false, paper = "9-4", requiredNum = 10, num = 0},
        ["Coffin"] = {Unlocked = false, paper = "9-3", requiredNum = 10, num = 0},
        ["Stargazer"] = {Unlocked = false, paper = "9-1", requiredNum = 3, num = 0},
        ["Tainted Rocks"] = {Unlocked = false, paper = "9-2", requiredNum = 5, num = 0},
        ["Birth Certificate"] = {Unlocked = false, paper = "9-7"}
    }
}

-- Get the mark (string) depending on what stage you've killed the boss at.
local function getFinalBossMark(room, level, stage)
	room = room or game:GetRoom()
	level = level or game:GetLevel()
	stage = stage or level:GetStage()

	if game.Difficulty >= Difficulty.DIFFICULTY_GREED
	and stage == LevelStage.STAGE7_GREED and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x2 then
		return "Greed"
	elseif game.Difficulty == Difficulty.DIFFICULTY_HARD then
		if room:GetType() == RoomType.ROOM_BOSSRUSH then
			return "Boss Rush"
		elseif room:GetType() == RoomType.ROOM_BOSS then
			local isAltPath = level:GetStageType() == StageType.STAGETYPE_WOTL	-- Cathedral and Chest are technically "alt" floors introduced in WotL expansion
			local isSecretPath = level:GetStageType() >= StageType.STAGETYPE_REPENTANCE	-- Repentance alt floors (used to disambiguate Corpse II from Womb II)

			if stage == LevelStage.STAGE4_2 and not isSecretPath then
				return "Mom's Heart"
			elseif stage == LevelStage.STAGE5 then
				return isAltPath and "Isaac" or "Satan"
			elseif stage == LevelStage.STAGE6 then
				return isAltPath and "Blue Baby" or nil
			end
		end
	end

	return nil
end

---@param player EntityPlayer|number|string
---@return string
local function toCharacterIdString(player, mark)
	if type(player) == "string" and player == "Special" then
		return "Special"
	elseif type(player) ~= "number" then
		player = player:GetPlayerType()
	end

	if player < 21 then
		if mark == "Character Unlock" then
			-- get the id of the normal character's tainted counterpart
			if player == 12 then										-- Dark Judas
				player = 24
			elseif player >= 13 and player <= 16 then					-- Lilith to Forgotten
				player = player + 19
			elseif player == 11 or player == 17 or player == 18 then	-- Lazarus Risen, The Soul and Bethany
				player = player + 18
			elseif player == 19 or player == 20 then					-- Jacob & Esau
				player = 37
			else
				player = player + 21
			end
		else
			return ""
		end
	elseif mark ~= "Character Unlock" then
		-- adjust tainted characters' ids
		if player == 38 then player = 29 									-- T. Lazarus Dead
		elseif player == 39 then player = 37								-- T. Jacob Ghost
		elseif player == 40 then player = 35 end							-- T. Soul
	end

	return tostring(player)
end

-- Whether the mark is unlocked, according to CustomData.Unlocks
local function isMarkUnlocked(playerType, mark)
	if not CustomData.Unlocks
	or type(mark) ~= "string" then
		return nil
	end

	local characterId = toCharacterIdString(playerType, mark)

	if not CustomData.Unlocks[characterId]
	or not CustomData.Unlocks[characterId][mark] then
		return nil
	end

	return CustomData.Unlocks[characterId][mark].Unlocked
end

local function unlockMark(playerType, mark)
	if not CustomData.Unlocks
	or type(mark) ~= "string" then
		return nil
	end

	local characterId = toCharacterIdString(playerType, mark)

	if not CustomData.Unlocks[characterId]
	or not CustomData.Unlocks[characterId][mark] then
		return nil
	end

	if CustomData.Unlocks[characterId][mark].Unlocked then
		print("Error: Mark already unlocked!")
		return nil
	end

	CustomData.Unlocks[characterId][mark].Unlocked = true
end

local function unlockAllCharactersMarks(pl)
	for _, m in pairs(bossMarks) do
		unlockMark(pl, m)
	end
end
RepentancePlusMod.unlockAllCharactersMarks = unlockAllCharactersMarks

local function unlockMarkOnAllCharacters(mark)
	for p = 21, 37 do
		unlockMark(p, mark)
	end
end
RepentancePlusMod.unlockMarkOnAllCharacters = unlockMarkOnAllCharacters

local function unlockSpecials()
	for _, sp in pairs({"Black Chest", "Scarlet Chest", "Flesh Chest", "Coffin", "Stargazer", "Tainted Rocks"}) do
		unlockMark("Special", sp)
	end
end

local function unlockHearts()
	for p = 0, 19 do
		if p ~= 11 and p ~= 12 and p ~= 17 then
			unlockMark(p, "Character Unlock")
		end
	end
end

local function unlockAll()
	for p = 21, 37 do
		for _, m in pairs(bossMarks) do
			unlockMark(p, m)
		end
	end

	unlockSpecials()
	unlockHearts()
	unlockMark("Special", "Birth Certificate")
end

local function checkAllCharactersMarks(pl)
	for _, m in pairs(bossMarks) do
		if not isMarkUnlocked(pl, m) then
			return false
		end
	end

	return true
end

local function checkAllMarks(keepGoing, includeSpecials)
	for p = 21, 37 do
		for _, m in pairs(bossMarks) do
			if not isMarkUnlocked(p, m) then
				if keepGoing then
					print("MARK: character " .. playerTypeToName[p] .. " to " .. m .. " is not unlocked!")
				else
					return false
				end
			end
		end
	end

	if includeSpecials then
		for _, sp in pairs({"Black Chest", "Scarlet Chest", "Flesh Chest", "Coffin", "Stargazer", "Tainted Rocks"}) do
			if not isMarkUnlocked("Special", sp) then
				if keepGoing then
					print("SPECIAL MARK: " .. sp .. " is not unlocked!")
				else
					return false
				end
			end
		end
	end

	return true
end
----------------------------------------------------------------------

local function GetScreenCenterPosition()
	-- function stolen by me from Bogdan Ryduka, who stole it from kil
	-- that's how mafia works, everybody
	local room = game:GetRoom()
	local shape = room:GetRoomShape()
	local centerOffset = (room:GetCenterPos()) - room:GetTopLeftPos()
	local pos = room:GetCenterPos()

	if centerOffset.X > 260 then
		pos.X = pos.X - 260
	end
	if shape == RoomShape.ROOMSHAPE_LBL or shape == RoomShape.ROOMSHAPE_LTL then
		pos.X = pos.X - 260
	end

	if centerOffset.Y > 140 then
		pos.Y = pos.Y - 140
	end
	if shape == RoomShape.ROOMSHAPE_LTR or shape == RoomShape.ROOMSHAPE_LTL then
		pos.Y = pos.Y - 140
	end

	return Isaac.WorldToRenderPosition(pos)
end
RepentancePlusMod.GetScreenCenterPosition = GetScreenCenterPosition

local function SilentUseCard(p, card)
	p:UseCard(card, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
end

local function playAchievementPaper(playerType, mark)
	if not CustomData.Unlocks
	or type(mark) ~= "string" then
		return nil
	end

	local characterId = toCharacterIdString(playerType, mark)

	if not CustomData.Unlocks[characterId]
	or not CustomData.Unlocks[characterId][mark]
	or not CustomData.Unlocks[characterId][mark].Unlocked
	or not CustomData.Unlocks[characterId][mark].paper then
		return nil
	end

	FLAG_FAKE_POPUP_PAUSE = true
	SilentUseCard(Isaac.GetPlayer(0), Card.RUNE_BERKANO)
	for _, bluefly in pairs(Isaac.FindByType(3, FamiliarVariant.BLUE_FLY, -1)) do
		if bluefly:Exists() and bluefly.FrameCount <= 0 then
			bluefly:Remove()
		end
	end
	for _, bluespider in pairs(Isaac.FindByType(3, FamiliarVariant.BLUE_SPIDER, -1)) do
		if bluespider:Exists() and bluespider.FrameCount <= 0 then
			bluespider:Remove()
		end
	end
	FLAG_RENDER_PAPER = true
	achievementPaper:ReplaceSpritesheet(3, "gfx/ui/achievement/" .. CustomData.Unlocks[characterId][mark].paper .. ".png")
	achievementPaper:LoadGraphics()
end

local function isPickupUnlocked(pV, pS)
	if not CustomData.Unlocks then return end

	if pV == 300 or pV == 100 or pV == 10 or pV == 350 then	-- cards, trinkets, hearts or collectible items
		for p = 21, 37 do
			for _, m in pairs(bossMarks) do
				if CustomData.Unlocks[tostring(p)][m].Variant == pV and CustomData.Unlocks[tostring(p)][m].SubType == pS
				and isMarkUnlocked(p, m) then
					return true
				end
			end
		end
	else
		print("[ERR] Invalid argument: `pV` to isPickupUnlocked")
		return false
	end

	-- Specials
	if pV == 100 then
		if pS == CustomCollectibles.BIRTH_CERTIFICATE then
			return isMarkUnlocked("Special", "Birth Certificate")

		-- double unlock: Magic Cube + Rubik's Cube
		elseif pS == CustomCollectibles.MAGIC_CUBE then
			return isMarkUnlocked(21, "Isaac")
		-- triple unlock: Book of Leviathan forms
		elseif pS == CustomCollectibles.BOOK_OF_LEVIATHAN_UNCHAINED
		or pS == CustomCollectibles.BOOK_OF_LEVIATHAN_OPEN then
			return isMarkUnlocked(28, "Blue Baby")

		-------------------
		--* special unlocks
		--* show up only after you beat all Repentance+ marks on a certain character
		elseif pS == CustomCollectibles.HELICOPTER_BOYS
		or pS == CustomCollectibles.WE_NEED_TO_GO_SIDEWAYS then
			return checkAllCharactersMarks(37)
		elseif pS == CustomCollectibles.THE_HOOD
		or pS == CustomCollectibles.SPIRITUAL_AMENDS then
			return checkAllCharactersMarks(31)
		elseif pS == CustomCollectibles.BAG_OF_JEWELS
		or pS == CustomCollectibles.DEAD_WEIGHT then
			return checkAllCharactersMarks(35)
		elseif pS == CustomCollectibles.KEEPERS_ANNOYING_FLY then
			return checkAllCharactersMarks(33)
		end
	elseif pV == 300 then
		-- double unlock: Demon Form + Fiend Fire
		if pS == CustomConsumables.FIEND_FIRE then
			return isMarkUnlocked(28, "Greed")

		-- special unlocks
		elseif pS == CustomConsumables.DARK_REMNANTS then
			return checkAllCharactersMarks(28)
		elseif pS == CustomConsumables.FUNERAL_SERVICES_Q then
			return checkAllCharactersMarks(24)
		end
	elseif pV == 350 then
		-- special unlocks
		if pS == CustomTrinkets.CRACKED_CROSS then
			return checkAllCharactersMarks(28)
		elseif pS == CustomTrinkets.MY_SOUL then
			return checkAllCharactersMarks(31)
		elseif pS == CustomTrinkets.JEWEL_DIADEM then
			return checkAllCharactersMarks(35)
		elseif pS == CustomTrinkets.HEAVENLY_KEYS then
			return checkAllCharactersMarks(23)
		end
	end

	return false
end
RepentancePlusMod.isPickupUnlocked = isPickupUnlocked

local function isPillEffectUnlocked(effect)
	if not CustomData.Unlocks then return end

	for p = 21, 37 do
		if CustomData.Unlocks[tostring(p)]["Greed"].Variant == 70 and CustomData.Unlocks[tostring(p)]["Greed"].SubType == effect
		and isMarkUnlocked(p, "Greed") then
			return true
		end
	end

	-- double unlock: Yuck! and Yum! pills
	if effect == CustomPills.YUM then
		return isMarkUnlocked(28, "Greed")
	end

	-- special unlock
	if effect == CustomPills.SUPPOSITORY then
		return checkAllCharactersMarks(25)
	end

	return false
end
RepentancePlusMod.isPillEffectUnlocked = isPillEffectUnlocked

local function isChallengeCoreItem(item)
	local c = Isaac.GetChallenge()

	return c == CustomChallenges.THE_COMMANDER and item == CustomCollectibles.TANK_BOYS
	or c == CustomChallenges.JUDGEMENT and (item == CustomCollectibles.BOOK_OF_JUDGES or item == CustomCollectibles.CHERUBIM)
	or c == CustomChallenges.BLOOD and item == CustomCollectibles.CEREMONIAL_BLADE
	or c == CustomChallenges.IN_THE_LIGHT and item == CustomCollectibles.ANGELS_WINGS
end
--------------------------------------------------

-- Get a random unlocked vanilla collectible.
local function GetUnlockedVanillaCollectible(allPools, includeActives, ofChosenQualityOnly, constrainToTags, excludeTags)
	allPools = allPools or false
	includeActives = includeActives or false
	ofChosenQualityOnly = ofChosenQualityOnly or -1
	constrainToTags = constrainToTags or 0
	excludeTags = excludeTags or ItemConfig.TAG_QUEST

	local freezePreventChecker = 0
	local chosenPool
	local colResult
	rng:SetSeed(Random() + 1, 1)
	local roomType = game:GetRoom():GetType()

	repeat
		if allPools then
			chosenPool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
		else

			if roomType % 20 == 2 then
				-- Shops and Black markets
				chosenPool = 1
			elseif roomType == 5 then chosenPool = 2
			elseif roomType == 7 or roomType == 8 then
				-- Secret and Super secret rooms
				chosenPool = 5
			elseif roomType == 10 then chosenPool = 12
			elseif roomType == 14 then chosenPool = 3
			elseif roomType == 15 then chosenPool = 4
			elseif roomType == 24 then chosenPool = 26
			elseif roomType == 29 then chosenPool = 24
			elseif roomType == 12 then
				-- Libraries: if only passive items are needed, grabs from the Treasure pool instead
				chosenPool = includeActives and 6 or 0
			else
				chosenPool = 0
			end
		end

		colResult = game:GetItemPool():GetCollectible(chosenPool, false)
		freezePreventChecker = freezePreventChecker + 1
	until (Isaac.GetItemConfig():GetCollectible(colResult).Tags & excludeTags ~= excludeTags							-- excluding by tags
	and (includeActives or Isaac.GetItemConfig():GetCollectible(colResult).Type % 3 == 1)								-- passive or familiar (type 1 or 4)
	and (ofChosenQualityOnly == -1 or Isaac.GetItemConfig():GetCollectible(colResult).Quality == ofChosenQualityOnly	-- constraining by quality
	or colResult == CollectibleType.COLLECTIBLE_BREAKFAST)
	and (Isaac.GetItemConfig():GetCollectible(colResult).Tags & constrainToTags == constrainToTags))					-- constraining by tags
	or freezePreventChecker == 250

	game:GetItemPool():RemoveCollectible(colResult)
	return colResult
end
RepentancePlusMod.GetUnlockedVanillaCollectible = GetUnlockedVanillaCollectible

local function GetUnlockedCollectibleFromCustomPool(poolTableEntry)
	local freezePreventChecker = 0
	local colResult = CollectibleType.COLLECTIBLE_BREAKFAST
	rng:SetSeed(Random() + 1, 1)

	repeat
		local tryID = game:GetItemPool():GetCollectible(rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS), false)

		for _, el in pairs(poolTableEntry) do
			if el == tryID then
				colResult = tryID
				game:GetItemPool():RemoveCollectible(tryID)
				Isaac.DebugString("INFO: successfully chosen unlocked collectible #" .. tostring(colResult) .. " from custom pool!")
				break
			end
		end

		freezePreventChecker = freezePreventChecker + 1
	until (colResult ~= CollectibleType.COLLECTIBLE_BREAKFAST) or freezePreventChecker == 1500

	if freezePreventChecker == 1500 then
		print("WARNING: pool is exhausted and will not return any valid items!")
		Isaac.DebugString("WARNING: trying to grab a new item from a pool that is likely exhausted; returning Breakfast...")
	end

	return colResult
end

local function GetUnlockedTrinketFromCustomPool(poolTableEntry)
	local freezePreventChecker = 0
	local trinketRes = nil
	rng:SetSeed(Random() + 1, 1)

	repeat
		local roll = rng:RandomInt(#poolTableEntry) + 1
		trinketRes = poolTableEntry[roll]
		freezePreventChecker = freezePreventChecker + 1
	until game:GetItemPool():RemoveTrinket(trinketRes) or freezePreventChecker == 100

	if freezePreventChecker == 100 then
		print("WARNING: trinkets pool is exhausted and will no longer return valid trinkets!")
		Isaac.DebugString("WARNING: trying to grab a new trinket from trinkets pool that is exhausted; returning nothing...")
	end

	return trinketRes
end

local function BlacklistCollectibles(Pickup, Player)
	for _, subtable in pairs(BlacklistedCollectibles) do
		for _, i in pairs(subtable[2]) do
			if Player:HasCollectible(i) then
				if Pickup.SubType == subtable[1] then
					Pickup:Morph(5, 100, subtable[3], true, true, true)
					game:GetItemPool():RemoveCollectible(subtable[1])

					return
				end
			end

			if Pickup.SubType == i then
				if Player:HasCollectible(subtable[1]) then
					Pickup:Morph(5, 100, subtable[3], true, true, true)
					game:GetItemPool():RemoveCollectible(i)

					return
				end
			end
		end
	end
end
--------------------------------------------------

-- Handle displaying error message advising players to restart
local function DisplayErrorMessage()
	if not FLAG_HIDE_ERROR_MESSAGE then
		local newLineOffset = 0
		for line in string.gmatch(ErrorMessage, '([^#]+)') do
			Isaac.RenderText(line, 30, 220 + newLineOffset, 1, 0.2, 0.2, 1)
			newLineOffset = newLineOffset + 12
		end
	end
end

-- Helper functions to turn fire delay into equivalent tears up (since via api only fire delay is accessible, not tears)
local function GetTears(fireDelay)
    return 30 / (fireDelay + 1)
end
local function GetFireDelay(tears)
    return math.max(30 / tears - 1, -0.9999)
end

---@param Player EntityPlayer
local function isInGhostForm(Player, ignoreVisibleHealth)
	ignoreVisibleHealth = ignoreVisibleHealth or false

	if ignoreVisibleHealth then
		return Player:GetPlayerType() == 10 or Player:GetPlayerType() == 31
	else
		return Player:GetPlayerType() == 10 or Player:GetPlayerType() == 31 or
		Player:GetPlayerType() == 39 or	Player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
	end
end
RepentancePlusMod.isInGhostForm = isInGhostForm

local function isSelfDamage(damageFlags, data)
	-- `damageFlags` (int): damage flags passed from MC_ENTITY_TAKE_DMG callback
	-- `data` (string): can be used to specify what sources you want to include on checking (to ignore the rest)
	local currentFlags = PlayerSelfDamageFlags
	if data == "greedsheart" then
		currentFlags = {
			PlayerSelfDamageFlags['IVBag'],
			PlayerSelfDamageFlags['SacrificeRoom']
		}
	elseif data == "bloodvessel" then
		currentFlags = {
			PlayerSelfDamageFlags['SacrificeRoom'],
			PlayerSelfDamageFlags['MausoleumDoor']
		}
	elseif data == "taintedhearts" then
		currentFlags = {
			PlayerSelfDamageFlags['IVBag'],
			PlayerSelfDamageFlags['Confessional'],
			PlayerSelfDamageFlags['DemonBeggar'],
			PlayerSelfDamageFlags['BloodDonationMachine'],
			PlayerSelfDamageFlags['HellGame']
		}
	end

	for _, flags in pairs(currentFlags) do
		if damageFlags & flags == flags then
			return true
		end
	end
	return false
end
RepentancePlusMod.isSelfDamage = isSelfDamage


-- HANDLE REVIVING AND THE LIKE
-------------------------------
local function isPlayerDying(Player)
	if Player:GetBabySkin() == BabySubType.BABY_FOUND_SOUL then return false end
	-- and by 'dying' I (unfortunately) mean 'playing death animation'
	local sprite = Player:GetSprite()

	return (sprite:IsPlaying("Death") and sprite:GetFrame() == 51) or
	(sprite:IsPlaying("LostDeath") and sprite:GetFrame() == 30)
end
RepentancePlusMod.isPlayerDying = isPlayerDying

-- Allows you to revive Isaac, give them short i-frames, and revive their twin (e.g. Esau or Tainted Soul)
---@param Player EntityPlayer
local function reviveWithTwin(Player, iv)
	iv = iv or 40
	Player:Revive()
	Player:SetMinDamageCooldown(iv)
	if Player:GetOtherTwin() then
		Player:GetOtherTwin():Revive()
		Player:GetOtherTwin():SetMinDamageCooldown(iv)
	end

	-- da skull boi loses all his health when he revives, which isn't good
	if Player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
		Player:AddBoneHearts(1)
	end
end
RepentancePlusMod.reviveWithTwin = reviveWithTwin

-- Priority queue for Repentance+ revivals
-- sorry it's not above along other tables, it uses functions which are only defined a bit later
local CustomRevivals = {
    BIRD_OF_HOPE = {
		priority = 0,
        condition = function(Player)
            return Player:HasCollectible(CustomCollectibles.BIRD_OF_HOPE) and not CustomData.Data.Items.BIRD_OF_HOPE.dieFrame
        end,
        onRevival = function(Player)
            reviveWithTwin(Player)

            CustomData.Data.Items.BIRD_OF_HOPE.numRevivals = CustomData.Data.Items.BIRD_OF_HOPE.numRevivals + 1
            CustomData.Data.Items.BIRD_OF_HOPE.dieFrame = game:GetFrameCount()
            CustomData.Data.Items.BIRD_OF_HOPE.diePos = Player.Position
            CustomData.Data.Items.BIRD_OF_HOPE.catchingBird = true
            CustomData.Data.Items.BIRD_OF_HOPE.birdCaught = false
            Player:GetSprite():Stop()
            Player:AddCacheFlags(CacheFlag.CACHE_FLYING)

			-- Apparently cache evaluation causes CustomHealthAPISavedata to disappear, so let's fix that with a temporary variable
			local temp = Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts
            Player:EvaluateItems()
			Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts = temp

            Player:AddNullCostume(CustomCostumes.BIRD_OF_HOPE)

            local Birb = Isaac.Spawn(3, CustomFamiliars.BIRD, 0, game:GetRoom():GetCenterPos(), Vector.FromAngle(math.random(360)) * CustomData.Data.Items.BIRD_OF_HOPE.numRevivals, Player)
            Birb:GetSprite():Play("Flying")
        end
    },
    ADAMS_RIB = {
		priority = 10,
        condition = function(Player)
            if Player:GetTrinketMultiplier(CustomTrinkets.ADAMS_RIB) == 0 then
                return false
            end

            rng:SetSeed(Random() + Player.InitSeed, 1)
            return rng:RandomFloat() * 100 < 22
        end,
        onRevival = function(Player)
			local temp = Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts
            reviveWithTwin(Player)

            if Player:GetTrinketMultiplier(CustomTrinkets.ADAMS_RIB) > 1 then
                SilentUseCard(Player, Card.CARD_SOUL_EVE)
            end

            Player:ChangePlayerType(PlayerType.PLAYER_EVE)
            Player:AddMaxHearts(4 - Player:GetMaxHearts())

            for _, startingItem in pairs({CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON, CollectibleType.COLLECTIBLE_DEAD_BIRD}) do
                if not Player:HasCollectible(startingItem) then
                    Player:AddCollectible(startingItem)
                end
            end

			Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts = temp
        end
    },
    ENIGMA_HEARTS = {
		priority = 20,
        condition = function(Player)
            return Player:GetData().CustomHealthAPISavedata and Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts
			and Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts > 0
        end,
        onRevival = function(Player)
            reviveWithTwin(Player)

            Player:AddHearts(4 * (Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts - 1))
            sfx:Play(SoundEffect.SOUND_SUPERHOLY)
            Player:GetData().CustomHealthAPISavedata.NumEnigmaHearts = 0
            if Player:GetSubPlayer() then
                Player:GetSubPlayer():GetData().CustomHealthAPISavedata.NumEnigmaHearts = 0
            end
        end
    },
    MARK_OF_CAIN = {
		priority = 30,
        condition = function(Player)
            if not Player:HasCollectible(CustomCollectibles.MARK_OF_CAIN) then
                return false
            end

            local playerFamiliars = {}

            for i = 8, 1200 do
                if Isaac.GetItemConfig():GetCollectible(i) and Isaac.GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_FAMILIAR
                and Isaac.GetItemConfig():GetCollectible(i).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
                and i ~= CustomCollectibles.MARK_OF_CAIN then
                    for _ = 1, Player:GetCollectibleNum(i, true) do
                        table.insert(playerFamiliars, i)
                    end
                end
            end

            Player:GetData().playerFamiliars = playerFamiliars
            return #playerFamiliars > 0
        end,
        onRevival = function(Player)
            reviveWithTwin(Player)

            Player:GetEffects():AddCollectibleEffect(CustomCollectibles.MARK_OF_CAIN)
            sfx:Play(SoundEffect.SOUND_SUPERHOLY)
            for _, enoch in pairs(Isaac.FindByType(3, CustomFamiliars.ENOCH, -1, false, false)) do
                enoch:Remove()
            end

            for _, itemToRemove in pairs(Player:GetData().playerFamiliars) do
                Player:RemoveCollectible(itemToRemove)
            end

            Player:GetData().playerFamiliars = nil
        end
    }
}

local function tryCustomRevivePlayer(Player)
	local priority = 0

	while priority <= 30 do
		for k, v in pairs(CustomRevivals) do
			if priority == v.priority and v.condition(Player) then
				v.onRevival(Player)
				return true
			end
		end

		priority = priority + 10
	end

	return nil
end
RepentancePlusMod.tryCustomRevivePlayer = tryCustomRevivePlayer
---------------------
-- REVIVAL HANDLE END


local function getMothersLoveStatBoost(fVariant, insertCustom, boostMul)
	-- `fVariant` (int): familiar that you want to check (you can also insert info about it if `insertCustom` is true)
	-- `insertCustom` (boolean): default - false. If true, allows you to add a custom stat boost multiplier for familiar
	-- `boostMul` (float): if you want to insert a stat boost multiplier for familiar

	-- for Mother's Love, familiars will grant stronger or weaker stat boosts, depending on their rarity and effectiveness
	-- all Repentance+ familiars have to be listed
	-- all vanilla familiars unlisted do NOT grant stat boosts (e.g. spiders, flies, dips, familiar spawned from trinkets and Isaac's body parts)
	insertCustom = insertCustom or false
	if insertCustom and type(boostMul) == 'number' then
		MothersLoveMultipliers[fVariant] = boostMul
		return boostMul
	end

	if not MothersLoveMultipliers[fVariant] then
		if fVariant < 244 or fVariant == 900 then
			-- vanilla unlisted: 0
			return 0
		else
			-- modded unlisted: 1 (unless overriden by insertCustom)
			return 1
		end
	else
		return MothersLoveMultipliers[fVariant]
	end
end
RepentancePlusMod.getMothersLoveStatBoost = getMothersLoveStatBoost

local function getTrueFamiliarNum(Player, collectible)
	return Player:GetCollectibleNum(collectible) + Player:GetEffects():GetCollectibleEffectNum(collectible)
end

--[[
	FUNCTIONS USED TO OPEN CUSTOM CHESTS
	STORED BOTH LOCALLY AND GLOBALLY
]]--

local function dropPickupFromTable(dropTable, pos, spawner)
	rng:SetSeed(Random() + 1, 1)
	local roll = rng:RandomFloat() * 100

	for i, v in pairs(dropTable) do
		if roll < v[1] then
			for _, y in pairs(v[2]) do
				Isaac.Spawn(5, y[1], y[2], pos, Vector.FromAngle(math.random(360)) * 3, spawner)
			end

			return
		end
	end
end

-- HANDLE PILLS AND PILL REPLACEMENT
------------------------------------
local function isEffectInRotation(pillEffect)
	antiPillCheckRecursion = true
	for color = PillColor.PILL_BLUE_BLUE, PillColor.PILL_WHITE_YELLOW do
		if pillEffect == game:GetItemPool():GetPillEffect(color) then
			antiPillCheckRecursion = false
			return true
		end
	end

	antiPillCheckRecursion = false
	return false
end

local function getPillCounterpart(pillEffect)
	local counterpart = pillEffect
	local phd = false
	local falsephd = false

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		if Player:HasCollectible(CollectibleType.COLLECTIBLE_PHD)
		or Player:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO)
		or Player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
			phd = true
		end

		if Player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then
			falsephd = true
		end
	end

	if phd and not falsephd then
		if pillCounterparts.POSITIVE[counterpart] then
			counterpart = pillCounterparts.POSITIVE[counterpart]
		end
	elseif falsephd and not phd then
		if pillCounterparts.NEGATIVE[counterpart] then
			counterpart = pillCounterparts.NEGATIVE[counterpart]
		end
	end

	return counterpart
end

---@param Player EntityPlayer
local function shouldUseHorsePillEffect(Player, pillEffect)
	local pillColor = Player:GetData().currentlyHeldPill
	if pillColor and pillColor >= PillColor.PILL_GIANT_FLAG then
		local isHorsePillForThisEffect = (game:GetItemPool():GetPillEffect(pillColor, Player) == pillEffect)
		local isGoldHorsePill = (pillColor == PillColor.PILL_GOLD + PillColor.PILL_GIANT_FLAG)

		return isHorsePillForThisEffect or isGoldHorsePill
	end

	return false
end

------------------------------------

local function openScarletChest(Pickup)
	-- subtype 1: opened chest (need to remove)
	Pickup.SubType = 1
	-- setting some data for pickup, because it is deleted on entering a new room, and the pickup is removed as well
	Pickup:GetData()["IsInRoom"] = true
	Pickup:GetSprite():Play("Open")
	sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
	rng:SetSeed(Pickup.DropSeed, 1)
	local roll = rng:RandomFloat() * 100

	if roll < 66 then
		local ScarletChestPedestal = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), Pickup.Position, Vector.Zero, Pickup)
		ScarletChestPedestal:GetSprite():ReplaceSpritesheet(5, "gfx/items/scarletchest_itemaltar.png")
		ScarletChestPedestal:GetSprite():LoadGraphics()

		Pickup:Remove()
	elseif roll < 77 then
		local numPickups = rng:RandomInt(10) + 5

		for i = 1, numPickups do
			Isaac.Spawn(5, 30, 1, Pickup.Position, Vector.FromAngle(math.random(360)) * 4, Pickup)
		end
	else
		local numPickups = rng:RandomInt(2) + 1

		for i = 1, numPickups do
			local card = rng:RandomInt(22) + Card.CARD_REVERSE_FOOL
			Isaac.Spawn(5, 300, card, Pickup.Position, Vector.FromAngle(math.random(360)) * 4, Pickup)
		end
	end
end
RepentancePlusMod.openScarletChest = openScarletChest

local function openFleshChest(Pickup)
	CustomData.Data.FleshChestConsumedHP = 0
	-- subtype 1: opened chest (need to remove)
	Pickup.SubType = 1
	-- setting some data for pickup, because it is deleted on entering a new room, and the pickup is removed as well
	Pickup:GetData()["IsInRoom"] = true
	Pickup:GetSprite():Play("Open")
	sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
	local roll = rng:RandomFloat() * 100

	if roll < 30 then
		local newID = GetUnlockedCollectibleFromCustomPool(CustomItempools.FLESH_CHEST)
		local fleshChest = Isaac.Spawn(5, 100, newID, Pickup.Position, Vector.Zero, Pickup)
		fleshChest:GetSprite():ReplaceSpritesheet(5, "gfx/items/fleshchest_itemaltar.png")
		fleshChest:GetSprite():LoadGraphics()

		Pickup:Remove()
	else
		-- 3 to 6 pickups
		local NumOfPickups = rng:RandomInt(4) + 3

		for i = 1, NumOfPickups do
			local roll = rng:RandomFloat() * 100

			if roll < 50 then
				local heart
				if roll < 10 then
					heart = 1
				elseif roll < 25 then
					heart = 2
				elseif roll < 40 then
					heart = 9
				elseif roll < 45 then
					heart = 11
				else
					heart = 12
				end

				Isaac.Spawn(5, 10, heart, Pickup.Position, Vector.FromAngle(math.random(360)) * 4, Pickup)
			else
				Isaac.Spawn(5, 70, 0, Pickup.Position, Vector.FromAngle(math.random(360)) * 4, Pickup)
			end
		end

		local t = GetUnlockedTrinketFromCustomPool(CustomItempools.FLESH_CHEST_TRINKETS)
		if t then
			Isaac.Spawn(5, 350, t, Pickup.Position, Vector.FromAngle(math.random(360)) * 4, Pickup) end
	end
end
RepentancePlusMod.openFleshChest = openFleshChest

local function openBlackChest(Pickup)
	-- setting some data for pickup, because it is deleted on entering a new room, and the pickup is removed as well
	Pickup:GetData()["IsInRoom"] = true
	Pickup:GetSprite():Play("Open")
	sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
	rng:SetSeed(Random() + Pickup.DropSeed, 1)
	local roll = rng:RandomFloat() * 100

	if roll < 15 then
		local BlackChestPedestal = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_CURSE, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), Pickup.Position, Vector.Zero, Pickup)
		BlackChestPedestal:GetSprite():ReplaceSpritesheet(5,"gfx/items/blackchest_itemaltar.png")
		BlackChestPedestal:GetSprite():LoadGraphics()

		Pickup:Remove()
	elseif roll < 70 then
		-- subtype 2: opened chest with consumables (need to close again later)
		Pickup.SubType = 2
		Pickup:GetData()['OpenFrame'] = game:GetFrameCount()
		dropPickupFromTable(DropTables.BLACK_CHEST, Pickup.Position, Pickup)
	else
		-- subtype 1: opened chest with nothing (need to remove)
		Pickup.SubType = 1
	end
end
RepentancePlusMod.openBlackChest = openBlackChest
---------------------

local function replaceBloodyRockSprite(spikedRock, room, level)
	local stageType = level:GetStageType()
	local roomType = room:GetType()
	local stage = level:GetStage()
	if stage < 10 and stage % 2 == 0 then stage = stage - 1 end		-- no way to account for odd floors other than that, omg
	local newSpritePath

	if roomType == RoomType.ROOM_SECRET then
		newSpritePath = "secretroom"
	else
		local stageTypeToFilePath = {
			[LevelStage.STAGE1_1] = {	-- chapter 1
				[StageType.STAGETYPE_ORIGINAL] = "basement",
				[StageType.STAGETYPE_WOTL] = "cellar",
				[StageType.STAGETYPE_AFTERBIRTH] = "burningbasement",
				[StageType.STAGETYPE_REPENTANCE] = "downpour",
				[StageType.STAGETYPE_REPENTANCE_B] = "dross",
			},
			[LevelStage.STAGE2_1] = {	-- chapter 2
				[StageType.STAGETYPE_ORIGINAL] = "caves",
				[StageType.STAGETYPE_WOTL] = "catacombs",
				[StageType.STAGETYPE_AFTERBIRTH] = "floodedcaves",
				[StageType.STAGETYPE_REPENTANCE] = "ashpit",
				[StageType.STAGETYPE_REPENTANCE_B] = "ashpit",
			},
			[LevelStage.STAGE3_1] = {	-- chapter 3
				[StageType.STAGETYPE_ORIGINAL] = "depths",
				[StageType.STAGETYPE_WOTL] = "depths",
				[StageType.STAGETYPE_AFTERBIRTH] = "depths",
				[StageType.STAGETYPE_REPENTANCE] = "mausoleum",
				[StageType.STAGETYPE_REPENTANCE_B] = "gehenna",
			},
			[LevelStage.STAGE4_1] = {	-- chapter 4
				[StageType.STAGETYPE_ORIGINAL] = "womb",
				[StageType.STAGETYPE_WOTL] = "utero",
				[StageType.STAGETYPE_AFTERBIRTH] = "scarredwomb",
				[StageType.STAGETYPE_REPENTANCE] = "corpse"
			},
			[LevelStage.STAGE4_3] = "bluewomb",
			[LevelStage.STAGE5] = {	-- chapter 4
				[StageType.STAGETYPE_ORIGINAL] = "sheol",
				[StageType.STAGETYPE_WOTL] = "cathedral"
			}
		}

		if type(stageTypeToFilePath[stage]) == 'string' then newSpritePath = stageTypeToFilePath[stage]
		else newSpritePath = stageTypeToFilePath[stage][stageType] end
	end

	newSpritePath = newSpritePath or "depths"
	newSpritePath = "gfx/grid/rocks_" .. tostring(newSpritePath) .. "_alt.png"
	spikedRock:GetSprite():ReplaceSpritesheet(0, newSpritePath)
	spikedRock:GetSprite():LoadGraphics()
end

local function getNextMapIconPos()
	local Y = 58	-- stays the same
	local X = 468	-- doesn't stay the same
	local Offsets = {0, 0, 0, 0, 0,				-- items: The Mind, Blue Map, Treasure Map, Compass, Restock (BRUH)
					0, 0, 0, 0, 0, 0, 0}		-- curses: Darkness, XL, Lost, Unknown, Cursed, Maze, Blind

	-- classic blame API moment, no flexible map icons smh my head
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		Offsets[2] = Player:HasCollectible(CollectibleType.COLLECTIBLE_BLUE_MAP) and 1 or (Offsets[2] == 1 and 1 or 0)
		Offsets[3] = Player:HasCollectible(CollectibleType.COLLECTIBLE_TREASURE_MAP) and 1 or (Offsets[3] == 1 and 1 or 0)
		Offsets[4] = Player:HasCollectible(CollectibleType.COLLECTIBLE_COMPASS) and 1 or (Offsets[4] == 1 and 1 or 0)
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then Offsets = {1,0,0,0,0,0,0,0,0,0,0,0} break end
	end
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		Offsets[5] = Player:HasCollectible(CollectibleType.COLLECTIBLE_RESTOCK) and 1 or (Offsets[5] == 1 and 1 or 0)
	end


	local c = game:GetLevel():GetCurses()
	for i = 0, 6 do
		if c & 2^i ~= 0 then Offsets[i + 6] = 1 end
	end

	for _, val in pairs(Offsets) do X = X - 16 * val end

	return Vector(X, Y)
end

local function canBuyHeart(Player, st)
	if st <= 2 or st == 5 then
		return Player:CanPickRedHearts()
	elseif st == 6 then
		return Player:CanPickBlackHearts()
	elseif st == 11 then
		return Player:CanPickBoneHearts()
	elseif st == 12 then
		return Player:CanPickRottenHearts()
	elseif st == 3 or st == 8 then
		return Player:CanPickSoulHearts()
	elseif st == 10 then	-- blended heart
		return Player:CanPickSoulHearts() or Player:CanPickRedHearts()
	end

	return true
end

local function canBuyBattery(Player)
	for i = 0, 2 do
		if Player:NeedsCharge(i) then return true end
	end

	return false
end
RepentancePlusMod.canBuyBattery = canBuyBattery

local function isCollidingWithAstralChain(entity)
	if not entity:IsVulnerableEnemy() or entity:GetData().isChainedToPlayer then return end
	if #Isaac.FindByType(865, 10, 1, false, false) == 0 then return end

	for _, chain in pairs(Isaac.FindByType(865, 10, 1, true, false)) do
		if not (chain.Target and chain.Parent) then chain:Remove() return end
		local Vector1 = (chain.Parent.Position - chain.Target.Position)
		local Vector2 = (entity.Position - chain.Target.Position)

		if math.abs(Vector1:GetAngleDegrees() - Vector2:GetAngleDegrees()) < 7.5 and Vector1:Length() > Vector2:Length() then
			return true
		else
			return false
		end
	end
end

local function makeRoomAngelShop(room)
	for i = 1, room:GetGridSize() do
		if room:GetGridEntity(i)
		and room:GetGridEntity(i):GetType() ~= GridEntityType.GRID_DOOR and room:GetGridEntity(i):GetType() ~= GridEntityType.GRID_WALL then
			room:RemoveGridEntity(i, 0, false)
		end
	end

	game:ShowHallucination(0, BackdropType.CATHEDRAL)
	sfx:Stop(33)
end

local function isInPlayersLineOfSight(EntityNPC, Player, margin)
	margin = margin or 36

	local v1 = DIRECTION_VECTOR[Player:GetHeadDirection()]
	local v2 = EntityNPC.Position - Player.Position
	local angle = math.abs(v1:GetAngleDegrees() - v2:GetAngleDegrees())

	return Player:GetHeadDirection() == Direction.LEFT and math.min(angle, 360 - angle) < margin or angle < margin
end

local function isItemPocketSlotBlacklisted(i)
	for _, entry in pairs(PocketBlacklistedCollectibles) do
		if entry == i then
			return true
		end
	end

	return false
end

---@param enemy Entity
local function crippleEnemy(enemy)
	local d = enemy:GetData()
	-- RETURNS:
	-- 		true if the enemy can be crippled and has been crippled just now
	--		false if it can't be crippled
	--		nil if it is already crippled

	if d.IsCrippled then
		return nil
	end

	if enemy:IsBoss()
	or not enemy:IsVulnerableEnemy() or not enemy:IsActiveEnemy(false)
	or enemy:HasEntityFlags(EntityFlag.FLAG_CHARM) or enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		return false
	end

	-- applying custom debuffs to enemies
	d.IsCrippled = true
	d.CrippleStartFrame = game:GetFrameCount()
	d.CrippleDeathBurst = false
	local crippleHands = Isaac.Spawn(1000, HelperEffects.CRIPPLING_HANDS, 0, enemy.Position + Vector(0, 5), Vector.Zero, enemy)
	crippleHands:GetSprite():Play("ClawsAppearing")

	return true
end
RepentancePlusMod.crippleEnemy = crippleEnemy

local function createBookOfJudgesCrosshairs(room)
	if not CustomData.Data then return end

	CustomData.Data.Items.BOOK_OF_JUDGES.beamTargets = {}
	for _, t in pairs(Isaac.FindByType(1000, EffectVariant.TARGET, 3)) do
		t:Remove()
	end

	rng:SetSeed(Random() + 1, 1)
	local roll = rng:RandomInt(math.floor(room:GetGridSize() / 15)) + 1 + math.floor(room:GetGridSize() / 30)

	repeat
		-- get random tile-aligned position (just getting a random index won't work because of L-shaped rooms with blind corners)
		local pos = room:GetGridPosition(room:GetGridIndex(room:GetRandomPosition(10)))
		local isNearDoor = false

		for i = 0, 7 do
			if room:GetDoorSlotPosition(i):Distance(pos) < 80 then
				isNearDoor = true
			end
		end

		if not isNearDoor and room:GetGridEntityFromPos(pos) == nil then
			table.insert(CustomData.Data.Items.BOOK_OF_JUDGES.beamTargets, pos)
			local beamTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 3, pos, Vector.Zero, nil)
			beamTarget:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_beam_target.png")
			beamTarget:GetSprite():LoadGraphics()
			beamTarget:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 10000, 1, false, false)
		end
	until #CustomData.Data.Items.BOOK_OF_JUDGES.beamTargets == roll
end

local function addTemporaryDmgBoost(Player)
	local data = Player:GetData()
	local flag = data.flagGiveTempBoost
	local step = data.boostTimeStep
	local num = data.numTempBoosts

	if not flag then flag = true end
	if not step then step = 0 end
	if not num then num = 1 else num = num + 1 end

	Player:GetData().flagGiveTempBoost = flag
	Player:GetData().boostTimeStep = step
	Player:GetData().numTempBoosts = num
end
RepentancePlusMod.addTemporaryDmgBoost = addTemporaryDmgBoost

local function shouldPlayVoiceover()
	-- Announcer mode. 2: always on, 1: always off, 0: random (assume a 50% chance to play a sound)
	local ann = Options.AnnouncerVoiceMode

	if ann == 2 then
		return true
	elseif ann == 1 then
		return false
	else
		rng:SetSeed(Random() + 1, 1)
		return rng:RandomFloat() < 0.5
	end
end

-- Play delayed sound if it has a defined delay, otherwise play instantly.
local function playDelayed(soundId)
	if shouldPlayVoiceover() then
		if SoundDelays[soundId] then
			table.insert(delayedSounds, {soundId, SoundDelays[soundId]})
		else
			sfx:Play(soundId)
		end
	end
end

local function getRedHeartPickups()
	local t = {}

	for _, heart in pairs(Isaac.FindByType(5, 10, -1)) do
		if (heart.SubType == 1 or heart.SubType == 2 or heart.SubType == HeartSubType.HEART_DOUBLEPACK
		or heart.SubType == HeartSubType.HEART_SCARED or heart.SubType == CustomPickups.TaintedHearts.HEART_HOARDED)
		and heart:ToPickup().Price == 0 then
			table.insert(t, heart)
		end
	end

	return t
end

local function hasActiveChallenge(room)
	local t = room:GetType()
	if t ~= RoomType.ROOM_BOSSRUSH and t ~= RoomType.ROOM_CHALLENGE then return not room:IsClear() end

	for i = 0, 7 do
		local door = room:GetDoor(i)
		if door and door:IsOpen() then return false end
	end

	return true
end
RepentancePlusMod.hasActiveChallenge = hasActiveChallenge

local function getBlackHeartNumFromBitmask(Player)
	local b = Player:GetBlackHearts()	-- bitmask of black hearts read right-to-left

	local y = {}
	while b > 0 do
		table.insert(y, b % 2)
		b = b // 2
	end

	-- if we just need the amount of black hearts, return right now
	local numB = 0
	for _, el in pairs(y) do
		if el == 1 then numB = numB + 1 end
	end

	return numB
end
RepentancePlusMod.getBlackHeartNumFromBitmask = getBlackHeartNumFromBitmask

-- for Quasar and Quasar Shard
------------------------------
local function isOptionsPickupIndexNew(t, index)
	-- `t`: {{}, {}, {}} - table of tables
	for _, subtable in pairs(t) do
		if subtable[2] == index then
			return false
		end
	end

	return true
end

local function properQuasarUse(Player)
	local roomCollectibleInfo = {}

	for _, c in pairs(Isaac.FindByType(5, 100, -1)) do
		if c:ToPickup().Price == 0 then
			local i = c:ToPickup().OptionsPickupIndex
			if c.SubType > 0 and (i == 0 or isOptionsPickupIndexNew(roomCollectibleInfo, i)) then
				table.insert(roomCollectibleInfo, {c.SubType, i})
			end
			Isaac.Spawn(1000, EffectVariant.POOF01, 0, c.Position, Vector.Zero, Player)
			c:Remove()
		end
	end

	if Player.QueuedItem and Player.QueuedItem.Item
	and Player.QueuedItem.Item:IsCollectible() then
		-- `Item` becomes inaccessible after we flush the item queue so I'd like to save the info
		local id = Player.QueuedItem.Item.ID
		-- oh boy how great is that to work with queued items. so much fun!
		local b = Player.QueuedItem.Item.AddBombs
		local b_p = Player:GetNumBombs()
		local c = Player.QueuedItem.Item.AddCoins
		local c_p = Player:GetNumCoins()
		local k = Player.QueuedItem.Item.AddKeys
		local k_p = Player:GetNumKeys()
		local mh = Player.QueuedItem.Item.AddMaxHearts
		local mh_p = Player:GetMaxHearts()
		local h = Player.QueuedItem.Item.AddHearts
		local h_p = Player:GetHearts()
		local sh = Player.QueuedItem.Item.AddSoulHearts
		local sh_p = Player:GetSoulHearts()
		local bh = Player.QueuedItem.Item.AddBlackHearts
		local bh_p = getBlackHeartNumFromBitmask(Player)
		--
		Player:FlushQueueItem()
		Player:RemoveCollectible(id)
		--
		Player:AddBombs(-math.min(b, 99 - b_p))
		Player:AddCoins(-math.min(c, 99 - c_p))
		Player:AddKeys(-math.min(k, 99 - k_p))
		Player:AddMaxHearts(-math.min(mh, 24 - mh_p))
		Player:AddHearts(-math.min(h, Player:GetEffectiveMaxHearts() - h_p))
		Player:AddSoulHearts(-math.min(sh, 24 - sh_p))
		Player:AddBlackHearts(-math.min(bh, 24 - bh_p))

		for _, pickup in pairs(Isaac.FindByType(5)) do
			if pickup.FrameCount == 0 and pickup.Position:Distance(Player.Position) < 250 then
				pickup:Remove()
			end
		end

		table.insert(roomCollectibleInfo, {id, 0})
	end

	for i = 1, #roomCollectibleInfo * 3 do
		local newID = GetUnlockedVanillaCollectible(false, false)
		Player:AddItemWisp(newID, Player.Position, true)
	end
	sfx:Play(SoundEffect.SOUND_DEATH_CARD)
end
-------------------------

-- for animated Angel's Wings pedestal
local function hasEffectOnIt(ent)
	for _, eff in pairs(Isaac.FindByType(1000, HelperEffects.ANIMATED_ITEM_DUMMY, 0, true, true)) do
		if eff.SpawnerEntity and GetPtrHash(eff.SpawnerEntity) == GetPtrHash(ent) then return true end
	end

	return false
end
---------------------------------



						-----------------------------
						-- CALLBACK TIED FUNCTIONS --
						-----------------------------

-- very epic and cool command to prevent game crash when reloading this mod through the mod menu
-- DEPRECATED since custom health no longer uses shaders
--[[
rplus:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
    if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
        Isaac.ExecuteCommand("reloadshaders")
    end
end)--]]

						-- MC_POST_GAME_STARTED			
						--------------------------
function rplus:OnGameStart(Continued)
	if not Continued then
		FLAG_HIDE_ERROR_MESSAGE = false

		--[[ 
			clear CustomData table that was used pre-1.27
			will only work ONCE when you first update the mod
		--]]
		local qData = nil
		local firstDataLoad = Isaac.LoadModData(rplus)
		if not firstDataLoad or firstDataLoad == "" then
			Isaac.DebugString("[REP PLUS] First launch of the mod! Gonna create savedata for ya...")
		else
			qData = json.decode(firstDataLoad)
		end

		if qData and (not qData.Data or not qData.Unlocks) then
			Isaac.DebugString("[REP PLUS] First launch of version 1.27 or older! Removing old custom data for restructure...")
			rplus:RemoveData()
		end

		--[[
			if CustomData doesn't exist, then it's first launch of v1.27+, LOAD the unlocks
			otherwise, do NOT do anything to not overwrite the table
		--]]
		local secondDataLoad = Isaac.LoadModData(rplus)
		if not secondDataLoad or secondDataLoad == "" then
			Isaac.DebugString("[REP PLUS] Creating a new saveX.dat file...")
			CustomData.Unlocks = MOD_UNLOCKS_TABLE
			CustomData.DssSettings = {}

			FLAG_DISPLAY_UNLOCKS_TIP = true
			Isaac.SaveModData(rplus, json.encode(CustomData, "CustomData"))
		else
			Isaac.DebugString("[REP PLUS] Loading mod data from saveX.dat...")
			CustomData = json.decode(secondDataLoad)
		end

		--[[ 
			Correct mistakes in CustomData.Unlocks 
			This has to be done manually, because unlocks table is already written into users' savedata
			Guess why I also need to do this? Right, to have other content mods not break it due to dynamic subtype assignment
		--]]
		-- Items
		CustomData.Unlocks["21"]["Satan"].SubType = CustomCollectibles.ORDINARY_LIFE
		CustomData.Unlocks["21"]["Isaac"].SubType = CustomCollectibles.RUBIKS_CUBE
		CustomData.Unlocks["21"]["Blue Baby"].SubType = CustomCollectibles.RED_BOMBER
		CustomData.Unlocks["22"]["Satan"].SubType = CustomCollectibles.CHERRY_FRIENDS
		CustomData.Unlocks["22"]["Isaac"].SubType = CustomCollectibles.COOKIE_CUTTER
		CustomData.Unlocks["22"]["Blue Baby"].SubType = CustomCollectibles.BLOOD_VESSELS[1]
		CustomData.Unlocks["23"]["Satan"].SubType = CustomCollectibles.MARK_OF_CAIN
		CustomData.Unlocks["23"]["Mom's Heart"].SubType = CustomCollectibles.RED_MAP
		CustomData.Unlocks["24"]["Satan"].SubType = CustomCollectibles.CEREMONIAL_BLADE
		CustomData.Unlocks["24"]["Isaac"].SubType = CustomCollectibles.BLACK_DOLL
		CustomData.Unlocks["25"]["Satan"].SubType = CustomCollectibles.BLESS_OF_THE_DEAD
		CustomData.Unlocks["25"]["Isaac"].SubType = CustomCollectibles.BAG_O_TRASH
		CustomData.Unlocks["25"]["Blue Baby"].SubType = CustomCollectibles.HAND_ME_DOWNS
		CustomData.Unlocks["26"]["Satan"].SubType = CustomCollectibles.BIRD_OF_HOPE
		CustomData.Unlocks["26"]["Isaac"].SubType = CustomCollectibles.TOWER_OF_BABEL
		CustomData.Unlocks["26"]["Blue Baby"].SubType = CustomCollectibles.ULTRA_FLESH_KID
		CustomData.Unlocks["27"]["Satan"].SubType = CustomCollectibles.TEMPER_TANTRUM
		CustomData.Unlocks["27"]["Isaac"].SubType = CustomCollectibles.GUSTY_BLOOD
		CustomData.Unlocks["27"]["Blue Baby"].SubType = CustomCollectibles.BOOK_OF_JUDGES
		CustomData.Unlocks["28"]["Satan"].SubType = CustomCollectibles.CROSS_OF_CHAOS
		CustomData.Unlocks["28"]["Isaac"].SubType = CustomCollectibles.SCALPEL
		CustomData.Unlocks["28"]["Blue Baby"].SubType = CustomCollectibles.BOOK_OF_LEVIATHAN
		CustomData.Unlocks["29"]["Satan"].SubType = CustomCollectibles.DNA_REDACTOR
		CustomData.Unlocks["29"]["Isaac"].SubType = CustomCollectibles.CAT_IN_A_BOX
		CustomData.Unlocks["29"]["Blue Baby"].SubType = CustomCollectibles.NERVE_PINCH
		CustomData.Unlocks["30"]["Satan"].SubType = CustomCollectibles.BOOK_OF_GENESIS
		CustomData.Unlocks["30"]["Isaac"].SubType = CustomCollectibles.MAGIC_PEN
		CustomData.Unlocks["30"]["Blue Baby"].SubType = CustomCollectibles.MAGIC_MARKER
		CustomData.Unlocks["31"]["Satan"].SubType = CustomCollectibles.CHERUBIM
		CustomData.Unlocks["31"]["Isaac"].SubType = CustomCollectibles.SOUL_BOND
		CustomData.Unlocks["31"]["Blue Baby"].SubType = CustomCollectibles.ANGELS_WINGS
		CustomData.Unlocks["32"]["Satan"].SubType = CustomCollectibles.REJECTION
		CustomData.Unlocks["32"]["Isaac"].SubType = CustomCollectibles.MOTHERS_LOVE
		CustomData.Unlocks["32"]["Blue Baby"].SubType = CustomCollectibles.FRIENDLY_SACK
		CustomData.Unlocks["33"]["Satan"].SubType = CustomCollectibles.TWO_PLUS_ONE
		CustomData.Unlocks["33"]["Isaac"].SubType = CustomCollectibles.AUCTION_GAVEL
		CustomData.Unlocks["33"]["Blue Baby"].SubType = CustomCollectibles.KEEPERS_PENNY
		CustomData.Unlocks["34"]["Satan"].SubType = CustomCollectibles.SINNERS_HEART
		CustomData.Unlocks["34"]["Isaac"].SubType = CustomCollectibles.BOTTOMLESS_BAG
		CustomData.Unlocks["34"]["Blue Baby"].SubType = CustomCollectibles.VAULT_OF_HAVOC
		CustomData.Unlocks["35"]["Satan"].SubType = CustomCollectibles.ENRAGED_SOUL
		CustomData.Unlocks["35"]["Isaac"].SubType = CustomCollectibles.PURE_SOUL
		CustomData.Unlocks["35"]["Blue Baby"].SubType = CustomCollectibles.HANDICAPPED_PLACARD
		CustomData.Unlocks["36"]["Satan"].SubType = CustomCollectibles.CEILING_WITH_THE_STARS
		CustomData.Unlocks["36"]["Isaac"].SubType = CustomCollectibles.QUASAR
		CustomData.Unlocks["36"]["Blue Baby"].SubType = CustomCollectibles.STARGAZERS_HAT
		CustomData.Unlocks["37"]["Mom's Heart"].SubType = CustomCollectibles.SIBLING_RIVALRY
		CustomData.Unlocks["37"]["Satan"].SubType = CustomCollectibles.CHEESE_GRATER
		CustomData.Unlocks["37"]["Isaac"].SubType = CustomCollectibles.RED_KING
		CustomData.Unlocks["37"]["Blue Baby"].SubType = CustomCollectibles.TANK_BOYS

		-- Trinkets
		CustomData.Unlocks["21"]["Mom's Heart"].SubType = CustomTrinkets.BASEMENT_KEY
		CustomData.Unlocks["22"]["Mom's Heart"].SubType = CustomTrinkets.KEY_TO_THE_HEART
		CustomData.Unlocks["23"]["Isaac"].SubType = CustomTrinkets.TRICK_PENNY
		CustomData.Unlocks["23"]["Blue Baby"].SubType = CustomTrinkets.SLEIGHT_OF_HAND
		CustomData.Unlocks["24"]["Blue Baby"].SubType = CustomTrinkets.JUDAS_KISS
		CustomData.Unlocks["24"]["Mom's Heart"].SubType = CustomTrinkets.KEY_KNIFE
		CustomData.Unlocks["25"]["Mom's Heart"].SubType = CustomTrinkets.NIGHT_SOIL
		CustomData.Unlocks["26"]["Mom's Heart"].SubType = CustomTrinkets.ADAMS_RIB
		CustomData.Unlocks["27"]["Mom's Heart"].SubType = CustomTrinkets.MAGIC_SWORD
		CustomData.Unlocks["28"]["Mom's Heart"].SubType = CustomTrinkets.ANGELS_CROWN
		CustomData.Unlocks["29"]["Mom's Heart"].SubType = CustomTrinkets.TORN_PAGE
		CustomData.Unlocks["30"]["Mom's Heart"].SubType = CustomTrinkets.EDENS_LOCK
		CustomData.Unlocks["31"]["Mom's Heart"].SubType = CustomTrinkets.PIECE_OF_CHALK
		CustomData.Unlocks["32"]["Mom's Heart"].SubType = CustomTrinkets.BABY_SHOES
		CustomData.Unlocks["33"]["Mom's Heart"].SubType = CustomTrinkets.GREEDS_HEART
		CustomData.Unlocks["34"]["Mom's Heart"].SubType = CustomTrinkets.SHATTERED_STONE
		CustomData.Unlocks["35"]["Mom's Heart"].SubType = CustomTrinkets.BONE_MEAL
		CustomData.Unlocks["36"]["Mom's Heart"].SubType = CustomTrinkets.EMPTY_PAGE

		-- Cards
		CustomData.Unlocks["21"]["Boss Rush"].SubType = CustomConsumables.UNO_REVERSE_CARD
		CustomData.Unlocks["21"]["Greed"].SubType = CustomConsumables.SPINDOWN_DICE_SHARD
		CustomData.Unlocks["22"]["Boss Rush"].SubType = CustomConsumables.QUEEN_OF_DIAMONDS
		CustomData.Unlocks["22"]["Greed"].SubType = CustomConsumables.NEEDLE_AND_THREAD
		CustomData.Unlocks["23"]["Boss Rush"].SubType = CustomConsumables.JACK_OF_DIAMONDS
		CustomData.Unlocks["23"]["Greed"].SubType = CustomConsumables.BAG_TISSUE
		CustomData.Unlocks["24"]["Boss Rush"].SubType = CustomConsumables.JACK_OF_HEARTS
		CustomData.Unlocks["24"]["Greed"].SubType = CustomConsumables.SACRIFICIAL_BLOOD
		CustomData.Unlocks["25"]["Boss Rush"].SubType = CustomConsumables.FLY_PAPER
		CustomData.Unlocks["26"]["Boss Rush"].SubType = CustomConsumables.BEDSIDE_QUEEN
		CustomData.Unlocks["27"]["Boss Rush"].SubType = CustomConsumables.JACK_OF_CLUBS
		CustomData.Unlocks["28"]["Boss Rush"].SubType = CustomConsumables.JOKER_Q
		CustomData.Unlocks["28"]["Greed"].SubType = CustomConsumables.DEMON_FORM
		CustomData.Unlocks["29"]["Boss Rush"].SubType = CustomConsumables.JACK_OF_SPADES
		CustomData.Unlocks["30"]["Boss Rush"].SubType = CustomConsumables.VALENTINES_CARD
		CustomData.Unlocks["30"]["Greed"].SubType = CustomConsumables.MIRRORED_LANDSCAPE
		CustomData.Unlocks["31"]["Boss Rush"].SubType = CustomConsumables.CURSED_CARD
		CustomData.Unlocks["31"]["Greed"].SubType = CustomConsumables.SPIRITUAL_RESERVES
		CustomData.Unlocks["32"]["Boss Rush"].SubType = CustomConsumables.QUEEN_OF_CLUBS
		CustomData.Unlocks["32"]["Greed"].SubType = CustomConsumables.MOMS_ID
		CustomData.Unlocks["33"]["Boss Rush"].SubType = CustomConsumables.KING_OF_DIAMONDS
		CustomData.Unlocks["33"]["Greed"].SubType = CustomConsumables.LOADED_DICE
		CustomData.Unlocks["34"]["Boss Rush"].SubType = CustomConsumables.KING_OF_SPADES
		CustomData.Unlocks["34"]["Greed"].SubType = CustomConsumables.RED_RUNE
		CustomData.Unlocks["35"]["Boss Rush"].SubType = CustomConsumables.KING_OF_CLUBS
		CustomData.Unlocks["35"]["Greed"].SubType = CustomConsumables.FUNERAL_SERVICES
		CustomData.Unlocks["36"]["Boss Rush"].SubType = CustomConsumables.LIBRARY_CARD
		CustomData.Unlocks["36"]["Greed"].SubType = CustomConsumables.QUASAR_SHARD
		CustomData.Unlocks["37"]["Boss Rush"].SubType = CustomConsumables.BUSINESS_CARD
		CustomData.Unlocks["37"]["Greed"].SubType = CustomConsumables.ANTIMATERIAL_CARD

		-- Pills
		CustomData.Unlocks["25"]["Greed"].SubType = CustomPills.LAXATIVE
		CustomData.Unlocks["26"]["Greed"].SubType = CustomPills.ESTROGEN_UP
		CustomData.Unlocks["27"]["Greed"].SubType = CustomPills.PHANTOM_PAINS
		CustomData.Unlocks["29"]["Greed"].SubType = CustomPills.YUCK

		-- create new data entry for CustomData table
		CustomData.Data = {
			Items = {
				RUBIKS_CUBE = {counter = 0},
				BIRD_OF_HOPE = {numRevivals = 0, birdCaught = false, catchingBird = false, dieFrame = nil, diePos = nil},
				BLACK_DOLL = {entitiesGroupA = {}, entitiesGroupB = {}},
				DNA_REDACTOR = {whitePillUsed = 0},
				RED_MAP = {shownOnFloorOne = false},
				TWO_PLUS_ONE = {isEffectActive = false, itemsBought = 0},
				STARGAZERS_HAT = {usedOnFloor = false},
				MOTHERS_LOVE = {soulDrop = false, numStats = 0, numFriends = 0},
				BLOOD_VESSEL = {preventDmgLoop = false},
				RED_KING = {redCrawlspacesData = {}},
				MAGIC_MARKER = {cardDrop = false},
				VAULT_OF_HAVOC = {enemyList = {}, isInVaultRoom = false, sumHp = 0, spawnedEnemies = false},
				PURE_SOUL = {isPortalSuperSecret = false},
				BOOK_OF_JUDGES = {beamTargets = {}, noBeams = false},
				BOOK_OF_LEVIATHAN_OPEN = {stopDebug = false},
				WE_NEED_TO_GO_SIDEWAYS = {numStoredKeys = 0}
			},
			Cards = {
				jackPickupType = nil,
				JOKER_Q = {isCardMarket = false}
			},
			Trinkets = {
				GREEDS_HEART = "CoinHeartEmpty",
				ANGELS_CROWN = {treasureRoomsData = {{index = -1, needToConvert = false},
												     {index = -1, needToConvert = false}}}
			},
			NumTaintedRocks = 0,
			FleshChestConsumedHP = 0,
			ErasedEnemies = {},
			pillReplacements = {}
		}

		if CustomData and CustomData.Data and CustomData.Unlocks and CustomData.DssSettings then
			if FLAG_PRINT_INIT_MESSAGE then
				print("Repentance Plus mod v" .. MOD_VERSION .. " initialized. For helper functions, type `rplus_help`")
				FLAG_PRINT_INIT_MESSAGE = false
			end
		else
			if not CustomData.Unlocks then
				print("[ERR] Something went wrong! Unlocks table is missing! Resetting!")
				CustomData.Unlocks = MOD_UNLOCKS_TABLE
			elseif not CustomData.DssSettings then
				CustomData.DssSettings = {}
			end
		end

		-- Loading menus:
		-- MOD CONFIG MENU
		if ModConfigMenu and FLAG_CONNECT_MCM then
			local modName = "Repentance Plus"

			ModConfigMenu.UpdateCategory(modName, {
				Info = {"Repentance Plus Unlocks",}
			})

			for id = 21, 37 do
				local characterName = playerTypeToName[id]
				ModConfigMenu.AddSpace(modName, characterName)
				for _, m in pairs(bossMarks) do
					ModConfigMenu.AddSetting(modName, characterName,
						{
							Type = ModConfigMenu.OptionType.BOOLEAN,
							CurrentSetting = function()
								return CustomData.Unlocks[tostring(id)][m].Unlocked
							end,
							Display = function()
								local val = "Locked"
								if CustomData.Unlocks[tostring(id)][m].Unlocked then
									val = "Unlocked"
								end
								return tostring(m) .. ": " .. val
							end,
							OnChange = function(newVal)
								CustomData.Unlocks[tostring(id)][m].Unlocked = newVal
							end,
							Info = {"Unlocks"},
						}
					)
				end
			end

			ModConfigMenu.AddSpace(modName, "Special")
			for _, m in pairs({"Black Chest", "Scarlet Chest", "Flesh Chest", "Coffin", "Stargazer", "Tainted Rocks", "Birth Certificate"}) do
					ModConfigMenu.AddSetting(modName, "Special",
						{
							Type = ModConfigMenu.OptionType.BOOLEAN,
							CurrentSetting = function()
								return CustomData.Unlocks["Special"][m].Unlocked
							end,
							Display = function()
								local val = "Locked"
								if CustomData.Unlocks["Special"][m].Unlocked then
									val = "Unlocked"
								end
								return tostring(m) .. ": " .. val
							end,
							OnChange = function(newVal)
								CustomData.Unlocks["Special"][m].Unlocked = newVal
							end,
							Info = {"Unlocks"},
						}
					)
			end

			FLAG_CONNECT_MCM = false
		end
		-- End loading menus

		-- Processing custom challenges
		local p = Isaac.GetPlayer(0)
		if Isaac.GetChallenge() == CustomChallenges.JUDGEMENT then
			p:AddCollectible(CustomCollectibles.BOOK_OF_JUDGES)
			p:AddCollectible(CustomCollectibles.CHERUBIM)
		elseif Isaac.GetChallenge() == CustomChallenges.BLOOD then
			p:AddCollectible(CustomCollectibles.CEREMONIAL_BLADE)
		elseif Isaac.GetChallenge() == CustomChallenges.IN_THE_LIGHT then
			p:AddCollectible(CustomCollectibles.ANGELS_WINGS)
		end

		-- Re-evaluating cache, just in case
		for i = 0, game:GetNumPlayers() - 1 do
			local Player = Isaac.GetPlayer(i)
			Player:AddCacheFlags(CacheFlag.CACHE_ALL)
			Player:EvaluateItems()
		end
	else
		-- load CustomData into a continued run
		Isaac.DebugString("[REP PLUS] Loading custom mod data from source...")
		CustomData = json.decode(Isaac.LoadModData(rplus))
	end

	-- Birth Certificate unlock
	if checkAllMarks(false, false) and not isMarkUnlocked("Special", "Birth Certificate") then
		unlockMark("Special", "Birth Certificate")
		playAchievementPaper("Special", "Birth Certificate")
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, rplus.OnGameStart)


						-- MC_PRE_GAME_EXIT --						
						----------------------
function rplus:PreGameExit(ShouldSave)
	-- save CustomData regardless of whether you should save on exit or not
	Isaac.DebugString("[REP PLUS] Saving custom mod data to source...")
	Isaac.SaveModData(rplus, json.encode(CustomData, "CustomData"))
	delayedSounds = {}
end
rplus:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, rplus.PreGameExit)


						-- MC_POST_GAME_END --										
						----------------------
function rplus:GameEnded(isGameOver)
	local maxID = Isaac.GetItemConfig():GetCollectibles().Size - 1
	HAND_ME_DOWNS_GAMEOVER.Items = {}
    for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		if Player:HasCollectible(CustomCollectibles.HAND_ME_DOWNS) then
			HAND_ME_DOWNS_GAMEOVER.Stage = game:GetLevel():GetStage()
			rng:SetSeed(Random() + 1, 1)
			local freezePreventChecker = 0

			repeat
				local roll = rng:RandomInt(maxID) + 1
				freezePreventChecker = freezePreventChecker + 1

				if Player:HasCollectible(roll)
				and Isaac.GetItemConfig():GetCollectible(roll).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
				and roll ~= CustomCollectibles.HAND_ME_DOWNS then
					table.insert(HAND_ME_DOWNS_GAMEOVER.Items, roll)
				end
			until #HAND_ME_DOWNS_GAMEOVER.Items == 3 or freezePreventChecker == 1000
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_GAME_END, rplus.GameEnded)


						-- MC_EXECUTE_CMD --											
						--------------------
function rplus:OnCommandExecute(command, args)
	if command == 'hide' then
		FLAG_HIDE_ERROR_MESSAGE = true
		print('Error message hidden. To see it again, type `show` into the console')
	elseif command == 'show' then
		FLAG_HIDE_ERROR_MESSAGE = false
	end

	if command == "customhearts_none" then
		FLAG_NO_TAINTED_HEARTS = true
		print('No more hearts from Repentance Plus mod! To see them again, type `customhearts_all` into the console')
	elseif command == "customhearts_all" then
		FLAG_NO_TAINTED_HEARTS = false
		print('Tainted hearts are back! To prevent them from spawning, type `customhearts_none` into the console')
	end

	if command == "rplus_version" then
		print("The current version is: " .. MOD_VERSION .. ". Thanks for playing! :)")
	end

	if command == "rplus_unlockall" then
		unlockAll()
	elseif command == "rplus_unlockspecials" then
		unlockSpecials()
	elseif command == "rplus_checkmarks" then
		checkAllMarks(true, true)
	elseif command == "rplus_unlockhearts" then
		unlockHearts()
	elseif command == "rplus_reset" then
		print("Progress succesfully reset.")
		CustomData.Unlocks = MOD_UNLOCKS_TABLE
	end

	if command == "rplus_help" then
		print("COMMANDS PROVIDED BY REPENTANCE PLUS MOD:")
		print("customhearts_none: prevents ALL Tainted hearts from spawning")
		print("customhearts_all: allows Tainted hearts to be spawned again")
		print("rplus_version: gets version of currently running mod")
		print("rplus_unlockall: unlocks ALL marks")
		print("rplus_unlockspecials: unlocks SPECIAL marks (not tied to characters)")
		print("rplus_unlockhearts: unlocks all Tainted hearts")
		print("rplus_checkmarks: lists which marks haven't been unlocked yet")
		print("rplus_reset: resets your current unlocks progress")
	end

	--! TEST (DEBUG) COMMAND
	-- basically a more elaborate version of `macro qk`
	if command == "rplus_debug" then
		Isaac.ExecuteCommand("g glowing")
		Isaac.ExecuteCommand("macro qk")
		Isaac.ExecuteCommand("g k5")
	end
end
rplus:AddCallback(ModCallbacks.MC_EXECUTE_CMD, rplus.OnCommandExecute)


						-- MC_POST_NEW_LEVEL --										
						-----------------------
function rplus:OnNewLevel()
	if not CustomData.Data then return end
	local level = game:GetLevel()
	rng:SetSeed(Random() + 1, 1)

	CustomData.Data.Items.PURE_SOUL.isPortalSuperSecret = false
	if rng:RandomFloat() < 0.5 then
		CustomData.Data.Items.PURE_SOUL.isPortalSuperSecret = true
	end
	CustomData.Data.Cards.jackPickupType = nil
	CustomData.Data.NumTaintedRocks = 0
	CustomData.Data.Items.WE_NEED_TO_GO_SIDEWAYS.numStoredKeys = 0
	CustomData.Data.Items.STARGAZERS_HAT.usedOnFloor = false
	CustomData.Data.Items.RED_KING.redCrawlspacesData = {}
	CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData = {{index = -1, needToConvert = false},
														  		{index = -1, needToConvert = false}}
	CustomData.Data.Items.VAULT_OF_HAVOC.enemyList = {}
	CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive = false

	if HAND_ME_DOWNS_GAMEOVER.Stage == level:GetStage() then
		for _, item in pairs(HAND_ME_DOWNS_GAMEOVER.Items) do
			Isaac.Spawn(5, 100, item, game:GetRoom():FindFreePickupSpawnPosition(Vector(300, 200)), Vector.Zero, nil):ToPickup()
		end
		HAND_ME_DOWNS_GAMEOVER.Stage = 0
		HAND_ME_DOWNS_GAMEOVER.Items = {}
	end

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL) then
			Player:GetEffects():RemoveCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.DEMON_FORM_NULL))
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			Player:EvaluateItems()
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.HARLOT_FETUS) then
			Player:GetEffects():RemoveCollectibleEffect(CustomCollectibles.HARLOT_FETUS, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.HARLOT_FETUS))
			Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
		end

		if Player:GetData().tornPageSatanicBible then
			Player:GetData().tornPageSatanicBible = false
		end

		if Player:HasCollectible(CustomCollectibles.CEILING_WITH_THE_STARS)
		and not level:IsAscent() then
			for _ = 1, 2 do
				local newID = GetUnlockedVanillaCollectible(false, false)
				Player:AddItemWisp(newID, Player.Position, true)
			end

			if Player:HasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
				for _ = 1, 3 do
					Player:AddWisp(1, Player.Position, true, false)
				end
			end
		end

		if Player:HasCollectible(CustomCollectibles.TWO_PLUS_ONE) then
			CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive = true

			CustomData.Data.Items.TWO_PLUS_ONE.itemsBought = 0
		end

		if Player:HasTrinket(CustomTrinkets.BONE_MEAL) then
			Player:GetEffects():AddTrinketEffect(CustomTrinkets.BONE_MEAL, false, Player:GetTrinketMultiplier(CustomTrinkets.BONE_MEAL))
			Player:UsePill(PillEffect.PILLEFFECT_LARGER, PillColor.PILL_NULL, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
		end

		if Player:HasCollectible(CustomCollectibles.KEEPERS_PENNY) then
			Isaac.Spawn(5, 20, CoinSubType.COIN_GOLDEN, Vector(320, 320), Vector.Zero, Player)
		end
	end

	for _, bag in pairs(Isaac.FindByType(3, CustomFamiliars.BAG_O_TRASH)) do
		bag:GetData().Levels = bag:GetData().Levels + 1
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, rplus.OnNewLevel)


						-- MC_POST_NEW_ROOM --										
						----------------------
function rplus:OnNewRoom()
	local level = game:GetLevel()
	local room = game:GetRoom()
	local roomtype = room:GetType()

	-- unlocks for entering certain room types
	if room:IsFirstVisit() then
		if roomtype == RoomType.ROOM_SECRET and not isMarkUnlocked("Special", "Coffin") then
			CustomData.Unlocks["Special"]["Coffin"].num = CustomData.Unlocks["Special"]["Coffin"].num + 1
			if CustomData.Unlocks["Special"]["Coffin"].num == CustomData.Unlocks["Special"]["Coffin"].requiredNum then
				unlockMark("Special", "Coffin")
				playAchievementPaper("Special", "Coffin")
			end
		elseif roomtype == RoomType.ROOM_PLANETARIUM and not isMarkUnlocked("Special", "Stargazer") then
			CustomData.Unlocks["Special"]["Stargazer"].num = CustomData.Unlocks["Special"]["Stargazer"].num + 1
			if CustomData.Unlocks["Special"]["Stargazer"].num == CustomData.Unlocks["Special"]["Stargazer"].requiredNum then
				unlockMark("Special", "Stargazer")
				playAchievementPaper("Special", "Stargazer")
			end
		elseif roomtype == RoomType.ROOM_ULTRASECRET and not isMarkUnlocked("Special", "Scarlet Chest") then
			CustomData.Unlocks["Special"]["Scarlet Chest"].num = CustomData.Unlocks["Special"]["Scarlet Chest"].num + 1
			if CustomData.Unlocks["Special"]["Scarlet Chest"].num == CustomData.Unlocks["Special"]["Scarlet Chest"].requiredNum then
				unlockMark("Special", "Scarlet Chest")
				playAchievementPaper("Special", "Scarlet Chest")
			end
		elseif roomtype == RoomType.ROOM_DEVIL and not isMarkUnlocked("Special", "Black Chest") then
			CustomData.Unlocks["Special"]["Black Chest"].num = CustomData.Unlocks["Special"]["Black Chest"].num + 1
			if CustomData.Unlocks["Special"]["Black Chest"].num == CustomData.Unlocks["Special"]["Black Chest"].requiredNum then
				unlockMark("Special", "Black Chest")
				playAchievementPaper("Special", "Black Chest")
			end
		elseif roomtype == RoomType.ROOM_CURSE and not isMarkUnlocked("Special", "Flesh Chest") then
			CustomData.Unlocks["Special"]["Flesh Chest"].num = CustomData.Unlocks["Special"]["Flesh Chest"].num + 1
			if CustomData.Unlocks["Special"]["Flesh Chest"].num == CustomData.Unlocks["Special"]["Flesh Chest"].requiredNum then
				unlockMark("Special", "Flesh Chest")
				playAchievementPaper("Special", "Flesh Chest")
			end
		elseif roomtype == RoomType.ROOM_SUPERSECRET and not isMarkUnlocked("Special", "Tainted Rocks") then
			CustomData.Unlocks["Special"]["Tainted Rocks"].num = CustomData.Unlocks["Special"]["Tainted Rocks"].num + 1
			if CustomData.Unlocks["Special"]["Tainted Rocks"].num == CustomData.Unlocks["Special"]["Tainted Rocks"].requiredNum then
				unlockMark("Special", "Tainted Rocks")
				playAchievementPaper("Special", "Tainted Rocks")
			end
		end
	end
	--

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		if Player:HasCollectible(CustomCollectibles.ORDINARY_LIFE) and room:GetType() == RoomType.ROOM_TREASURE
		and room:IsFirstVisit() and not room:IsMirrorWorld() then
			local momNDadItem = Isaac.Spawn(5, 100, GetUnlockedCollectibleFromCustomPool(CustomItempools.MOM_AND_DAD), room:FindFreePickupSpawnPosition(Vector(320,280), 1, true, false), Vector.Zero, nil):ToPickup()

			momNDadItem.OptionsPickupIndex = 3
			for _, entity in pairs(Isaac.FindByType(5, 100)) do
				entity:ToPickup().OptionsPickupIndex = 3
			end
		end

		if Player:HasCollectible(CustomCollectibles.BLACK_DOLL) and room:IsFirstVisit() and Isaac.CountEnemies() > 1 then
			local sep = math.floor(Isaac.CountEnemies() / 2)
			CustomData.Data.Items.BLACK_DOLL.entitiesGroupA = {}
			CustomData.Data.Items.BLACK_DOLL.entitiesGroupB = {}
			local count = 0

			for _, entity in pairs(Isaac.GetRoomEntities()) do
				if entity:IsActiveEnemy(false) and not entity:IsBoss()
				and entity:IsVulnerableEnemy() then
					count = count + 1
					if count <= sep then
						table.insert(CustomData.Data.Items.BLACK_DOLL.entitiesGroupA, entity)
					else
						table.insert(CustomData.Data.Items.BLACK_DOLL.entitiesGroupB, entity)
					end
				end
			end
		end

		if roomtype == RoomType.ROOM_TREASURE and not room:IsMirrorWorld() then
			if room:IsFirstVisit() then
				if CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[1].index == -1 then
					CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[1].index = level:GetCurrentRoomDesc().ListIndex
				else
					CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[2].index = level:GetCurrentRoomDesc().ListIndex
				end

				for i = 1, 2 do
					if level:GetCurrentRoomDesc().ListIndex == CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[i].index then
						if Player:HasTrinket(CustomTrinkets.ANGELS_CROWN)
						and not Player:HasTrinket(TrinketType.TRINKET_DEVILS_CROWN) then
							CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[i].needToConvert = true

							for _, collectible in pairs(Isaac.FindByType(5, 100, -1, false, false)) do
								local cP = collectible:ToPickup()
								local newSubtype = game:GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL)
								cP:Morph(5, 100, newSubtype, false, false, false)
								cP.ShopItemId = -777
								if Isaac.GetItemConfig():GetCollectible(newSubtype).Quality == 4 then
									cP.Price = Player:GetTrinketMultiplier(CustomTrinkets.ANGELS_CROWN) > 1 and 15 or 30
								else
									cP.Price = Player:GetTrinketMultiplier(CustomTrinkets.ANGELS_CROWN) > 1 and 7 or 15
								end
								cP.AutoUpdatePrice = false
							end
						else
							CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[i].needToConvert = false
						end
					end
				end
			end

			for i = 1, 2 do
				if level:GetCurrentRoomDesc().ListIndex == CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[i].index
				and CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData[i].needToConvert then
					makeRoomAngelShop(room)
				end
			end
		end

		if Player:HasCollectible(CustomCollectibles.GUSTY_BLOOD) then
			Player:GetEffects():RemoveCollectibleEffect(CustomCollectibles.GUSTY_BLOOD, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.GUSTY_BLOOD))
			Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			Player:EvaluateItems()
		end

		if Player:HasCollectible(CustomCollectibles.KEEPERS_PENNY) and room:GetType() == RoomType.ROOM_SHOP
		and room:IsFirstVisit() and not room:IsMirrorWorld() and #Isaac.FindByType(EntityType.ENTITY_GREED, -1, -1, false, true) == 0 then
			rng:SetSeed(Random() + 1, 1)
			local numNewItems = rng:RandomInt(4) + 1
			local V = {}

			if numNewItems == 1 then
				V = {Vector(320, 280)}
			elseif numNewItems == 2 then
				V = {Vector(160, 280), Vector(480, 280)}
			elseif numNewItems == 3 then
				V = {Vector(320, 280), Vector(160, 280), Vector(480, 280)}
			else
				V = {Vector(160, 280), Vector(480, 280), Vector(120, 360), Vector(520, 360)}
			end

			for i = 1, numNewItems do
				local KEEPERS_PENNY_ITEMPOOLS = {
					ItemPoolType.POOL_TREASURE,
					ItemPoolType.POOL_BOSS,
					ItemPoolType.POOL_SHOP
				}
				local roll = rng:RandomInt(3) + 1
				local pool = KEEPERS_PENNY_ITEMPOOLS[roll]
				local item = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(pool, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), V[i], Vector.Zero, nil):ToPickup()
				item.Price = 15
				item.ShopItemId = -11 * i
			end
		end

		if Player:GetData().tornPageBookOfBelial then
			Player:GetData().tornPageBookOfBelial = false
			Player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
			Player:EvaluateItems()
		end

		if Player:GetData().usedCursedCard then
			Player:GetData().usedCursedCard = false
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.LOADED_DICE_NULL) then
			Player:GetEffects():RemoveCollectibleEffect(CustomCollectibles.LOADED_DICE_NULL, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.LOADED_DICE_NULL))
			Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
			Player:EvaluateItems()
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL)
		and not room:IsClear() and room:IsFirstVisit() then
			if Player.Damage <= 2 then
				Player:GetEffects():AddCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL, false, room:GetType() == RoomType.ROOM_BOSS and 5 or 1)	--* 1 effect is HALF the damage boost
			elseif Player.Damage >= 15 then
				Player:GetEffects():AddCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL, false, room:GetType() == RoomType.ROOM_BOSS and 40 or 8)
			else
				Player:GetEffects():AddCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL, false, room:GetType() == RoomType.ROOM_BOSS and 10 or 2)
			end
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			Player:EvaluateItems()
		end

		if Player:GetData().RejectionUsed == false then
			Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			Player:EvaluateItems()
		end

		if Player:GetData().isFlowerOfLustExtraReward then
			Player:GetData().isFlowerOfLustExtraReward = nil
		end

		if Player:HasCollectible(CustomCollectibles.PURE_SOUL) then
			local sinToAnim = {
				[EntityType.ENTITY_SLOTH] = "Sloth",
				[EntityType.ENTITY_LUST] = "Lust",
				[EntityType.ENTITY_WRATH] = "Wrath",
				[EntityType.ENTITY_GLUTTONY] = "Gluttony",
				[EntityType.ENTITY_GREED] = "Greed",
				[EntityType.ENTITY_ENVY] = "Envy",
				[EntityType.ENTITY_PRIDE] = "Pride"
			}

			if room:IsFirstVisit() and (room:GetType() == RoomType.ROOM_SUPERSECRET and CustomData.Data.Items.PURE_SOUL.isPortalSuperSecret
			or room:GetType() == RoomType.ROOM_SECRET and not CustomData.Data.Items.PURE_SOUL.isPortalSuperSecret) then
				rng:SetSeed(Random() + 1, 1)
				local sinType = rng:RandomInt(7) + EntityType.ENTITY_SLOTH
				local sinVariant = rng:RandomInt(2)

				local soul = Isaac.Spawn(1000, HelperEffects.PURE_SOUL_GHOST, 0, room:FindFreePickupSpawnPosition(Vector(400, 280), 10, true, false), Vector.Zero, Player)
				soul:GetSprite():Play(sinToAnim[sinType] .. "_" .. sinVariant)
				Player:GetData().PureSoulSin = {sinType, sinVariant}
			end

			for i = 0, 7 do
				if room:GetDoor(i) and room:GetDoor(i).TargetRoomType == RoomType.ROOM_MINIBOSS then
					local soul = Isaac.Spawn(1000, HelperEffects.PURE_SOUL_GHOST, 1, room:GetDoorSlotPosition(i), Vector.Zero, nil)
					local index = room:GetDoor(i).TargetRoomIndex
					local targetRoom = level:GetRoomByIdx(index, -1)
					local spawns = targetRoom.Data.Spawns

					for n = 0, #spawns - 1 do
						local entry = spawns:Get(n):PickEntry(0)

						if sinToAnim[entry.Type] then
							soul:GetSprite():Play(sinToAnim[entry.Type] .. "_" .. entry.Variant)
						end
					end

				end
			end
		end

		if Player:HasCollectible(CustomCollectibles.BOOK_OF_JUDGES) then
			CustomData.Data.Items.BOOK_OF_JUDGES.noBeams = false

			if room:IsFirstVisit() and not room:IsClear() then
				createBookOfJudgesCrosshairs(room)
			end
		end

		if Player:HasCollectible(CustomCollectibles.CEILING_WITH_THE_STARS)
		and level:IsAscent() and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex()
		and room:IsFirstVisit() then
			local newID = GetUnlockedVanillaCollectible(false, false)
			Player:AddItemWisp(newID, Player.Position, true)
		end

		if Player:HasTrinket(CustomTrinkets.CRACKED_CROSS)
		and not room:IsClear() then
			local enemies = Isaac.GetRoomEntities()
			rng:SetSeed(Random() + 1, 1)
			local c = 0
			local e = 0
			while c < Player:GetTrinketMultiplier(CustomTrinkets.CRACKED_CROSS) and e < 1000 do
				local enemy = enemies[rng:RandomInt(#enemies) + 1]
				if crippleEnemy(enemy) then
					c = c + 1
				end
				e = e + 1
			end
		end

		if Player:HasTrinket(CustomTrinkets.HEAVENLY_KEYS)
		and level:GetStage() == LevelStage.STAGE6 and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex()
		and room:IsFirstVisit() then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, false, true, true, false, -1)
		end

		if Player:HasCollectible(CustomCollectibles.WE_NEED_TO_GO_SIDEWAYS) then
			if room:IsFirstVisit() and room:GetType() == RoomType.ROOM_SECRET then
				local dirtPatch = Isaac.Spawn(
					1000,
					EffectVariant.DIRT_PATCH,
					1,
					room:FindFreePickupSpawnPosition(Vector(240, 280), 10, true, false),
					Vector.Zero,
					Player
				)
			end
		end

		if Player:GetData().heldSkeleton then
			Player:AnimateCollectible(CustomCollectibles.DEAD_WEIGHT_HELD_SKELETON, "LiftItem", "PlayerPickupSparkle")
		end
	end

	if CustomData.Data then
		if CustomData.Data.Items.BOOK_OF_LEVIATHAN_OPEN.stopDebug then
			CustomData.Data.Items.BOOK_OF_LEVIATHAN_OPEN.stopDebug = false
			Isaac.ExecuteCommand("debug 10")
		end

		-- 2+1
		if CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive
		and CustomData.Data.Items.TWO_PLUS_ONE.itemsBought == 0 then
			for _, p in pairs(Isaac.FindByType(5)) do
				p:ToPickup().AutoUpdatePrice = p:ToPickup().Price == 1
			end
		end

		-- handle red crawlspaces spawned by Red King item
		for _, r in pairs(Isaac.FindByType(6, CustomSlots.SLOT_RED_KING_CRAWLSPACE, -1, false, false)) do
			if r.SubType == 0 then
				for i, v in pairs(CustomData.Data.Items.RED_KING.redCrawlspacesData) do
					if r.InitSeed == v.seed and v.isRoomDefeated then
						r.SubType = 1
						r:GetSprite():Play("Closed")
						r.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					end
				end
			else
				r:GetSprite():Play("Closed")
				r.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			end
			r.DepthOffset = -100
		end

		-- handle Vault of Havoc rooms
		if CustomData.Data.Items.VAULT_OF_HAVOC.isInVaultRoom then
			hud:ShowItemText("Isaac vs The Vault", "")
			-- turning placeholders (black flies) from BR into stored enemies
			for i, placeholder in pairs(Isaac.FindByType(13, 0, 0, false, false)) do
				placeholder:Remove()
				local enemyID = #CustomData.Data.Items.VAULT_OF_HAVOC.enemyList - i + 1
				if enemyID > 0 then
					local enemy = CustomData.Data.Items.VAULT_OF_HAVOC.enemyList[enemyID]
					Isaac.Spawn(enemy.Type, enemy.Variant, enemy.SubType, placeholder.Position, Vector.Zero, nil)
					CustomData.Data.Items.VAULT_OF_HAVOC.sumHp = CustomData.Data.Items.VAULT_OF_HAVOC.sumHp + enemy.MaxHitPoints
				end
			end

			CustomData.Data.Items.VAULT_OF_HAVOC.spawnedEnemies = true
			CustomData.Data.Items.VAULT_OF_HAVOC.enemyList = {}
		elseif CustomData.Data.Items.VAULT_OF_HAVOC.spawnedEnemies then
			CustomData.Data.Items.VAULT_OF_HAVOC.isInVaultRoom = false
			CustomData.Data.Items.VAULT_OF_HAVOC.sumHp = 0
			CustomData.Data.Items.VAULT_OF_HAVOC.spawnedEnemies = false
		end

		-- spawn The Fool card in black markets teleported to by Joker? on final floors
		if room:GetType() == RoomType.ROOM_BLACK_MARKET
		and CustomData.Data.Cards.JOKER_Q.isCardMarket then
			CustomData.Data.Cards.JOKER_Q.isCardMarket = false
			Isaac.Spawn(5, 300, Card.CARD_FOOL, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40, false, false), Vector.Zero, nil)
		end
	end

	-- Reset contact damage of Keeper's Annoying Fly
	for _, KAF in pairs(Isaac.FindByType(3, CustomFamiliars.KEEPERS_ANNOYING_FLY)) do
		KAF.CollisionDamage = 1.5
	end

	-- Handle turning placeholder (Rules Cards) from BR into modded pickups
	for _, placeholder in pairs(Isaac.FindByType(5, 300, Card.CARD_RULES, false, false)) do
		local var = level:GetCurrentRoomDesc().Data.Variant
		local rtype = room:GetType()

		if (var == 19245 and rtype == RoomType.ROOM_ERROR)
		or (var == 2929 and rtype == RoomType.ROOM_SECRET) then
			placeholder:ToPickup():Morph(5, 300, CustomConsumables.BAG_TISSUE, true, true, true)
		elseif (rtype == RoomType.ROOM_ARCADE and var >= 2388 and var <= 2391) then
			placeholder:ToPickup():Morph(5, 300, CustomConsumables.LOADED_DICE, true, true, true)
		elseif (rtype == RoomType.ROOM_LIBRARY and var >= 7839 and var <= 7845) then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100

			if roll < 50 then
				placeholder:ToPickup():Morph(5, 350, CustomTrinkets.EMPTY_PAGE, true, true, true)
			else
				placeholder:ToPickup():Morph(5, 350, CustomTrinkets.TORN_PAGE, true, true, true)
			end
		elseif rtype == RoomType.ROOM_SUPERSECRET then
			if var == 4382 or var == 4383 then
				placeholder:ToPickup():Morph(5, 300, CustomConsumables.MIRRORED_LANDSCAPE, true, true, true)
			elseif var == 4384 then
				placeholder:ToPickup():Morph(5, 300, CustomConsumables.SPIRITUAL_RESERVES, true, true, true)
			end
		end
	end

	-- handle Tainted rocks placement
	if level:GetStage() ~= LevelStage.STAGE7 then
		-- setting the variant
		for ind = 1, room:GetGridSize() do
			local gridEnt = room:GetGridEntity(ind)

			if gridEnt and gridEnt:GetType() == GridEntityType.GRID_ROCK_SPIKED then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 100

				if roll < ModConstants.Chances.TAINTED_ROCKS_REPLACE and room:IsFirstVisit()
				and CustomData.Data and CustomData.Data.NumTaintedRocks < 2
				and CustomData.Unlocks["Special"]["Tainted Rocks"].Unlocked
				and isPickupUnlocked(300, CustomConsumables.RED_RUNE) then
					gridEnt:SetVariant(2)
					CustomData.Data.NumTaintedRocks = CustomData.Data.NumTaintedRocks + 1
					break
				end
			end
		end

		-- replacing the spritesheet
		for ind = 1, room:GetGridSize() do
			local gridEnt = room:GetGridEntity(ind)

			if gridEnt and gridEnt:GetType() == GridEntityType.GRID_ROCK_SPIKED and gridEnt:GetVariant() == 2 then
				replaceBloodyRockSprite(gridEnt, room, level)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, rplus.OnNewRoom)


						-- MC_POST_UPDATE --											
						--------------------
function rplus:OnGameUpdate()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stage = level:GetStage()

	-- handle delayed sounds
	if #delayedSounds > 0 then
		for id, info in pairs(delayedSounds) do
			info[2] = info[2] - 1
			if info[2] == 0 then
				sfx:Play(info[1])
				table.remove(delayedSounds, id)
			end
		end
	end

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		local sprite = Player:GetSprite()

		-- Handle temporary dmg boosts
		if Player:GetData().flagGiveTempBoost then
			if game:GetFrameCount() % math.floor(1 + 11 / Player:GetData().numTempBoosts) == 0 then
				Player:GetData().boostTimeStep = Player:GetData().boostTimeStep + 1
				Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				Player:EvaluateItems()
				if Player:GetData().boostTimeStep == 50 * Player:GetData().numTempBoosts then
					Player:GetData().flagGiveTempBoost = false
					Player:GetData().numTempBoosts = 0
					Player:GetData().boostTimeStep = 0
					Player:GetData().frameBoostLost = game:GetFrameCount()
				end
			end
		end

		-- Handle reviving Isaac
		if isPlayerDying(Player) and not Player:WillPlayerRevive() then
			tryCustomRevivePlayer(Player)
		end

		-- Bird of Hope dying part
		if CustomData.Data and CustomData.Data.Items.BIRD_OF_HOPE.dieFrame and game:GetFrameCount() > CustomData.Data.Items.BIRD_OF_HOPE.dieFrame + 150
		and not CustomData.Data.Items.BIRD_OF_HOPE.birdCaught then
			Player:Die()
		end

		-- COUNTDOWNS FOR PILLS
		if Player:GetData().yuckDuration and Player:GetData().yuckDuration > 0 then
			Player:GetData().yuckDuration = Player:GetData().yuckDuration - 1
		end
		if Player:GetData().yumDuration and Player:GetData().yumDuration > 0 then
			Player:GetData().yumDuration = Player:GetData().yumDuration - 1
		end
		if Player:GetData().phantomPainsDuration and Player:GetData().phantomPainsDuration > 0 then
			Player:GetData().phantomPainsDuration = Player:GetData().phantomPainsDuration - 1
		end
		if Player:GetData().laxativeDuration and Player:GetData().laxativeDuration > 0 then
			Player:GetData().laxativeDuration = Player:GetData().laxativeDuration - 1
		end

		if Player:GetData().reverseCardRoom and Player:GetData().reverseCardRoom ~= game:GetLevel():GetCurrentRoomIndex() then
			Player:AnimateCard(CustomConsumables.UNO_REVERSE_CARD, "Pickup")
			for i = 0, 1 do
				if Player:GetCard(i) == CustomConsumables.UNO_REVERSE_CARD then Player:SetCard(i, 0) end
			end
			Player:GetData().reverseCardRoom = nil
		end

		if Player:GetData().isSuperBerserk and not Player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
			Player:GetData().isSuperBerserk  = false
		end
		if CustomData.Data and CustomData.Data.ErasedEnemies then
			for _, enemyType in pairs(CustomData.Data.ErasedEnemies) do
				for _, roomEnemy in pairs(Isaac.FindByType(enemyType)) do
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, roomEnemy.Position, Vector.Zero, roomEnemy)
					roomEnemy:Remove()
				end
			end
		end

		if Player:HasTrinket(CustomTrinkets.PIECE_OF_CHALK)
		and not room:IsClear() and room:IsFirstVisit() then
			if room:GetFrameCount() <=  150
			and room:GetFrameCount() % 3 == 0 then
				local Powder = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 5, Player.Position, Vector.Zero, Player):ToEffect()

				Powder:GetSprite():Load("gfx/1000.333_effect_chalk_powder.anm2", true)
				Powder.Timeout = 600 * Player:GetTrinketMultiplier(CustomTrinkets.PIECE_OF_CHALK)
				Powder:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 610 * Player:GetTrinketMultiplier(CustomTrinkets.PIECE_OF_CHALK), 1, true, false)
				--Powder:Update()
			end
		end

		if CustomData.Data then
			CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive = Player:HasCollectible(CustomCollectibles.TWO_PLUS_ONE)

			if CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive then
				for _, entity in pairs(Isaac.FindByType(5)) do
					local entityPickup = entity:ToPickup()

					if entityPickup.Price > 0 and CustomData.Data.Items.TWO_PLUS_ONE.itemsBought == 2 then
						entityPickup.Price = 1
						entityPickup.AutoUpdatePrice = false
					end
				end
			end
		end

		if Player:GetData().laxativeDuration and Player:GetData().laxativeDuration > 0 then
			if Player:GetData().laxativeDuration % 3 == 0 then
				local vector = Vector.FromAngle(DIRECTION_VECTOR[Player:GetMovementDirection()]:GetAngleDegrees() + math.random(-15, 15)):Resized(-7.5)
				local SCorn = Isaac.Spawn(2, CustomTearVariants.CORN, 0, Player.Position, vector, Player):GetSprite()

				SCorn:Play("Big0" .. math.random(4))
				local cornScale = math.random(5, 10) / 10
				SCorn.Scale = Vector(cornScale, cornScale)
			end
		end

		if Player:HasCollectible(CustomCollectibles.RED_MAP) and not room:IsFirstVisit()
		and room:GetType() < 6 and room:GetType() > 3 then
			for _, trinket in pairs(Isaac.FindByType(5, 350, -1, false, false)) do
				trinket:ToPickup():Morph(5, 300, Card.CARD_CRACKED_KEY, true, true, true)
			end
		end

		if Player:GetData().phantomPainsDuration and Player:GetData().phantomPainsDuration > 0 then
			if Player:GetData().phantomPainsDuration % 450 == 1
			and not isInGhostForm(Player) then
				Player:TakeDamage(1, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(Player), 24)

				if Player:GetData().isHorsePhantomPainsEffect then
					for angle = 0, 360, 45 do
						local boneTear = Player:FireTear(Player.Position, Vector.FromAngle(angle):Resized(7.5), false, true, false, Player, 1)
						boneTear:ChangeVariant(TearVariant.BONE)
					end
				end
			end
		end

		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) then
			if not CustomData.Data.Items.MOTHERS_LOVE.runeDrop then
				Isaac.Spawn(5, 300, Card.CARD_SOUL_LILITH, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)

				CustomData.Data.Items.MOTHERS_LOVE.runeDrop = true
			end

			if CustomData.Data.Items.MOTHERS_LOVE.numFriends ~= #Isaac.FindByType(3, -1, -1, false, false) then
				CustomData.Data.Items.MOTHERS_LOVE.numStats = 0
				if #Isaac.FindByType(3, -1, -1, false, false) > 0 then
					for _, friend in pairs(Isaac.FindByType(3, -1, -1, false, false)) do
						local LoveStatMulGiven = getMothersLoveStatBoost(friend.Variant)

						CustomData.Data.Items.MOTHERS_LOVE.numStats = CustomData.Data.Items.MOTHERS_LOVE.numStats + LoveStatMulGiven
					end
				end
				Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_RANGE)
				Player:EvaluateItems()

				CustomData.Data.Items.MOTHERS_LOVE.numFriends = #Isaac.FindByType(3, -1, -1, false, false)
			end
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.SCALPEL) and Player:GetFireDirection() ~= Direction.NO_DIRECTION then
			local buffer = math.ceil(Player.MaxFireDelay) + 1

			if game:GetFrameCount() % buffer == 0 then
				for i = 1, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.SCALPEL) do
					local redTear = Player:FireTear(Player.Position, Vector.FromAngle(math.random(360)) * 5, false, true, false, Player, 0.65)

					redTear.FallingAcceleration = 2
					redTear.FallingSpeed = -14
					redTear.TearFlags = TearFlags.TEAR_NORMAL
					if redTear.Variant ~= TearVariant.BLOOD then redTear:ChangeVariant(TearVariant.BLOOD) end
				end
			end
		end

		-- Sibling Rivalry changing forms every 15 seconds (it works flawlessly now!!!)
		if getTrueFamiliarNum(Player, CustomCollectibles.SIBLING_RIVALRY) > 0
		and game:GetFrameCount() % ModConstants.Cooldowns.SIBLING_RIVALRY_STATE_SWITCH == 0 then
			local d = Player:GetData().fightingSiblings
			if d == false or type(d) == 'nil' then
				d = true
				sfx:Play(SoundEffect.SOUND_CHILD_ANGRY_ROAR)
			else
				d = false
			end
			Player:GetData().fightingSiblings = d
			for _, s in pairs(Isaac.FindByType(3, -1, -1, false, true)) do
				if s.Variant == CustomFamiliars.SIBLING_1 or
				s.Variant == CustomFamiliars.SIBLING_2 or
				s.Variant == CustomFamiliars.FIGHTING_SIBLINGS then
					s:Remove()
				end
			end

			Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			Player:EvaluateItems()
		end

		if Player:HasTrinket(CustomTrinkets.TORN_PAGE) and Player:HasCollectible(CollectibleType.COLLECTIBLE_HOW_TO_JUMP)
		and sprite:IsPlaying("Jump") and sprite:GetFrame() == 18 then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat()
			local Angles = {45, 135, 225, 315}

			if roll <= 0.5 then
				Angles = {0, 90, 180, 270}
			end

			for _, angle in pairs(Angles) do
				Player:FireTear(Player.Position, Vector.FromAngle(angle):Resized(7.5), true, true, false, Player, 0.75)
			end
		end

		if Player:GetData().BOTTOMLESS_BAG then
			if game:GetFrameCount() < Player:GetData().BOTTOMLESS_BAG.frame + 120 then
				Player:SetMinDamageCooldown(40)

				for _, entity in pairs(Isaac.FindInRadius(Player.Position, 40, EntityPartition.PROJECTILE)) do
					if entity:ToProjectile() then
						entity:Remove()
						Player:GetData().BOTTOMLESS_BAG.tearsCollected = Player:GetData().BOTTOMLESS_BAG.tearsCollected + 1
					end
				end

				if game:GetFrameCount() < Player:GetData().BOTTOMLESS_BAG.frame + 110 then
					for _, entity in pairs(Isaac.FindInRadius(Player.Position, 300, EntityPartition.PROJECTILE)) do
						if entity:ToProjectile() then
							entity:AddVelocity((Player.Position - entity.Position):Normalized())
						end
					end
				elseif game:GetFrameCount() == Player:GetData().BOTTOMLESS_BAG.frame + 110 then
					Player:AnimateCollectible(CustomCollectibles.BOTTOMLESS_BAG, "HideItem", "PlayerPickupSparkle")

					if Player:GetData().BOTTOMLESS_BAG.tearsCollected > 1 then
						local shootVector = DIRECTION_VECTOR[Player:GetFireDirection()]

						for i = 1, Player:GetData().BOTTOMLESS_BAG.tearsCollected do
							local extraOffset = Vector(math.random(-5,5), math.random(-5,5))
							local vacuumTear = Player:FireTear(Player.Position, shootVector * math.random(6, 15) + extraOffset, false, true, false, Player)
							vacuumTear.TearFlags = vacuumTear.TearFlags | TearFlags.TEAR_HOMING
							local color = Color(1, 1, 1, 1, 0, 0, 0)
							color:SetColorize(1, 0, 1, 1)
							vacuumTear:SetColor(color, 0, 0, true, false)
						end
					end
				end
			else
				Player:GetData().BOTTOMLESS_BAG = nil
			end
		end

		if Player:HasCollectible(CustomCollectibles.CROSS_OF_CHAOS) then
			for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 50, EntityPartition.ENEMY)) do
				crippleEnemy(enemy)
			end
		end

		if Player:HasCollectible(CustomCollectibles.RED_MAP)
		and not CustomData.Data.Items.RED_MAP.shownOnFloorOne then
			local USR = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, true, RNG(), true))

			if USR.Data and USR.Data.Type == RoomType.ROOM_ULTRASECRET and USR.DisplayFlags & 1 << 2 == 0 then
				USR.DisplayFlags = USR.DisplayFlags | 1 << 2
				level:UpdateVisibility()
			end
			CustomData.Data.Items.RED_MAP.shownOnFloorOne = true
		end

		-- balancing the amount of active (main) and passive (technical) Rejection items
		if Player:GetCollectibleNum(CustomCollectibles.REJECTION) > Player:GetCollectibleNum(CustomCollectibles.REJECTION_P) then
			Player:AddCollectible(CustomCollectibles.REJECTION_P)
		elseif Player:GetCollectibleNum(CustomCollectibles.REJECTION) < Player:GetCollectibleNum(CustomCollectibles.REJECTION_P) then
			Player:RemoveCollectible(CustomCollectibles.REJECTION_P)
		end

		if Player:HasCollectible(CustomCollectibles.MAGIC_MARKER) and not CustomData.Data.Items.MAGIC_MARKER.cardDrop then
			CustomData.Data.Items.MAGIC_MARKER.cardDrop = true
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomInt(22) + 1
			local isReversed = rng:RandomInt(2) * 55		-- normal Fool is CARD 1, reversed Fool? is CARD 56

			Isaac.Spawn(5, 300, roll + isReversed, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)
		end

		if Player:HasCollectible(CustomCollectibles.PURE_SOUL) and Player:GetData().PureSoulSin then
			for _, ps in pairs(Isaac.FindByType(1000, HelperEffects.PURE_SOUL_GHOST, 0)) do
				if Player.Position:Distance(ps.Position) < 20 then
					Isaac.Spawn(Player:GetData().PureSoulSin[1], Player:GetData().PureSoulSin[2], 0, Vector(320, 280), Vector.Zero, nil)
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, ps.Position, Vector.Zero, Player)
					ps:Remove()

					for i = 0, 8 do
						local door = room:GetDoor(i)
						if door then
							door:Bar()
						end
					end
				end
			end
		end

		if Player:HasCollectible(CustomCollectibles.BOOK_OF_JUDGES) and not CustomData.Data.Items.BOOK_OF_JUDGES.noBeams
		and #Isaac.FindByType(1000, EffectVariant.TARGET, 3) > 0 and not room:IsClear()
		and room:GetFrameCount() % 90 == 45 then
			local isChal = Isaac.GetChallenge() == CustomChallenges.JUDGEMENT

			-- spawning light beams at crosshairs' positions
			for _, pos in pairs(CustomData.Data.Items.BOOK_OF_JUDGES.beamTargets) do

				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, pos, Vector.Zero, isChal and Player or nil)
				for _, enemy in pairs(Isaac.FindInRadius(pos, 25, EntityPartition.ENEMY)) do
					local burnMult = Player:HasTrinket(CustomTrinkets.TORN_PAGE) and 2 or 1
					if isChal then burnMult = burnMult * Player.Damage / 3.5 end

					enemy:AddBurn(EntityRef(Player), math.floor(45 * burnMult), 3.5 * burnMult)
				end
			end

			-- generating new crosshairs
			createBookOfJudgesCrosshairs(room)
		end

		if Player:GetData().voidOfGluttonyRegenData then
			if Player:GetData().voidOfGluttonyRegenData.regen
			and game:GetFrameCount() % 30 == 0 then
				Player:GetData().voidOfGluttonyRegenData.duration = Player:GetData().voidOfGluttonyRegenData.duration - 1

				if 2 * Player:GetEffectiveMaxHearts() > 2 * Player:GetHearts() + Player:GetRottenHearts() then
					Player:AddHearts(1)
					sfx:Play(SoundEffect.SOUND_VAMP_GULP)
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, Player.Position + Vector(10,10), Vector.Zero, Player)

					Player:GetData().voidOfGluttonyRegenData.amount = Player:GetData().voidOfGluttonyRegenData.amount + 0.02
				end

				if Player:GetData().voidOfGluttonyRegenData.duration < 0 then
					Player:GetData().voidOfGluttonyRegenData.regen = false end
				Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				Player:EvaluateItems()
			end
		end

		-- since patch v1.7.9, Player:GetPill() no longer works on MC_USE_PILL callback,
		-- which effectively makes the distinction between normal and horse pills not work anymore
		-- the workaround is constantly writing currently held pill color into player's data
		Player:GetData().currentlyHeldPill = Player:GetPill(0)

		-- CHALLENGE
		if Isaac.GetChallenge() == CustomChallenges.BLOOD then
			if Player:GetCard(0) == CustomConsumables.SACRIFICIAL_BLOOD then
				Player:UseCard(Player:GetCard(0), 0)
				Player:SetCard(0, 0)
			end

			if not Player:GetData().flagGiveTempBoost
			and Player:GetData().frameBoostLost and (Player:GetData().frameBoostLost - game:GetFrameCount()) % 180 == 90 then
				if Player:GetHearts() + Player:GetRottenHearts() + Player:GetSoulHearts() > 1 then
					if Player:GetHearts() > 0 and Player:GetRottenHearts() == 0 then
						Player:AddHearts(-1)
					elseif Player:GetRottenHearts() > 0 then
						Player:AddRottenHearts(-2)
					elseif Player:GetSoulHearts() > 0 then
						Player:AddSoulHearts(-1)
					end
				end
			end
		end
		-- CHALLENGE END
	end

	-- I don't even want to explain it
	if hiddenChest then
		hiddenChest.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

		if #Isaac.FindByType(1000, EffectVariant.MR_ME) == 0 then
			hiddenChest:Remove()
		end
	end

	-- Stargazer
	for _, sg in pairs(Isaac.FindByType(6, CustomSlots.SLOT_STARGAZER, 0, false, false)) do
		local SGSprite = sg:GetSprite()

		if SGSprite:IsFinished("PayPrize") or SGSprite:IsFinished("PayPrize_fast") then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100

			if roll * (sg:GetData().isBetterPayout and 2 or 1) <= ModConstants.Chances.STARGAZER_ITEM_PAYOUT then
				SGSprite:Play(FasterAnimationsMod and "Teleport_fast" or "Teleport")
			else
				SGSprite:Play(FasterAnimationsMod and "Prize_fast" or "Prize")
			end
		elseif SGSprite:IsFinished("Teleport") or SGSprite:IsFinished("Teleport_fast") then
			sg:Remove()
		elseif SGSprite:IsFinished("Prize") or SGSprite:IsFinished("Prize_fast") then
			SGSprite:Play("Idle")
		end

		if (SGSprite:IsPlaying("Teleport") or SGSprite:IsPlaying("Teleport_fast"))
		and SGSprite:IsEventTriggered("Disappear") then
			Isaac.Spawn(5, 100, GetUnlockedVanillaCollectible(true, true, false, ItemConfig.TAG_STARS),
				Isaac.GetFreeNearPosition(Vector(sg.Position.X, sg.Position.Y + 40), 40), Vector.Zero, nil)
			sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
		end

		if (SGSprite:IsPlaying("Prize") or SGSprite:IsPlaying("Prize_fast"))
		and SGSprite:IsEventTriggered("Prize") then
			rng:SetSeed(Random() + 1, 1)
			local Rune = rng:RandomInt(9) + 32
			Isaac.Spawn(5, 300, Rune, sg.Position, Vector.FromAngle(math.random(360)) * 5, nil)
			sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
		end
	end

	-- Tainted rocks
	for ind = 1, room:GetGridSize() do
		local gridEnt = room:GetGridEntity(ind)

		if gridEnt and gridEnt:GetType() == GridEntityType.GRID_ROCK_SPIKED and gridEnt:GetVariant() == 2
		and gridEnt.State == 2 and gridEnt.VarData == 0 then
			dropPickupFromTable(DropTables.TAINTED_ROCKS, gridEnt.Position, nil)
			gridEnt.VarData = 1
		end
	end

	-- Soul Bond
	for _, enemy in pairs(Isaac.FindInRadius(Vector(320, 280), 400, EntityPartition.ENEMY)) do
		-- enemies colliding with Soul Bond chains
		if isCollidingWithAstralChain(enemy) and game:GetFrameCount() % 3 == 0 then
			enemy:TakeDamage(stage * 0.5, 0, EntityRef(enemy), 0)
		end
	end
	for _, chain in pairs(Isaac.FindByType(865, 10, 1, true, false)) do
		local t = chain.Target
		-- removing the chain if the target is dead; chained enemies have a 33% chance to drop a soul heart when killed
		if not t or t:IsDead() then
			chain:Remove()
			rng:SetSeed(Random() + 1, 1)
			if rng:RandomFloat() * 100 < ModConstants.Chances.SOUL_BOND_DROP_HEART then
				Isaac.Spawn(5, 10, HeartSubType.HEART_SOUL, t.Position, Vector.Zero, nil)
			end
		-- breaking the chain if you get too far away from enemy or if the boss is chained for longer than 5 seconds
		elseif math.abs((chain.Parent.Position - t.Position):Length()) > 350
		or (t and chain.Target:IsBoss() and game:GetFrameCount() >= t:GetData().chainingStartFrame + 150) then
			chain:Remove()
			t:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
			sfx:Play(SoundEffect.SOUND_ANIMA_BREAK)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_UPDATE, rplus.OnGameUpdate)


--[[Use X callbacks: 	MC_USE_ITEM
						MC_USE_CARD
						MC_USE_PILL
						MC_PRE_USE_ITEM
----------------------------]]
---@param Player EntityPlayer
---@param itemUsed integer
---@param UseFlags UseFlag
function rplus:OnItemUse(itemUsed, _, Player, UseFlags, Slot, _)
	local level = game:GetLevel()
	local room = game:GetRoom()

	--[[ VANILLA ]]
	if Player:HasTrinket(CustomTrinkets.TORN_PAGE) and UseFlags & UseFlag.USE_OWNED == UseFlag.USE_OWNED then
		-- Bible removes one broken heart
		if itemUsed == CollectibleType.COLLECTIBLE_BIBLE then
			rng:SetSeed(Player.InitSeed + Random(), 1)
			if Player:GetBrokenHearts() > 0 then
				Player:AddBrokenHearts(-2)
			elseif rng:RandomInt(4) == 0 then
				Player:AddEternalHearts(1)
			end

		-- Book of the Dead gives you a bone heart
		elseif itemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD then
			Player:AddBoneHearts(1)

		-- Book of Belial also grants eye of belial effect for the room
		elseif itemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL then
			Player:GetData().tornPageBookOfBelial = true
			Player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
			Player:EvaluateItems()

		-- Telepathy for Dummies also grants dunce cap effect for the room
		elseif itemUsed == CollectibleType.COLLECTIBLE_TELEPATHY_BOOK then
			Player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_THE_WIZ, true, 1)

		-- Necronomicon spawns 3 locusts of death on use
		elseif itemUsed == CollectibleType.COLLECTIBLE_NECRONOMICON then
			for i = 1, 3 do
				Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_DEATH, Player.Position, Vector.Zero, Player)
			end

		-- Book of Shadows has extended shield duration
		elseif itemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS then
			SilentUseCard(Player, Card.RUNE_ALGIZ)

		-- Book of Secrets & Monster Manual get 2 charges back when used
		elseif itemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS
		or itemUsed == CollectibleType.COLLECTIBLE_MONSTER_MANUAL then
			Player:SetActiveCharge(Player:GetActiveCharge(Slot) + 2, Slot)

		-- Satanic Bible gives you 2 devil deals to choose from
		elseif itemUsed == CollectibleType.COLLECTIBLE_SATANIC_BIBLE then
			Player:GetData().tornPageSatanicBible = true

		elseif itemUsed == CollectibleType.COLLECTIBLE_LEMEGETON then
			Player:GetData().tornPageLemegetonUse = true
		end
	end
	--[[ VANILLA END ]]

	if itemUsed == CustomCollectibles.COOKIE_CUTTER then
		Player:AddMaxHearts(2, true)
		Player:AddHearts(4)
		Player:AddBrokenHearts(1)
		sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN)
		if Player:GetBrokenHearts() >= 12 then
			Player:Die()
		end

		return {Discharge = true, Remove = false, ShowAnim = true}
	end

	if itemUsed == CustomCollectibles.CHEESE_GRATER then
		if Player:GetMaxHearts() > 0 then
			Player:AddMaxHearts(-2, false)
			if Player:GetEffectiveMaxHearts() + Player:GetSoulHearts() == 0 then
				Player:Die()
			end

			for i = 1, 3 do
				Player:AddMinisaac(Player.Position, true)
			end
			Player:GetEffects():AddCollectibleEffect(CustomCollectibles.CHEESE_GRATER_NULL)
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			Player:EvaluateItems()

			sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN)
			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = true, Remove = false, ShowAnim = false}
		end
	end

	if itemUsed == CustomCollectibles.RUBIKS_CUBE
	and UseFlags & (UseFlag.USE_OWNED | UseFlag.USE_CARBATTERY | UseFlag.USE_VOID) > 0 then
		rng:SetSeed(Random() + 1, 1)
		local solveChance = rng:RandomFloat() * 100

		if solveChance < 5 or CustomData.Data.Items.RUBIKS_CUBE.counter == 20
		or Player:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then
			if UseFlags & UseFlag.USE_VOID == 0 then
				Player:RemoveCollectible(CustomCollectibles.RUBIKS_CUBE, true, Slot, true)
				Player:AddCollectible(CustomCollectibles.MAGIC_CUBE, 0, true, Slot, 0)
				Player:FullCharge(Slot, true)
			end

			Player:AnimateHappy()
			CustomData.Data.Items.RUBIKS_CUBE.counter = 0
			return {Discharge = false, Remove = false, ShowAnim = false}
		else
			CustomData.Data.Items.RUBIKS_CUBE.counter = CustomData.Data.Items.RUBIKS_CUBE.counter + 1
			return {Discharge = true, Remove = false, ShowAnim = true}
		end
	end

	if itemUsed == CustomCollectibles.MAGIC_CUBE then
		for _, entity in pairs(Isaac.FindByType(5, 100, -1)) do
			if entity.SubType > 0 then
				local entP = entity:ToPickup()
				entP:Morph(5, 100, GetUnlockedVanillaCollectible(true, true), true, true, false)
				entP.Touched = false
			end
		end

		return {Discharge = true, Remove = false, ShowAnim = true}
	end

	if itemUsed == CustomCollectibles.QUASAR
	and UseFlags & UseFlag.USE_CARBATTERY ~= UseFlag.USE_CARBATTERY then
		properQuasarUse(Player)
		return {Discharge = true, Remove = false, ShowAnim = true}
	end

	if itemUsed == CustomCollectibles.TOWER_OF_BABEL then
		for g = 1, room:GetGridSize() do
			if room:GetGridEntity(g) then room:GetGridEntity(g):Destroy() end
		end
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 200, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false) and not enemy:IsBoss() then
				enemy:AddEntityFlags(EntityFlag.FLAG_CONFUSION)
			end
		end

		return {Discharge = true, Remove = false, ShowAnim = true}
	end

	if itemUsed == CustomCollectibles.BOOK_OF_GENESIS then
		local freezePreventChecker = 0
		local ID
		local option = rng:Next()

		repeat
			ID = Player:GetDropRNG():RandomInt(Isaac.GetItemConfig():GetCollectibles().Size - 1) + 1
			freezePreventChecker = freezePreventChecker + 1
		until (Player:HasCollectible(ID, true)
		and Isaac.GetItemConfig():GetCollectible(ID).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
		and Isaac.GetItemConfig():GetCollectible(ID).Type % 3 == 1)
		or freezePreventChecker == 1000

		if freezePreventChecker < 1000 then
			Player:AnimateCollectible(ID, "UseItem", "PlayerPickupSparkle")
			Player:RemoveCollectible(ID, true, -1, true)

			local Q = Isaac.GetItemConfig():GetCollectible(ID).Quality
			for i = 1, (Player:HasTrinket(CustomTrinkets.TORN_PAGE) and 4 or 3) do
				local newID = GetUnlockedVanillaCollectible(true, false, Q)

				local bookOfGenesisItem = Isaac.Spawn(5, 100, newID, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil):ToPickup()
				bookOfGenesisItem.OptionsPickupIndex = option
			end

			return {Discharge = true, Remove = false, ShowAnim = false}
		else
			return {Discharge = false, Remove = false, ShowAnim = false}
		end
	end

	if itemUsed == CustomCollectibles.BLOOD_VESSELS[7] and Player:GetDamageCooldown() <= 0
	and UseFlags & UseFlag.USE_OWNED == UseFlag.USE_OWNED then
		CustomData.Data.Items.BLOOD_VESSEL.preventDmgLoop = true
		local h = math.min(5, Player:GetHearts())
		Player:AddHearts(-h)
		Player:TakeDamage(6 - h, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 18)
		Player:RemoveCollectible(itemUsed)
		Player:AddCollectible(CustomCollectibles.BLOOD_VESSELS[1])
		CustomData.Data.Items.BLOOD_VESSEL.preventDmgLoop = false
	end

	if Player:HasTrinket(CustomTrinkets.EMPTY_PAGE) then
		if Isaac.GetItemConfig():GetCollectible(itemUsed).Tags & ItemConfig.TAG_BOOK == ItemConfig.TAG_BOOK
		and UseFlags & UseFlag.USE_OWNED == UseFlag.USE_OWNED then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100

			if roll < 4 ^ Isaac.GetItemConfig():GetCollectible(itemUsed).MaxCharges then
				--[[
					1% for 0 charges (How to Jump)
					16% for 2 charges (Telepathy for Dummies)
					64% for 3 charges (Book of Shadows)
					100% for 4+ charges
				]]
				for i = 1, Player:GetTrinketMultiplier(CustomTrinkets.EMPTY_PAGE) do
					Player:UseActiveItem(CustomItempools.EMPTY_PAGE_ACTIVES[math.random(#CustomItempools.EMPTY_PAGE_ACTIVES)], UseFlag.USE_NOANIM, -1)
				end
			end
		end
	end

	if itemUsed == CustomCollectibles.STARGAZERS_HAT then
		Player:AnimateCollectible(itemUsed, "UseItem", "PlayerPickupSparkle")
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
		Isaac.Spawn(6, CustomSlots.SLOT_STARGAZER, 0, Isaac.GetFreeNearPosition(Player.Position, 40), Vector.Zero, Player)
		CustomData.Data.Items.STARGAZERS_HAT.usedOnFloor = true
	end

	if itemUsed == CustomCollectibles.BOTTOMLESS_BAG then
		Player:GetData().BOTTOMLESS_BAG = {
			usedBag = true,
			frame = game:GetFrameCount(),
			data = true,
			tearsCollected = 0
		}
		Player:AnimateCollectible(CustomCollectibles.BOTTOMLESS_BAG_OPENED, "LiftItem", "PlayerPickupSparkle")
	end

	if itemUsed == CustomCollectibles.REJECTION then
		if not Player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION, false) then
			Player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_C_SECTION), true)
		end
		Player:GetData().FamiliarsInBelly = {}
		Player:GetData().RejectionAnimName = "Spin"

		for _, lil in pairs(Isaac.FindByType(3, -1, -1, false, true)) do
			if lil:ToFamiliar() and lil:ToFamiliar().IsFollower
			and not (lil.Variant == FamiliarVariant.INCUBUS and Player:GetPlayerType() == PlayerType.PLAYER_LILITH) then
				table.insert(Player:GetData().FamiliarsInBelly, lil.Variant)
				if lil.Variant == FamiliarVariant.INCUBUS or lil.Variant == FamiliarVariant.LIL_ABADDON or lil.Variant == FamiliarVariant.DEMON_BABY
				or lil.Variant == FamiliarVariant.LIL_BRIMSTONE then
					Player:GetData().RejectionAnimName = "Spin_demon"
				elseif lil.Variant == FamiliarVariant.SERAPHIM or lil.Variant == CustomFamiliars.CHERUBIM then
					Player:GetData().RejectionAnimName = "Spin_angel"
				end
				lil:Remove()
			end
		end

		if #Player:GetData().FamiliarsInBelly == 1 then Player:GetData().RejectionAnimName = "Spin_fetusonly" end
		if #Player:GetData().FamiliarsInBelly > 0 then
			Player:GetData().RejectionUsed = true -- for repeatedly deleting familiars afterwards
			sfx:Play(SoundEffect.SOUND_VAMP_GULP)
		end
	end

	if itemUsed == CustomCollectibles.AUCTION_GAVEL then
		Player:AnimateCollectible(itemUsed, "UseItem", "PlayerPickupSparkle")
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
		local auctionCollectible = Isaac.Spawn(5, 100, GetUnlockedVanillaCollectible(false), Isaac.GetFreeNearPosition(Player.Position, 40), Vector.Zero, Player):ToPickup()
		auctionCollectible.AutoUpdatePrice = false
		auctionCollectible.Price = Player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) and 10 or 22
		auctionCollectible.ShopItemId = -321
		auctionCollectible:GetData().Data = Player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) and "sale price" or "normal price"
	end

	if itemUsed == CustomCollectibles.SOUL_BOND then
		local en = {}
		for _, ent in pairs(Isaac.FindInRadius(Player.Position, 275, EntityPartition.ENEMY)) do
			if ent:IsVulnerableEnemy()
			-- killing a chained Heart doesn't kill its Mask, causing a softlock :p
			and ent.Type ~= EntityType.ENTITY_HEART then table.insert(en, ent) end
		end

		if #en > 0 then
			local astralChain = Isaac.Spawn(865, 10, 1, Player.Position, Vector.Zero, Player)
			astralChain:GetSprite():ReplaceSpritesheet(0, "gfx/astral_chain.png")
			astralChain:GetSprite():ReplaceSpritesheet(1, "gfx/astral_chain.png")
			astralChain:GetSprite():LoadGraphics()
			sfx:Play(SoundEffect.SOUND_ANIMA_TRAP)
			astralChain.Parent = Player
			astralChain.Target = en[math.random(#en)]
			astralChain.Target:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			astralChain.Target:GetData().isChainedToPlayer = true
			if astralChain.Target:IsBoss() then astralChain.Target:GetData().chainingStartFrame = game:GetFrameCount() end

			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = false}
		end
	end

	if itemUsed == CustomCollectibles.BOOK_OF_LEVIATHAN then
		if not room:IsClear()
		and (Player:GetNumKeys() > 0 or Player:HasGoldenKey() or Player:HasTrinket(CustomTrinkets.TORN_PAGE)) then
			if not Player:HasGoldenKey() and not Player:HasTrinket(CustomTrinkets.TORN_PAGE) then Player:AddKeys(-1) end
			rng:SetSeed(Random() + Player.InitSeed, 1)

			for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 1200, EntityPartition.ENEMY)) do
				if crippleEnemy(enemy) then
					local roll = rng:RandomFloat() * 100
					local pickupRoll = (rng:RandomInt(3) + 2) * 10

					if Player:HasTrinket(TrinketType.TRINKET_STRANGE_KEY) and roll < 75 then
						local Flags = {
							EntityFlag.FLAG_POISON,
							EntityFlag.FLAG_SLOW,
							EntityFlag.FLAG_CHARM,
							EntityFlag.FLAG_CONFUSION,
							EntityFlag.FLAG_FEAR,
							EntityFlag.FLAG_BURN
						}
						enemy:AddEntityFlags(Flags[rng:RandomInt(#Flags) + 1])
					elseif Player:HasTrinket(TrinketType.TRINKET_GILDED_KEY) and roll < 25 then enemy:AddMidasFreeze(EntityRef(Player), 90)
					elseif Player:HasTrinket(TrinketType.TRINKET_CRYSTAL_KEY) and roll < 25 then enemy:AddEntityFlags(EntityFlag.FLAG_ICE)
					elseif Player:HasTrinket(TrinketType.TRINKET_BLUE_KEY) and roll < 15 then enemy:GetData().dropSoulHeart = true
					elseif Player:HasTrinket(TrinketType.TRINKET_RUSTED_KEY) and roll < 50 then enemy:AddConfusion(EntityRef(Player), 90, true)
					elseif Player:HasTrinket(TrinketType.TRINKET_STORE_KEY) and roll < 75 then enemy:GetData().dropPickup = pickupRoll
					elseif Player:HasTrinket(CustomTrinkets.BASEMENT_KEY) and roll < 50 then enemy:GetData().spawnBoneOrbital = true
					elseif Player:HasTrinket(CustomTrinkets.KEY_TO_THE_HEART) and roll < 40 then enemy:GetData().dropRedHeart = true
					elseif Player:HasTrinket(CustomTrinkets.KEY_KNIFE) and roll < 75 then enemy:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT) end
				end
			end

			if rng:RandomFloat() < 0.1
			and UseFlags & UseFlag.USE_OWNED == UseFlag.USE_OWNED then
				-- playing giantbook animation (tricky trick by Bogdan Ryduka)
				if not GiantBookAPI then
					SilentUseCard(Player, Card.RUNE_BERKANO)
					for _, bluefly in pairs(Isaac.FindByType(3, FamiliarVariant.BLUE_FLY, -1)) do
						if bluefly:Exists() and bluefly.FrameCount <= 0 then
							bluefly:Remove()
						end
					end
					for _, bluespider in pairs(Isaac.FindByType(3, FamiliarVariant.BLUE_SPIDER, -1)) do
						if bluespider:Exists() and bluespider.FrameCount <= 0 then
							bluespider:Remove()
						end
					end

					LeviathanGiantBookAnim:Load("gfx/ui/giantbook/giantbook_bookofleviathan.anm2", true)
					LeviathanGiantBookAnim:Play("Shake", true)
					FLAG_FAKE_POPUP_PAUSE = true
					animLength = 36
				end

				Player:RemoveCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, true, ActiveSlot.SLOT_PRIMARY, true)
				Player:AddCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN_UNCHAINED, 0, true, ActiveSlot.SLOT_PRIMARY)
			end

			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = true}
		end
	end

	if itemUsed == CustomCollectibles.BOOK_OF_LEVIATHAN_UNCHAINED then
		if not room:IsClear()
		and (Player:GetHearts() > 0 or Player:HasTrinket(CustomTrinkets.TORN_PAGE)) then
			if not Player:HasTrinket(CustomTrinkets.TORN_PAGE) then Player:AddHearts(-1) end
			rng:SetSeed(Random() + Player.InitSeed, 1)

			for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 1200, EntityPartition.ENEMY)) do
				crippleEnemy(enemy)
			end

			if rng:RandomFloat() < 0.2
			and UseFlags & UseFlag.USE_OWNED == UseFlag.USE_OWNED then
				Player:RemoveCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN_UNCHAINED, true, ActiveSlot.SLOT_PRIMARY, true)
				Player:AddCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN_OPEN, 0, true, ActiveSlot.SLOT_PRIMARY)
			end

			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = true}
		end
	end

	if itemUsed == CustomCollectibles.BOOK_OF_LEVIATHAN_OPEN then
		if Isaac.CountBosses() == 0 then
			Isaac.ExecuteCommand("debug 10")
			CustomData.Data.Items.BOOK_OF_LEVIATHAN_OPEN.stopDebug = true

			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = true}
		end
	end

	if itemUsed == CustomCollectibles.MAGIC_MARKER then
		local primaryCard = Player:GetCard(0)

		if primaryCard >= Card.CARD_FOOL and primaryCard <= Card.CARD_WORLD then	-- normal tarots
			if primaryCard == Card.CARD_WORLD then
				Player:SetCard(0, Card.CARD_FOOL)
			else
				Player:SetCard(0, primaryCard + 1)
			end

			return {Discharge = true, Remove = false, ShowAnim = true}
		elseif primaryCard >= Card.CARD_REVERSE_FOOL and primaryCard <= Card.CARD_REVERSE_WORLD then	-- reversed tarots
			if primaryCard == Card.CARD_REVERSE_FOOL then
				Player:SetCard(0, Card.CARD_REVERSE_WORLD)
			else
				Player:SetCard(0, primaryCard - 1)
			end

			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = false}
		end
	end

	if itemUsed == CustomCollectibles.VAULT_OF_HAVOC then
		if #CustomData.Data.Items.VAULT_OF_HAVOC.enemyList >= 12
		-- Prevent using the item during the Beast fight
		and room:GetBackdropType() ~= BackdropType.DUNGEON_BEAST then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomInt(5) + 1

			Isaac.ExecuteCommand("goto s.miniboss." .. roll + 55000)
			CustomData.Data.Items.VAULT_OF_HAVOC.isInVaultRoom = true
			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = true}
		end
	end

	if itemUsed == CustomCollectibles.HANDICAPPED_PLACARD then
		if not hasActiveChallenge(room) then
			return {Discharge = false, Remove = false, ShowAnim = true}
		else
			local placard = Isaac.Spawn(3, CustomFamiliars.HANDICAPPED_PLACARD, 0, Player.Position, Vector.Zero, Player)
			placard:GetData().area = 1 + (Player:GetEffectiveMaxHearts() - Player:GetHearts()) * 0.1
			local eff = Isaac.Spawn(1000, HelperEffects.HANDICAPPED_PLACARD_AOE, 0, placard.Position, Vector.Zero, placard):ToEffect()
			eff.SpriteScale = Vector(placard:GetData().area * 2.75, placard:GetData().area * 2.75)
		end
	end

	if itemUsed == CustomCollectibles.BOOK_OF_JUDGES then
		CustomData.Data.Items.BOOK_OF_JUDGES.noBeams = true
		return {Discharge = true, Remove = false, ShowAnim = true}
	end

	if itemUsed == CustomCollectibles.BIRTH_CERTIFICATE then
		if room:IsMirrorWorld() then
			return {Discharge = false, Remove = false, ShowAnim = false}
		else
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER)
			Player:GetData().birthCertificateUseRoom = level:GetCurrentRoomIndex()
			Isaac.ExecuteCommand("goto s.supersecret.890")
			return {Discharge = true, Remove = true, ShowAnim = false}
		end
	end

	if itemUsed == CustomCollectibles.SCALPEL
	and not isInGhostForm(Player) then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.SCALPEL)

		if Player:GetMaxHearts() > 0 then
			Player:AddMaxHearts(-2)
		elseif Player:GetBoneHearts() > 0 then
			Player:AddBoneHearts(-1)
		else
			Player:AddSoulHearts(-4)
		end

		sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN)
		return {Discharge = true, Remove = false, ShowAnim = true}
	end

	if itemUsed == CustomCollectibles.BAG_OF_JEWELS then
		rng:SetSeed(Player.InitSeed + Random(), 1)
		local myPocketItem = Player:GetActiveItem(ActiveSlot.SLOT_POCKET)
		local charge = Player:GetActiveCharge(ActiveSlot.SLOT_POCKET)

		local randomJewel = rng:RandomInt(7) + CustomConsumables.CANINE_OF_WRATH
		local curCard = Player:GetCard(0)
		if curCard ~= Card.CARD_NULL then
			Isaac.Spawn(5, 300, curCard, room:FindFreePickupSpawnPosition(Player.Position, 10, true, false), Vector.Zero, Player)
			Player:SetCard(0, Card.CARD_NULL)
		end

		Player:SetCard(0, randomJewel)
		if myPocketItem ~= 0 then
			Player:SetPocketActiveItem(myPocketItem, ActiveSlot.SLOT_POCKET, false)
			Player:SetActiveCharge(charge, ActiveSlot.SLOT_POCKET)
		end
		return {Discharge = true, Remove = false, ShowAnim = true}
	end

	if itemUsed == CustomCollectibles.WE_NEED_TO_GO_SIDEWAYS then
		local dirtPatch = Isaac.FindByType(1000, EffectVariant.DIRT_PATCH, 1)[1]

		if room:GetType() == RoomType.ROOM_SECRET and dirtPatch
		and Player.Position:Distance(dirtPatch.Position) < 40 then
			-- Dig up Cracked keys
			for i = 1, CustomData.Data.Items.WE_NEED_TO_GO_SIDEWAYS.numStoredKeys do
				Isaac.Spawn(5, 300, Card.CARD_CRACKED_KEY, dirtPatch.Position, Vector.FromAngle(math.random(360)), Player)
			end

			CustomData.Data.Items.WE_NEED_TO_GO_SIDEWAYS.numStoredKeys = 0
		else
			-- Bury normal keys
			for _, key in pairs(Isaac.FindByType(5, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL)) do
				key:Remove()
				CustomData.Data.Items.WE_NEED_TO_GO_SIDEWAYS.numStoredKeys = CustomData.Data.Items.WE_NEED_TO_GO_SIDEWAYS.numStoredKeys + 1
			end

			for _, key in pairs(Isaac.FindByType(5, PickupVariant.PICKUP_KEY, KeySubType.KEY_DOUBLEPACK)) do
				key:Remove()
				CustomData.Data.Items.WE_NEED_TO_GO_SIDEWAYS.numStoredKeys = CustomData.Data.Items.WE_NEED_TO_GO_SIDEWAYS.numStoredKeys + 2
			end
		end

		sfx:Play(SoundEffect.SOUND_SHOVEL_DIG)
		return {Discharge = true, Remove = false, ShowAnim = true}
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_ITEM, rplus.OnItemUse)

function rplus:OnCardUse(cardUsed, Player, _)
	local room = game:GetRoom()
	--[[ VANILLA ]]
	-- opening Scarlet chests via Soul of Cain
	if cardUsed == Card.CARD_SOUL_CAIN then
		for _, chest in pairs(Isaac.FindByType(5, CustomPickups.SCARLET_CHEST, -1, false, false)) do
			if chest.SubType == 0 or chest.SubType == 2 then
				openScarletChest(chest)
			end
		end
	end

	-- backwards compatibility for Berkano Rune
	if cardUsed == Card.RUNE_BERKANO and not FLAG_FAKE_POPUP_PAUSE and not GiantBookAPI then
		LeviathanGiantBookAnim:Load("gfx/ui/giantbook/giantbook.anm2", true)
		LeviathanGiantBookAnim:ReplaceSpritesheet(0, "gfx/ui/giantbook/Rune_07_Berkand.png")
		LeviathanGiantBookAnim:LoadGraphics()
		LeviathanGiantBookAnim:Play("Appear", true)
		animLength = 33
	end
	--[[ VANILLA END ]]

	if cardUsed == CustomConsumables.JOKER_Q then
		game:StartRoomTransition(-6, -1, RoomTransitionAnim.TELEPORT, Player, -1)
		CustomData.Data.Cards.JOKER_Q.isCardMarket = true
		playDelayed(CustomSounds.JOKER_Q)
	end

	if cardUsed == CustomConsumables.SPINDOWN_DICE_SHARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_SPINDOWN_DICE, UseFlag.USE_NOANIM, -1)
		playDelayed(CustomSounds.SPINDOWN_DICE_SHARD)
	end

	if cardUsed == CustomConsumables.BUSINESS_CARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, UseFlag.USE_NOANIM, -1)
		playDelayed(CustomSounds.BUSINESS_CARD)
	end

	if cardUsed == CustomConsumables.RED_RUNE then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_ABYSS, false, false, true, false, -1)
		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.ENEMY)) do
			entity:TakeDamage(40, 0, EntityRef(Player), 0)
		end
		rng:SetSeed(Random() + 1, 1)

		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.PICKUP)) do
			if ((entity.Variant < 100 and entity.Variant > 0) or entity.Variant == 300 or entity.Variant == 350 or entity.Variant == 360)
			and entity:ToPickup() and entity:ToPickup().Price % 10 == 0 then
				local pos = entity.Position

				entity:Remove()
				if rng:RandomFloat() <= 0.5 then
					Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, rng:RandomInt(5) + 1, pos, Vector.Zero, Player)
				end
			end
		end

		playDelayed(CustomSounds.RED_RUNE)
	end

	if cardUsed == CustomConsumables.UNO_REVERSE_CARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1)
		Player:GetData().reverseCardRoom = game:GetLevel():GetCurrentRoomIndex()
		playDelayed(CustomSounds.UNO_REVERSE_CARD)
	end

	if cardUsed == CustomConsumables.NEEDLE_AND_THREAD then
		if Player:GetBrokenHearts() > 0 then
			Player:AddBrokenHearts(-1)
			Player:AddMaxHearts(2, true)
			Player:AddHearts(2)
		end

		playDelayed(CustomSounds.NEEDLE_AND_THREAD)
	end

	if cardUsed == CustomConsumables.BAG_TISSUE then
		local Weights = {}
		local SumWeight = 0

		-- getting total weight of 8 most valuable pickups in a room
		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.PICKUP)) do
			if entity:ToPickup() and entity:ToPickup().Price % 10 == 0 then
				if PickupWeights[entity.Variant] and PickupWeights[entity.Variant][entity.SubType] then
					table.insert(Weights, PickupWeights[entity.Variant][entity.SubType])
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, entity)
					entity:Remove()
				elseif entity.Variant == 70 then
					table.insert(Weights, 2)
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, entity)
					entity:Remove()
				elseif entity.Variant == 300 then
					table.insert(Weights, 3)
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, entity)
					entity:Remove()
				end
			end
		end

		if #Weights == 0 then
			Player:AnimateSad()
			return
		end

		table.sort(Weights, function(a,b) return a>b end)
		for i = 1, 8 do
			if Weights[i] then
				SumWeight = SumWeight + Weights[i]
			end
		end

		-- defining item quality 
		local desiredQ = math.min(math.floor((SumWeight + 4) / 9), 4)

		-- spawning the item
		Player:AnimateHappy()
		Isaac.Spawn(5, 100, GetUnlockedVanillaCollectible(true, false, desiredQ),
			Isaac.GetFreeNearPosition(Player.Position, 5.0), Vector.Zero, Player)
		playDelayed(CustomSounds.BAG_TISSUE)
	end

	if cardUsed == CustomConsumables.LOADED_DICE then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.LOADED_DICE_NULL, false, 1)

		Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		Player:EvaluateItems()
		playDelayed(CustomSounds.LOADED_DICE)
	end

	if cardUsed == CustomConsumables.QUASAR_SHARD then
		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.ENEMY)) do
			entity:TakeDamage(40, 0, EntityRef(Player), 0)
		end

		properQuasarUse(Player)
		playDelayed(CustomSounds.QUASAR_SHARD)
	end

	if cardUsed == CustomConsumables.SACRIFICIAL_BLOOD then
		addTemporaryDmgBoost(Player)
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES) then
			Player:AddHearts(2)
		end

		sfx:Play(SoundEffect.SOUND_VAMP_GULP)
		rng:SetSeed(Player.InitSeed + Random(), 1)
		if rng:RandomFloat() < 0.25 then
			playDelayed(CustomSounds.SACRIFICIAL_BLOOD)
		end
	end

	if cardUsed == CustomConsumables.FLY_PAPER then
		for i = 1, 9 do
			Player:AddSwarmFlyOrbital(Player.Position)
		end
		playDelayed(CustomSounds.FLY_PAPER)
	end

	if cardUsed == CustomConsumables.LIBRARY_CARD then
		Player:UseActiveItem(game:GetItemPool():GetCollectible(ItemPoolType.POOL_LIBRARY, false, Random() + 1, 0), true, false, true, true, -1)
		playDelayed(CustomSounds.LIBRARY_CARD)
	end

	if cardUsed == CustomConsumables.FUNERAL_SERVICES then
		Isaac.Spawn(5, PickupVariant.PICKUP_OLDCHEST, 0, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, Player)
		playDelayed(CustomSounds.FUNERAL_SERVICES)
	end

	if cardUsed == CustomConsumables.MOMS_ID then
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 860, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() then
				local knifeTear = Isaac.Spawn(1000, HelperEffects.FALLING_KNIFE, 0, enemy.Position, Vector.Zero, enemy)
				knifeTear:GetData().Damage = Player.Damage * 2
			end
		end
		playDelayed(CustomSounds.MOMS_ID)
	end

	if cardUsed == CustomConsumables.ANTIMATERIAL_CARD then
		local antimaterialCardTear = Isaac.Spawn(2, CustomTearVariants.ANTIMATERIAL_CARD, 0, Player.Position, DIRECTION_VECTOR[Player:GetMovementDirection()]:Resized(10), Player)
		antimaterialCardTear:GetSprite():Play("Rotate")
		playDelayed(CustomSounds.ANTIMATERIAL_CARD)
	end

	if cardUsed == CustomConsumables.VALENTINES_CARD then
		local valentinesTear = Isaac.Spawn(2, CustomTearVariants.VALENTINES_CARD, 0, Player.Position, DIRECTION_VECTOR[Player:GetMovementDirection()]:Resized(10), Player)
		valentinesTear:GetSprite():Play("Rotate")
		Isaac.Spawn(5, 10, HeartSubType.HEART_FULL, Player.Position, Vector.Zero, Player)
		sfx:Play(SoundEffect.SOUND_KISS_LIPS1)
		playDelayed(CustomSounds.VALENTINES_CARD)
	end

	if cardUsed == CustomConsumables.DEMON_FORM then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL, false, 1)
		playDelayed(CustomSounds.DEMON_FORM)
	end

	if cardUsed == CustomConsumables.FIEND_FIRE then
		local Counter = 0

		for i = 1, 300 do
			rng:SetSeed(Random() + 1, 1)
			local RandomPickup = rng:RandomInt(3) + 1

			if RandomPickup == 1 and Player:GetNumCoins() > 0 then
				Player:AddCoins(-1)
				Counter = Counter + 1
			elseif RandomPickup == 2 and Player:GetNumKeys() > 0 then
				Player:AddKeys(-1)
				Counter = Counter + 1
			elseif RandomPickup == 3 and Player:GetNumBombs() > 0 then
				Player:AddBombs(-1)
				Counter = Counter + 1
			end

			if Counter == 80 or Player:GetNumKeys() + Player:GetNumBombs() + Player:GetNumCoins() == 0 then
				break
			end
		end

		if Counter >= 3 and Counter <= 20 then
		-- enemies take damage and are set on fire
			for _, enemy in pairs(Isaac.GetRoomEntities()) do
				if enemy:IsVulnerableEnemy() then
					enemy:TakeDamage(15, 1, EntityRef(Player), 0)
					enemy:AddBurn(EntityRef(Player), 120, Player.Damage)
				end
			end
		elseif Counter > 20 and Counter <= 40 then
		-- more damage, longer burn duration, destroy grid entities around you
			for _, enemy in pairs(Isaac.GetRoomEntities()) do
				if enemy:IsVulnerableEnemy() then
					enemy:TakeDamage(30, 1, EntityRef(Player), 0)
					enemy:AddBurn(EntityRef(Player), 240, 2 * Player.Damage)
				end
			end
			for g = 1, room:GetGridSize() do
				if room:GetGridEntity(g)
				and room:GetGridPosition(g):Distance(Player.Position) < 150 then
					room:GetGridEntity(g):Destroy()
				end
			end
		elseif Counter > 40 and Counter <= 80 then
		-- produce mama mega explosion, longer burn duration
			Isaac.Spawn(1000, 127, 0, Player.Position, Vector.Zero, nil)
			for _, enemy in pairs(Isaac.GetRoomEntities()) do
				if enemy:IsVulnerableEnemy() then
					enemy:AddBurn(EntityRef(Player), 480, 4 * Player.Damage)
				end
			end
		end

		sfx:Play(SoundEffect.SOUND_WAR_HORSE_DEATH)
		game:ShakeScreen(30)
		playDelayed(CustomSounds.FIEND_FIRE)
	end

	if cardUsed == CustomConsumables.SPIRITUAL_RESERVES then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.ORBITAL_GHOSTS, false, 3)
		Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
		Player:EvaluateItems()
		playDelayed(CustomSounds.SPIRITUAL_RESERVES)
	end

	if cardUsed == CustomConsumables.MIRRORED_LANDSCAPE then
		local primaryActive = Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
		local primaryCharge = Player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
		local pocketActive = Player:GetActiveItem(ActiveSlot.SLOT_POCKET)

		if primaryActive ~= 0
		and not isItemPocketSlotBlacklisted(primaryActive) then
			if pocketActive ~= 0 then
				Player:RemoveCollectible(pocketActive)
				Isaac.Spawn(5, 100, pocketActive, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil)
			end
			Player:RemoveCollectible(primaryActive)
			Player:SetPocketActiveItem(primaryActive, ActiveSlot.SLOT_POCKET, false)
			Player:SetActiveCharge(primaryCharge, ActiveSlot.SLOT_POCKET)
		end
		playDelayed(CustomSounds.MIRRORED_LANDSCAPE)
	end

	if cardUsed == CustomConsumables.CURSED_CARD then
		sfx:Play(SoundEffect.SOUND_DEVIL_CARD)
		Player:GetData().usedCursedCard = true
		playDelayed(CustomSounds.CURSED_CARD)
	end

	-- Jack cards
	if cardUsed == CustomConsumables.JACK_OF_DIAMONDS then
		CustomData.Data.Cards.jackPickupType = "Diamonds"
		playDelayed(CustomSounds.JACK_OF_DIAMONDS)
	elseif cardUsed == CustomConsumables.JACK_OF_CLUBS then
		CustomData.Data.Cards.jackPickupType = "Clubs"
		playDelayed(CustomSounds.JACK_OF_CLUBS)
	elseif cardUsed == CustomConsumables.JACK_OF_SPADES then
		CustomData.Data.Cards.jackPickupType = "Spades"
		playDelayed(CustomSounds.JACK_OF_SPADES)
	elseif cardUsed == CustomConsumables.JACK_OF_HEARTS then
		CustomData.Data.Cards.jackPickupType = "Hearts"
		playDelayed(CustomSounds.JACK_OF_HEARTS)
	end

	-- King cards
	if cardUsed == CustomConsumables.KING_OF_SPADES
	or cardUsed == CustomConsumables.KING_OF_CLUBS
	or cardUsed == CustomConsumables.KING_OF_DIAMONDS then
		local numKingSpawnedPickups = 0

		if cardUsed == CustomConsumables.KING_OF_SPADES then
			sfx:Play(SoundEffect.SOUND_GOLDENKEY)
			numKingSpawnedPickups = math.min(math.floor(Player:GetNumKeys() / 3), 11)
			Player:AddKeys(-math.min(Player:GetNumKeys(), 33))
			if Player:HasGoldenKey() then
				Player:RemoveGoldenKey() numKingSpawnedPickups = numKingSpawnedPickups + 2 end

			playDelayed(CustomSounds.KING_OF_SPADES)
		elseif cardUsed == CustomConsumables.KING_OF_CLUBS then
			numKingSpawnedPickups = math.min(math.floor(Player:GetNumBombs() / 3), 11)
			Player:AddBombs(-math.min(Player:GetNumBombs(), 33))
			if Player:HasGoldenBomb() then
				Player:RemoveGoldenBomb() numKingSpawnedPickups = numKingSpawnedPickups + 2 end

			playDelayed(CustomSounds.KING_OF_CLUBS)
		elseif cardUsed == CustomConsumables.KING_OF_DIAMONDS then
			numKingSpawnedPickups = math.min(math.floor(Player:GetNumCoins() / 6), 11)
			Player:AddCoins(-math.min(Player:GetNumCoins(), 66))

			playDelayed(CustomSounds.KING_OF_DIAMONDS)
		end

		if numKingSpawnedPickups > 0 then
			-- subtype 2 of variant 0 (NULL pickup): exclude collectibles
			-- thanks to kittenchilly & co. for finding this out
			-- sadly, there's no subtype that excludes only collectibles and trinkets :( )
			for _ = 1, numKingSpawnedPickups do
				Isaac.Spawn(5, 0, 2, room:FindFreePickupSpawnPosition(Player.Position, 20, true, false), Vector.Zero, Player)
			end

			rng:SetSeed(Player.InitSeed + Random(), 1)
			local roll = rng:RandomFloat() * 100

			if roll < 25 * numKingSpawnedPickups then
				Isaac.ExecuteCommand("spawn 5.350")
			end

			if roll < 14 * numKingSpawnedPickups then
				Isaac.ExecuteCommand("spawn 5.100")
			end
		end
	end

	-- Queen cards
	if cardUsed == CustomConsumables.QUEEN_OF_DIAMONDS then
		for i = 1, math.random(12) do
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat()
			local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false)

			if roll < 0.92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 1, spawnPos, Vector.Zero, Player)
			elseif roll < 0.98 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 2, spawnPos, Vector.Zero, Player)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 3, spawnPos, Vector.Zero, Player)
			end
		end

		playDelayed(CustomSounds.QUEEN_OF_DIAMONDS)
	elseif cardUsed == CustomConsumables.QUEEN_OF_CLUBS then
		for i = 1, math.random(12) do
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat()
			local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false)

			if roll < 0.92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, 1, spawnPos, Vector.Zero, Player)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, 2, spawnPos, Vector.Zero, Player)
			end
		end

		playDelayed(CustomSounds.QUEEN_OF_CLUBS)
	elseif cardUsed == CustomConsumables.BEDSIDE_QUEEN then
		for i = 1, math.random(12) do
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat()
			local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false)

			if roll < 0.95 then
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 1, spawnPos, Vector.Zero, Player)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 4, spawnPos, Vector.Zero, Player)
			end
		end

		playDelayed(CustomSounds.BEDSIDE_QUEEN)
	end

	-- Jewels
	if cardUsed == CustomConsumables.CROWN_OF_GREED then
		rng:SetSeed(Random() + 1, 1)
		local roll = rng:RandomInt(2) + 1

		if not Player:HasTrinket(CustomTrinkets.JEWEL_DIADEM) then
			Player:GetEffects():AddCollectibleEffect(CustomCollectibles.CROWN_OF_GREED_NULL, false, roll)
			Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
			Player:EvaluateItems()
		end

		for i = 1, roll do
			Isaac.Spawn(5, 20, CoinSubType.COIN_GOLDEN, Isaac.GetFreeNearPosition(Player.Position, 20), Vector.Zero, Player)
		end

		playDelayed(CustomSounds.CROWN_OF_GREED)
	elseif cardUsed == CustomConsumables.FLOWER_OF_LUST then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, false, false, true, false, -1)
		Player:GetData().isFlowerOfLustExtraReward = true

		playDelayed(CustomSounds.FLOWER_OF_LUST)
	elseif cardUsed == CustomConsumables.ACID_OF_SLOTH then
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 1500, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false) and not enemy:IsBoss() then
				enemy:AddSlowing(EntityRef(Player), 1000, 0.5, Color(0.08, 0.3, 0.05, 1, 0, 0, 0))
				if not Player:HasTrinket(CustomTrinkets.JEWEL_DIADEM) then
					enemy:GetData().isSpawningClouds = true
				end
			end
		end

		playDelayed(CustomSounds.ACID_OF_SLOTH)
	elseif cardUsed == CustomConsumables.VOID_OF_GLUTTONY then
		Player:GetData().voidOfGluttonyRegenData = {regen = true, amount = 0, duration = 7}

		playDelayed(CustomSounds.VOID_OF_GLUTTONY)
	elseif cardUsed == CustomConsumables.APPLE_OF_PRIDE then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_RANGE)
		Player:EvaluateItems()
		if Player:HasTrinket(CustomTrinkets.JEWEL_DIADEM) then
			SilentUseCard(Player, Card.CARD_HOLY)
		end

		playDelayed(CustomSounds.APPLE_OF_PRIDE)
	elseif cardUsed == CustomConsumables.CANINE_OF_WRATH then
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 1500, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false) then
				local bombSpawner = Player:HasTrinket(CustomTrinkets.JEWEL_DIADEM) and Player or nil
				Isaac.Explode(enemy.Position, bombSpawner, 15.1)

				if enemy.HitPoints <= 15 then
					addTemporaryDmgBoost(Player)
				end
			end
		end

		playDelayed(CustomSounds.CANINE_OF_WRATH)
	elseif cardUsed == CustomConsumables.MASK_OF_ENVY then
		if Player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER_B and Player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER then
			local hearts = Player:GetMaxHearts()
			local soulhearts = Player:GetSoulHearts()
			if not Player:HasTrinket(CustomTrinkets.JEWEL_DIADEM) then
				Player:AddSoulHearts(-soulhearts)
				Player:AddMaxHearts(-hearts)
				Player:AddBoneHearts(hearts / 2)
				Player:AddSoulHearts(soulhearts)
			end
			Player:AddRottenHearts(hearts)
		end

		playDelayed(CustomSounds.MASK_OF_ENVY)
	end

	if cardUsed == CustomConsumables.DARK_REMNANTS then
		Player:AddBlackHearts(2)
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 1500, EntityPartition.ENEMY)) do
			crippleEnemy(enemy)
		end

		playDelayed(CustomSounds.DARK_REMNANTS)
	end

	if cardUsed == CustomConsumables.FUNERAL_SERVICES_Q then
		Isaac.Spawn(5, CustomPickups.BLACK_CHEST, 0, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, Player)

		playDelayed(CustomSounds.FUNERAL_SERVICES_Q)
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_CARD, rplus.OnCardUse)

---@param Player EntityPlayer
---@param pillEffect PillEffect
function rplus:OnPillUse(pillEffect, Player, _)
	-- a way to distinguish the "horse-ness" of the pill:
	-- if the player holds a horse pill in the main slot at the moment of using the pill,
	-- it is most likely a horse pill (thanks API)
	--* this got even worse now, so THANKS A LOT AGAIN API!!!
	local pillColor = Player:GetData().currentlyHeldPill or 0
  	local isHorsePill = shouldUseHorsePillEffect(Player, pillEffect)

	if pillEffect == CustomPills.ESTROGEN_UP then
		CustomHealthAPI.PersistentData.IgnoreSumptoriumHandling = true

		-- Do the sucking
		-- 1 unit is 1 full rotten heart - absorbs 1 damage, takes up 2 halfs
		local rottenHearts = Player:GetRottenHearts()
		local soiledHearts = CustomHealthAPI.Library.GetHPOfKey(Player, "HEART_SOILED") / 2
		local redHearts = Player:GetHearts() - rottenHearts * 2 - soiledHearts * 2

		local left = rottenHearts + soiledHearts + redHearts
		while left > 2 do
			--print(redHearts .. " - " .. rottenHearts .. " - " .. soiledHearts)
			local clotVar
			if soiledHearts > 0 then
				CustomHealthAPI.Library.AddHealth(Player, "HEART_SOILED", -2)
				clotVar = CustomFamiliars.ClotSubtype.SOILED
			elseif rottenHearts > 0 then
				Player:AddRottenHearts(-1)
				Player:AddHearts(-1)
				clotVar = 6
			else
				Player:AddHearts(-1)
				clotVar = 0
			end

			Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, clotVar, Player.Position, Vector.Zero, Player)

			rottenHearts = Player:GetRottenHearts()
			soiledHearts = CustomHealthAPI.Library.GetHPOfKey(Player, "HEART_SOILED") / 2
			redHearts = Player:GetHearts() - rottenHearts * 2 - soiledHearts * 2
			left = rottenHearts + soiledHearts + redHearts
		end

		-- Well that was easier than I thought!
		CustomHealthAPI.PersistentData.IgnoreSumptoriumHandling = false

		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1, 2)
		if isHorsePill then
			playDelayed(CustomSounds.PILL_ESTROGEN_UP_HORSE)
		else
			playDelayed(CustomSounds.PILL_ESTROGEN_UP)
		end
	end

	if pillEffect == CustomPills.LAXATIVE then
		Player:GetData().laxativeDuration = isHorsePill and 360 or 90
		Player:AnimateSad()

		if isHorsePill then
			sfx:Play(SoundEffect.SOUND_FART_MEGA)
			playDelayed(CustomSounds.PILL_LAXATIVE_HORSE)
		else
			sfx:Play(SoundEffect.SOUND_FART, 1, 2)
			playDelayed(CustomSounds.PILL_LAXATIVE)
		end
	end

	if pillEffect == CustomPills.PHANTOM_PAINS
	and not isInGhostForm(Player) then
		Player:GetData().phantomPainsDuration = 902

		if isHorsePill then
			playDelayed(CustomSounds.PILL_PHANTOM_PAINS_HORSE)
			-- Taking fake damage will also cause player to shoot 8 bone tears in all directions
			Player:GetData().isHorsePhantomPainsEffect = true
		else
			playDelayed(CustomSounds.PILL_PHANTOM_PAINS)
		end
	end

	if pillEffect == CustomPills.YUCK then
		Player:GetData().yuckDuration = isHorsePill and 1800 or 900
		Isaac.Spawn(5, 10, 12, Player.Position, Vector.Zero, Player)

		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
		if isHorsePill then
			playDelayed(CustomSounds.PILL_YUCK_HORSE)
		else
			playDelayed(CustomSounds.PILL_YUCK)
		end
	end

	if pillEffect == CustomPills.YUM then
		Player:GetData().yumDuration = isHorsePill and 1800 or 900
		rng:SetSeed(Random() + 1, 1)
		local roll = rng:RandomInt(4) + 2
		for i = 1, roll do
			Isaac.Spawn(5, 10, 2, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)
		end

		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
		if isHorsePill then
			playDelayed(CustomSounds.PILL_YUM_HORSE)
		else
			playDelayed(CustomSounds.PILL_YUM)
		end
	end

	if pillEffect == CustomPills.SUPPOSITORY then
		if Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) > 0 then
			local item = Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
			local charge = Player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
			Player:RemoveCollectible(item, true, ActiveSlot.SLOT_PRIMARY, true)

			Isaac.Spawn(
				5,
				100,
				item,
				game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 10, true, false),
				Vector.Zero,
				Player
			):ToPickup().Charge = isHorsePill and 12 or charge
		end

		if isHorsePill then
			playDelayed(CustomSounds.PILL_SUPPOSITORY_HORSE)
		else
			playDelayed(CustomSounds.PILL_SUPPOSITORY)
		end
	end

	if Player:HasCollectible(CustomCollectibles.DNA_REDACTOR) then
		-- I honestly don't want to look at this ever again
		-- ...I had to look at this again. Oh well, it wasn't that bad

		if pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_BLUE_BLUE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_CLICKER, true, true, false, false, -1)

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_WHITE_BLUE then
			if not isHorsePill then
				Player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, true, true, false, false, -1)
			else
				for n = 1, 4 do
					Player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, true, true, false, false, -1)
				end
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_ORANGE_ORANGE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_D100, true, true, false, false, -1)

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_WHITE_WHITE then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100
			if roll < 100 - CustomData.Data.Items.DNA_REDACTOR.whitePillUsed * 10 then
				Player:AddPill(pillColor)
			end
			CustomData.Data.Items.DNA_REDACTOR.whitePillUsed = CustomData.Data.Items.DNA_REDACTOR.whitePillUsed + 1

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_REDDOTS_RED then
			Isaac.Explode(Player.Position, Player, 110)
			if not isHorsePill then
				Player:TakeDamage(1, 0, EntityRef(Player), 30)
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_PINK_RED then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_BERSERK, true, true, false, false, -1)
			if isHorsePill then
				Player:GetData().isSuperBerserk = true
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_BLUE_CADETBLUE then
			game:StartRoomTransition(-2, -1, RoomTransitionAnim.TELEPORT, Player, -1)

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_YELLOW_ORANGE then
			if not isHorsePill then
				Player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
			else
				Player:SetActiveCharge(12, ActiveSlot.SLOT_PRIMARY)
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_ORANGEDOTS_WHITE then
			SilentUseCard(Player, Card.CARD_GET_OUT_OF_JAIL)
			if isHorsePill then
				SilentUseCard(Player, Card.CARD_SOUL_CAIN)
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_WHITE_AZURE then
			local myPocketItem = Player:GetActiveItem(ActiveSlot.SLOT_POCKET)
			local charge = Player:GetActiveCharge(ActiveSlot.SLOT_POCKET)

			Player:SetPill(0, 0)
			SilentUseCard(Player, Card.CARD_REVERSE_FOOL)
			if myPocketItem ~= 0 then
				Player:SetPocketActiveItem(myPocketItem, ActiveSlot.SLOT_POCKET, false)
				Player:SetActiveCharge(charge, ActiveSlot.SLOT_POCKET)
			end

			if isHorsePill then
				SilentUseCard(Player, Card.CARD_JUSTICE)
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_BLACK_YELLOW then
			SilentUseCard(Player, Card.CARD_HUMANITY)

			if isHorsePill then
				for i = 1, 3 do
					Isaac.GridSpawn(GridEntityType.GRID_POOP, 3, game:GetRoom():FindFreeTilePosition(Player.Position, 500), true)
				end
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_WHITE_BLACK then
			if not isHorsePill then
				Isaac.Spawn(5, 350, 0, Player.Position, Vector.Zero, Player)
			else
				Isaac.Spawn(5, 350, TrinketType.TRINKET_GOLDEN_FLAG + rng:RandomInt(189) + 1, Player.Position, Vector.Zero, Player)
			end

		elseif pillColor % PillColor.PILL_GIANT_FLAG == PillColor.PILL_WHITE_YELLOW then
			if not isHorsePill then
				Player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, true, true, false, false, -1)
			else
				Player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, true, true, false, false, -1)
				Player:RemoveCollectible(CustomCollectibles.DNA_REDACTOR)
			end

		end
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_PILL, rplus.OnPillUse)

---@param Player EntityPlayer
function rplus:PreUseItem(itemUsed, RNG, Player, UseFlags, ActiveSlot, CustomVarData)
	if Player:HasTrinket(CustomTrinkets.TORN_PAGE) then
		-- Book of Revelations doesn't cause harbingers to spawn
		if itemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS then
			Player:AddSoulHearts(2)
			Player:AnimateCollectible(itemUsed, "UseItem", "PlayerPickupSparkle")
			return true

		-- Book of Sin has a small chance to spawn an item or a chest instead of a pickup
		elseif itemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_SIN then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100

			if roll < 1 then
				Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, nil)
			elseif roll < 2 then
				Isaac.Spawn(5, PickupVariant.PICKUP_CHEST, 0, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, nil)
			elseif roll < 3 then
				Isaac.Spawn(5, PickupVariant.PICKUP_LOCKEDCHEST, 0, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, nil)
			end

			if roll < 3 then
				Player:AnimateCollectible(itemUsed, "UseItem", "PlayerPickupSparkle")
				return true
			end

		-- Anarchist Cookbook spawns a golden troll bomb instead
		elseif itemUsed == CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK then
			Isaac.Spawn(5, 40, 6, game:GetRoom():GetRandomPosition(20), Vector.Zero, Player)
			Player:AnimateCollectible(itemUsed, "UseItem", "PlayerPickupSparkle")
			return true
		end
	end

	if Player:HasTrinket(CustomTrinkets.HEAVENLY_KEYS)
	and itemUsed == CollectibleType.COLLECTIBLE_ALABASTER_BOX then
		Player:AnimateCollectible(itemUsed, "UseItem", "PlayerPickupSparkle")
		-- drop special rewards
		Isaac.Spawn(5, 10, HeartSubType.HEART_ETERNAL, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)
		Isaac.Spawn(5, 10, HeartSubType.HEART_SOUL, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)
		Isaac.Spawn(5, 10, CustomPickups.TaintedHearts.HEART_ZEALOT, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)
		Isaac.Spawn(5, 10, CustomPickups.TaintedHearts.HEART_BALEFUL, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)

		for i = 1, 2 do
			Isaac.Spawn(5, 100,
			game:GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL, true, Random() + 1, CollectibleType.COLLECTIBLE_NULL),
			Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)
		end

		Isaac.Spawn(5, 100,
		GetUnlockedVanillaCollectible(true, true),
		Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)

		Player:RemoveCollectible(CollectibleType.COLLECTIBLE_ALABASTER_BOX, true)
		Player:TryRemoveTrinket(CustomTrinkets.HEAVENLY_KEYS)

		return true
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, rplus.PreUseItem)


						-- MC_POST_PLAYER_UPDATE --									
						---------------------------
---@param Player EntityPlayer
function rplus:PostPlayerUpdate(Player)
	local level = game:GetLevel()
	local room = game:GetRoom()

	-- handle removing items and trinkets from pool on a very beginning of a run
	-- this is ENOUGH even to prevent D4 jank, according to my friend Laraz
	-- I had Eden start with a locked modded item, so blame Laraz, I'm not fixing it
	if game:GetFrameCount() <= 0 then
		for item = CustomCollectibles.ORDINARY_LIFE, CustomCollectibles.BOOK_OF_LEVIATHAN_OPEN do
			if not isChallengeCoreItem(item) and not isPickupUnlocked(100, item) then
				game:GetItemPool():RemoveCollectible(item)
			end
		end

		game:GetItemPool():RemoveTrinket(CustomTrinkets.WAIT_NO)
		for trinket = CustomTrinkets.BASEMENT_KEY, CustomTrinkets.JEWEL_DIADEM do
			if not isPickupUnlocked(350, trinket) then
				game:GetItemPool():RemoveTrinket(trinket)
			end
		end
	end

	-- this callback handles inputs, because it rolls in 60 fps, unlike MC_POST_UPDATE, so inputs won't be missed out
	if Input.IsButtonTriggered(Keyboard.KEY_H, Player.ControllerIndex) and not FLAG_HIDE_ERROR_MESSAGE then
		print('Error message hidden. To see it again, type `show` into the console')
		FLAG_HIDE_ERROR_MESSAGE = true
	end

	if FLAG_DISPLAY_UNLOCKS_TIP
	and (Input.IsButtonTriggered(Keyboard.KEY_E, Player.ControllerIndex)
	or Input.IsButtonTriggered(Keyboard.KEY_ENTER, Player.ControllerIndex)
	or Input.IsButtonTriggered(Keyboard.KEY_SPACE, Player.ControllerIndex)) then
		if game:GetFrameCount() >= 150 then
			FLAG_DISPLAY_UNLOCKS_TIP = false

		--! PURELY FOR DEBUGGING AND TESTING PURPOSES, to make reloading through luamod easier
		elseif Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, Player.ControllerIndex) then
			FLAG_DISPLAY_UNLOCKS_TIP = false
			unlockAll()
		end
	end

	-- helper for reading double tap
	for i = 4, 7 do
		-- shooting left, right, up, down; reading first input
		if Input.IsActionTriggered(i, Player.ControllerIndex) and not Player:GetData().ButtonState then
			Player:GetData().ButtonPressed = i
			Player:GetData().ButtonState = "listening for second tap"
			Player:GetData().PressFrame = game:GetFrameCount()
			--print('button ' .. Player:GetData().ButtonPressed .. ' is pressed on frame ' .. Player:GetData().PressFrame)
		end

		if Player:GetData().PressFrame and game:GetFrameCount() <= Player:GetData().PressFrame + 6 then
			-- listening for next inputs in the next 6 frames
			if not Input.IsActionTriggered(Player:GetData().ButtonPressed, Player.ControllerIndex)
			and Player:GetData().ButtonState == "listening for second tap" then
				Player:GetData().ButtonState = "button released"
			end

			if Player:GetData().ButtonState == "button released"
			and Input.IsActionTriggered(Player:GetData().ButtonPressed, Player.ControllerIndex) then
				---------------------------------
				-- ITEM DOUBLE TAP MECHANICS HERE
				---------------------------------

				-- Enraged Soul
				if Player:HasCollectible(CustomCollectibles.ENRAGED_SOUL) and
				(not Player:GetData().enragedSoulCooldown or Player:GetData().enragedSoulCooldown <= 0) then
					local Velocity = DIRECTION_VECTOR[Direction.DOWN]
					local DashAnim = "DashDown"
					if (Player:GetData().ButtonPressed == 4 and not room:IsMirrorWorld()) or (Player:GetData().ButtonPressed == 5 and room:IsMirrorWorld()) then
						Velocity = DIRECTION_VECTOR[Direction.LEFT]
						DashAnim = "DashHoriz"
					elseif (Player:GetData().ButtonPressed == 5 and not room:IsMirrorWorld()) or (Player:GetData().ButtonPressed == 4 and room:IsMirrorWorld()) then
						Velocity = DIRECTION_VECTOR[Direction.RIGHT]
						DashAnim = "DashHoriz"
					elseif Player:GetData().ButtonPressed == 6 then
						Velocity = DIRECTION_VECTOR[Direction.UP]
						DashAnim = "DashUp"
					end

					local enragedSoul = Isaac.Spawn(3, CustomFamiliars.ENRAGED_SOUL, 0, Player.Position, Velocity * 15, Player)
					-- calculacting the damage
					enragedSoul.CollisionDamage = 3.5 * (1 + math.sqrt(level:GetStage()))
					enragedSoul:GetData().launchRoom = level:GetCurrentRoomIndex()

					local SoulSprite = enragedSoul:GetSprite()
					SoulSprite:Load("gfx/003.214_enragedsoul.anm2", true)
					SoulSprite:Play(DashAnim, true)
					if (Player:GetData().ButtonPressed == 4 and not room:IsMirrorWorld()) or (Player:GetData().ButtonPressed == 5 and room:IsMirrorWorld()) then
						SoulSprite.FlipX = true
					end
					sfx:Play(SoundEffect.SOUND_ANIMA_BREAK)
					sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A)

					Player:GetData().enragedSoulCooldown = ModConstants.Cooldowns.ENRAGED_SOUL_LAUNCH
				end

				-- Magic Pen
				if Player:HasCollectible(CustomCollectibles.MAGIC_PEN) and
				(not Player:GetData().magicPenCooldown or Player:GetData().magicPenCooldown <= 0) then
					local creepDirection = DIRECTION_VECTOR[Player:GetFireDirection()]:Resized(20)
					for i = 1, 15 do
						local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 4, Player.Position + creepDirection * i, Vector.Zero, Player)
						creep:ToEffect().Timeout = 120
					end

					sfx:Play(SoundEffect.SOUND_BLOODSHOOT)
					Player:GetData().magicPenCooldown = ModConstants.Cooldowns.MAGIC_PEN_CREEP_SPEW
				end

				-- Angel's Wings
				if Player:HasCollectible(CustomCollectibles.ANGELS_WINGS) and
				(not Player:GetData().angelsWingsCooldown or Player:GetData().angelsWingsCooldown <= 0) then
					if not Player:GetData().angelsWingsNextAttack then
						Player:GetData().angelsWingsNextAttack = 1
					end

					if Player:GetData().angelsWingsNextAttack == 1 then
						local dogmaBaby = Isaac.Spawn(950, 10, 0, Player.Position, Vector.Zero, Player)
						dogmaBaby:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
						dogmaBaby:AddEntityFlags(EntityFlag.FLAG_CHARM)
					elseif Player:GetData().angelsWingsNextAttack == 2 then
						for _, angle in pairs({-15, 0, 15}) do
							local vector = Vector.FromAngle(DIRECTION_VECTOR[Player:GetFireDirection()]:GetAngleDegrees() + angle):Resized(7.5)
							local TVTear = Player:FireTear(Player.Position, vector, false, true, false, Player, 1)
							TVTear.TearFlags = TearFlags.TEAR_GLOW | TearFlags.TEAR_PIERCING
							TVTear.Scale = 1.5
							TVTear.FallingAcceleration = 0.03
							TVTear.FallingSpeed = -2.25
							sfx:Play(SoundEffect.SOUND_DOGMA_GODHEAD)
						end
					else
						local laserAngle = DIRECTION_VECTOR[Player:GetFireDirection()]:GetAngleDegrees()
						local dogmaLaser
						if laserAngle == 0 then
							dogmaLaser = EntityLaser.ShootAngle(3, Player.Position, laserAngle, 16, Vector(13, -29), Player)
							dogmaLaser.DepthOffset = 10
						elseif laserAngle == 90 then
							dogmaLaser = EntityLaser.ShootAngle(3, Player.Position, laserAngle, 16, Vector(0, -29), Player)
							dogmaLaser.DepthOffset = 20
						elseif laserAngle == 180 then
							dogmaLaser = EntityLaser.ShootAngle(3, Player.Position, laserAngle, 16, Vector(-13, -29), Player)
							dogmaLaser.DepthOffset = 10
						else
							dogmaLaser = EntityLaser.ShootAngle(3, Player.Position, laserAngle, 16, Vector(0, -10), Player)
							dogmaLaser.DepthOffset = 0
						end

						dogmaLaser:GetData().IsDogmaLaser = true
						dogmaLaser:GetData().scaleUp = math.min(Player.Damage * 0.06, 2.5)
						dogmaLaser.Timeout = 16 + math.floor(Player.TearRange / 18)
						dogmaLaser.CollisionDamage = math.max(3.5, Player.Damage * 0.75)

						sfx:Play(SoundEffect.SOUND_DOGMA_BRIMSTONE_SHOOT)
					end

					if Player:GetData().angelsWingsNextAttack < 3 then
						Player:GetData().angelsWingsNextAttack = Player:GetData().angelsWingsNextAttack + 1
					else
						Player:GetData().angelsWingsNextAttack = 1
					end

					Player:GetData().angelsWingsCooldown = ModConstants.Cooldowns.ANGELS_WINGS_NEW_ATTACK / (Isaac.GetChallenge() == CustomChallenges.IN_THE_LIGHT and 2 or 1)
					if Player:GetData().angelsWingsNextAttack == 2 then
						Player:GetData().angelsWingsCooldown = math.ceil(Player:GetData().angelsWingsCooldown * 0.75)
					end
				end

				-- Nerve Pinch
				if Player:HasCollectible(CustomCollectibles.NERVE_PINCH) and
				(not Player:GetData().nervePinchCooldown or Player:GetData().nervePinchCooldown <= 0) then
					Player:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(Player), 30)
					local primaryItem = Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
					local charges = 0
					if primaryItem ~= 0 then
						charges = Isaac.GetItemConfig():GetCollectible(primaryItem).MaxCharges
					end

					Player:GetEffects():AddCollectibleEffect(CustomCollectibles.NERVE_PINCH, false, charges >= 6 and 2 or 1)
					Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
					Player:EvaluateItems()

					rng:SetSeed(Random() + 1, 1)
					local roll = rng:RandomFloat() * 100
					if charges > 0
					and not (primaryItem == 490 or primaryItem == 585)
					and roll <= ModConstants.Chances.NERVE_PINCH_USE_ACTIVE then
						Player:UseActiveItem(primaryItem, 0, -1)
					end

					Player:GetData().nervePinchCooldown = ModConstants.Cooldowns.NERVE_PINCH_TRIGGER
				end

				Player:GetData().ButtonState = nil
			end
		else
			Player:GetData().ButtonState = nil
		end
	end

	if CustomData.Data then
		if Player:GetData().enragedSoulCooldown then
			Player:GetData().enragedSoulCooldown = Player:GetData().enragedSoulCooldown - 1
		end

		if Player:GetData().magicPenCooldown then
			Player:GetData().magicPenCooldown = Player:GetData().magicPenCooldown - 1
		end

		if Player:GetData().angelsWingsCooldown then
			Player:GetData().angelsWingsCooldown = Player:GetData().angelsWingsCooldown - 1
		end

		if Player:GetData().nervePinchCooldown then
			Player:GetData().nervePinchCooldown = Player:GetData().nervePinchCooldown - 1
		end

		if Player:HasTrinket(CustomTrinkets.MAGIC_SWORD) or Player:GetEffects():HasTrinketEffect(CustomTrinkets.BONE_MEAL) then
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			Player:EvaluateItems()
		end
	end

	if ((Player:GetSprite():IsPlaying("Appear") and Player:GetSprite():IsEventTriggered("FX"))
	-- for Forget Me Now
	or (level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() and room:IsFirstVisit() and room:GetFrameCount() == 25)) then
		if Player:HasCollectible(CustomCollectibles.RED_MAP) then
			local USR = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, true, RNG(), true))

			if USR.Data and USR.Data.Type == RoomType.ROOM_ULTRASECRET and USR.DisplayFlags & 1 << 2 == 0 then
				USR.DisplayFlags = USR.DisplayFlags | 1 << 2
				level:UpdateVisibility()
			end
		end

		if level:GetCurses() ~= 0 and level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= LevelCurse.CURSE_OF_LABYRINTH then
			if Player:HasCollectible(CustomCollectibles.BLESS_OF_THE_DEAD) then
				Player:GetEffects():AddCollectibleEffect(CustomCollectibles.BLESS_OF_THE_DEAD)
				hud:ShowFortuneText("The Dead protect you", "")
				level:RemoveCurses(level:GetCurses())
				Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				Player:EvaluateItems()
			elseif Player:HasTrinket(CustomTrinkets.NIGHT_SOIL) then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 100

				if roll < ModConstants.Chances.NIGHT_SOIL_NEGATE_CURSE  * Player:GetTrinketMultiplier(CustomTrinkets.NIGHT_SOIL) then
					level:RemoveCurses(level:GetCurses())
					hud:ShowFortuneText("Night Soil protects you", "")
					Player:AnimateHappy()
				end
			end
		end
	end

	if Player:HasCollectible(CustomCollectibles.RED_BOMBER) then
		if Input.IsActionTriggered(ButtonAction.ACTION_BOMB, Player.ControllerIndex)
		and Player:GetNumBombs() > 0 then
			if not Player:GetData().redBomberCooldown or Player:GetData().redBomberCooldown < 0 then
				Player:GetData().redBomberCooldown = ModConstants.Cooldowns.RED_BOMBER_BOMB_THROW
			end
		end

		if Player:GetData().redBomberCooldown then
			Player:GetData().redBomberCooldown = Player:GetData().redBomberCooldown - 1
		end
	end

	if Player:GetData().RejectionUsed then
		if Player:GetFireDirection() ~= Direction.NO_DIRECTION then
			Player:GetData().RejectionUsed = false
			sfx:Play(SoundEffect.SOUND_WHIP)
			-- launching the familiars
			local gutBall = Isaac.Spawn(2, CustomTearVariants.REJECTED_BABY, 0, Player.Position, DIRECTION_VECTOR[Player:GetFireDirection()] * 12.5, Player):ToTear()
			gutBall.TearFlags = TearFlags.TEAR_PIERCING | TearFlags.TEAR_POISON | TearFlags.TEAR_BURSTSPLIT
			gutBall.Scale = 1.5
			gutBall:GetSprite():Play(Player:GetData().RejectionAnimName)
			gutBall.CollisionDamage = 5 + Player.Damage * 3.75 * (#Player:GetData().FamiliarsInBelly + 1)

			if not Player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION, false) then
				Player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_C_SECTION))
			end
		end
	end

	if Player:HasCollectible(CustomCollectibles.DEAD_WEIGHT) then
		if not Player:GetData().heldSkeleton then
			-- Find skeletons in room, if you're near one of them, lift it and hold
			for _, sk in pairs(Isaac.FindByType(3, CustomFamiliars.DEAD_WEIGHT)) do
				if sk.Position:Distance(Player.Position) < 10
				and sk.Velocity:Length() < 1 then
					Player:GetData().heldSkeleton = sk
					Player:AnimateCollectible(CustomCollectibles.DEAD_WEIGHT_HELD_SKELETON, "LiftItem", "PlayerPickupSparkle")
					sk.Visible = false
					sk.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				end
			end
		else
			-- Listen for shooting input to throw skeleton
			if Player:GetFireDirection() ~= Direction.NO_DIRECTION then
				local sk = Player:GetData().heldSkeleton
				sk.Position = Player.Position
				sk.Visible = true
				sk.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				sk.Friction = 1
				sk.Velocity = Player:GetAimDirection() * 25
				-- Controlled in FAMILIAR_UPDATE, when the familiar fully deccelerates, set collision damage back to 0
				sk:GetData().decceleration = Player:GetAimDirection() * (-0.9)
				-- Extra caution to stop the familiar after a certain amount of time
				sk:GetData().pinFrictionAfter = 60
				sk.CollisionDamage = Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 50 or 25
				sk.SpriteOffset = Vector(0, -30)

				sfx:Play(SoundEffect.SOUND_SCAMPER)
				Player:AnimateCollectible(CustomCollectibles.DEAD_WEIGHT_HELD_SKELETON, "HideItem", "PlayerPickupSparkle")
				Player:GetData().heldSkeleton = nil
			end
		end
	end

	for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 800, EntityPartition.ENEMY)) do
		if enemy:IsActiveEnemy(false) and enemy.Type ~= 92 and not enemy:HasEntityFlags(EntityFlag.FLAG_CHARM) then
			if Player:HasCollectible(CustomCollectibles.CAT_IN_A_BOX)
			and not isInPlayersLineOfSight(enemy, Player) then
				if enemy:IsBoss() then
					enemy:AddConfusion(EntityRef(Player), 60, false)
				else
					enemy:AddEntityFlags(EntityFlag.FLAG_FREEZE)
					enemy:GetData().isCatInBoxFrozen = true
				end
			end

			if enemy:GetData().isCatInBoxFrozen
			and (isInPlayersLineOfSight(enemy, Player) or not Player:HasCollectible(CustomCollectibles.CAT_IN_A_BOX)) then
				enemy:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
				enemy:GetData().isCatInBoxFrozen = false
			end
		end
	end

	-- handle Lemegeton + Torn Page
	if Input.IsButtonTriggered(Keyboard.KEY_SPACE, Player.ControllerIndex)
	and Player:HasTrinket(CustomTrinkets.TORN_PAGE) and Player:GetActiveItem(0) == CollectibleType.COLLECTIBLE_LEMEGETON
	and Player:GetActiveCharge(0) < 6 and Player:GetDamageCooldown() == 0 then
		if not Player:GetData().tornPageLemegetonUse then
			local heartCharges = math.min(6 - Player:GetActiveCharge(0), Player:GetHearts() + Player:GetSoulHearts() - 1)
			Player:SetActiveCharge(Player:GetActiveCharge(0) + heartCharges, 0)
			Player:TakeDamage(heartCharges, DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 0)
		else
			Player:GetData().tornPageLemegetonUse = false
		end
	end

	-- MC_PRE_PLAYER_COLLISION
	if #Isaac.FindByType(6) > 0 then
		for _, moddedSlot in pairs(Isaac.FindByType(6)) do
			if moddedSlot.Position:Distance(Player.Position) < 32 then
				local s = moddedSlot:GetSprite()

				-- for Red King crawlspaces
				if moddedSlot.Variant == CustomSlots.SLOT_RED_KING_CRAWLSPACE and moddedSlot.SubType == 0 then
					for i, v in pairs(CustomData.Data.Items.RED_KING.redCrawlspacesData) do
						if v.seed == moddedSlot.InitSeed then
							Isaac.ExecuteCommand("goto s.boss." .. tostring(v.associatedRoom))
						end
					end
				end

				-- for Tainted character entity
				if level:GetStage() == LevelStage.STAGE8
				and moddedSlot.Variant == 14 and s:IsPlaying("Idle") then
					unlockMark(Player, "Character Unlock")
					playAchievementPaper(Player:GetPlayerType(), "Character Unlock")
				end

				-- for Stargazers
				if moddedSlot.Variant == CustomSlots.SLOT_STARGAZER and moddedSlot.SubType == 0
				and Player:GetNumCoins() >= 7
				and s:IsPlaying("Idle") then
					Player:AddCoins(-7)
					s:Play(FasterAnimationsMod and "PayPrize_fast" or "PayPrize")
					moddedSlot:GetData().isBetterPayout = Player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					sfx:Play(SoundEffect.SOUND_SCAMPER)
				end

				-- for Trick Penny
				if Player:HasTrinket(CustomTrinkets.TRICK_PENNY) then
					rng:SetSeed(Random() + 1, 1)
					local roll = rng:RandomFloat() * 100

					if roll < ModConstants.Chances.TRICK_PENNY * Player:GetTrinketMultiplier(CustomTrinkets.TRICK_PENNY) then
						-- cuz slots don't have their own collision callback, thanks api lmao

						if s:GetFrame() == 1 and
						(s:IsPlaying("PayPrize") or s:IsPlaying("PayNothing") or s:IsPlaying("PayShuffle") or s:IsPlaying("Initiate")) then
							if Player:GetNumCoins() > 0 and																				-- slots that take your money
							(moddedSlot.Variant == 1 or moddedSlot.Variant == 3 or moddedSlot.Variant == 4 or moddedSlot.Variant == 6
							or moddedSlot.Variant == 10 or moddedSlot.Variant == 13 or moddedSlot.Variant == 18) then
								Player:AddCoins(1)
							end
							if Player:GetNumBombs() > 0 and moddedSlot.Variant == 9 then												-- that was bomb bum, simple stuff
								Player:AddBombs(1)
							end
							if Player:GetNumKeys() > 0 and moddedSlot.Variant == 7 then													-- and that was a key master
								Player:AddKeys(1)
							end
						end
					end
				end
			end
		end
	end
	--

	-- control player's and room's behaviour inside of Birth Certificate area
	if room:GetType() == RoomType.ROOM_SUPERSECRET then
		local roomVar = level:GetCurrentRoomDesc().Data.Variant

		if roomVar == 890 then
			if room:GetFrameCount() == 1 and Isaac.GetItemConfig():GetTrinkets().Size > 230 then
				SilentUseCard(Player, Card.CARD_SOUL_CAIN)
			else

			for i = 0, 7 do
				local door = room:GetDoor(i)

				if door and room:IsDoorSlotAllowed(i) and room:GetFrameCount() > 5 then
						local pos = room:GetDoorSlotPosition(i)

						if Player.Position:Distance(pos) <= 8 then
							Isaac.ExecuteCommand("goto s.supersecret.891")
						end
					end
				end
			end
		end

		if roomVar == 890 or roomVar == 891 then
			if Player.QueuedItem.Item and Player.QueuedItem.Item:IsTrinket()
			and (Player:GetMaxTrinkets() == 1
			-- if a+b>0, ab = 0, means that one of a,b is a zero, and one isn't. quick maffs!
			or (Player:GetTrinket(0) + Player:GetTrinket(1) > 0 and Player:GetTrinket(0) * Player:GetTrinket(1) == 0)) then
				Player:GetData().outTransitionDuration = 60
				for _, p in pairs(Isaac.FindByType(5)) do
					p:Remove()
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
				end
			end

			if Player:GetData().outTransitionDuration then
				if Player:GetData().outTransitionDuration > 0 then
					game:ShakeScreen(2)

					Player:GetData().outTransitionDuration = Player:GetData().outTransitionDuration - 1
				else
					Player:GetData().outTransitionDuration = nil
					game:StartRoomTransition(Player:GetData().birthCertificateUseRoom or level:GetStartingRoomIndex(),
					Direction.LEFT, RoomTransitionAnim.DEATH_CERTIFICATE, Player, 0)
				end
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, rplus.PostPlayerUpdate, 0)


						-- MC_POST_RENDER --										
						--------------------
function rplus:OnGameRender()
	local level = game:GetLevel()
	local room = game:GetRoom()
	local ho = Options.HUDOffset

	if FLAG_DISPLAY_UNLOCKS_TIP then
		tipPaper:Update()
		for i = 0, 3 do
			tipPaper:RenderLayer(i, GetScreenCenterPosition(), Vector.Zero, Vector.Zero)
		end
		local newLineOffset = 0
		for line in string.gmatch(UnlocksTip, '([^#]+)') do
			Isaac.RenderText(line, 90, 40 + newLineOffset, 0.8, 0.8, 1, 1)
			newLineOffset = newLineOffset + 12
		end
	end

	if not CustomData.Data then
		DisplayErrorMessage()
	else
		-- rendering achievement papers
		if FLAG_RENDER_PAPER then
			achievementPaper:Update()
			for i = 0, 3 do
				achievementPaper:RenderLayer(i, GetScreenCenterPosition(), Vector.Zero, Vector.Zero)
			end
			if achievementPaper:IsEventTriggered("SetFlag") then
				FLAG_RENDER_PAPER = false
				FLAG_FAKE_POPUP_PAUSE = false
			end
		end

		-- rendering Book of Leavithan's giantbook anim
		if not GiantBookAPI and animLength then
			if animLength > 0 then
				if (game:GetFrameCount() % 2 == 0) then
					LeviathanGiantBookAnim:Update()
					animLength = animLength - 1
				end
				for i = 0, 6 do
					LeviathanGiantBookAnim:RenderLayer(i, GetScreenCenterPosition(), Vector.Zero, Vector.Zero)
				end
			elseif animLength == 0 and FLAG_FAKE_POPUP_PAUSE then
				FLAG_FAKE_POPUP_PAUSE = false
			end
		end

		for i = 0, game:GetNumPlayers() - 1 do
			local Player = Isaac.GetPlayer(i)

			if Player:HasTrinket(CustomTrinkets.GREEDS_HEART) and not isInGhostForm(Player)
			and hud:IsVisible() then
				if level:GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN ~= LevelCurse.CURSE_OF_THE_UNKNOWN then
					CoinHeartSprite:SetFrame(CustomData.Data.Trinkets.GREEDS_HEART, 0)	-- custom data value is either "CoinHeartEmpty" or "CoinHeartFull"
				else
					CoinHeartSprite:SetFrame("CoinHeartUnknown", 0)
				end
				CoinHeartSprite:Render(HeartRenderPos + HUDValueRenderOffset * ho, Vector.Zero, Vector.Zero)
			end

			if Player:HasCollectible(CustomCollectibles.CEILING_WITH_THE_STARS) and (room:GetType() == 18 or room:GetType() == 19 or level:GetCurrentRoomIndex() == level:GetStartingRoomIndex()) then
				if not StarCeiling then StarCeiling = Sprite() end
				StarCeiling:Load("gfx/ui/ui_starceiling.anm2", true)
				StarCeiling:SetFrame("Idle", game:GetFrameCount() % 65)
				StarCeiling.Scale = Vector(1.5, 1.5)
				StarCeiling:Render(Vector(300, 200), Vector.Zero, Vector.Zero)
			end

			if Player:HasCollectible(CustomCollectibles.DNA_REDACTOR) then
				for _, pickupPill in pairs(Isaac.FindInRadius(Player.Position, 150, EntityPartition.PICKUP)) do
					if pickupPill.Variant == 70 then
						DNAPillIcon:SetFrame("pill_" .. tostring(pickupPill.SubType), 0)
						DNAPillIcon:Render(Isaac.WorldToScreen(pickupPill.Position + Vector(15, -15)), Vector.Zero, Vector.Zero)
					end
				end
			end

			if Player:HasCollectible(CustomCollectibles.RED_MAP) and hud:IsVisible() then
				RedMapIcon:SetFrame("RedMap", 0)
				RedMapIcon:Render(getNextMapIconPos() + Vector(-HUDValueRenderOffset.X, HUDValueRenderOffset.Y) * ho, Vector.Zero, Vector.Zero)
			end

			if Player:HasCollectible(CustomCollectibles.ENRAGED_SOUL) and Player:GetData().enragedSoulCooldown
			and Player:GetData().enragedSoulCooldown <= 0 and Player:GetData().enragedSoulCooldown >= -40 then
				SoulIcon:Update()
				SoulIcon:Render(Isaac.WorldToScreen(Player.Position + Vector(25, -45)), Vector.Zero, Vector.Zero)
			end

			if Player:HasCollectible(CustomCollectibles.MAGIC_PEN) and Player:GetData().magicPenCooldown
			and Player:GetData().magicPenCooldown <= 0 and Player:GetData().magicPenCooldown >= -34 then
				PenIcon:Update()
				PenIcon:Render(Isaac.WorldToScreen(Player.Position + Vector(25, -45)), Vector.Zero, Vector.Zero)
			end

			if Player:HasCollectible(CustomCollectibles.ANGELS_WINGS) and Player:GetData().angelsWingsCooldown
			and Player:GetData().angelsWingsCooldown <= 0 and Player:GetData().angelsWingsCooldown >= -40 then
				DogmaAttackIcon:Update()
				DogmaAttackIcon:Render(Isaac.WorldToScreen(Player.Position + Vector(25, -45)), Vector.Zero, Vector.Zero)
			end

			if Player:GetActiveItem(0) == CustomCollectibles.VAULT_OF_HAVOC and hud:IsVisible() then
				Isaac.RenderScaledText('x' .. tostring(math.min(12, #CustomData.Data.Items.VAULT_OF_HAVOC.enemyList)), 21 + 20 * ho, 23 + 12 * ho, 0.85, 0.85, 0.8, 0.7, 0.7, 1)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_RENDER, rplus.OnGameRender)


						-- MC_ENTITY_TAKE_DMG --									
						------------------------
---@param Entity Entity
---@param SourceRef EntityRef
function rplus:EntityTakeDmg(Entity, Amount, Flags, SourceRef, CooldownFrames)
	local Source = SourceRef.Entity
	local Player = Entity:ToPlayer()
	rng:SetSeed(Entity.InitSeed + Random(), 1)

	-- Damage dealt to player
	if Player then
		if Player:HasCollectible(CustomCollectibles.TEMPER_TANTRUM) then
			local roll = rng:RandomFloat() * 100

			if roll < ModConstants.Chances.TEMPER_TANTRUM.STATE_ENTER then
				Player:UseActiveItem(CollectibleType.COLLECTIBLE_BERSERK, true, true, false, true, -1)
				Player:GetData().isSuperBerserk = true
			end
		end

		if Player:HasTrinket(CustomTrinkets.JUDAS_KISS)
		and Source and Source:IsActiveEnemy(false) then
			Source:AddEntityFlags(EntityFlag.FLAG_BAITED)
			Source:AddFear(EntityRef(Player), 60)
		end

		if Player:HasTrinket(CustomTrinkets.GREEDS_HEART) and CustomData.Data.Trinkets.GREEDS_HEART == "CoinHeartFull"
		and not isInGhostForm(Player) and Flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE
		and not isSelfDamage(Flags, "greedsheart") then
			sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
			CustomData.Data.Trinkets.GREEDS_HEART = "CoinHeartEmpty"
			Player:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(Entity), 24)

			return false
		end

		if Player:HasCollectible(CustomCollectibles.BIRD_OF_HOPE)
		and CustomData.Data.Items.BIRD_OF_HOPE.catchingBird then
			return false
		end

		if Player:HasTrinket(CustomTrinkets.MAGIC_SWORD, false) and not Player:HasTrinket(TrinketType.TRINKET_DUCT_TAPE)
		and Flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE and not isSelfDamage(Flags) then
			sfx:Play(SoundEffect.SOUND_BONE_SNAP)
			Player:TryRemoveTrinket(CustomTrinkets.MAGIC_SWORD)
			Isaac.Spawn(5, 350, CustomTrinkets.WAIT_NO, Player.Position, Vector.Zero, nil)
		end

		if Player:HasTrinket(CustomTrinkets.EDENS_LOCK)
		and not isSelfDamage(Flags) then
			local freezePreventChecker = 0

			repeat
				ID = Player:GetDropRNG():RandomInt(728) + 1
				freezePreventChecker = freezePreventChecker + 1
			until (Player:HasCollectible(ID, true)
			and Isaac.GetItemConfig():GetCollectible(ID).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
			and Isaac.GetItemConfig():GetCollectible(ID).Type % 3 == 1)	-- passive or familiar (1 or 4)
			or freezePreventChecker == 1000

			if freezePreventChecker < 1000 then
				Player:RemoveCollectible(ID, true, -1, true)
			else
				return true
			end

			local newID = GetUnlockedVanillaCollectible(true, false)
			Player:AddCollectible(newID, 0, false, -1, 0)

			sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)
		end

		if Player:HasCollectible(CustomCollectibles.RED_BOMBER)
		and Flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION then
			return false
		end

		if Flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE
		and not isInGhostForm(Player) and not CustomData.Data.Items.BLOOD_VESSEL.preventDmgLoop
		and not isSelfDamage(Flags, "bloodvessel") and Player:GetPlayerType() ~= PlayerType.PLAYER_EDEN_B then
			for i = 1, #CustomCollectibles.BLOOD_VESSELS do
				if Player:HasCollectible(CustomCollectibles.BLOOD_VESSELS[i]) then
					if i + Amount == 8 then
						CustomData.Data.Items.BLOOD_VESSEL.preventDmgLoop = true
						-- apparently, if the Player doesn't have 3.5 red hearts, DAMAGE_RED_HEARTS damage will take soul hearts instead,
						-- and it can take away way less than intended
						-- you also can't call TakeDamage() twice because of i-frames, so I will just remove this retarded flag
						local h = math.min(6, Player:GetHearts())
						Player:AddHearts(-h)
						Player:TakeDamage(7 - h, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 18)
						Player:RemoveCollectible(CustomCollectibles.BLOOD_VESSELS[i])
						Player:AddCollectible(CustomCollectibles.BLOOD_VESSELS[1])
						CustomData.Data.Items.BLOOD_VESSEL.preventDmgLoop = false
					else
						Player:SetMinDamageCooldown(40)
						Player:RemoveCollectible(CustomCollectibles.BLOOD_VESSELS[i])
						Player:AddCollectible(CustomCollectibles.BLOOD_VESSELS[i + Amount])
					end

					return false
				end
			end
		end

		if Player:HasTrinket(CustomTrinkets.KEY_KNIFE) then
			local roll = rng:RandomFloat() * 100

			if roll < ModConstants.Chances.KEY_KNIFE_SHADOW_ENTER * Player:GetTrinketMultiplier(CustomTrinkets.KEY_KNIFE) then
				Player:UseActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS, UseFlag.USE_NOANIM, -1)
			end
		end

		if Player:GetData().usedCursedCard
		and Flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE and not isSelfDamage(Flags) then
			Player:AddBrokenHearts(1)
			Player:GetEffects():AddCollectibleEffect(CustomCollectibles.CURSED_CARD_NULL, false, 1)
			Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			Player:EvaluateItems()
			Player:SetMinDamageCooldown(40)
			if Player:GetBrokenHearts() >= 12 then
				Player:Die()
			end

			return false
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) and Flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE
		and not isSelfDamage(Flags) then
			Player:GetEffects():RemoveCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL))
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_RANGE)
			Player:EvaluateItems()
		end

		if Player:HasCollectible(CustomCollectibles.SPIRITUAL_AMENDS)
		and Flags == PlayerSelfDamageFlags['SacrificeRoom'] then
			local roll = rng:RandomFloat()
			if roll < 0.25 then
				Player:GetEffects():AddCollectibleEffect(CustomCollectibles.ORBITAL_GHOSTS, 1)
				Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			elseif roll < 0.5 then
				Player:GetEffects():AddCollectibleEffect(CustomCollectibles.ORBITAL_GHOSTS, 2)
				Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			end
		end

	-- Damage dealt to other entities (enemies)
	elseif Source and Entity:IsVulnerableEnemy() then
		if Source:ToEffect() and Source.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL then
			if Source.SubType == 4 and game:GetFrameCount() % 3 == 0 then
				local roll = rng:RandomFloat() * 100

				if roll < 0.5 then
					Entity:AddBurn(EntityRef(Entity), 90, 3.5)
				elseif roll < 1 then
					Entity:AddCharmed(EntityRef(Entity), 90)
				elseif roll < 1.5 then
					Entity:AddConfusion(EntityRef(Entity), 90, true)
				elseif roll < 2 then
					Entity:AddFear(EntityRef(Entity), 90)
				elseif roll < 2.5 then
					Entity:AddFreeze(EntityRef(Entity), 60)
				elseif roll < 3 then
					Entity:AddPoison(EntityRef(Entity), 90, 3.5)
				elseif roll < 3.5 then
					Entity:AddShrink(EntityRef(Entity), 30)
				elseif roll < 4 then
					Entity:AddBurn(EntityRef(Entity), 90, 0.5)
				end

				return false
			elseif Source.SubType == 5 then
				Entity.Friction = 0
				return false
			end
		end

		if Source:ToPlayer() and Source:GetData().isSuperBerserk
		and not Entity:IsBoss() and Entity.Type ~= 951 -- for the Beast fight protection
		then
			if rng:RandomFloat() * 100 < ModConstants.Chances.TEMPER_TANTRUM.STATE_ERASE_ENEMY then
				table.insert(CustomData.Data.ErasedEnemies, Entity.Type)
			end
		end

		if #CustomData.Data.Items.BLACK_DOLL.entitiesGroupA > 0 then
			for i = 1, #CustomData.Data.Items.BLACK_DOLL.entitiesGroupA do
				if Entity.InitSeed == CustomData.Data.Items.BLACK_DOLL.entitiesGroupA[i].InitSeed and CustomData.Data.Items.BLACK_DOLL.entitiesGroupB[i] and Source and Source.Type < 9 then
					CustomData.Data.Items.BLACK_DOLL.entitiesGroupB[i]:TakeDamage(Amount * 0.6, 0, EntityRef(Entity), 0)
				end
			end

			for i = 1, #CustomData.Data.Items.BLACK_DOLL.entitiesGroupB do
				if Entity.InitSeed == CustomData.Data.Items.BLACK_DOLL.entitiesGroupB[i].InitSeed and CustomData.Data.Items.BLACK_DOLL.entitiesGroupA[i] and Source and Source.Type < 9 then
					CustomData.Data.Items.BLACK_DOLL.entitiesGroupA[i]:TakeDamage(Amount * 0.6, 0, EntityRef(Entity), 0)
				end
			end
		end

		if (Source:ToTear() and Source.Variant == CustomTearVariants.CEREMONIAL_BLADE)
		or (Source:ToKnife() and Source:GetData().IsCeremonial and rng:RandomFloat() * 100 <= ModConstants.Chances.CEREMONIAL_DAGGER_LAUNCH) then
			Entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
			sfx:Play(SoundEffect.SOUND_KNIFE_PULL)
		end

		if Source:ToTear()
		and Source.Variant == CustomTearVariants.KEY_TO_THE_HEART
		and Entity.HitPoints < Source.SpawnerEntity:ToPlayer().Damage then
			Entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
			Entity:Kill()
			for i = 1, 3 do
				local angle = rng:RandomInt(360)
				local fadingHeart = Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, Entity.Position, Vector.FromAngle(angle) * 12.5, Entity)
				-- Fading hearts are managed by a function in customhealth.lua (see line @524)
				fadingHeart:GetData().isFading = true
                fadingHeart:GetData().fadeTimeout = 45
			end
		end

		if Entity:GetData().isCatInBoxFrozen then
			return false
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, rplus.EntityTakeDmg)


--[[npc callbacks:	MC_POST_NPC_INIT
					MC_POST_NPC_RENDER
					MC_NPC_UPDATE
					MC_POST_NPC_DEATH						
-----------------------]]
---@param npc EntityNPC
function rplus:OnNPCInit(npc)
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		if Player:HasTrinket(CustomTrinkets.BABY_SHOES) then
			npc.Size = npc.Size * (1 - 0.1 * Player:GetTrinketMultiplier(CustomTrinkets.BABY_SHOES))
			npc.Scale = npc.Scale * (1 - 0.1 * Player:GetTrinketMultiplier(CustomTrinkets.BABY_SHOES))
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_INIT, rplus.OnNPCInit)

---@param npc EntityNPC
function rplus:OnNPCRender(npc, _)
	if npc.Type == Enemies.JEWEL_CRAWLER.Type
	and npc.Variant == 10 and npc.SubType > 0
	and npc.FrameCount == 1 then
		for i, s in pairs(Enemies.JEWEL_CRAWLER.SubTypes) do
			if s == npc.SubType then
				npc:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/repentanceplus/crawler_" .. Enemies.JEWEL_CRAWLER.Sprites[i] .. ".png")
				npc:GetSprite():LoadGraphics()
			end
		end
	end

	if npc:GetData().IsCrippled then
		npc.Friction = 90 / (90 + game:GetFrameCount() - npc:GetData().CrippleStartFrame)

		if (npc:HasMortalDamage() or npc.Friction <= 0.2) and not npc:GetData().CrippleDeathBurst then
			if npc.Friction <= 0.2 then npc:Kill() end

			rng:SetSeed(Random() + 1, 1)
			local NumTears = rng:RandomInt(5) + 5

			for i = 1, NumTears do
				local newTear = Isaac.Spawn(2, 0, 0, npc.Position, Vector.FromAngle(math.random(360)) * (math.random(20) / 10), npc):ToTear()
				newTear.FallingSpeed = -20
				newTear.FallingAcceleration = 0.4
				newTear:AddTearFlags(TearFlags.TEAR_SLOW)
				newTear:SetColor(Color(0.15, 0.15, 0.15, 1, 0, 0, 0), 300, 1, false, false)
			end

			-- handle custom cripple deaths
			if npc:GetData().dropSoulHeart then
				Isaac.Spawn(5, 10, HeartSubType.HEART_HALF_SOUL, npc.Position, Vector.Zero, nil)
			elseif npc:GetData().dropRedHeart then
				Isaac.Spawn(5, 10, HeartSubType.HEART_HALF, npc.Position, Vector.Zero, nil)
			elseif npc:GetData().dropPickup then
				Isaac.Spawn(5, npc:GetData().dropPickup, 0, npc.Position, Vector.Zero, nil)
			elseif npc:GetData().spawnBoneOrbital then
				Isaac.Spawn(3, FamiliarVariant.BONE_ORBITAL, 0, npc.Position, Vector.Zero, nil)
			end

			npc:GetData().CrippleDeathBurst = true
		end
	end

	if npc:GetData().isCatInBoxFrozen then
		LineOfSightEyes:SetFrame("EyesClosed", 0)
		LineOfSightEyes:Render(Isaac.WorldToScreen(npc.Position + Vector(0, -40)), Vector.Zero, Vector.Zero)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, rplus.OnNPCRender)

---@param npc EntityNPC
function rplus:NPCUpdate(npc)
	-- Jewel Crawlers
	if npc.Type == Enemies.JEWEL_CRAWLER.Type
	and npc.Variant == 10 then
		local target = npc:GetPlayerTarget()
		local dist = target.Position:Distance(npc.Position)

		if dist < 120 then
			npc:GetSprite():Play("Flee")
			local fleeAngle = (npc.Position - target.Position):Normalized():Rotated(rng:RandomInt(60) - 30)
			local fleePosition = npc.Position + (fleeAngle * (rng:RandomInt(40) + 80))

			if not game:GetRoom():IsPositionInRoom(fleePosition, 0) then
				fleePosition = Isaac.GetFreeNearPosition(fleePosition, 20)
			end

			npc.Pathfinder:FindGridPath(fleePosition, 1.75, 1, false)
		else
			npc.Velocity = Vector.Zero
			npc.Pathfinder:Reset()
			npc:GetSprite():Play("Idle")
		end
	end

	if npc:GetData().isSpawningClouds and game:GetFrameCount() % 60 == 0 then
		local gasCloud = Isaac.Spawn(1000, 141, 0, npc.Position, Vector.Zero, npc):ToEffect()
		gasCloud.Timeout = 150
	end
end
rplus:AddCallback(ModCallbacks.MC_NPC_UPDATE, rplus.NPCUpdate)

---@param npc EntityNPC
function rplus:OnNpcDeath(npc)
	local room = game:GetRoom()
	rng:SetSeed(npc.InitSeed + Random(), 1)
	local roll = rng:RandomFloat() * 100

	-- same for killing Jewel Crawlers
	if npc.Type == Enemies.JEWEL_CRAWLER.Type
	and npc.Variant == 10 then
		for _, s in pairs(Enemies.JEWEL_CRAWLER.SubTypes) do
			if s == npc.SubType then
				for i = 0, game:GetNumPlayers() - 1 do
					if s == CustomConsumables.FLOWER_OF_LUST
					and Isaac.GetPlayer(i):GetData().isFlowerOfLustExtraReward then
						return
					end
				end

				Isaac.Spawn(5, 300, s, npc.Position, Vector.Zero, npc)
			end
		end
	end

	if room:GetType() == RoomType.ROOM_SHOP
	and npc.Type == EntityType.ENTITY_GREED then
		for i = 0, game:GetNumPlayers() - 1 do
			if Isaac.GetPlayer(i):HasCollectible(CustomCollectibles.KEEPERS_PENNY) then
				local numNewItems = rng:RandomInt(2) + 3
				local vectors = {Vector(160, 280), Vector(480, 280), Vector(120, 360), Vector(520, 360)}
				if numNewItems == 3 then
					vectors = {Vector(320, 280), Vector(160, 280), Vector(480, 280)}
				end

				for _, v in pairs(vectors) do
					local KEEPERS_PENNY_ITEMPOOLS = {
						ItemPoolType.POOL_TREASURE,
						ItemPoolType.POOL_BOSS,
						ItemPoolType.POOL_SHOP
					}
					local pool = KEEPERS_PENNY_ITEMPOOLS[rng:RandomInt(3) + 1]
					local item = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(pool, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), v, Vector.Zero, Isaac.GetPlayer(i)):ToPickup()
					item.Price = 15
					item.ShopItemId = -1
				end

				return
			end
		end
	end

	if Isaac.GetPlayer(0):GetTrinketMultiplier(CustomTrinkets.GREEDS_HEART) > 1
	and CustomData.Data.Trinkets.GREEDS_HEART == "CoinHeartEmpty"
	and roll <= 15 then
		Isaac.Spawn(5, 20, 1, npc.Position, Vector.FromAngle(math.random(360)), nil)
	end

	if not npc:IsBoss() and npc:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT)
	and isPickupUnlocked(300, CustomConsumables.SACRIFICIAL_BLOOD) then
		for i = 0, game:GetNumPlayers() - 1 do
			if Isaac.GetPlayer(i):HasCollectible(CustomCollectibles.CEREMONIAL_BLADE) then
				Isaac.Spawn(5, 300, CustomConsumables.SACRIFICIAL_BLOOD, npc.Position, Vector.Zero, nil)

				return
			end
		end
	end

	if roll < ModConstants.Chances.CHERRY_FRIENDS_SPAWN then
		for i = 0, game:GetNumPlayers() - 1 do
			if Isaac.GetPlayer(i):HasCollectible(CustomCollectibles.CHERRY_FRIENDS) then
				Isaac.Spawn(3, CustomFamiliars.CHERRY, 1, npc.Position, Vector.Zero, nil)
				sfx:Play(SoundEffect.SOUND_BABY_HURT)

				return
			end
		end
	end

	-- Killing sin mini-boss has a chance to spawn its Jewel
	if npc.Type >= EntityType.ENTITY_SLOTH and npc.Type <= EntityType.ENTITY_PRIDE
	and room:GetType() ~= RoomType.ROOM_BOSS and isMarkUnlocked(35, "Isaac") then
		local trueChance = ModConstants.Chances.SINS_JEWEL_BASE_DROP * (npc.Variant + 1)
		for i = 0, game:GetNumPlayers() - 1 do
			local Player = Isaac.GetPlayer(i)

			if Player:HasCollectible(CustomCollectibles.PURE_SOUL) then
				trueChance = 100
			end

			if npc.Type == EntityType.ENTITY_LUST
			and Player:GetData().isFlowerOfLustExtraReward then
				return
			end
		end

		if roll < trueChance then
			if npc.Type == EntityType.ENTITY_GREED then
				Isaac.Spawn(5, 300, CustomConsumables.CROWN_OF_GREED, npc.Position, Vector.Zero, npc)
			elseif npc.Type == EntityType.ENTITY_LUST then
				Isaac.Spawn(5, 300, CustomConsumables.FLOWER_OF_LUST, npc.Position, Vector.Zero, npc)
			elseif npc.Type == EntityType.ENTITY_SLOTH
			and npc.Variant < 2 then
				Isaac.Spawn(5, 300, CustomConsumables.ACID_OF_SLOTH, npc.Position, Vector.Zero, npc)
			elseif npc.Type == EntityType.ENTITY_GLUTTONY then
				Isaac.Spawn(5, 300, CustomConsumables.VOID_OF_GLUTTONY, npc.Position, Vector.Zero, npc)
			elseif npc.Type == EntityType.ENTITY_PRIDE
			-- Ultra Pride (which is a variant of Sloth (blame Nicalis))
			or (npc.Type == EntityType.ENTITY_SLOTH and npc.Variant == 2) then
				Isaac.Spawn(5, 300, CustomConsumables.APPLE_OF_PRIDE, npc.Position, Vector.Zero, npc)
			elseif npc.Type == EntityType.ENTITY_WRATH then
				Isaac.Spawn(5, 300, CustomConsumables.CANINE_OF_WRATH, npc.Position, Vector.Zero, npc)
			-- Only main segments of Envy and Super Envy
			elseif npc.Type == EntityType.ENTITY_ENVY
			and npc.Variant < 2 then
				Isaac.Spawn(5, 300, CustomConsumables.MASK_OF_ENVY, npc.Position, Vector.Zero, npc)
			end
		end
	end

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		if Player:HasCollectible(CustomCollectibles.GUSTY_BLOOD) and npc:IsEnemy() and Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.GUSTY_BLOOD) < 10 then
			Player:GetEffects():AddCollectibleEffect(CustomCollectibles.GUSTY_BLOOD, 1)
			Player:SetColor(Color(1, 0.5, 0.5, 1, 0, 0, 0), 15, 1, true, false)
			Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED)
			Player:EvaluateItems()
		end

		if Player:HasCollectible(CustomCollectibles.VAULT_OF_HAVOC) and not CustomData.Data.Items.VAULT_OF_HAVOC.isInVaultRoom
		and npc.MaxHitPoints >= 10 and npc:IsEnemy() and not npc:IsBoss() then
			table.insert(CustomData.Data.Items.VAULT_OF_HAVOC.enemyList, npc)
		end

		if Player:GetData().voidOfGluttonyRegenData
		and Player:GetData().voidOfGluttonyRegenData.regen then
			npc:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
			Player:GetData().voidOfGluttonyRegenData.duration = Player:GetData().voidOfGluttonyRegenData.duration + 2
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rplus.OnNpcDeath)


						-- MC_PRE_ENTITY_SPAWN --
						-------------------------
function rplus:PreEntitySpawn(etype, variant, subtype, pos, vel, spawner, seed)
	if etype == Enemies.JEWEL_CRAWLER.Type
	and variant == 10 and subtype == 0 then
		if checkAllCharactersMarks(35) then
			rng:SetSeed(seed, 1)
			local roll = rng:RandomInt(7) + 1
			return {Enemies.JEWEL_CRAWLER.Type, 10, Enemies.JEWEL_CRAWLER.SubTypes[roll], seed}
		else
			return {EntityType.ENTITY_ATTACKFLY, 0, 0, seed}
		end
	end

	if etype == 6 and variant == CustomSlots.SLOT_STARGAZER
	and subtype == 0
	and not isMarkUnlocked("Special", "Stargazer") then
		return {6, 3, 0, seed}
	end

	-- prevent locked familiars from being summoned by Monster Manual
	if etype == 3 and spawner and spawner.Type == 1 then
		if variant == CustomFamiliars.CHERUBIM and not isPickupUnlocked(100, CustomCollectibles.CHERUBIM)
		and Isaac.GetChallenge() ~= CustomChallenges.JUDGEMENT then
			return {3, FamiliarVariant.SERAPHIM, 0, seed}
		end

		if variant == CustomFamiliars.BAG_O_TRASH and not isPickupUnlocked(100, CustomCollectibles.BAG_O_TRASH) then
			return {3, FamiliarVariant.SACK_OF_PENNIES, 0, seed}
		end

		if not isPickupUnlocked(100, CustomCollectibles.TANK_BOYS)
		and Isaac.GetChallenge() ~= CustomChallenges.THE_COMMANDER then
			if variant == CustomFamiliars.TOY_HELICOPTER_TANK then
				if subtype == 0 then
					return {3, 1, 0, seed}
				elseif subtype == 1 then
					return nil
				end
			end
		end

		if not isPickupUnlocked(100, CustomCollectibles.SIBLING_RIVALRY) then
			if variant == CustomFamiliars.SIBLING_1 then
				return {3, 2, 0, seed}
			elseif variant == CustomFamiliars.SIBLING_2 then
				return nil
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, rplus.PreEntitySpawn)

--[[Pickup callbacks:	MC_POST_PICKUP_INIT
						MC_PRE_PICKUP_COLLISION
						MC_POST_PICKUP_UPDATE				
--------------------------]]
---@param Pickup EntityPickup
function rplus:OnPickupInit(Pickup)
	local room = game:GetRoom()

	-- challenge stuff
	if Pickup.Variant == 100 and Isaac.GetChallenge() == CustomChallenges.THE_COMMANDER
	and Isaac.GetItemConfig():GetCollectible(Pickup.SubType).Tags & ItemConfig.TAG_QUEST == 0 then
		Pickup:Morph(5, 100, CustomCollectibles.TANK_BOYS, true, true, true)
	end

	-- morph modded content if it hasn't been unlocked yet
	-- ITEMS
	--[[ 
		apparently, it is enough to remove items from pools only on a run start
		BUT, sometimes mods can do fuckery and reset item pools, causing "locked" items to show up again
		thus, if we see a locked item on a pedestal even though we removed it, let's remove them all again and replace the one that spawned
	--]]
	if Pickup.Variant == 100 and Pickup.SubType >= CustomCollectibles.ORDINARY_LIFE and Pickup.SubType <= CustomCollectibles.BOOK_OF_LEVIATHAN_OPEN
	and not isPickupUnlocked(100, Pickup.SubType) and not isChallengeCoreItem(Pickup.SubType) then
		for i = CustomCollectibles.ORDINARY_LIFE, CustomCollectibles.SIBLING_RIVALRY do
			if not isPickupUnlocked(100, i) then
				game:GetItemPool():RemoveCollectible(i)
			end
		end

		Pickup:Morph(5, 100, GetUnlockedVanillaCollectible(false, true), true, true, true)
	end

	-- TRINKETS
	-- well, since I'm fixing it, why not add failsafe for trinkets too to make it perfect?
	if Pickup.Variant == 350 and Pickup.SubType >= CustomTrinkets.BASEMENT_KEY and Pickup.SubType <= CustomTrinkets.JEWEL_DIADEM
	and not isPickupUnlocked(350, Pickup.SubType) then
		game:GetItemPool():RemoveTrinket(Pickup.SubType)
		Pickup:Morph(5, 350, game:GetItemPool():GetTrinket(false), true, true, true)
	end

	-- CHESTS
	if Pickup.Variant == CustomPickups.BLACK_CHEST and not isMarkUnlocked("Special", "Black Chest") then
		Pickup:Morph(5, PickupVariant.PICKUP_REDCHEST, 0, true, true, true)
	elseif Pickup.Variant == CustomPickups.FLESH_CHEST and not isMarkUnlocked("Special", "Flesh Chest") then
		Pickup:Morph(5, PickupVariant.PICKUP_SPIKEDCHEST, 0, true, true, true)
	elseif Pickup.Variant == CustomPickups.COFFIN and not isMarkUnlocked("Special", "Coffin") then
		Pickup:Morph(5, PickupVariant.PICKUP_BOMBCHEST, 0, true, true, true)
	elseif Pickup.Variant == CustomPickups.SCARLET_CHEST and not isMarkUnlocked("Special", "Scarlet Chest") then
		Pickup:Remove()
	end

	-- CARDS & RUNES
	if Pickup.Variant == 300 and Pickup.SubType >= CustomConsumables.RED_RUNE and Pickup.SubType <= CustomConsumables.JACK_OF_HEARTS
	and not (Pickup.SubType >= CustomConsumables.CANINE_OF_WRATH and Pickup.SubType <= CustomConsumables.ACID_OF_SLOTH)
	and not isPickupUnlocked(300, Pickup.SubType) then
		local isRune = Pickup.SubType == CustomConsumables.RED_RUNE
		or Pickup.SubType == CustomConsumables.QUASAR_SHARD
		or Pickup.SubType == CustomConsumables.DARK_REMNANTS

		local card = game:GetItemPool():GetCard(Random() + 1, not isRune, isRune, isRune)
		print("Card/Rune " .. Pickup.SubType .. " -> Card " .. card)

		Pickup:Morph(5, 300, card, true, true, true)
	end

	-- JEWELS
	if Pickup.Variant == 300
	and Pickup.SubType >= CustomConsumables.CANINE_OF_WRATH and Pickup.SubType <= CustomConsumables.ACID_OF_SLOTH
	-- is Pure Soul unlocked?
	and not isMarkUnlocked(35, "Isaac") then
		local rune = game:GetItemPool():GetCard(Random() + 1, false, true, true)
		print("Jewel " .. tostring(Pickup.SubType - CustomConsumables.CANINE_OF_WRATH + 1) .. " -> Rune " .. rune)

		Pickup:Morph(5, 300, rune, true, true, true)
	end

	if Pickup.Variant == PickupVariant.PICKUP_GRAB_BAG then
		if Pickup.SubType == CustomPickups.WHITE_SACK
		and not checkAllCharactersMarks(29) then
			Pickup:Morph(5, PickupVariant.PICKUP_GRAB_BAG, 0, true, true, false)
		elseif Pickup.SubType == CustomPickups.STOMACK
		and not checkAllCharactersMarks(22) then
			Pickup:Morph(5, PickupVariant.PICKUP_GRAB_BAG, 0, true, true, false)
		end
	end

	-- Blacklisting collectibles
	if Pickup.Variant == 100 then
		for i = 0, game:GetNumPlayers() - 1 do
			BlacklistCollectibles(Pickup, Isaac.GetPlayer(i))
		end
	end

	-- Blood Vessels
	if Pickup.Variant == 100 then
		for i = 2, 7 do
			if Pickup.SubType == CustomCollectibles.BLOOD_VESSELS[i] then
				local c = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, Pickup.Position, Vector.Zero, Pickup):ToEffect()
				c.Timeout = 300
				c.Scale = 2.5

				for _ = 1, math.ceil(i / 2) do
					Isaac.Spawn(5, 10, HeartSubType.HEART_HALF, Pickup.Position, Vector.FromAngle(math.random(360)) * 2, Pickup)
				end

				for _, p in pairs(Isaac.FindByType(1, 0)) do
					local Player = p:ToPlayer()
					if not isInGhostForm(Player) then
						local h = math.min(i - 1, Player:GetHearts())
						Player:AddHearts(-h)
						Player:TakeDamage(i - 1 - h, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 18)
					end
				end

				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
				Pickup:Remove()
			end
		end
	end

	if (Pickup.Variant == CustomPickups.FLESH_CHEST or Pickup.Variant == CustomPickups.BLACK_CHEST
	or Pickup.Variant == CustomPickups.SCARLET_CHEST or Pickup.Variant == CustomPickups.COFFIN)
	and Pickup.SubType == 1 and not Pickup:GetData()["IsInRoom"] then
		Pickup:Remove()
	end

	if (Pickup:GetSprite():IsPlaying("Appear") or Pickup:GetSprite():IsPlaying("AppearFast"))
	and Pickup:GetSprite():GetFrame() == 0 then
		rng:SetSeed(Random() + 1, 1)
		local roll = rng:RandomFloat() * 100

		-- Handle Flesh Chest replacement
		if (Pickup.Variant == PickupVariant.PICKUP_SPIKEDCHEST or Pickup.Variant == PickupVariant.PICKUP_MIMICCHEST)
		and room:GetType() ~= RoomType.ROOM_CHALLENGE
		-- make sure there are no players nearby to prevent mimic chests turning into Flesh chests when approached
		and #Isaac.FindInRadius(Pickup.Position, 60, EntityPartition.PLAYER) == 0 then
			for i = 0, game:GetNumPlayers() - 1 do
				if Isaac.GetPlayer(i):HasTrinket(CustomTrinkets.KEY_TO_THE_HEART) then
					Pickup:Morph(5, CustomPickups.FLESH_CHEST, 0, true, true, false)
					sfx:Play(SoundEffect.SOUND_CHEST_DROP)

					return
				end
			end

			if roll < ModConstants.Chances.FLESH_CHEST.REPLACE then
				Pickup:Morph(5, CustomPickups.FLESH_CHEST, 0, true, true, false)
				sfx:Play(SoundEffect.SOUND_CHEST_DROP)
			end
		end

		if Pickup.Variant == PickupVariant.PICKUP_GRAB_BAG then
			-- White Sack replacement
			if roll <= ModConstants.Chances.WHITE_SACK_REPLACE
			and checkAllCharactersMarks(29) then
				Pickup:Morph(5, PickupVariant.PICKUP_GRAB_BAG, CustomPickups.WHITE_SACK, true, true, false)
			end

			-- Stomack replacement
			if roll <= ModConstants.Chances.STOMACK_REPLACE
			and checkAllCharactersMarks(22) then
				Pickup:Morph(5, PickupVariant.PICKUP_GRAB_BAG, CustomPickups.STOMACK, true, true, false)
			end
		end

		if Pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
		and checkAllCharactersMarks(36) then
			if roll < ModConstants.Chances.HEARTTERY_REPLACE then
				Pickup:Morph(5, PickupVariant.PICKUP_LIL_BATTERY, CustomPickups.HEARTTERY_RED, true, true, false)
			elseif roll < ModConstants.Chances.HEARTTERY_REPLACE * 2 then
				Pickup:Morph(5, PickupVariant.PICKUP_LIL_BATTERY, CustomPickups.HEARTTERY_SOUL, true, true, false)
			end
		end

		-- Removing pickups that spawn near Red Crawlspaces (presumably by it being bombed)
		for _, rc in pairs(Isaac.FindByType(6, CustomSlots.SLOT_RED_KING_CRAWLSPACE, -1, false, false)) do
			if rc.Position:Distance(Pickup.Position) < 5 and Pickup.Variant ~= 100 then
				Pickup:Remove()
			end
		end

		for i = 0, game:GetNumPlayers() - 1 do
			local Player = Isaac.GetPlayer(i)

			if Player:HasTrinket(CustomTrinkets.BASEMENT_KEY) and Pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST
			and roll <= ModConstants.Chances.BASEMENT_KEY * Player:GetTrinketMultiplier(CustomTrinkets.BASEMENT_KEY) then
				Pickup:Morph(5, PickupVariant.PICKUP_OLDCHEST, 0, true, true, false)
			end

			if Pickup.Variant == 20 and Pickup.SubType ~= 7 and Player:HasTrinket(CustomTrinkets.SLEIGHT_OF_HAND)
			and roll <= ModConstants.Chances.SLEIGHT_OF_HAND_UPGRADE * Player:GetTrinketMultiplier(CustomTrinkets.SLEIGHT_OF_HAND) then
				local coinSubTypesByVal = {1, 4, 6, 2, 3, 5, 7} -- penny, doublepack, sticky nickel, nickel, dime, lucky penny, golden penny
				local curType

				for j = 1, #coinSubTypesByVal do
					if coinSubTypesByVal[j] == Pickup.SubType then curType = j break end
				end

				Pickup:Morph(5, 20, coinSubTypesByVal[curType + 1], true, true, false)
				sfx:Play(SoundEffect.SOUND_THUMBSUP)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, rplus.OnPickupInit)

---@param Pickup EntityPickup
function rplus:PickupCollision(Pickup, Collider, _)
	if not Collider:ToPlayer() then return end
	---@type EntityPlayer
	local Player = Collider:ToPlayer()
	local sp = Pickup:GetSprite()

	if CustomData.Data and CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive
		and Pickup.Price > -6 and Pickup.Price ~= 0 									-- this pickup costs something
		and not Player:IsHoldingItem()													-- we're not holding another pickup right now
	then
		if Pickup.Price > 0 and Player:GetNumCoins() >= Pickup.Price					-- this shop item is affordable
		and not (Pickup.Variant == 90 and not canBuyBattery(Player))
		and not (Pickup.Variant == 10 and not canBuyHeart(Player, Pickup.SubType))
		then
			if CustomData.Data.Items.TWO_PLUS_ONE.itemsBought == 2 then
				CustomData.Data.Items.TWO_PLUS_ONE.itemsBought = 0
				for _, pickup in pairs(Isaac.FindByType(5, -1, -1, false, false)) do
					if pickup:ToPickup().Price == 1 then
						pickup:ToPickup().AutoUpdatePrice = true
					end
				end
			else
				CustomData.Data.Items.TWO_PLUS_ONE.itemsBought = CustomData.Data.Items.TWO_PLUS_ONE.itemsBought + 1
			end
		end
	end

	if Player:HasCollectible(CustomCollectibles.CEILING_WITH_THE_STARS) and Pickup.Variant == 380 and not Pickup.Touched
	-- can not sleep in bed while at full health
	and (Player:GetHearts() ~= Player:GetEffectiveMaxHearts() or Player:GetMaxHearts() == 0) then
		for i = 1, 2 do
			Player:AddItemWisp(GetUnlockedVanillaCollectible(), Player.Position, true)
		end

		if Player:HasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
			for i = 1, 3 do
				Player:AddWisp(1, Player.Position, true, false)
			end
		end
	end

	if Player:HasTrinket(CustomTrinkets.GREEDS_HEART) and CustomData.Data.Trinkets.GREEDS_HEART == "CoinHeartEmpty" and Pickup.Variant == 20 and Pickup.SubType ~= 6
	and not isInGhostForm(Player)
	-- If the Player's Keeper, they should be at full health to gain a new coin heart
	and (Player:GetHearts() == Player:GetMaxHearts() or (Player:GetPlayerType() ~= 14 and Player:GetPlayerType() ~= 33)) then
		Player:AddCoins(-1)
		CustomData.Data.Trinkets.GREEDS_HEART = "CoinHeartFull"
	end

	if Pickup.Variant == 10 and Player:CanPickRedHearts()
	and (Pickup.SubType == 1 or Pickup.SubType == 2 or Pickup.SubType == 5
	or Pickup.SubType == 9 or Pickup.SubType == CustomPickups.TaintedHearts.HEART_HOARDED) then
		-- Different hearts gives different boosts
		local mult = 2
		if Pickup.SubType == 2 then
			mult = 1
		elseif Pickup.SubType == 5 then
			mult = 4
		elseif Pickup.SubType == CustomPickups.TaintedHearts.HEART_HOARDED then
			mult = 8 end

		-- Bonuses should apply according to how many hearts were FILLED, not how many were picked up
		mult = math.min(mult, Player:GetEffectiveMaxHearts() - Player:GetHearts())

		if Player:GetData().yuckDuration and Player:GetData().yuckDuration > 0 then
			for i = 1, mult do
				Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, Player.Position, Vector.Zero, Player)
			end
		end

		if Player:GetData().yumDuration and Player:GetData().yumDuration > 0 then
			for n = 1, mult do
				rng:SetSeed(Random() + 1, 1)
				local yumStat = rng:RandomInt(5)
				Player:GetEffects():AddCollectibleEffect(yumStat + CustomCollectibles.YUM_DAMAGE_NULL, false, 1)

				if yumStat == 0 then 		-- damage
					Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				elseif yumStat == 1 then 	-- tears	
					Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				elseif yumStat == 2 then 	-- range
					Player:AddCacheFlags(CacheFlag.CACHE_RANGE)
				elseif yumStat == 3 then 	-- luck
					Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
				elseif yumStat == 4 then 	-- speed
					Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				end
			end

			Player:EvaluateItems()
		end
	end

	if Pickup.Variant == CustomPickups.FLESH_CHEST and Pickup.SubType == 0 then
		if Player:GetDamageCooldown() > 0 then return false end
		Player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CHEST, EntityRef(Pickup), 30)
		CustomData.Data.FleshChestConsumedHP = CustomData.Data.FleshChestConsumedHP + 1
		sp:Play("TakeHealth")
		rng:SetSeed(Pickup.DropSeed + Random(), 1)

		if ((CustomData.Data.FleshChestConsumedHP > 2 and rng:RandomFloat() * 100 < ModConstants.Chances.FLESH_CHEST.OPEN)
		or CustomData.Data.FleshChestConsumedHP == 6) then
			openFleshChest(Pickup)
		end
	end

	if Pickup.Variant == CustomPickups.BLACK_CHEST and Pickup.SubType == 0 then
		Player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CHEST, EntityRef(Pickup), 24)

		openBlackChest(Pickup)
	end

	if Pickup.Variant == CustomPickups.SCARLET_CHEST and (Pickup.SubType == 0 or Pickup.SubType == 2) then
		if sp:IsPlaying("Appear") then return false end

		if Pickup.SubType == 2 or not Player:HasTrinket(TrinketType.TRINKET_CRYSTAL_KEY) then
			if Player:GetActiveItem(0) == CollectibleType.COLLECTIBLE_RED_KEY and Player:GetActiveCharge(0) >= 4 then
				Player:DischargeActiveItem(0)
			elseif Player:GetCard(0) == Card.CARD_CRACKED_KEY then
				Player:SetCard(0, 0)
			else
				return false
			end
		elseif Pickup.SubType == 0 then
			if math.random(100) >= 100 / (4 - Player:GetTrinketMultiplier(TrinketType.TRINKET_CRYSTAL_KEY)) then
				Pickup.SubType = 2
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
				game:GetRoom():SpawnClearAward()
				return false
			end
		else
			return false
		end

		openScarletChest(Pickup)
	end

	if Player:HasCollectible(CustomCollectibles.STARGAZERS_HAT)
	and Pickup.Variant == 10 and (Pickup.SubType == HeartSubType.HEART_SOUL or Pickup.SubType == HeartSubType.HEART_HALF_SOUL)
	and not (Pickup.Price > 0 and Player:GetNumCoins() < Pickup.Price) and not CustomData.Data.Items.STARGAZERS_HAT.usedOnFloor then
		local HatSlot = 0
		local addCharges = 2

		if Pickup.SubType == HeartSubType.HEART_HALF_SOUL then addCharges = 1 end
		if Player:GetActiveItem(0) ~= CustomCollectibles.STARGAZERS_HAT then HatSlot = 1 end

		if Player:GetActiveCharge(HatSlot) < 2 then
			Player:SetActiveCharge(Player:GetActiveCharge(HatSlot) + addCharges, HatSlot)
			if Player:GetActiveCharge(HatSlot) >= 2 then
				sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
			else
				sfx:Play(SoundEffect.SOUND_BEEP) end

			if Pickup:IsShopItem() then
				local holdSprite = Sprite()
				holdSprite:Load(sp:GetFilename(), true)
				holdSprite:Play(sp:GetAnimation(), true)
				holdSprite:SetFrame(sp:GetFrame())

				Player:AnimatePickup(holdSprite)
			end

			Pickup:Remove()
			return false
		end
	end

	if Player:HasTrinket(CustomTrinkets.SHATTERED_STONE)
	and (
		Pickup.Variant == 20
		or Pickup.Variant == 30
		or Pickup.Variant == 40
		or (Pickup.Variant == 10 and canBuyHeart(Player, Pickup.SubType) and Pickup.SubType <= HeartSubType.HEART_ROTTEN)
		or (Pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY and canBuyBattery(Player))
	) then
		local locustSpawnChance = 0
		rng:SetSeed(Pickup.DropSeed, 1)

		if PickupWeights[Pickup.Variant] and PickupWeights[Pickup.Variant][Pickup.SubType] then
			locustSpawnChance = PickupWeights[Pickup.Variant][Pickup.SubType] * 0.2
		end

		if rng:RandomFloat() < locustSpawnChance then
			local locustRoll = rng:RandomInt(5) + 1
			local locust = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, locustRoll, Player.Position, Vector.Zero, Player)
			locust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end

	if Pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
	and not canBuyBattery(Player)
	and not Pickup:GetSprite():IsPlaying("Collect") then
		if Pickup.SubType == CustomPickups.HEARTTERY_SOUL
		and Player:CanPickSoulHearts() then
			local e = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, Player.Position + Vector(10,10), Vector.Zero, Player)
			e:GetSprite():Play("SoulHeart", true)
			Player:AddSoulHearts(2)

			sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
			Pickup:GetSprite():Play("Collect", true)
			Pickup:Die()
		elseif Pickup.SubType == CustomPickups.HEARTTERY_RED
		and Player:CanPickRedHearts() then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, Player.Position + Vector(10,10), Vector.Zero, Player)
			Player:AddHearts(2)

			sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
			Pickup:GetSprite():Play("Collect", true)
			Pickup:Die()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, rplus.PickupCollision)

---@param Pickup EntityPickup
function rplus:PostPickupUpdate(Pickup)
	if not CustomData.Data then return end

	local room = game:GetRoom()
	local sp = Pickup:GetSprite()

	-- Items spawned by Auction Gavel
	if Pickup.ShopItemId == -321 and Pickup.SpawnerType == 1 and Pickup.Price >= 6 then
		if type(Pickup:GetData().Data) == 'nil'
		and (not Pickup.SpawnerEntity or (Pickup.SpawnerEntity:ToPlayer():GetPlayerType() ~= PlayerType.PLAYER_ISAAC_B
		and not Pickup.SpawnerEntity:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER))) then
			Pickup:Remove()
		else
			local pf = Pickup.FrameCount

			if pf % 5 == 0 then
				if Pickup:GetData().Data == "normal price" then
					Pickup.Price = math.min(math.random(22 + pf // 24, 32 + pf // 24), 99)
				elseif Pickup:GetData().Data == "sale price" then
					Pickup.Price = math.min(math.random(10 + pf // 27, 20 + pf // 27), 99)
				end
			end
		end
	end

	-- Custom chests
	if Pickup.Variant == CustomPickups.BLACK_CHEST then
		if (Pickup:GetData()['OpenFrame'] and game:GetFrameCount() >= Pickup:GetData()['OpenFrame'] + 60)
		and Pickup.SubType == 2 then
			sp:Play("Close")
			sfx:Play(SoundEffect.SOUND_CHEST_DROP)
			Pickup.SubType = 0
			Pickup:GetData()['OpenFrame'] = nil
		end

		if sp:IsFinished("Close") or (Pickup.SubType == 2 and room:GetFrameCount() == 0) then
			sp:Play("Idle")
			Pickup.SubType = 0
		end
	elseif Pickup.Variant == CustomPickups.FLESH_CHEST then
		if sp:IsFinished("TakeHealth") then
			sp:Play("Idle")
		end
	elseif Pickup.Variant == CustomPickups.COFFIN then
		if Pickup.FrameCount == 1 then
			if not room:IsFirstVisit() and Pickup.SubType == 2 then
				Pickup:GetSprite():Play("Idle_Exploded")
			end
			Pickup.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		end
	end

	if Pickup.Variant == PickupVariant.PICKUP_GRAB_BAG
	and sp:IsPlaying("Collect") and sp:GetFrame() == 1
	and (Pickup.SubType == CustomPickups.WHITE_SACK or Pickup.SubType == CustomPickups.STOMACK) then
		for _, p in pairs(Isaac.FindByType(5)) do
			if p.Position:Distance(Pickup.Position) < 25
			and p.Variant ~= PickupVariant.PICKUP_GRAB_BAG then
				p:Remove()
			end
		end

		-- Prevent troll bomb drops
		for _, b in pairs(Isaac.FindByType(4)) do
			if b.Position:Distance(Pickup.Position) < 25
			and (b.Variant == BombVariant.BOMB_TROLL or b.Variant == BombVariant.BOMB_SUPERTROLL or b.Variant == BombVariant.BOMB_GOLDENTROLL) then
				b:Remove()
			end
		end

		-- White Sacks
		if Pickup.SubType == CustomPickups.WHITE_SACK then
			dropPickupFromTable(DropTables.WHITE_SACK, Pickup.Position, Pickup)

		-- Stomacks
		else
			rng:SetSeed(Pickup.InitSeed + Random(), 1)

			-- Spawn either a trinket or a bunch of pickups
			if rng:RandomFloat() < 0.1 then
				Isaac.Spawn(5, 350, CustomItempools.FLESH_CHEST_TRINKETS[rng:RandomInt(#CustomItempools.FLESH_CHEST_TRINKETS) + 1], Pickup.Position, Vector.FromAngle(rng:RandomFloat() * 360), Pickup)
			else
				dropPickupFromTable(DropTables.STOMACK, Pickup.Position, Pickup)
			end

			-- Spawn bone orbitals
			for _ = 1, 2 do
				if rng:RandomFloat() < 0.5 then
					local p = Isaac.FindInRadius(Pickup.Position, 40, EntityPartition.PLAYER)[1]:ToPlayer()
					local b = Isaac.Spawn(3, FamiliarVariant.BONE_ORBITAL, 0, p.Position, Vector.Zero, p)
					b:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				end
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, rplus.PostPickupUpdate)


						-- MC_POST_FIRE_TEAR --
						-----------------------
---@param Tear EntityTear
function rplus:OnTearFired(Tear)
	local Player
	if Tear.Parent then Player = Tear.Parent:ToPlayer() elseif Tear.SpawnerEntity then Player = Tear.SpawnerEntity:ToPlayer() end
	if not Player then return end
	local tearSprite = Tear:GetSprite()
	rng:SetSeed(Tear.InitSeed + Random(), 1)

	if Player:HasCollectible(CustomCollectibles.CEREMONIAL_BLADE)
	and rng:RandomFloat() * 100 <= ModConstants.Chances.CEREMONIAL_DAGGER_LAUNCH then
		local bladeTear = Isaac.Spawn(2, CustomTearVariants.CEREMONIAL_BLADE, 0, Player.Position, Tear.Velocity, Player):ToTear()
		bladeTear:AddTearFlags(TearFlags.TEAR_PIERCING)
		bladeTear:GetSprite():Play("Move")
	end

	if Player:HasTrinket(CustomTrinkets.KEY_TO_THE_HEART)
	and rng:RandomFloat() * 100 <= ModConstants.Chances.KEY_TO_THE_HEART then
		Tear:ChangeVariant(CustomTearVariants.KEY_TO_THE_HEART)
		tearSprite:Play("Move")
		Tear:Update()
	end

	if Player:HasCollectible(CustomCollectibles.SINNERS_HEART) then
		Tear:ChangeVariant(CustomTearVariants.SINNERS_HEART)
		tearSprite:Play("Move")
		tearSprite.Scale = Vector(0.5, 0.5)
		Tear:Update()
	end

	if Player:HasCollectible(CustomCollectibles.ANGELS_WINGS) then
		Tear:ChangeVariant(CustomTearVariants.DOGMA_FEATHER)
		tearSprite:Play("Move")
		Tear:Update()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, rplus.OnTearFired)


						-- MC_POST_TEAR_UPDATE --
						-------------------------
---@param Tear EntityTear
function rplus:OnTearUpdate(Tear)
	local Player
	if Tear.Parent then Player = Tear.Parent:ToPlayer() elseif Tear.SpawnerEntity then Player = Tear.SpawnerEntity:ToPlayer() end
	if not Player then return end

	local tearSprite = Tear:GetSprite()

	for _, KAF in pairs(Isaac.FindByType(3, CustomFamiliars.KEEPERS_ANNOYING_FLY)) do
		if Tear.Position:Distance(KAF.Position) < 10 then
			KAF.CollisionDamage = math.min(15, KAF.CollisionDamage * 1.03)
			Tear:Remove()
		end
	end

	if Tear.Variant == CustomTearVariants.CEREMONIAL_BLADE
	or Tear.Variant == CustomTearVariants.SINNERS_HEART
	or Tear.Variant == CustomTearVariants.DOGMA_FEATHER
	or Tear.Variant == CustomTearVariants.KEY_TO_THE_HEART then
		tearSprite.Rotation = Tear.Velocity:GetAngleDegrees() + 90
	end

	if Tear.Variant == CustomTearVariants.DOGMA_FEATHER and Tear.FrameCount % 3 == 0 then
		Tear.CollisionDamage = Tear.CollisionDamage * 1.02
	end

	if Tear.Height >= -5
	or Tear:CollidesWithGrid() then
		local tearToSplashCol = {
			[CustomTearVariants.CEREMONIAL_BLADE] = Color(0.56, 0.56, 0.56, 1, 0, 0, 0),
			[CustomTearVariants.SINNERS_HEART] = Color(0.93, 0.22, 0.56, 1, 0, 0, 0),
			[CustomTearVariants.REJECTED_BABY] = Color(0.87, 0.24, 0.18, 1, 0, 0, 0),
			[CustomTearVariants.DOGMA_FEATHER] = Color(0.53, 0.51, 0.59, 1, 0, 0, 0),
			[CustomTearVariants.KEY_TO_THE_HEART] = Color(0.56, 0.56, 0.56, 1, 0, 0, 0),
		}

		if tearToSplashCol[Tear.Variant] then
			-- Manually making tears leave splashes when they land
			local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0, Tear.Position, Vector.Zero, Tear):ToEffect()

			splash:SetColor(tearToSplashCol[Tear.Variant], 100, 1, false, false)

			-- Remove laser impacts left by Trisagion
			for _, impact in pairs(Isaac.FindByType(1000, 50)) do
				if impact.SpawnerType == 7 then impact:Remove() end
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, rplus.OnTearUpdate)


						-- MC_PRE_TEAR_COLLISION --										
						---------------------------
---@param Tear EntityTear
---@param Collider Entity
function rplus:TearCollision(Tear, Collider, _)
	local Player
	if Tear.Parent then
		Player = Tear.Parent:ToPlayer()
	elseif Tear.SpawnerEntity then
		Player = Tear.SpawnerEntity:ToPlayer()
	end
	if not Player then return end

	if Collider:IsVulnerableEnemy() and not Collider:IsBoss()
	and Collider.Type ~= 951 then
		rng:SetSeed(Tear.InitSeed + Random(), 1)

		if Tear.Variant == CustomTearVariants.ANTIMATERIAL_CARD then
			table.insert(CustomData.Data.ErasedEnemies, Collider.Type)
			Tear:Remove()
		end

		if Tear.Variant == CustomTearVariants.VALENTINES_CARD then
			Collider:AddCharmed(EntityRef(Player), -1)
		end

		if Player:HasCollectible(CustomCollectibles.CROSS_OF_CHAOS) then
			local roll = rng:RandomFloat() * 100
			local trueCrippleChance = math.max(ModConstants.Chances.CROSS_OF_CHAOS_TEAR_CRIPPLE, ModConstants.Chances.CROSS_OF_CHAOS_TEAR_CRIPPLE + Player.Luck / 2)
			trueCrippleChance = math.min(trueCrippleChance, 7)

			if roll < trueCrippleChance then
				crippleEnemy(Collider)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, rplus.TearCollision)


						-- MC_POST_LASER_UPDATE --
						--------------------------
---@param Laser EntityLaser
function rplus:OnLaserUpdate(Laser)
	-- replacing the spritesheet of static Dogma laser
	if Laser.FrameCount <= 2 and Laser.SpawnerEntity and Laser.SpawnerEntity:ToPlayer()
	and Laser:GetData().IsDogmaLaser and Laser.Variant == 3 then
		sfx:Stop(SoundEffect.SOUND_BLOOD_LASER)
		Laser:GetSprite():ReplaceSpritesheet(0, "gfx/dogma_laser.png")
		Laser:GetSprite():LoadGraphics()

		Laser:GetSprite().Scale = Vector(1.0 + Laser:GetData().scaleUp , 1.0 + Laser:GetData().scaleUp)

		if Laser.Child then
			Laser.Child:GetSprite():ReplaceSpritesheet(0, "gfx/dogma_laser_end.png")
			Laser.Child:GetSprite():LoadGraphics()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, rplus.OnLaserUpdate)


						-- MC_EVALUATE_CACHE --							
						-----------------------
---@param Player EntityPlayer
function rplus:OnCacheEvaluate(Player, Flag)
	-- If any Stat-Changes are done, just check for the collectible in the cacheflag (be sure to set the cacheflag in the items.xml)

	if Flag == CacheFlag.CACHE_DAMAGE then
		-- temporary dmg boosts
		if Player:GetData().flagGiveTempBoost then
			Player.Damage = Player.Damage + CustomStatups.Damage.DMG_TEMPORARY * (Player:GetData().numTempBoosts - Player:GetData().boostTimeStep / 50)
		end

		if Player:HasCollectible(CustomCollectibles.SINNERS_HEART) then
			Player.Damage = Player.Damage + CustomStatups.Damage.SINNERS_HEART_ADD
			Player.Damage = Player.Damage * CustomStatups.Damage.SINNERS_HEART_MUL
		end

		if Player:HasTrinket(CustomTrinkets.MAGIC_SWORD) then
			Player.Damage = Player.Damage * CustomStatups.Damage.MAGIC_SWORD_MUL * Player:GetTrinketMultiplier(CustomTrinkets.MAGIC_SWORD)
		end

		if Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CHEESE_GRATER_NULL) > 0 then
			Player.Damage = Player.Damage * CustomStatups.Damage.CHEESE_GRATER_MUL ^ (Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CHEESE_GRATER_NULL))
		end

		if Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.BLESS_OF_THE_DEAD) > 0 then
			Player.Damage = Player.Damage * CustomStatups.Damage.BLESS_OF_THE_DEAD_MUL ^ (Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.BLESS_OF_THE_DEAD))
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.YUM_DAMAGE_NULL) then
			Player.Damage = Player.Damage + CustomStatups.Damage.PILL_YUM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.YUM_DAMAGE_NULL)
		end

		if Player:GetEffects():HasTrinketEffect(CustomTrinkets.BONE_MEAL) then
			Player.Damage = Player.Damage * CustomStatups.Damage.BONE_MEAL_MUL ^ (Player:GetEffects():GetTrinketEffectNum(CustomTrinkets.BONE_MEAL))
		end

		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) and CustomData.Data then
			Player.Damage = Player.Damage + CustomStatups.Damage.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.numStats
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL) then
			Player.Damage = Player.Damage + CustomStatups.Damage.DEMON_FORM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.DEMON_FORM_NULL)
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.HEART_BENIGHTED_NULL) then
			Player.Damage = Player.Damage * (1 + Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.HEART_BENIGHTED_NULL) * 0.00666)
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) then
			Player.Damage = Player.Damage * CustomStatups.Damage.APPLE_OF_PRIDE_MUL ^ Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		end
	end

	if Flag == CacheFlag.CACHE_FIREDELAY then
		if Player:HasCollectible(CustomCollectibles.ORDINARY_LIFE) then
			Player.MaxFireDelay = Player.MaxFireDelay * CustomStatups.Tears.ORDINARY_LIFE_MUL
		end

		if Player:HasCollectible(CustomCollectibles.GUSTY_BLOOD) then
			Player.MaxFireDelay = GetFireDelay(GetTears(Player.MaxFireDelay) + CustomStatups.Tears.GUSTY_BLOOD * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.GUSTY_BLOOD) ^ 2 / (Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.GUSTY_BLOOD) + 1))
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.YUM_TEARS_NULL) then
			Player.MaxFireDelay = GetFireDelay(GetTears(Player.MaxFireDelay) + CustomStatups.Tears.PILL_YUM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.YUM_TEARS_NULL))
		end

		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) and CustomData.Data then
			Player.MaxFireDelay = GetFireDelay(GetTears(Player.MaxFireDelay) + CustomStatups.Tears.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.numStats)
		end

		if Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CURSED_CARD_NULL) > 0 then
			Player.MaxFireDelay = GetFireDelay(GetTears(Player.MaxFireDelay) + CustomStatups.Tears.CURSED_CARD * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CURSED_CARD_NULL))
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) then
			Player.MaxFireDelay = Player.MaxFireDelay * CustomStatups.Tears.APPLE_OF_PRIDE_MUL ^ Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		end
	end

	if Flag == CacheFlag.CACHE_TEARFLAG then
		if Player:HasCollectible(CustomCollectibles.SINNERS_HEART) then
			Player.TearFlags = Player.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
		end

		if Player:HasTrinket(CustomTrinkets.TORN_PAGE) and Player:GetData().tornPageBookOfBelial then
			Player.TearFlags = Player.TearFlags | TearFlags.TEAR_BELIAL | TearFlags.TEAR_PIERCING
		end

		if Player:HasCollectible(CustomCollectibles.ANGELS_WINGS) then
			Player.TearFlags = Player.TearFlags | TearFlags.TEAR_PIERCING
		end
	end

	if Flag == CacheFlag.CACHE_SHOTSPEED then
		if Player:HasCollectible(CustomCollectibles.SINNERS_HEART)  then
			Player.ShotSpeed = Player.ShotSpeed + CustomStatups.ShotSpeed.SINNERS_HEART
		end

		if Player:HasCollectible(CustomCollectibles.ANGELS_WINGS)  then
			Player.ShotSpeed = Player.ShotSpeed + CustomStatups.ShotSpeed.ANGELS_WINGS
		end
	end

	if Flag == CacheFlag.CACHE_RANGE then
		-- (((Range currently not functioning, blame Edmund)))
		-- it's working now, yo!
		if Player:HasCollectible(CustomCollectibles.SINNERS_HEART)  then
			Player.TearRange = Player.TearRange + CustomStatups.Range.SINNERS_HEART * 40
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.YUM_RANGE_NULL) then
			Player.TearRange = Player.TearRange + CustomStatups.Range.PILL_YUM * 40 * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.YUM_RANGE_NULL)
		end

		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) and CustomData.Data then
			Player.TearRange = Player.TearRange + CustomStatups.Range.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.numStats * 40
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) then
			Player.TearRange = Player.TearRange + CustomStatups.Range.APPLE_OF_PRIDE * 40 * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		end
	end

	if Flag == CacheFlag.CACHE_FAMILIARS then
		-- toys
		Player:CheckFamiliar(CustomFamiliars.TOY_HELICOPTER_TANK, getTrueFamiliarNum(Player, CustomCollectibles.TANK_BOYS), Player:GetCollectibleRNG(CustomCollectibles.TANK_BOYS), nil, 0)
		Player:CheckFamiliar(CustomFamiliars.TOY_HELICOPTER_TANK, getTrueFamiliarNum(Player, CustomCollectibles.TANK_BOYS), Player:GetCollectibleRNG(CustomCollectibles.TANK_BOYS), nil, 1)
		Player:CheckFamiliar(CustomFamiliars.TOY_HELICOPTER_TANK, getTrueFamiliarNum(Player, CustomCollectibles.HELICOPTER_BOYS), Player:GetCollectibleRNG(CustomCollectibles.HELICOPTER_BOYS), nil, 10)
		Player:CheckFamiliar(CustomFamiliars.TOY_HELICOPTER_TANK, getTrueFamiliarNum(Player, CustomCollectibles.HELICOPTER_BOYS), Player:GetCollectibleRNG(CustomCollectibles.HELICOPTER_BOYS), nil, 11)

		-- orbital ghosts
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.ORBITAL_GHOSTS) then
			local g = Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.ORBITAL_GHOSTS)
			for _, v in pairs({1, 2, 8}) do
				Player:CheckFamiliar(CustomFamiliars.ORBITAL_GHOST, (g % (v * 2)) // v, Player:GetCollectibleRNG(1), nil, v)
			end
		end
		Player:CheckFamiliar(CustomFamiliars.ORBITAL_GHOST, Player:GetTrinketMultiplier(CustomTrinkets.MY_SOUL), Player:GetCollectibleRNG(1), nil, 16)

		Player:CheckFamiliar(CustomFamiliars.BAG_O_TRASH, getTrueFamiliarNum(Player, CustomCollectibles.BAG_O_TRASH), Player:GetCollectibleRNG(CustomCollectibles.BAG_O_TRASH))
		Player:CheckFamiliar(CustomFamiliars.CHERUBIM, getTrueFamiliarNum(Player, CustomCollectibles.CHERUBIM), Player:GetCollectibleRNG(CustomCollectibles.CHERUBIM))
		if not Player:GetData().fightingSiblings then
			Player:CheckFamiliar(CustomFamiliars.SIBLING_1, getTrueFamiliarNum(Player, CustomCollectibles.SIBLING_RIVALRY), Player:GetCollectibleRNG(CustomCollectibles.SIBLING_RIVALRY))
			Player:CheckFamiliar(CustomFamiliars.SIBLING_2, getTrueFamiliarNum(Player, CustomCollectibles.SIBLING_RIVALRY), Player:GetCollectibleRNG(CustomCollectibles.SIBLING_RIVALRY))
		else
			Player:CheckFamiliar(CustomFamiliars.FIGHTING_SIBLINGS, getTrueFamiliarNum(Player, CustomCollectibles.SIBLING_RIVALRY), Player:GetCollectibleRNG(CustomCollectibles.SIBLING_RIVALRY))
		end
		Player:CheckFamiliar(CustomFamiliars.REJECTION_FETUS, getTrueFamiliarNum(Player, CustomCollectibles.REJECTION_P), Player:GetCollectibleRNG(CustomCollectibles.REJECTION_P))
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.MARK_OF_CAIN) then
			Player:CheckFamiliar(CustomFamiliars.ENOCH_B, getTrueFamiliarNum(Player, CustomCollectibles.MARK_OF_CAIN) - 1, Player:GetCollectibleRNG(CustomCollectibles.MARK_OF_CAIN))
		else
			Player:CheckFamiliar(CustomFamiliars.ENOCH, getTrueFamiliarNum(Player, CustomCollectibles.MARK_OF_CAIN), Player:GetCollectibleRNG(CustomCollectibles.MARK_OF_CAIN))
		end
		Player:CheckFamiliar(CustomFamiliars.FRIENDLY_SACK, getTrueFamiliarNum(Player, CustomCollectibles.FRIENDLY_SACK), Player:GetCollectibleRNG(CustomCollectibles.FRIENDLY_SACK))
		if Player:GetData().UFKLevel == 1 or not Player:GetData().UFKLevel then
			Player:CheckFamiliar(CustomFamiliars.ULTRA_FLESH_KID_L1, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))
		elseif Player:GetData().UFKLevel == 2 then
			Player:CheckFamiliar(CustomFamiliars.ULTRA_FLESH_KID_L2, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))
		elseif Player:GetData().UFKLevel == 3 then
			Player:CheckFamiliar(CustomFamiliars.ULTRA_FLESH_KID_L3, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))
		end

		-- Helper familiar: Leech for Ultra Flesh Kid
		Player:CheckFamiliar(FamiliarVariant.LEECH, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID) + getTrueFamiliarNum(Player, CollectibleType.COLLECTIBLE_LEECH), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))

		Player:CheckFamiliar(CustomFamiliars.KEEPERS_ANNOYING_FLY, getTrueFamiliarNum(Player, CustomCollectibles.KEEPERS_ANNOYING_FLY), Player:GetCollectibleRNG(CustomCollectibles.KEEPERS_ANNOYING_FLY))
		Player:CheckFamiliar(CustomFamiliars.DEAD_WEIGHT, getTrueFamiliarNum(Player, CustomCollectibles.DEAD_WEIGHT), Player:GetCollectibleRNG(CustomCollectibles.DEAD_WEIGHT))
		Player:CheckFamiliar(FamiliarVariant.GEMINI, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.HARLOT_FETUS), Player:GetCollectibleRNG(CustomCollectibles.HARLOT_FETUS), nil, 10)
	end

	if Flag == CacheFlag.CACHE_LUCK then
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.LOADED_DICE_NULL) then
			Player.Luck = Player.Luck + CustomStatups.Luck.LOADED_DICE * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.LOADED_DICE_NULL)
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.YUM_LUCK_NULL) then
			Player.Luck = Player.Luck + CustomStatups.Luck.PILL_YUM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.YUM_LUCK_NULL)
		end

		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) and CustomData.Data then
			Player.Luck = Player.Luck + CustomStatups.Luck.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.numStats
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.CROWN_OF_GREED_NULL) then
			Player.Luck = Player.Luck - Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CROWN_OF_GREED_NULL)
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) then
			Player.Luck = Player.Luck + CustomStatups.Luck.APPLE_OF_PRIDE * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		end
	end

	if Flag == CacheFlag.CACHE_SPEED then
		if Player:HasCollectible(CustomCollectibles.GUSTY_BLOOD) then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.GUSTY_BLOOD * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.GUSTY_BLOOD) ^ 2 / (Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.GUSTY_BLOOD) + 1)
		end

		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) and CustomData.Data then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.numStats
		end

		if Player:HasCollectible(CustomCollectibles.NERVE_PINCH) then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.NERVE_PINCH * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.NERVE_PINCH)
		end

		if Player:HasCollectible(CustomCollectibles.HAND_ME_DOWNS) then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.HAND_ME_DOWNS
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.APPLE_OF_PRIDE * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		end

		if Player:GetData().voidOfGluttonyRegenData
		and Player:GetData().voidOfGluttonyRegenData.regen
		and not Player:HasTrinket(CustomTrinkets.JEWEL_DIADEM) then
			Player.MoveSpeed = Player.MoveSpeed - Player:GetData().voidOfGluttonyRegenData.amount
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.YUM_SPEED_NULL) then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.PILL_YUM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.YUM_SPEED_NULL)
		end
	end

	if Flag == CacheFlag.CACHE_FLYING and CustomData.Data then
		if CustomData.Data.Items.BIRD_OF_HOPE.catchingBird then
			Player.CanFly = true
		end
	end

	if Flag == CacheFlag.CACHE_TEARCOLOR then
		if Player:HasCollectible(CustomCollectibles.CROSS_OF_CHAOS) then
			Player.TearColor = Color(0.15, 0.15, 0.15, 1, 0, 0, 0)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rplus.OnCacheEvaluate)


--[[Familiar callbacks:	MC_FAMILIAR_INIT
						MC_FAMILIAR_UPDATE
						MC_PRE_FAMILIAR_COLLISION				
--------------------------]]
---@param Familiar EntityFamiliar
function rplus:FamiliarInit(Familiar)
	local fSprite = Familiar:GetSprite()

	if Familiar.Variant == CustomFamiliars.BAG_O_TRASH or  Familiar.Variant == CustomFamiliars.CHERUBIM
	or Familiar.Variant == CustomFamiliars.REJECTION_FETUS or Familiar.Variant == CustomFamiliars.ENOCH
	or Familiar.Variant == CustomFamiliars.ENOCH_B or Familiar.Variant == CustomFamiliars.FRIENDLY_SACK then
		Familiar:AddToFollowers()
		Familiar.IsFollower = true

		if Familiar.Variant == CustomFamiliars.BAG_O_TRASH then
			Familiar:GetData().Levels = 1
		end
	end

	if Familiar.Variant == CustomFamiliars.DEAD_WEIGHT then
		Familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	end

	if Familiar.Variant == CustomFamiliars.TOY_HELICOPTER_TANK then
		local s = Familiar.SubType

		if s < 10 then
			Familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			Familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			if s == 0 then
				Familiar:GetData().Data = {lineOfSightDist = 450, lineOfSightAngle = 40, tankVelocityMul = 3.5,
											tankAttackBuffer = 8, currBuffer = 0, projectileVelocityMul = 20, newRoomAttackHold = 5}
			else
				Familiar:GetData().Data = {lineOfSightDist = 300, lineOfSightAngle = 10, tankVelocityMul = 1.75,
											tankAttackBuffer = 60, currBuffer = 0, projectileVelocityMul = 10, newRoomAttackHold = 30}
			end
		else
			Familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			Familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			if s == 10 then
				Familiar:GetData().Data = {lineOfSightDist = 450, lineOfSightAngle = 40, tankVelocityMul = 3.5,
											tankAttackBuffer = 2, currBuffer = 0, projectileVelocityMul = 17.5, newRoomAttackHold = 5}
			else
				Familiar:GetData().Data = {lineOfSightDist = 500, lineOfSightAngle = 40, tankVelocityMul = 1.75,
											tankAttackBuffer = 60, currBuffer = 0, --[[unused]]projectileVelocityMul = 0, newRoomAttackHold = 30}
			end
		end
	end

	if Familiar.Variant == CustomFamiliars.SIBLING_1 or Familiar.Variant == CustomFamiliars.SIBLING_2
	or Familiar.Variant == CustomFamiliars.FIGHTING_SIBLINGS then
		Familiar:AddToOrbit(25)
		fSprite:Play("Idle")
		fSprite.PlaybackSpeed = 0.75
	end

	if Familiar.Variant == CustomFamiliars.ORBITAL_GHOST then
		Familiar:AddToOrbit(30)
	end

	if Familiar.Variant == CustomFamiliars.KEEPERS_ANNOYING_FLY then
		Familiar:AddToOrbit(15)
	end
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, rplus.FamiliarInit)

---@param Familiar EntityFamiliar
function rplus:FamiliarUpdate(Familiar)
	--[[ VANILLA --]]
		if Familiar.Variant == FamiliarVariant.WISP
		and Familiar.FrameCount == 5 and Familiar.Player:HasTrinket(CustomTrinkets.TORN_PAGE) then
			Familiar.MaxHitPoints = Familiar.MaxHitPoints * 1.5
			Familiar.HitPoints = Familiar.MaxHitPoints
		end

		if Familiar.Variant == FamiliarVariant.ISAACS_HEART
		and Isaac.GetChallenge() == CustomChallenges.IN_THE_LIGHT
		and Familiar.FrameCount <= 5 then
			Familiar:GetSprite():Load("gfx/challenge_isaacs_tv.anm2", true)
		end

		if Familiar.Variant == FamiliarVariant.GB_BUG
		and Familiar:GetSprite():IsPlaying("Float") and (math.abs(Familiar.Velocity.X) == 10 or math.abs(Familiar.Velocity.Y) == 10) then
			--* from the wiki:
			-- if GB bug rerolls a chest, it has a 28% chance to stay a chest. 75% for it to be a random chest, 25% for a locked one
			local Pickup = nil
			for t = 512, 515 do
				if #Isaac.FindByType(5, t, 0) > 0 and Isaac.FindByType(5, t, 0)[1].Position:Distance(Familiar.Position) < 15 then
					Pickup = Isaac.FindByType(5, t, 0)[1]:ToPickup()
				end
			end

			if Pickup then
				local newVariant = PickupVariant.PICKUP_LOCKEDCHEST
				rng:SetSeed(Pickup.InitSeed, 3)
				local pickupRoll = rng:RandomFloat() * 100
				local chestRoll = rng:RandomFloat() * 100

				if pickupRoll < 28 then
					if chestRoll < 75 then
						newVariant = PickupVariant.PICKUP_CHEST
					end
				else
					newVariant = (rng:RandomInt(4) + 1) * 10
				end

				Pickup:Morph(5, newVariant, 0, true, true, false)
				Isaac.Spawn(1000, EffectVariant.POOF01, 0, Pickup.Position, Vector.Zero, Familiar)
				sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)
				Familiar:Remove()
				Familiar.Player:GetData().shouldReviveGBBug = true
			end
		end
	--[[ VANILLA END --]]

	if Familiar.Variant == CustomFamiliars.BAG_O_TRASH then
		Familiar:FollowParent()
		if Familiar:GetSprite():IsFinished("Spawn") or Familiar.FrameCount == 10 then
			Familiar:GetSprite().PlaybackSpeed = 1.0
			Familiar:GetSprite():Play("FloatDown")
		end

		if Familiar.RoomClearCount >= 1 then
			rng:SetSeed(Familiar.InitSeed, 1)
			local roll = rng:RandomFloat() * Familiar:GetData().Levels * 1.2
			local NumFlies = math.floor(roll) + 1

			Familiar:GetSprite().PlaybackSpeed = 0.5
			Familiar:GetSprite():Play("Spawn")
			for _ = 1, (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS, true) and NumFlies + 1 or NumFlies) do
				local fly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, Familiar.Position, Vector.Zero, Familiar)
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end

			if Sewn_API then
				if Sewn_API:GetLevel(Familiar:GetData()) == 2 then
					local NumSpiders = math.floor(roll) + 1

					for _ = 1, (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS, true) and NumSpiders + 1 or NumSpiders) do
						local spooder = Isaac.Spawn(3, FamiliarVariant.BLUE_SPIDER, 0, Familiar.Position, Vector.Zero, Familiar)
						spooder:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
				end
			end

			Familiar.RoomClearCount = 0
		end
	end

	if Familiar.Variant == CustomFamiliars.CHERRY then
		if Familiar.Velocity:Length() > 1 then
			Familiar.Velocity = Vector.Zero
			Familiar.Friction = 0
		end

		if game:GetRoom():IsClear() then
			Familiar:GetSprite():Play("Collect")

			if Familiar:GetSprite():IsFinished("Collect") then
				Familiar:Remove()
				rng:SetSeed(Familiar.DropSeed, 1)

				if rng:RandomFloat() < 0.33 then
					Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, Familiar.Position, Vector.Zero, Familiar)
				end
			end
		end
	end

	if Familiar.Variant == CustomFamiliars.CHERUBIM then
		Familiar:FollowParent()
		local Sprite = Familiar:GetSprite()
		local Player = Familiar.Player
		local TearVector

		if Player:GetFireDirection() == Direction.NO_DIRECTION then
			Sprite:Play(DIRECTION_FLOAT_ANIM[Player:GetMovementDirection()], false)
		else
			TearVector = DIRECTION_VECTOR[Player:GetFireDirection()]
			Sprite:Play(DIRECTION_SHOOT_ANIM[Player:GetFireDirection()], false)
		end

		if Player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and #Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true) > 0 then
			TearVector = (Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true)[1].Position - Familiar.Position):Normalized()
			Sprite:Play(DIRECTION_SHOOT_ANIM[Player:GetFireDirection()], false)
		end

		if Familiar.FireCooldown <= 0 and TearVector then
			local Tear = Familiar:FireProjectile(TearVector * 0.75):ToTear()
			Tear.CollisionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 10 or 5)
			Tear.TearFlags = TearFlags.TEAR_GLOW | TearFlags.TEAR_HOMING

			if Sewn_API then
				local crownTier = Sewn_API:GetLevel(Familiar:GetData())

                if crownTier >= 1 then
					Tear.CollisionDamage = Tear.CollisionDamage * 1.25
					Tear.Scale = Tear.Scale * 1.25
				end

				if crownTier == 2 then
					Tear:ChangeVariant(TearVariant.EYE)
					Tear.TearFlags = TearFlags.TEAR_GLOW | TearFlags.TEAR_HOMING | TearFlags.TEAR_POP
				end
			end

			Tear:Update()

			if Player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
				Familiar.FireCooldown = 12
			else
				Familiar.FireCooldown = 18
			end
		end

		Familiar.FireCooldown = Familiar.FireCooldown - 1
	end

	if Familiar.Variant == CustomFamiliars.REJECTION_FETUS then
		Familiar:FollowParent()
		Familiar:GetSprite():Play("Rotate")
	end

	if Familiar.Variant == CustomFamiliars.ENRAGED_SOUL then
		if Familiar:GetData().attachedEnemy then
			if Familiar:GetData().attachedEnemy:IsActiveEnemy() and Familiar:GetData().attachmentFrames >= 0 then
				Familiar.Position = Familiar:GetData().attachedEnemy.Position
				Familiar:GetData().attachmentFrames = Familiar:GetData().attachmentFrames - 1
			else
				Familiar:Remove()
				Familiar:GetData().attachedEnemy = nil
			end
		end

		if Familiar:GetData().launchRoom ~= game:GetLevel():GetCurrentRoomIndex() or Familiar.RoomClearCount == 1 then
			Familiar:Remove()
			Familiar.RoomClearCount = 0
		end
	end

	if Familiar.Variant == CustomFamiliars.TOY_HELICOPTER_TANK then
		-- moving around (BASEMENT DRIFT YOOO)
		-- change direction naturally; they change direction when colliding with grid automatically
		if game:GetFrameCount() % 48 == 0 then
			local randomVector = Vector(1, 0)
			rng:SetSeed(Random() + Familiar.InitSeed, 1)
			local roll = rng:RandomInt(3)

			if roll == 0 then randomVector = Vector(-1, 0)
			elseif roll == 1 then randomVector = Vector(0, 1)
			else randomVector = Vector(0, -1) end

			Familiar.Velocity = randomVector * Familiar:GetData().Data.tankVelocityMul
		end

		-- correct the velocity when colliding with grid so that the tanks don't move diagonally
		local TX = Familiar.Velocity.X
		local TY = Familiar.Velocity.Y
		if TY > 0 and TX <= TY and TX >= -TY then
			Familiar.Velocity = Vector(0, 1) * Familiar:GetData().Data.tankVelocityMul
		elseif TX > 0 and TY < TX and TY > -TX then
			Familiar.Velocity = Vector(1, 0) * Familiar:GetData().Data.tankVelocityMul
		elseif TX <= 0 and TY < -TX and TY > TX then
			Familiar.Velocity = Vector(-1, 0) * Familiar:GetData().Data.tankVelocityMul
		else
			Familiar.Velocity = Vector(0, -1) * Familiar:GetData().Data.tankVelocityMul
		end

		local tankSprite = Familiar:GetSprite()
		if Familiar.Velocity.X < -0.1 and math.abs(Familiar.Velocity.Y) < 0.1  then tankSprite:Play("MoveLeft")
		elseif Familiar.Velocity.Y < -0.1 and math.abs(Familiar.Velocity.X) < 0.1 then tankSprite:Play("MoveUp")
		elseif Familiar.Velocity.X > 0.1 and math.abs(Familiar.Velocity.Y) < 0.1 then tankSprite:Play("MoveRight")
		else tankSprite:Play("MoveDown") end

		-- shooting at enemies
		for _, enemy in pairs(Isaac.FindInRadius(Familiar.Position, Familiar:GetData().Data.lineOfSightDist, EntityPartition.ENEMY)) do
			if enemy.Type ~= EntityType.ENTITY_SHOPKEEPER and enemy.Type ~= EntityType.ENTITY_FIREPLACE
			and enemy:IsVulnerableEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_CHARM) then
				local curVel = Familiar.Velocity:Normalized()
				local posDiff = (enemy.Position - Familiar.Position):Normalized()

				if game:GetRoom():CheckLine(enemy.Position, Familiar.Position, 3, 0, false, Familiar.SubType > 1) and
				math.abs(curVel:GetAngleDegrees() - posDiff:GetAngleDegrees()) < Familiar:GetData().Data.lineOfSightAngle then
					if game:GetFrameCount() > Familiar:GetData().Data.currBuffer + Familiar:GetData().Data.tankAttackBuffer
					and game:GetRoom():GetFrameCount() > Familiar:GetData().Data.newRoomAttackHold then
						if Familiar.SubType == 0 then
							-- shoot normal bullets quite frequently
							local tankBullet = Isaac.Spawn(2, TearVariant.METALLIC, 0, Familiar.Position, posDiff * Familiar:GetData().Data.projectileVelocityMul, Familiar):ToTear()
							tankBullet.CollisionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 7 or 3.5)
							tankBullet.KnockbackMultiplier = 0.8

							if Sewn_API then
								-- Sewing Machine upgrade
								if Sewn_API:GetLevel(Familiar:GetData()) >= 1 then
									tankBullet:AddTearFlags(TearFlags.TEAR_HOMING)
								end

								if Sewn_API:GetLevel(Familiar:GetData()) == 2 then
									for _, familiarInRoom in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, CustomFamiliars.TOY_HELICOPTER_TANK, 1, false, false)) do
										local tankLaser = EntityLaser.ShootAngle(2,	familiarInRoom.Position, (enemy.Position - familiarInRoom.Position):Normalized():GetAngleDegrees(), 7, Vector.Zero, familiarInRoom)
										tankLaser.CollisionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 7 or 3.5)
									end
								end
							end

						elseif Familiar.SubType == 1 then
							-- shoot rockets
							local tankRocket = Isaac.Spawn(4, 19, 0, Familiar.Position, Vector.Zero, Familiar):ToBomb()
							tankRocket.SpriteScale = Vector(0.6, 0.6)
							tankRocket:GetData().forcedRocketTargetVel = curVel * Familiar:GetData().Data.projectileVelocityMul
							tankRocket.ExplosionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 70 or 35)

						elseif Familiar.SubType == 10 then
							-- shoot weak spectral bullets very frequently (soy milk tears)
							posDiff = (enemy.Position - (Familiar.Position - Vector(0, 48))):Normalized()
							local heliBullet = Isaac.Spawn(2, TearVariant.METALLIC, 0, Familiar.Position - Vector(0, 48), posDiff * Familiar:GetData().Data.projectileVelocityMul, Familiar):ToTear()
							heliBullet.CollisionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 1.4 or 0.7)
							heliBullet.Scale = 0.33
							heliBullet.KnockbackMultiplier = 0.5
							heliBullet:AddTearFlags(TearFlags.TEAR_SPECTRAL)

						elseif Familiar.SubType == 11 then
							-- do an airstrike
							local airstrike = Isaac.Spawn(1000, EffectVariant.TARGET, 0, enemy.Position, Vector.Zero, Familiar):ToEffect()
							airstrike.State = 1
							airstrike.Timeout = 27

						end

						Familiar:GetData().Data.currBuffer = game:GetFrameCount()
					end
				end
			end
		end
	end

	if Familiar.Variant == CustomFamiliars.SIBLING_1 or Familiar.Variant == CustomFamiliars.SIBLING_2 or Familiar.Variant == CustomFamiliars.FIGHTING_SIBLINGS then
		Familiar.Velocity = Familiar:GetOrbitPosition(Familiar.Player.Position + Familiar.Player.Velocity) - Familiar.Position

		if Familiar.Variant == CustomFamiliars.SIBLING_1 or Familiar.Variant == CustomFamiliars.SIBLING_2 then
			Familiar.OrbitDistance = Vector(75, 75)
			Familiar.OrbitSpeed = 0.04
		else
			Familiar.OrbitDistance = Vector(60, 60)
			Familiar.OrbitSpeed = 0.03

			-- Randomly shooting tooth tears and spawning blood creep
			if game:GetFrameCount() % 12 == 0 then
				local toothTear = Familiar:FireProjectile(Vector.FromAngle(math.random(360)))
				toothTear:ChangeVariant(TearVariant.TOOTH)
				toothTear.Velocity = toothTear.Velocity / 2
			end

			if game:GetFrameCount() % 18 == 0 then
				Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, Familiar.Position, Vector.Zero, Familiar)
			end
		end
	end

	if Familiar.Variant == CustomFamiliars.KEEPERS_ANNOYING_FLY then
		Familiar.Velocity = Familiar:GetOrbitPosition(Familiar.Player.Position + Familiar.Player.Velocity) - Familiar.Position
		Familiar.OrbitDistance = Vector(80, 80)
		Familiar.OrbitSpeed = 0.025
	end

	if Familiar.IsFollower and Familiar.Player:GetData().RejectionUsed
	and not (Familiar.Variant == FamiliarVariant.INCUBUS and Familiar.Player:GetPlayerType() == PlayerType.PLAYER_LILITH) then
		Familiar:Remove()
	end

	if Familiar.Variant == CustomFamiliars.ENOCH or Familiar.Variant == CustomFamiliars.ENOCH_B then
		Familiar:FollowParent()
		local Sprite = Familiar:GetSprite()
		local Player = Familiar.Player
		local TearVector

		if Player:GetFireDirection() == Direction.NO_DIRECTION then
			Sprite:Play(DIRECTION_FLOAT_ANIM[Player:GetMovementDirection()], false)
		else
			TearVector = DIRECTION_VECTOR[Player:GetFireDirection()]
			Sprite:Play(DIRECTION_SHOOT_ANIM[Player:GetFireDirection()], false)
		end

		if Player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and #Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true) > 0 then
			TearVector = (Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true)[1].Position - Familiar.Position):Normalized()
			Sprite:Play(DIRECTION_SHOOT_ANIM[Player:GetFireDirection()], false)
		end

		if Familiar.FireCooldown <= 0 and TearVector then
			local Tear = Familiar:FireProjectile(TearVector):ToTear()
			Tear.TearFlags = TearFlags.TEAR_TURN_HORIZONTAL

			if Familiar.Variant == CustomFamiliars.ENOCH_B then
				Tear:ChangeVariant(TearVariant.ROCK)
				if math.random(100) <= 7 then Tear.TearFlags = Tear.TearFlags | TearFlags.TEAR_RIFT end
				Tear.CollisionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 8.75 or 4.375)
				for i = 1, 3 do
					local headBloodSpit = Isaac.Spawn(2, TearVariant.BLOOD, 0, Familiar.Position, Vector.FromAngle(math.random(360)) * 1.5, Familiar):ToTear()
					headBloodSpit.FallingSpeed = math.random(-25, -20)
					headBloodSpit.FallingAcceleration = math.random(125, 175) / 100
					headBloodSpit.Scale = headBloodSpit.Scale * math.random(75, 90) / 100
					headBloodSpit.CollisionDamage = 1.25
				end
			end

			Tear:Update()
			Familiar.FireCooldown = Player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 12 or 18
		end

		Familiar.FireCooldown = Familiar.FireCooldown - 1
	end

	if Familiar.Variant == CustomFamiliars.ORBITAL_GHOST then
		local s = Familiar:GetSprite()
		local Player = Familiar.Player
		Familiar.Velocity = Familiar:GetOrbitPosition(Familiar.Player.Position + Familiar.Player.Velocity) - Familiar.Position
		Familiar.OrbitDistance = Vector(20, 20)
		Familiar.OrbitSpeed = 0.03

		if Familiar:GetData().blockedShots == 3 then
			Familiar:GetData().blockedShots = 0
			s:Play("Death")
			sfx:Play(SoundEffect.SOUND_ISAACDIES, 1, 2, false, 1.5, 0)
			s.PlaybackSpeed = 1
		end

		if s:IsPlaying("Death") then
			if s:IsEventTriggered("Remove") then
				Isaac.Spawn(5, 10,
				(Player:HasCollectible(CustomCollectibles.SPIRITUAL_AMENDS) and Familiar.SubType ~= 8) and HeartSubType.HEART_ETERNAL or HeartSubType.HEART_HALF_SOUL,
				Familiar.Position, Vector.Zero, Familiar)
				Player:GetEffects():RemoveCollectibleEffect(CustomCollectibles.ORBITAL_GHOSTS, Familiar.SubType)
				Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
				Player:EvaluateItems()
				Familiar:Remove()
			end
		else
			local TearVector

			if Player:GetFireDirection() == Direction.NO_DIRECTION then
				s:Play("Float")
				s.PlaybackSpeed = 0.5
			else
				TearVector = DIRECTION_VECTOR[Player:GetFireDirection()]
				s:Play("Shoot")
			end

			if Player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and #Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true) > 0 then
				TearVector = (Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true)[1].Position - Familiar.Position):Normalized()
				s:Play("Shoot")
			end

			if Familiar.FireCooldown <= 0 and TearVector then
				local Tear = Familiar:FireProjectile(TearVector):ToTear()
				Tear.TearFlags = Tear.TearFlags | TearFlags.TEAR_SPECTRAL

				if Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER)
				or (Player:HasCollectible(CustomCollectibles.THE_HOOD) and Familiar.SubType == 8) then
					Tear:AddTearFlags(TearFlags.TEAR_HOMING)
				end
				Tear.CollisionDamage = Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 4 or 2
				Tear:Update()

				Familiar.FireCooldown = Player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 16 or 24
			end

			Familiar.FireCooldown = Familiar.FireCooldown - 1
		end
	end

	if Familiar.Variant == CustomFamiliars.FRIENDLY_SACK then
		local fsp = Familiar:GetSprite()

		Familiar:FollowParent()
		if fsp:IsFinished("Spawn") or fsp:IsFinished("Opening")
		or Familiar.FrameCount == 10 then
			fsp.PlaybackSpeed = 1.0
			fsp:Play("FloatDown")
		end

		if fsp:IsPlaying("Opening") and fsp:IsEventTriggered("MonsterSpawn") then
			Familiar.Player:UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, false, true, false, false, -1)
		end

		if Familiar.RoomClearCount >= 3 then
			if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
				fsp:Play("Opening")
			else
				local friends = {
					FamiliarVariant.BLUE_FLY,
					FamiliarVariant.BLUE_SPIDER,
					FamiliarVariant.DIP,
					FamiliarVariant.MINISAAC,
					FamiliarVariant.BLOOD_BABY,
					FamiliarVariant.WISP
				}
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomInt(6) + 1
				local roll2 = 0
				if roll == 1 then
					roll2 = rng:RandomInt(5) + 1
				elseif roll == 3 then
					roll2 = rng:RandomInt(14) + 1
				elseif roll == 4 then
					roll2 = rng:RandomInt(8) + 1
				elseif roll == 5 then
					roll2 = rng:RandomInt(6) + 1
				end

				fsp.PlaybackSpeed = 0.5
				fsp:Play("Spawn")
				CustomHealthAPI.PersistentData.IgnoreSumptoriumHandling = true
				Isaac.Spawn(3, friends[roll], roll2, Familiar.Position, Vector.Zero, Familiar.Player)
				CustomHealthAPI.PersistentData.IgnoreSumptoriumHandling = false
			end

			Familiar.RoomClearCount = 0
		end
	end

	if Familiar.Variant >= CustomFamiliars.ULTRA_FLESH_KID_L1 and Familiar.Variant <= CustomFamiliars.ULTRA_FLESH_KID_L3 then
		local d = Familiar:GetData()
		local sprite = Familiar:GetSprite()

		if not d.helper then
			for _, leech in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEECH)) do
				if leech:ToFamiliar().Keys ~= 13 then
					d.helper = leech
					leech:ToFamiliar():AddKeys(13)
					if Sewn_API then
						leech:ToFamiliar():GetData().Sewn_noUpgrade = Sewn_API.Enums.NoUpgrade.ANY
					end
					Familiar.Position = leech.Position
					break
				end
			end
		else
			Familiar.Velocity = d.helper.Velocity
			Familiar.SplatColor = Color(0,0,0,1)
			d.helper.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			d.helper.Visible = false
			local room = game:GetRoom()

			-- altering familiar's behaviour via states (can allow for custom attacks and red heart collecting)
			if not d.familiarState then
				d.familiarState = "normal"
			elseif d.familiarState == "normal" then
				if #getRedHeartPickups() > 0
				and (Familiar.Variant == CustomFamiliars.ULTRA_FLESH_KID_L1 or Familiar.Variant == CustomFamiliars.ULTRA_FLESH_KID_L2)
				and game:GetRoom():IsClear() then
					d.familiarState = "chasing red heart"
				end

				sprite:Play("Move")

				if game:GetFrameCount() % 6 == 0 then
					Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, Familiar.Position, Vector.Zero, Familiar)
				end

				if hasActiveChallenge(room) then
					if game:GetFrameCount() % 30 == 0
					and Familiar.Variant > CustomFamiliars.ULTRA_FLESH_KID_L1 then
						for i = 1, 8 do
							local tear = Familiar:FireProjectile(Vector.FromAngle(i * 45))
							tear.TearFlags = TearFlags.TEAR_NORMAL
							tear.FallingSpeed = -25
							tear.FallingAcceleration = 5
							tear:ChangeVariant(TearVariant.BLOOD)
							tear.CollisionDamage = Familiar.Variant == CustomFamiliars.ULTRA_FLESH_KID_L2 and 0.6 or 0.7
						end
					end

					if Familiar.Variant == CustomFamiliars.ULTRA_FLESH_KID_L3 and game:GetRoom():GetFrameCount() >= 75 then
						Familiar:GetSprite():Play("MoveBodyOnly")
						local head = Isaac.Spawn(3, CustomFamiliars.ULTRA_FLESH_KID_L3_HEAD, 0, Familiar.Position, Vector.FromAngle(135) * 7.5, Familiar):ToFamiliar()
						sfx:Play(SoundEffect.SOUND_PLOP)
						head.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
						head:GetSprite():Play("MoveHeadOnly")

						d.familiarState = "headout"
					end
				end
			elseif d.familiarState == "headout" then
				if not hasActiveChallenge(room) then
					d.familiarState = "normal"
					for _, head in pairs(Isaac.FindByType(3, CustomFamiliars.ULTRA_FLESH_KID_L3_HEAD)) do
						head:Remove()
					end
				else
					if game:GetFrameCount() % 16 == 0 then
						for i = 1, 8 do
							local tear = Familiar:FireProjectile(Vector.FromAngle(i * 45 + math.random(-15, 15)))
							tear.TearFlags = TearFlags.TEAR_NORMAL
							tear.FallingSpeed = -25
							tear.FallingAcceleration = 5
							tear:ChangeVariant(TearVariant.BLOOD)
							tear.CollisionDamage = 0.9
						end

						Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, Familiar.Position, Vector.Zero, Familiar):ToEffect().Scale = 1.75
					end
				end
			elseif d.familiarState == "chasing red heart" then
				local hp = getRedHeartPickups()

				if #hp == 0 then
					d.familiarState = "normal"
				else
					for _, h in pairs(hp) do
						-- instead of collecting red hearts, UFK will now just suck them towards him for better behaviour
						h.Velocity = (Familiar.Position - h.Position):Normalized() * 2.75

						if h.Position:Distance(d.helper.Position) < 15 then
							-- actual collecting
							h:Remove()
							sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
							local heartPoints = {
								[1] = 2,
								[2] = 1,
								[5] = 4,
								[9] = 2,
								[CustomPickups.TaintedHearts.HEART_HOARDED] = 8
							}
							Familiar:AddHearts(heartPoints[h.SubType])

							if Familiar.Hearts >= 15 then
								Familiar:Remove()
								local Player = Familiar.Player
								if Familiar.Variant == CustomFamiliars.ULTRA_FLESH_KID_L1 then
									Player:GetData().UFKLevel = 2
								else
									Player:GetData().UFKLevel = 3
								end
								Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
								Player:EvaluateItems()
							end
							d.familiarState = "normal"
						end
					end
				end

				sprite:Play("Move")
			end

			-- manually correcting helper's position and existance, just in case
			if math.abs((d.helper.Position - Familiar.Position).X) > 20 or math.abs((d.helper.Position - Familiar.Position).Y) > 20 then
				Familiar.Position = d.helper.Position
			end
			if not d.helper:Exists() then
				d.helper = nil
			end
		end
	end
	if Familiar.Variant == CustomFamiliars.ULTRA_FLESH_KID_L3_HEAD then
		if game:GetFrameCount() % 6 == 0 then
			Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, Familiar.Position, Vector.Zero, Familiar)
		end

		if Familiar.Velocity:LengthSquared() < 30 then
			Familiar.Velocity = Familiar.Velocity:Resized(5.5)
		end
	end

	if Familiar.Variant == CustomFamiliars.HANDICAPPED_PLACARD then
		Familiar.Friction = 0
		if not hasActiveChallenge(game:GetRoom()) then
			Familiar:Remove()
			for _, e in pairs(Isaac.FindByType(1000, HelperEffects.HANDICAPPED_PLACARD_AOE)) do
				if GetPtrHash(e.SpawnerEntity) == GetPtrHash(Familiar) then
					e:Remove()
				end
			end
		end

		for _, enemy in pairs(Isaac.FindInRadius(Familiar.Position, 800, EntityPartition.ENEMY)) do
			if enemy:IsActiveEnemy(true) then
				if enemy.Position:Distance(Familiar.Position) < 100 * Familiar:GetData().area then
					-- enemies near the placard
					if not enemy:GetData().wasNearPlacard then
						enemy:GetData().wasNearPlacard = true
						enemy:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
					end

					if (enemy:IsDead() or enemy:HasMortalDamage())
					and not enemy:GetData().placardDeathBurst then
						rng:SetSeed(enemy.DropSeed, 1)
						local roll = rng:RandomInt(2) + 1

						for _ = 1, roll do
							Isaac.Spawn(3, FamiliarVariant.BONE_SPUR, 0, enemy.Position, Vector.FromAngle(math.random(360)) * 1.5, Familiar)
						end
						enemy:GetData().placardDeathBurst = true
					end
				else
					-- enemies further away
					if enemy:GetData().wasNearPlacard then
						enemy:GetData().wasNearPlacard = false
						enemy:ClearEntityFlags(EntityFlag.FLAG_WEAKNESS)
					end
				end
			end
		end
	end

	if Familiar.Variant == CustomFamiliars.DEAD_WEIGHT then
		if Familiar:GetData().decceleration then
			Familiar.Velocity = Familiar.Velocity + Familiar:GetData().decceleration
			Familiar:GetData().pinFrictionAfter = Familiar:GetData().pinFrictionAfter - 1

			-- Put out the fires
			for _, fire in pairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE)) do
				if fire.Variant <= 1 and fire.Position:Distance(Familiar.Position) < 15 then
					fire:Kill()
				end
			end

			if Familiar.Velocity:Length() > 18 then
				Familiar.SpriteOffset = Familiar.SpriteOffset + Vector(0, -0.4)
			elseif Familiar.Velocity:Length() > 9 then
				Familiar.SpriteOffset = Familiar.SpriteOffset + Vector(0, 3.25)
			end

			if Familiar.Velocity:Length() < 1
			or Familiar:GetData().pinFrictionAfter <= 0
			or Familiar:CollidesWithGrid() then
				Familiar.Velocity = Vector.Zero
				Familiar.CollisionDamage = 0
				Familiar:GetData().decceleration = nil

				if Familiar:CollidesWithGrid() then
					Familiar.SpriteOffset = Vector(0, 0)
					Familiar:GetSprite():Play("WallHit", true)
					sfx:Play(SoundEffect.SOUND_BONE_SNAP)

					for _ = 1, 6 do
						local bone = Isaac.Spawn(2, TearVariant.BONE, 0, Familiar.Position,
							Vector.FromAngle(math.random(360)) * (math.random(15) / 10), Familiar):ToTear()
						bone.FallingSpeed = -15
						bone.FallingAcceleration = 0.5
					end
				end
			end
		elseif Familiar.Friction > 0 then
			Familiar.Friction = 0
		end

		if Familiar:GetSprite():IsFinished("WallHit") then
			Familiar:GetSprite():Play("Idle")
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, rplus.FamiliarUpdate)

---@param Familiar EntityFamiliar
function rplus:FamiliarCollision(Familiar, Collider, _)
	if Familiar.Variant == CustomFamiliars.CHERRY then
		if Collider:IsActiveEnemy(true) and not Collider:IsBoss() and game:GetFrameCount() % 8 == 0 then
			game:CharmFart(Familiar.Position, 10.0, Familiar)
			sfx:Play(SoundEffect.SOUND_FART)
		end
	end

	if Familiar.Variant == CustomFamiliars.BIRD then
		if Collider:ToPlayer() and CustomData.Data.Items.BIRD_OF_HOPE.catchingBird then
			local Player = Collider:ToPlayer()

			sfx:Play(SoundEffect.SOUND_SUPERHOLY)
			Familiar:Remove()
			Player.Position = CustomData.Data.Items.BIRD_OF_HOPE.diePos
			CustomData.Data.Items.BIRD_OF_HOPE.dieFrame = nil
			CustomData.Data.Items.BIRD_OF_HOPE.catchingBird = false
			CustomData.Data.Items.BIRD_OF_HOPE.birdCaught = true
			Player:TryRemoveNullCostume(CustomCostumes.BIRD_OF_HOPE)
			Player:SetMinDamageCooldown(40)
			Player:AddCacheFlags(CacheFlag.CACHE_FLYING)
			Player:EvaluateItems()
		end
	end

	if Familiar.Variant == CustomFamiliars.ENRAGED_SOUL then
		if Collider:IsActiveEnemy(true) and not Collider:HasEntityFlags(EntityFlag.FLAG_CHARM)
		and not Familiar:GetData().attachedEnemy then
			if Collider.MaxHitPoints > 10 then
				Familiar.Velocity = Vector.Zero
				Familiar:GetData().attachedEnemy = Collider
				Familiar:GetData().attachmentFrames = ModConstants.Cooldowns.ENRAGED_SOUL_LAUNCH / 2
				Familiar:GetSprite():Play("Idle", true)
			else
				Collider:Die()
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, rplus.FamiliarCollision)


						-- MC_POST_BOMB_UPDATE --									
						-------------------------
function rplus:BombUpdate(Bomb)
	if Bomb.SpawnerEntity and Bomb.SpawnerEntity:ToPlayer() then
		local Player = Bomb.SpawnerEntity:ToPlayer()

		if Player:HasCollectible(CustomCollectibles.RED_BOMBER)
		and not Player:HasCollectible(CollectibleType.COLLECTIBLE_REMOTE_DETONATOR)
		and not Bomb:GetData()['isNewBomb'] and not Bomb.IsFetus then
			if (Bomb.Variant == 0 or Bomb.Variant == 19) and Bomb.FrameCount == 1 then
				local throwableBomb = Isaac.Spawn(5, 41, 0, Player.Position, Vector.Zero, nil)
				throwableBomb:GetSprite():Stop()
				Player:GetData().bombFlags = Bomb.Flags
				Bomb:Remove()
			elseif Bomb.Variant == 13 and Bomb.FrameCount == 45 then
				local newBomb = Player:FireBomb(Bomb.Position, Bomb.Velocity, nil)
				newBomb:AddTearFlags(Player:GetData().bombFlags)
				newBomb:SetExplosionCountdown(1)
				newBomb:GetData()['isNewBomb'] = true
				Bomb:Remove()
			end
		end
	end

	-- Helper for pointing Tank Boy's rockets in a right direction
	if Bomb.Variant == BombVariant.BOMB_ROCKET then
		if Bomb:GetData().forcedRocketTargetVel then
			Bomb.Velocity = Bomb:GetData().forcedRocketTargetVel + Vector(-1.75, 0)
			Bomb.SpriteRotation = Bomb:GetData().forcedRocketTargetVel:GetAngleDegrees()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, rplus.BombUpdate)


						-- MC_POST_KNIFE_UPDATE --									
						--------------------------
function rplus:KnifeUpdate(Knife)
	if Knife.FrameCount == 1 then
		local Player = Knife.Parent:ToPlayer() or Knife.SpawnerEntity:ToPlayer()

		if Player and Player:HasCollectible(CustomCollectibles.CEREMONIAL_BLADE) then
			Knife:GetSprite():ReplaceSpritesheet(0, "gfx/ceremonial_knife.png")
			Knife:GetSprite():LoadGraphics()
			Knife:GetData().IsCeremonial = true
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, rplus.KnifeUpdate)


						-- MC_PRE_PROJECTILE_COLLISION --									
						---------------------------------
function rplus:ProjectileCollision(Projectile, Collider, _)
	-- Prevent familiars from soaking projectiles shot by friendly monsters
	if Projectile:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then return end

	if Collider.Type == EntityType.ENTITY_FAMILIAR then
		if Collider.Variant == CustomFamiliars.BAG_O_TRASH then
			Projectile:Remove()
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100

			if roll < ModConstants.Chances.BAG_O_TRASH_BREAK
			and (not Sewn_API or Sewn_API:GetLevel(Collider:ToFamiliar():GetData()) < 1) then
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 1, false, 1, 0)
				Collider:ToFamiliar().Player:RemoveCollectible(CustomCollectibles.BAG_O_TRASH)

				if rng:RandomInt(3) == 0 and isPickupUnlocked(350, CustomTrinkets.NIGHT_SOIL) then
					Isaac.Spawn(5, 350, CustomTrinkets.NIGHT_SOIL, Collider.Position, Vector.Zero, Collider)
				else
					Isaac.Spawn(5, 100, CollectibleType.COLLECTIBLE_BREAKFAST, Collider.Position, Vector.Zero, Collider)
				end
			end
		end

		if Collider.Variant == CustomFamiliars.SIBLING_1
		or Collider.Variant == CustomFamiliars.SIBLING_2
		or Collider.Variant == CustomFamiliars.FIGHTING_SIBLINGS
		or Collider.Variant == CustomFamiliars.DEAD_WEIGHT
		or Collider.Variant == CustomFamiliars.KEEPERS_ANNOYING_FLY then
			Projectile:Remove()
		end

		if Collider.Variant == CustomFamiliars.ORBITAL_GHOST
		and not Collider:GetSprite():IsPlaying("Death") then
			Projectile:Remove()

			if not Collider:GetSprite():IsOverlayPlaying("Hit") then
				if Collider.SubType ~= 16 then
					Collider:GetData().blockedShots = Collider:GetData().blockedShots and Collider:GetData().blockedShots + 1 or 1
				end
				Collider:GetSprite():PlayOverlay("Hit", true)
				sfx:Play(SoundEffect.SOUND_HOLY_MANTLE, 0.5, 2, false, 1.5, 0)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, rplus.ProjectileCollision)


						-- MC_PRE_SPAWN_CLEAN_AWARD --							
						------------------------------
function rplus:PickupAwardSpawn(_, Pos)
	local room = game:GetRoom()
	local level = game:GetLevel()
	local c = room:GetCenterPos()

	if not CustomData.Data then return end
	if CustomData.Data.Items.BOOK_OF_LEVIATHAN_OPEN.stopDebug then
		CustomData.Data.Items.BOOK_OF_LEVIATHAN_OPEN.stopDebug = false
		Isaac.ExecuteCommand("debug 10")
	end

	rng:SetSeed(room:GetAwardSeed(), 1)
	local roll = rng:RandomFloat() * 100

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		-- UNLOCK STUFF
		local mark = getFinalBossMark()
		if mark and isMarkUnlocked(Player, mark) == false then
			unlockMark(Player, mark)
			playAchievementPaper(Player:GetPlayerType(), mark)
		end

		if Player:GetData().shouldReviveGBBug then
			Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			Player:EvaluateItems()
			Player:GetData().shouldReviveGBBug = false
		end

		if Player:HasCollectible(CustomCollectibles.RED_KING)
		and room:GetType() == RoomType.ROOM_BOSS and level:GetStage() < 8 then
			if level:GetCurrentRoomDesc().Data.Weight == 0
			and level:GetCurrentRoomDesc().Data.Variant >= 44000 and level:GetCurrentRoomDesc().Data.Variant < 44200 then
				-- these are special boss rooms used by Red King
				for _, v in pairs(CustomData.Data.Items.RED_KING.redCrawlspacesData) do
					if v.associatedRoom == level:GetCurrentRoomDesc().Data.Variant then
						v.isRoomDefeated = true
					end
				end
				local Item1 = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				local Item2 = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), room:FindFreePickupSpawnPosition(c + Vector(-40, 40), 10, true, false), Vector.Zero, nil)
				Item1:ToPickup().OptionsPickupIndex = 7
				Item2:ToPickup().OptionsPickupIndex = 7
				return true
			elseif level:GetCurrentRoomDesc().Data.Weight > 0 then
				if #Isaac.FindByType(6, CustomSlots.SLOT_RED_KING_CRAWSPACE, 0) == 0 then
					local randomRoom = rng:RandomInt(4)
					local chapterAdd = (level:GetStage() + 1) // 2
					local isAltPath = level:GetStageType() > 3 and 100 or 0

					local redCrawlspace = Isaac.Spawn(6, CustomSlots.SLOT_RED_KING_CRAWLSPACE, 0, c, Vector.Zero, nil)
					redCrawlspace.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					redCrawlspace:GetSprite():Play("OpenAnim")
					table.insert(
						CustomData.Data.Items.RED_KING.redCrawlspacesData,
						{
							seed = redCrawlspace.InitSeed,
							associatedRoom = 44000 + isAltPath + chapterAdd * 10 + randomRoom,
							isRoomDefeated = false
						}
					)
				end
			end
		end

		if CustomData.Data.Items.VAULT_OF_HAVOC.isInVaultRoom and level:GetCurrentRoomDesc().Data.Weight == 0
		and level:GetCurrentRoomDesc().Data.Variant >= 55000 and level:GetCurrentRoomDesc().Data.Variant < 55010 then
			-- spawn reward after clearing Vault of Havoc room
			if CustomData.Data.Items.VAULT_OF_HAVOC.sumHp < 120 + 25 * level:GetStage() then
				Isaac.Spawn(5, 10, HeartSubType.HEART_FULL, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, 10, HeartSubType.HEART_SOUL, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, 10, HeartSubType.HEART_GOLDEN, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
			elseif CustomData.Data.Items.VAULT_OF_HAVOC.sumHp < 140 + 30 * level:GetStage() then
				Isaac.Spawn(5, PickupVariant.PICKUP_CHEST, 0, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, PickupVariant.PICKUP_LOCKEDCHEST, 0, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, 350, 0, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
			else
				Isaac.Spawn(5, 100, GetUnlockedVanillaCollectible(true, true), room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
			end

			CustomData.Data.Items.VAULT_OF_HAVOC.enemyList = {}
			CustomData.Data.Items.VAULT_OF_HAVOC.isInVaultRoom = false
			CustomData.Data.Items.VAULT_OF_HAVOC.sumHp = 0
			return true
		end

		if Player:GetData().tornPageSatanicBible and room:GetType() == RoomType.ROOM_BOSS
		and level:GetStage() < 8 and level:GetStage() ~= 6 then
			local opt = Player:HasCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS)
			local spawnXs = opt and {-40, 0, 40} or {-40, 40}

			-- spawning new items
			for _, spawnX in pairs(spawnXs) do
				local it = Isaac.Spawn(
					5, 100,
					game:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, true, Random() + 1, CollectibleType.COLLECTIBLE_NULL),
					room:FindFreePickupSpawnPosition(c + Vector(spawnX, 80), 10, true, false),
					Vector.Zero, Player
				):ToPickup()

				it.OptionsPickupIndex = 666
				it.Price = -1
				it.AutoUpdatePrice = true
			end

			room:DestroyGrid(room:GetGridIndex(c + Vector(0, -80)), true)
			Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, c + Vector(0, -80), true)
			return true
		end

		if Player:GetData().isFlowerOfLustExtraReward
		and room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_BOSSRUSH then
			local extraGoodPickups = {
				{10, {PickupVariant.PICKUP_GRAB_BAG, 1}},
				{20, {PickupVariant.PICKUP_GRAB_BAG, 2}},
				{30, {20, CoinSubType.COIN_DIME}},
				{40, {20, CoinSubType.COIN_LUCKYPENNY}},
				{50, {20, CoinSubType.COIN_NICKEL}},
				{60, {30, KeySubType.KEY_CHARGED}},
				{70, {PickupVariant.PICKUP_CHEST, 0}},
				{80, {PickupVariant.PICKUP_WOODENCHEST, 0}},
				{90, {PickupVariant.PICKUP_LOCKEDCHEST, 0}},
				{100, {PickupVariant.PICKUP_TRINKET, 0}}
			}

			for _, subt in pairs(extraGoodPickups) do
				if roll < subt[1] then
					Isaac.Spawn(5, subt[2][1], subt[2][2], game:GetRoom():FindFreePickupSpawnPosition(Pos, 0, true, false), Vector.Zero, Player)
					break
				end
			end

			Player:GetData().isFlowerOfLustExtraReward = nil
			return true
		end
	end

	if roll < ModConstants.Chances.JACK_EXTRA_DROP and CustomData.Data.Cards.jackPickupType then
		local Variant
		local SubType
		local pickupSubTypeRoll = rng:RandomFloat() * 100

		if CustomData.Data.Cards.jackPickupType == "Diamonds" then
			Variant = 20

			if pickupSubTypeRoll < 80 then
				SubType = CoinSubType.COIN_PENNY
			elseif pickupSubTypeRoll < 95 then
				SubType = CoinSubType.COIN_NICKEL
			else
				SubType = CoinSubType.COIN_DIME
			end
		elseif CustomData.Data.Cards.jackPickupType == "Clubs" then
			Variant = 40

			if pickupSubTypeRoll < 80 then
				SubType = BombSubType.BOMB_NORMAL
			else
				SubType = BombSubType.BOMB_DOUBLEPACK
			end
		elseif CustomData.Data.Cards.jackPickupType == "Spades" then
			Variant = 30

			if pickupSubTypeRoll < 80 then
				SubType = KeySubType.KEY_NORMAL
			elseif pickupSubTypeRoll < 95 then
				SubType = KeySubType.KEY_DOUBLEPACK
			else
				SubType = KeySubType.KEY_CHARGED
			end
		elseif CustomData.Data.Cards.jackPickupType == "Hearts" then
			Variant = 10

			if pickupSubTypeRoll < 30 then
				SubType = HeartSubType.HEART_FULL
			elseif pickupSubTypeRoll < 50 then
				SubType = HeartSubType.HEART_DOUBLEPACK
			elseif pickupSubTypeRoll < 60 then
				SubType = HeartSubType.HEART_ROTTEN
			elseif pickupSubTypeRoll < 85 then
				SubType = HeartSubType.HEART_SOUL
			elseif pickupSubTypeRoll < 90 then
				SubType = HeartSubType.HEART_BONE
			elseif pickupSubTypeRoll < 97 then
				SubType = HeartSubType.HEART_BLACK
			else
				SubType = HeartSubType.HEART_ETERNAL
			end
		end

		Isaac.Spawn(5, Variant, SubType, game:GetRoom():FindFreePickupSpawnPosition(Pos, 20, true, false), Vector.Zero, nil)
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, rplus.PickupAwardSpawn)


						-- MC_GET_PILL_EFFECT --							
						------------------------
function rplus:ChangePillEffect(pillEffect, pillColor)
	if antiPillCheckRecursion or not CustomData.Data then return end

	-- Handle custom pill effects that are not unlocked
	if pillEffect >= CustomPills.ESTROGEN_UP and pillEffect <= CustomPills.SUPPOSITORY then
		if not isPillEffectUnlocked(pillEffect) then
			-- if it's already cached, use this
			if CustomData.Data.pillReplacements[pillEffect] then
				return getPillCounterpart(CustomData.Data.pillReplacements[pillEffect])
			end

			-- FIXED counterpart for the pill; always attempt to pick this first
			local firstCandidate = pillCounterparts.LOCKED[pillEffect]
			if not isEffectInRotation(firstCandidate) then
				return getPillCounterpart(firstCandidate)
			end

			-- if fixed counterpart is already in the pool, pick another random one
			local runSeed = game:GetSeeds():GetStartSeed()
			local replacementCandidates = {}
			for eff = PillEffect.PILLEFFECT_BAD_GAS, PillEffect.PILLEFFECT_EXPERIMENTAL do
				if not isEffectInRotation(eff) then
					-- make sure it isn't used already (no other custom pills use it as a counterpart)
					local used = false
					for k, v in pairs(CustomData.Data.pillReplacements) do
						if v == eff then
							used = true
						end
					end

					if not used then
						table.insert(replacementCandidates, eff)
					end
				end
			end

			local replacement = replacementCandidates[(runSeed % #replacementCandidates) + 1]
			if replacement then
				-- Store this replacement to avoid changing it later
				CustomData.Data.pillReplacements[pillEffect] = replacement
				return getPillCounterpart(replacement)
			else
				Isaac.DebugString("[REP+] ERROR! Failed to choose replacement for locked pill! I'm gonna fart!")
				return PillEffect.PILLEFFECT_BAD_GAS
			end
		else
			return getPillCounterpart(pillEffect)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, rplus.ChangePillEffect)


						-- MC_POST_EFFECT_UPDATE --							
						---------------------------
---@param Effect EntityEffect
function rplus:PostEffectUpdate(Effect)
	if Effect.Variant == EffectVariant.BOMB_EXPLOSION or Effect.Variant == EffectVariant.MAMA_MEGA_EXPLOSION then
		-- thanks to Xalum for mentioning that the radius may be adjusted for different explosions
		local trueExplosionDist = Effect.Variant == EffectVariant.MAMA_MEGA_EXPLOSION and 1500
			or 90 * Effect.SpriteScale:Length() / Vector.One:Length()

		for _, bag in pairs(Isaac.FindByType(3, CustomFamiliars.BAG_O_TRASH)) do
			if bag.Position:Distance(Effect.Position) < trueExplosionDist
			and not bag:GetData().preventSecondDrop then
				bag:GetData().preventSecondDrop = true

				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 1, false, 1, 0)
				rng:SetSeed(bag.InitSeed + Random(), 1)

				if rng:RandomInt(3) == 0 and isPickupUnlocked(350, CustomTrinkets.NIGHT_SOIL) then
					Isaac.Spawn(5, 350, CustomTrinkets.NIGHT_SOIL, bag.Position, Vector.Zero, bag)
				else
					Isaac.Spawn(5, 100, CollectibleType.COLLECTIBLE_BREAKFAST, bag.Position, Vector.Zero, bag)
				end
				bag:ToFamiliar().Player:RemoveCollectible(CustomCollectibles.BAG_O_TRASH)
				bag:Remove()
			end
		end

		for _, slot in pairs(Isaac.FindByType(6, CustomSlots.SLOT_STARGAZER, -1, false, true)) do
			if slot.Position:Distance(Effect.Position) < trueExplosionDist then
				slot:Kill()
				slot:Remove()
				game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
			end
		end

		for _, cof in pairs(Isaac.FindByType(5, CustomPickups.COFFIN, -1)) do
			if cof.Position:Distance(Effect.Position) < trueExplosionDist
			and (not cof:GetData().ExplodeFrame or game:GetFrameCount() >= cof:GetData().ExplodeFrame + 60) then
				if cof.SubType == 2 or Effect.Variant == EffectVariant.MAMA_MEGA_EXPLOSION then
					-- open coffin
					cof.SubType = 1
					cof:GetData()["IsInRoom"] = true
					cof:GetSprite():Play("Open")
					rng:SetSeed(Random() + 1, 1)
					local Player = Isaac.GetPlayer(0)
					local roll = rng:RandomFloat()

					if roll < 0.15 then
						local CoffinPedestal1 = Isaac.Spawn(5, 100, GetUnlockedCollectibleFromCustomPool(CustomItempools.COFFIN), cof.Position + Vector(-20, 0), Vector.Zero, cof)
						CoffinPedestal1:GetSprite():ReplaceSpritesheet(5, "gfx/items/coffin_itemaltar_left.png")
						CoffinPedestal1:GetSprite():LoadGraphics()

						local CoffinPedestal2 = Isaac.Spawn(5, 100, GetUnlockedCollectibleFromCustomPool(CustomItempools.COFFIN), cof.Position + Vector(20, 0), Vector.Zero, cof)
						CoffinPedestal2:GetSprite():ReplaceSpritesheet(5, "gfx/items/coffin_itemaltar_right.png")
						CoffinPedestal2:GetSprite():LoadGraphics()

						cof:Remove()
					elseif roll < 0.5 then
						for j = 1, 2 do
							local h = Isaac.Spawn(5, 10, HeartSubType.HEART_BONE, cof.Position, Vector.FromAngle(math.random(360)) * 3, cof)
							h:GetData().noTaintedMorph = true
						end
					else
						for i = 1, 9 do
							Isaac.Spawn(3, FamiliarVariant.BONE_ORBITAL, 0, Player.Position, Vector.Zero, Player)
						end
						for j = 1, 3 do
							Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, cof.Position, Vector.Zero, Player):AddCharmed(EntityRef(Player), -1)
						end
					end
				elseif cof.SubType == 0 then
					cof.SubType = 2
					cof:GetSprite():Play("Idle_Exploded")
				end

				sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
				cof:GetData().ExplodeFrame = game:GetFrameCount()
			end
		end
	end

	if Effect.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL and Effect.SubType == 4 then
		local Frame = game:GetFrameCount() % 490 + 1

		if Frame <= 140 then	-- RED -> ORANGE -> YELLOW
			local color = Color(1, 1, 1, 1, 0, 0, 0)
			color:SetColorize(1, Frame / 140, 0, 1)
			Effect:SetColor(color, 1, 1, false, false)
		elseif Frame <= 210 then	-- YELLOW -> GREEN
			local color = Color(1, 1, 1, 1, 0, 0, 0)
			color:SetColorize(1 - (Frame - 140) / 70, 1, 0, 1)
			Effect:SetColor(color, 1, 1, false, false)
		elseif Frame <= 280 then	-- GREEN -> CYAN
			local color = Color(1, 1, 1, 1, 0, 0, 0)
			color:SetColorize(0, 1, (Frame - 210) / 70, 1)
			Effect:SetColor(color, 1, 1, false, false)
		elseif Frame <= 350 then	-- CYAN -> BLUE
			local color = Color(1, 1, 1, 1, 0, 0, 0)
			color:SetColorize(0, 1 - (Frame - 280) / 70, 1, 1)
			Effect:SetColor(color, 1, 1, false, false)
		elseif Frame <= 420 then	-- BLUE -> MAGENTA
			local color = Color(1, 1, 1, 1, 0, 0, 0)
			color:SetColorize((Frame - 350) / 70, 0, 1, 1)
			Effect:SetColor(color, 1, 1, false, false)
		else						-- MAGENTA -> RED
			local color = Color(1, 1, 1, 1, 0, 0, 0)
			color:SetColorize(1, 0, 1 - (Frame - 420) / 70, 1)
			Effect:SetColor(color, 1, 1, false, false)
		end
	end

	if Effect.Variant == HelperEffects.FALLING_KNIFE then
		local s = Effect:GetSprite()

		if s:IsEventTriggered("Fall") then
			Effect.SpawnerEntity:TakeDamage(Effect:GetData().Damage, 0, EntityRef(Effect), 0)
		elseif s:IsEventTriggered("Remove") then
			Effect:Remove()
		end
	end

	if Effect.Variant == HelperEffects.CRIPPLING_HANDS then
		if Effect:GetSprite():IsFinished("ClawsAppearing") then Effect:GetSprite():Play("ClawsHolding") end

		if not Effect.SpawnerEntity then Effect:Remove()
		else Effect.Position = Effect.SpawnerEntity.Position + Vector(0, 5) end
	end

	-- Mr. Me!
	if Effect.Variant == EffectVariant.MR_ME then
		if Effect.FrameCount == 73 then
			-- find Mr. Me! crosshair
			local target = nil
			for _, e in pairs(Isaac.FindByType(1000, EffectVariant.TARGET)) do
				if e.FrameCount == Effect.FrameCount then
					target = e
					break
				end
			end

			-- find modded chest that is closest to the target
			local gotoChest = nil
			for r = 20, 1000, 10 do
				local chestsAround = Isaac.FindInRadius(target.Position, r, EntityPartition.PICKUP)

				if #chestsAround > 0 then
					for _, c in pairs(chestsAround) do
						if c.Variant >= CustomPickups.SCARLET_CHEST and c.Variant <= CustomPickups.COFFIN
						and c.SubType == 0 then
							gotoChest = c
							break
						end
					end
				end
			end

			if not gotoChest then return end

			-- calculate position of a hidden chest
			-- spawn a hidden chest that is inaccessible, but will be used as a "bait" for Mr. ME to point him in the right direction
			local v = gotoChest.Position - Effect.Position
			local nPos = Effect.Position + v * 1.5
			hiddenChest = Isaac.Spawn(5, 50, 0, nPos, Vector.Zero, nil)
			hiddenChest:GetSprite():Stop()
			hiddenChest:GetSprite():ReplaceSpritesheet(0, "gfx/yomomma.png")
			hiddenChest:GetSprite():ReplaceSpritesheet(1, "gfx/yopoppa.png")
			hiddenChest:GetSprite():LoadGraphics()
		elseif Effect.FrameCount > 73 then
			for s = CustomPickups.SCARLET_CHEST, CustomPickups.COFFIN do
				for _, p in pairs(Isaac.FindInRadius(Effect.Position, 15, EntityPartition.PICKUP)) do
					if p.Variant == s and p.SubType == 0 then
						-- open modded chests
						if s == CustomPickups.SCARLET_CHEST then
							openScarletChest(p)
						elseif s == CustomPickups.FLESH_CHEST then
							openFleshChest(p)
						elseif s == CustomPickups.BLACK_CHEST then
							openBlackChest(p)
						elseif s == CustomPickups.COFFIN then
							p.SubType = 1
							p:GetData()["IsInRoom"] = true
							p:GetSprite():Play("Open")
							rng:SetSeed(Random() + 1, 1)
							local Player = Isaac.GetPlayer(0)
							local roll = rng:RandomFloat()

							if roll < 0.15 then
								local CoffinPedestal1 = Isaac.Spawn(5, 100, GetUnlockedCollectibleFromCustomPool(CustomItempools.COFFIN), p.Position + Vector(-20, 0), Vector.Zero, p)
								CoffinPedestal1:GetSprite():ReplaceSpritesheet(5, "gfx/items/coffin_itemaltar_left.png")
								CoffinPedestal1:GetSprite():LoadGraphics()
								local CoffinPedestal2 = Isaac.Spawn(5, 100, GetUnlockedCollectibleFromCustomPool(CustomItempools.COFFIN), p.Position + Vector(20, 0), Vector.Zero, p)
								CoffinPedestal2:GetSprite():ReplaceSpritesheet(5, "gfx/items/coffin_itemaltar_right.png")
								CoffinPedestal2:GetSprite():LoadGraphics()
								p:Remove()
							elseif roll < 0.5 then
								for j = 1, 2 do
									local h = Isaac.Spawn(5, 10, HeartSubType.HEART_BONE, p.Position, Vector.FromAngle(math.random(360)) * 3, p)
									h:GetData().noTaintedMorph = true
								end
							else
								for i = 1, 9 do
									Isaac.Spawn(3, FamiliarVariant.BONE_ORBITAL, 0, Player.Position, Vector.Zero, Player)
								end
								for j = 1, 3 do
									Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, p.Position, Vector.Zero, Player):AddCharmed(EntityRef(Player), -1)
								end
							end
						end

						Isaac.Spawn(1000, EffectVariant.POOF01, 0, Effect.Position, Vector.Zero, Effect)
						Effect:Remove()
						hiddenChest:Remove()
						break
					end
				end
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, rplus.PostEffectUpdate)


---------------------------------------------------------
-- helpers for animating the Angel's Wings' item pedestal
-- code shamelessly stolen from THE ANIMATED ITEMS MOD
function rplus:PostPickupRender(pickup)
	if pickup.SubType == CustomCollectibles.ANGELS_WINGS
	and game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND ~= LevelCurse.CURSE_OF_BLIND
	and not hasEffectOnIt(pickup) then
		Isaac.Spawn(1000, HelperEffects.ANIMATED_ITEM_DUMMY, 0, pickup.Position, Vector.Zero, pickup)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, rplus.PostPickupRender, PickupVariant.PICKUP_COLLECTIBLE)

function rplus:PostEffectInit(effect)
	local spawner = effect.SpawnerEntity

	effect:FollowParent(spawner)
	effect:GetSprite():Load("gfx/AngelsWingsAnimated.anm2", true)
	effect:GetSprite():Play("AnimatedPedestal")
	effect.DepthOffset = 1

	if spawner.Type == EntityType.ENTITY_PICKUP and spawner.Variant == PickupVariant.PICKUP_COLLECTIBLE then
		spawner:GetSprite():ReplaceSpritesheet(1, "gfx/nil_pedestal.png")
		spawner:GetSprite():LoadGraphics()
		effect.SpriteOffset = Vector(0, -3)
		if spawner:ToPickup():IsShopItem() then effect.SpriteOffset = Vector(0, 10) end

	elseif spawner.Type == EntityType.ENTITY_PLAYER then
		effect.SpriteOffset = Vector(0, -16)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, rplus.PostEffectInit, HelperEffects.ANIMATED_ITEM_DUMMY)

function rplus:PostEffectRender(effect)
	local spawner = effect.SpawnerEntity
	if not spawner then effect:Remove() end

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)

		if Player.QueuedItem.Item and Player.QueuedItem.Item.ID == CustomCollectibles.ANGELS_WINGS then
			if not hasEffectOnIt(Player) then
				effect:Remove()
				Isaac.Spawn(1000, HelperEffects.ANIMATED_ITEM_DUMMY, 0, Player.Position, Vector.Zero, Player)
			end
		end
	end

	if spawner.Type == 5 and spawner.Variant == 100 and spawner.SubType == CustomCollectibles.ANGELS_WINGS then
		local frame = spawner:GetSprite():GetFrame()

		if not spawner:ToPickup():IsShopItem() then
			local y = 0
			local scale = Vector.One

			if frame <= 2 then
				y = -3
			elseif frame <= 4 then
				y = -4
				scale = Vector(1, 1.04)
			elseif frame <= 6 then
				y = -5
				scale = Vector(1.08, 0.98)
			elseif frame <= 8 then
				y = -6
				scale = Vector(1, 1.04)
			elseif frame <= 11 then
				y = -7
			elseif frame <= 13 then
				y = -6
			elseif frame <= 15 then
				y = -5
			elseif frame <= 17 then
				y = -4
				scale = Vector(1.08, 0.98)
			else
				y = -3
				scale = Vector(1.08, 0.98)
			end
			effect.SpriteOffset = Vector(0, y)
			effect.SpriteScale = scale
		else
			effect.SpriteOffset = Vector(0, 10)
			effect.SpriteScale = Vector.One
		end
	elseif spawner.Type == 1 then
		local Player = effect.SpawnerEntity:ToPlayer()
		if not Player.QueuedItem.Item or Player.QueuedItem.Item.ID ~= CustomCollectibles.ANGELS_WINGS then effect:Remove() end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, rplus.PostEffectRender, HelperEffects.ANIMATED_ITEM_DUMMY)


								------------------
								-- DEPENDENCIES --
								------------------
-- Embeds: CHAPI and DSS
include("scripts/deadseascrolls.lua")
include("scripts/customhealthapi/core.lua")
include("scripts/customhealth.lua")
	-- CHRISTMAS SPECIAL
include("scripts/christmas.lua")

-- EID
if EID then
	include("scripts/EID.lua")
end

-- Encyclopedia
if Encyclopedia then
	include("scripts/Encyclopedia.lua")
end

-- MinimAPI
if MinimapAPI then
	include("scripts/MinimAPI.lua")
end

-- Sewing Machine
if Sewn_API then
	Sewn_API:MakeFamiliarAvailable(CustomFamiliars.TOY_HELICOPTER_TANK, CustomCollectibles.TANK_BOYS)
	Sewn_API:AddFamiliarDescription(CustomFamiliars.TOY_HELICOPTER_TANK, 'The green Tank Boy gains homing ammunition', 'Red Tank Boy will fire lasers at whatever enemy is attacked by the green Tank Boy')

	Sewn_API:MakeFamiliarAvailable(CustomFamiliars.BAG_O_TRASH, CustomCollectibles.BAG_O_TRASH)
    Sewn_API:AddFamiliarDescription(CustomFamiliars.BAG_O_TRASH, 'Bag can no longer be destroyed', 'Bag will also spawn blue spiders on room clear')

    Sewn_API:MakeFamiliarAvailable(CustomFamiliars.CHERUBIM, CustomCollectibles.CHERUBIM)
    Sewn_API:AddFamiliarDescription(CustomFamiliars.CHERUBIM, 'Cherubim gains increased God Head aura size and tear damage', 'Cherubim gains Pop! tears')
end

-- Sodom & Gomorrah
if XalumMods and XalumMods.SodomAndGomorrah then
	XalumMods.SodomAndGomorrah.AddBlacklistedSodomGomorrahItems({
		CustomCollectibles.CEILING_WITH_THE_STARS,
		CustomCollectibles.BIRD_OF_HOPE,
		CustomCollectibles.MARK_OF_CAIN,
		CustomCollectibles.STARGAZERS_HAT
	})

	XalumMods.SodomAndGomorrah.AddBlacklistedSodomGomorrahTrinkets({
		CustomTrinkets.KEY_TO_THE_HEART,
		CustomTrinkets.TRICK_PENNY,
		CustomTrinkets.ADAMS_RIB
	})
end

-- Andromeda
if ANDROMEDA then
	local pickupTable = {
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_BROKEN,
			NumCharges = 2,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_DAUNTLESS,
			NumCharges = 2,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_HOARDED,
			NumCharges = 3,
			CanPickUp = function()
				return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_DECEIVER,
			NumCharges = 1,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_CURDLED,
			NumCharges = 2,
			CanPickUp = function()
				return ANDROMEDA.player:CanPickRedHearts()
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_SOILED,
			NumCharges = 2,
			CanPickUp = function()
				return ANDROMEDA.player:CanPickRedHearts()
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_SAVAGE,
			NumCharges = 2,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_ENIGMA,
			NumCharges = 3,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_BALEFUL,
			NumCharges = 3,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_CAPRICIOUS,
			NumCharges = 0,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_HARLOT,
			NumCharges = 1,
			CanPickUp = function()
				return ANDROMEDA.player:CanPickRedHearts()
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_MISER,
			NumCharges = 2,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_BENIGHTED,
			NumCharges = 2,
			CanPickUp = function()
				return ANDROMEDA.player:CanPickBlackHearts()
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_EMPTY,
			NumCharges = 2,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_FETTERED,
			NumCharges = 2,
			CanPickUp = function()
				return ANDROMEDA.player:CanPickSoulHearts()
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_ZEALOT,
			NumCharges = 3,
			CanPickUp = function()
				return true
			end,
		},
		{
			Variant = PickupVariant.PICKUP_HEART,
			SubType = CustomPickups.TaintedHearts.HEART_DESERTED,
			NumCharges = 1,
			CanPickUp = function()
				return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:CanPickBlackHearts()
			end,
		}
	}

	ANDROMEDA:AddSingularityPickups(pickupTable)
end

rplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	-- Redemption Community Pack
	if RedemptionExports then
		-- rune: CardType, chargeCount: number (must be 1 - 12), sprite: string (link to an image of your rune sprite. must be 32x32. For now just grab a random image), player: EntityPlayer | nil, canBreak: boolean, brokenSprite: string | nil
		RedemptionExports.addGaldrabokRune(
			CustomConsumables.RED_RUNE,
			4,
			"gfx/items/pick ups/red_rune.png",
			nil,
			false,
			nil
		)

		RedemptionExports.addGaldrabokRune(
			CustomConsumables.QUASAR_SHARD,
			6,
			"gfx/items/pick ups/quasar_shard.png",
			nil,
			false,
			nil
		)
	end

	-- Better Pandora's Box Pool (obama hanging medal on himself.png)
    if PandorasBoxTweaked then
		table.insert(PandorasBoxTweaked.TRUE_BLUE_ITEMS, CustomCollectibles.HANDICAPPED_PLACARD)
		table.insert(PandorasBoxTweaked.TRUE_BLUE_ITEMS, CustomCollectibles.BIRD_OF_HOPE)
		table.insert(PandorasBoxTweaked.TRUE_BLUE_ITEMS, CustomCollectibles.SOUL_BOND)
		table.insert(PandorasBoxTweaked.TRUE_BLUE_ITEMS, CustomCollectibles.PURE_SOUL)
    end
end)