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
local rplus = RegisterMod("Repentance Plus", 1)
RepentancePlusMod = rplus
local json = require("json")
local CustomData = {}
local marks = {
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
--

local MOD_VERSION = "1.29a"
local sfx = SFXManager()
local music = MusicManager()
local rng = RNG()
local HUDValueRenderOffset = Vector(20, 12)
local FLAG_NO_TAINTED_HEARTS
local FLAG_CONNECT_MCM = true

-- effect helpers
local CripplingHandsHelper = Isaac.GetEntityVariantByName("Crippling Hands Helper")
local FallingKnifeHelper = Isaac.GetEntityVariantByName("Falling Knife Helper")
local AnimatedItemDummyEntity = Isaac.GetEntityVariantByName("AnimatedItemDummyEntity")
local PureSoul = Isaac.GetEntityVariantByName("Pure Soul")
local PlacardBorder = Isaac.GetEntityVariantByName("Handicapped Placard Effect Border")

-- helpers for rendering
local FLAG_DISPLAY_UNLOCKS_TIP = false	-- display tips on the screen for the first launch of v1.27 with the unlocks system
local UnlocksTip = "PLEASE TAKE A MOMENT TO READ THIS MESSAGE. # #Hello! Repentance Plus was updated to include the #unlocks and achievements system! You now need #to gain completion marks with tainted characters #to unlock modded content. # #You can also track your progress, or #unlock marks, in two ways: #  1. Using console commands (type #rplus_help into the console for help); #  2. Using Mod Config Menu. # #IMPORTANT NOTE: your unlock progress is saved #ONLY when you exit a run!!! #Press Space, E or Enter to close this message" 
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

local EnigmaHeartSprite = Sprite()
EnigmaHeartSprite:Load("gfx/ui/ui_taintedhearts.anm2", true)
EnigmaHeartSprite:Play("Enigma")
local EnigmaRenderPos = Vector(123, 24)

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
-------------
-- chances	
local BASEMENTKEY_CHANCE = 25			-- chance to replace golden chest with an old chest
local HEARTKEY_CHANCE = 5				-- chance for enemy to drop Flesh chest on death
local SUPERBERSERK_ENTER_CHANCE = 25	-- chance to enter berserk state via Temper Tantrum
local SUPERBERSERK_DELETE_CHANCE = 5	-- chance to erase enemies while in this state
local TRASHBAG_BREAK_CHANCE = 1.25			-- chance of Bag-o-Trash breaking
local CHERRY_SPAWN_CHANCE = 20			-- chance to spawn cherry on enemy death
local SLEIGHTOFHAND_UPGRADE_CHANCE = 20	-- chance to upgrade your coins via Sleight of Hand
local JACK_CHANCE = 60					-- chance for Jack cards to spawn their respective type of pickup
local TRICKPENNY_CHANCE = 20			-- chance to save your consumable when using it via Trick Penny
local CEREM_DAGGER_LAUNCH_CHANCE = 7 	-- chance to launch a dagger
local NIGHT_SOIL_CHANCE = 75 			-- chance to negate curse
local NERVEPINCH_USE_CHANCE = 80		-- chance to activate your active item for free via Nerve Pinch
local FLESHCHEST_REPLACE_CHANCE = 25	-- chance for Flesh chests to replace mimic, spiked normally
local FLESHCHEST_OPEN_CHANCE = 33		-- chance to open Flesh chest
local STARGAZER_PAYOUT_CHANCE = 20		-- chance for Stargazer beggar to payout with an item
local BLOODYROCKS_REPLACE_CHANCE = 10	-- chance for Bloody (Ultra secret, Tainted) rocks to replace spiked rocks
local CRIPPLE_TEAR_CHANCE = 2			-- chance to cripple enemies by hitting them with your tears
local DARK_ARTS_CHANCE = 8				-- chance to activate Dark Arts if hit while having Key Knife trinket
local SOUL_BOND_HEARTDROP_CHANCE = 33	-- chance for chained enemy to drop a doul heart on death
local JEWEL_DROP_CHANCE = 7.5 			-- base chance for sins to drop Jewel on death

-- cooldowns
local ENRAGED_SOUL_COOLDOWN = 7 * 60			-- Enraged Soul familiar
local REDBOMBER_LAUNCH_COOLDOWN = 1 * 60 		-- throwing red bombs
local MAGICPEN_CREEP_COOLDOWN = 4 * 60 			-- Magic Pen creep
local NERVEPINCH_HOLD = 60 * 3					-- Nerve Pinch
local SIBLING_STATE_SWITCH_COOLDOWN = 15 * 30	-- switching Sibling forms
local DOGMA_ATTACK_COOLDOWN = 60 * 6			-- Dogma-ish attack

									-----------------
									----- ENUMS -----
									-----------------

local Costumes = {
	-- add ONLY NON-PERSISTENT COSTUMES here, because persistent costumes work without lua
	BIRD_OF_HOPE = Isaac.GetCostumeIdByPath("gfx/characters/costume_004_birdofhope.anm2")
}

local CustomTearVariants = {
	CEREMONIAL_BLADE = Isaac.GetEntityVariantByName("Ceremonial Dagger Tear"),
	SINNERS_HEART = Isaac.GetEntityVariantByName("Sinner's Heart Tear"),
	CORN = Isaac.GetEntityVariantByName("Corn Tear"),
	ANTIMATERIAL_CARD = Isaac.GetEntityVariantByName("Antimaterial Card Tear"),
	REJECTED_BABY = Isaac.GetEntityVariantByName("Rejected Baby Tear"),
	DOGMA_FEATHER = Isaac.GetEntityVariantByName("Dogma Feather Tear"),
	VALENTINES_CARD = Isaac.GetEntityVariantByName("Valentine's Card Tear")
}

local CustomFamiliars = {
	BAG_O_TRASH = Isaac.GetEntityVariantByName("Bag-o-Trash"),
	CHERUBIM = Isaac.GetEntityVariantByName("Cherubim"),
	CHERRY = Isaac.GetEntityVariantByName("Cherry"),
	BIRD = Isaac.GetEntityVariantByName("Bird of Hope"),
	ENRAGED_SOUL = Isaac.GetEntityVariantByName("Enraged Soul"),
	TOY_TANK_1 = Isaac.GetEntityVariantByName("Toy Tank 1"),
	TOY_TANK_2 = Isaac.GetEntityVariantByName("Toy Tank 2"),
	SIBLING_1 = Isaac.GetEntityVariantByName("Peaceful Sibling 1"),
	SIBLING_2 = Isaac.GetEntityVariantByName("Peaceful Sibling 2"),
	FIGHTING_SIBLINGS = Isaac.GetEntityVariantByName("Fighting Siblings"),
	REJECTION_FETUS = Isaac.GetEntityVariantByName("Rejection Fetus"),
	ENOCH = Isaac.GetEntityVariantByName("Enoch"),
	ENOCH_B = Isaac.GetEntityVariantByName("Enoch (tainted)"),
	SPIRITUAL_RESERVES_SUN = Isaac.GetEntityVariantByName("Spiritual Reserves (Sun)"),
	SPIRITUAL_RESERVES_MOON = Isaac.GetEntityVariantByName("Spiritual Reserves (Moon)"),
	FRIENDLY_SACK = Isaac.GetEntityVariantByName("Friendly Sack"),
	ULTRA_FLESH_KID_L1 = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 1"),
	ULTRA_FLESH_KID_L2 = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 2"),
	ULTRA_FLESH_KID_L3 = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 3"),
	ULTRA_FLESH_KID_L3_HEAD = Isaac.GetEntityVariantByName("Ultra Flesh Kid lvl 3 (head)"),
	HANDICAPPED_PLACARD = Isaac.GetEntityVariantByName("Handicapped Placard")
}

CustomCollectibles = {
	ORDINARY_LIFE = Isaac.GetItemIdByName("Ordinary Life"),
	COOKIE_CUTTER = Isaac.GetItemIdByName("Cookie Cutter"),
	RUBIKS_CUBE = Isaac.GetItemIdByName("Rubik's Cube"),
	MAGIC_CUBE = Isaac.GetItemIdByName("Magic Cube"),
	MAGIC_PEN = Isaac.GetItemIdByName("Magic Pen"),					
	SINNERS_HEART = Isaac.GetItemIdByName("Sinner's Heart"),
	MARK_OF_CAIN = Isaac.GetItemIdByName("The Mark of Cain"),			
	BAG_O_TRASH = Isaac.GetItemIdByName("Bag o Trash"),
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
	BLESS_OF_THE_DEAD = Isaac.GetItemIdByName("Bless of the Dead"),
	TANK_BOYS = Isaac.GetItemIdByName("Tank Boys"),
	GUSTY_BLOOD = Isaac.GetItemIdByName("Gusty Blood"),
	RED_BOMBER = Isaac.GetItemIdByName("Red Bomber"),
	MOTHERS_LOVE = Isaac.GetItemIdByName("Mother's Love"),
	CAT_IN_A_BOX = Isaac.GetItemIdByName("A Cat in the Box"),
	BOOK_OF_GENESIS = Isaac.GetItemIdByName("Book of Genesis"),
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
	MAGIC_MARKER = Isaac.GetItemIdByName("Magic Marker"),
	PURE_SOUL = Isaac.GetItemIdByName("Pure Soul"),
	BOOK_OF_JUDGES = Isaac.GetItemIdByName("Book of Judges"),
	HANDICAPPED_PLACARD = Isaac.GetItemIdByName("Handicapped Placard"),
	BIRTH_CERTIFICATE = Isaac.GetItemIdByName("Birth Certificate"),
	-- NULLS
	LOADED_DICE_NULL = Isaac.GetItemIdByName("loaded dice"),
	APPLE_OF_PRIDE_NULL = Isaac.GetItemIdByName("apple of pride"),
	DEMON_FORM_NULL = Isaac.GetItemIdByName("demon form"),
	HEART_BENIGHTED_NULL = Isaac.GetItemIdByName("benighted hearts boost"),
	CROWN_OF_GREED_NULL = Isaac.GetItemIdByName("crown of greed"),
	CURSED_CARD_NULL = Isaac.GetItemIdByName("cursed card"),
	YUM_DAMAGE_NULL = Isaac.GetItemIdByName("yum damage"),
	YUM_TEARS_NULL = Isaac.GetItemIdByName("yum tears"),
	YUM_RANGE_NULL = Isaac.GetItemIdByName("yum range"),
	YUM_LUCK_NULL = Isaac.GetItemIdByName("yum luck"),
	YUM_SPEED_NULL = Isaac.GetItemIdByName("yum speed")
}

CustomTrinkets = {
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
	SHATTERED_STONE = Isaac.GetTrinketIdByName("Shattered Stone")
}

CustomConsumables = {
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
	-- SIN'S JEWELS
	CANINE_OF_WRATH = Isaac.GetCardIdByName("Canine of Wrath"),
	CROWN_OF_GREED = Isaac.GetCardIdByName("Crown of Greed"),
	FLOWER_OF_LUST = Isaac.GetCardIdByName("Flower of Lust"),
	MASK_OF_ENVY = Isaac.GetCardIdByName("Mask of Envy"),
	APPLE_OF_PRIDE = Isaac.GetCardIdByName("Apple of Pride"),
	VOID_OF_GLUTTONY = Isaac.GetCardIdByName("Void of Gluttony"),
	ACID_OF_SLOTH = Isaac.GetCardIdByName("Acid of Sloth")
}

CustomPickups = {
	FLESH_CHEST = Isaac.GetEntityVariantByName("Flesh Chest"),
	SCARLET_CHEST = Isaac.GetEntityVariantByName("Scarlet Chest"),
	BLACK_CHEST = Isaac.GetEntityVariantByName("Black Chest"),
	COFFIN = Isaac.GetEntityVariantByName("Coffin"),
	-- tainted hearts
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
		HEART_DESERTED  = 100
	},
	SLOT_STARGAZER = Isaac.GetEntityVariantByName("Stargazer")
}

CustomPills = {
	ESTROGEN = Isaac.GetPillEffectByName("Estrogen Up"),
	LAXATIVE = Isaac.GetPillEffectByName("Laxative"),
	PHANTOM_PAINS = Isaac.GetPillEffectByName("Phantom Pains"),
	YUM = Isaac.GetPillEffectByName("Yum!"),
	YUCK = Isaac.GetPillEffectByName("Yuck!")
}

CustomItempools = {
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
		731 -- Stye
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
	MOMNDAD = {
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
	EMPTYPAGEACTIVES = {
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

local DropTables = {
	BLACK_CHEST = {
		{40, {{PickupVariant.PICKUP_GRAB_BAG, 2}}},
		{65, {{PickupVariant.PICKUP_TAROTCARD, 0}}},
		{85, {{PickupVariant.PICKUP_GRAB_BAG, 2}, {300, CustomConsumables.SPINDOWN_DICE_SHARD}}},
		{100, {{PickupVariant.PICKUP_GRAB_BAG, 2}, {300, Card.RUNE_BLACK}}}
	},
	BLOODYROCKS = {
		{10, {{300, Card.CARD_CRACKED_KEY}, {300, CustomConsumables.RED_RUNE}}},
		{30, {{300, CustomConsumables.RED_RUNE}, {10, HeartSubType.HEART_FULL}}},
		{50, {{10, HeartSubType.HEART_FULL}, {10, HeartSubType.HEART_FULL}}},
		{100, {{10, HeartSubType.HEART_FULL}, {300, Card.CARD_CRACKED_KEY}}},
	}
}

CustomStatups = {
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

local CustomChallenges = {
	THE_COMMANDER = Isaac.GetChallengeIdByName("The Commander"),
	JUDGEMENT = Isaac.GetChallengeIdByName("Judgement"),
	BLOOD = Isaac.GetChallengeIdByName("The Sacrifice"),
	IN_THE_LIGHT = Isaac.GetChallengeIdByName("Living in the Light")
}

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

-- vectors
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
	[Direction.NO_DIRECTION] = Vector(0, 1),	-- when you don't shoot or move, you default to HeadDown
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.UP] = Vector(0, -1),
	[Direction.RIGHT] = Vector(1, 0),
	[Direction.DOWN] = Vector(0, 1)
}	

local VECTOR_CARDINAL = {
	Vector(0, 1), 
	Vector(-1, 0), 
	Vector(0, -1), 
	Vector(1, 0)
}


						----------------------
						-- HELPER FUNCTIONS --
						----------------------
-- UNLOCK AND ACHIEVEMENT SYSTEM MANAGEMENT
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

local function getCharBSide(chr)
	if chr > 20 then return -1 end
	
	if chr == 12 then	-- Judas
		return 24
	elseif chr >= 13 and chr <= 16 then		-- Lilith to Forgotten
		return chr + 19
	elseif chr == 11 or chr == 17 or chr == 18 then		-- Lazarus, Soul and Bethany
		return chr + 18
	elseif chr == 19 or chr == 20 then	-- J&E
		return 37
	end
	
	return chr + 21
end

--
local function isMarkUnlocked(playerType, mark)
	if not CustomData.Unlocks then return end
	
	if playerType ~= "Special" then
		if type(playerType) ~= "number" then playerType = playerType:GetPlayerType() end
		if playerType == 38 then playerType = 29 end	-- T. Lazarus Dead
		if playerType == 39 then playerType = 37 end	-- T. Jacob Ghost
		if playerType == 40 then playerType = 35 end	-- T. Soul
		playerType = tostring(playerType) 
		if type(mark) ~= "string" then print("[ERR] Invalid argument: `mark` to isMarkUnlocked (string expected, " .. type(mark) .. " provided)") return end
		if not CustomData.Unlocks[playerType] then print("[ERR] Invalid argument: `playerType` to isMarkUnlocked (Player type doesn't exist)") return end
		if not CustomData.Unlocks[playerType][mark] then print("[ERR] Invalid argument: `mark` to isMarkUnlocked (mark doesn't exist)") return end
	else
		if not CustomData.Unlocks[playerType][mark] then print("[ERR] Invalid argument: `mark` to isMarkUnlocked (mark doesn't exist)") return end
	end
	
	return CustomData.Unlocks[playerType][mark].Unlocked
end

local function unlockMark(playerType, mark)
	if not CustomData.Unlocks then return end
	
	if playerType ~= "Special" then
		if type(playerType) ~= "number" then playerType = playerType:GetPlayerType() end
		if mark ~= "Character Unlock" and playerType < 21 then return end
		if playerType == 38 then playerType = 29 end	-- T. Lazarus Dead
		if playerType == 39 then playerType = 37 end	-- T. Jacob Ghost
		if playerType == 40 then playerType = 35 end	-- T. Soul
		if mark == "Character Unlock" then
			-- match normal character with their B-side
			playerType = getCharBSide(playerType)
		end
		
		playerType = tostring(playerType)
		if type(mark) ~= "string" then print("[ERR] Invalid argument: `mark` to unlockMark (string expected, " .. type(mark) .. " provided)") return end
		if not CustomData.Unlocks[playerType] then print("[ERR] Invalid argument: `playerType` to unlockMark (Player type doesn't exist)") return end
		if not CustomData.Unlocks[playerType][mark] then print("[ERR] Invalid argument: `mark` to unlockMark (mark doesn't exist)") return end
	else
		if not CustomData.Unlocks[playerType][mark] then print("[ERR] Invalid argument: `mark` to unlockMark (mark doesn't exist)") return end
	end
	
	if CustomData.Unlocks[playerType][mark].Unlocked then print("Mark already unlocked!") return end
	
	CustomData.Unlocks[playerType][mark].Unlocked = true
end

local function unlockAllPlayersMarks(pl)
	for _, m in pairs(marks) do
		unlockMark(pl, m)
	end
end

local function unlockMarkOnAllPlayers(mark)
	for p = 21, 37 do
		unlockMark(p, mark)
	end
end

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
		for _, m in pairs(marks) do
			unlockMark(p, m)
		end
	end
	
	unlockSpecials()
	unlockHearts()
	unlockMark("Special", "Birth Certificate")
end

local function checkAllMarks(keepGoing, includeSpecials)
	for p = 21, 37 do
		for _, m in pairs(marks) do
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
--

local function GetScreenCenterPosition()
	-- function stolen by me from Bogdan Ryduka, who stole it from kil
	-- that's how mafia works everybody
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
	
	return Isaac.WorldToRenderPosition(pos, false)
end

local function SilentUseCard(p, card)
	p:UseCard(card, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
end

local function playAchievementPaper(playerType, mark)
	if not CustomData.Unlocks then return end
	if mark ~= "Character Unlock" and playerType < 21 then return end
	
	if playerType == 38 then playerType = 29 end	-- T. Lazarus Dead
	if playerType == 39 then playerType = 37 end	-- T. Jacob Ghost
	if playerType == 40 then playerType = 35 end	-- T. Soul
	if mark == "Character Unlock" then
		-- match normal character with their B-side
		playerType = getCharBSide(playerType)
	end
	
	playerType = tostring(playerType)
	if not CustomData.Unlocks[playerType] or not CustomData.Unlocks[playerType][mark] or not CustomData.Unlocks[playerType][mark].Unlocked 
	or not CustomData.Unlocks[playerType][mark].paper then return end
	
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
	achievementPaper:ReplaceSpritesheet(3, "gfx/ui/achievement/" .. CustomData.Unlocks[playerType][mark].paper .. ".png")
	achievementPaper:LoadGraphics()
end

local function isPickupUnlocked(pickupVar, pickupSubType)
	if not CustomData.Unlocks then return end
	
	if pickupVar == 300 or pickupVar == 100 or pickupVar == 10 or pickupVar == 350 then	-- cards, trinkets, hearts or collectible items
		for p = 21, 37 do
			for _, m in pairs(marks) do
				if CustomData.Unlocks[tostring(p)][m].Variant == pickupVar and CustomData.Unlocks[tostring(p)][m].SubType == pickupSubType
				and isMarkUnlocked(p, m) then
					return true
				end
			end
		end
	else
		print("[ERR] Invalid argument: `pickupVar` to isPickupUnlocked (can only check for hearts(10), cards(300), trinkets(350) or collectibles(100))")
		return false
	end
	
	-- special (B.C. and double unlocks)
	if pickupVar == 100 then
		if pickupSubType == CustomCollectibles.BIRTH_CERTIFICATE then
			return isMarkUnlocked("Special", "Birth Certificate")
		elseif pickupSubType == CustomCollectibles.MAGIC_CUBE then
			return isMarkUnlocked(21, "Isaac")
		end
	elseif pickupVar == 300 then
		if pickupSubType == CustomConsumables.FIEND_FIRE then
			return isMarkUnlocked(28, "Greed")
		end
	end
	
	return false
end
RepentancePlusMod.isPickupUnlocked = isPickupUnlocked

local function morphToTaintedIfUnlocked(heartPickup, taintedType)
	if isPickupUnlocked(10, taintedType) then
		heartPickup:Morph(5, 10, taintedType, true, true, true)
	end
end

local function isPillEffectUnlocked(effect)
	if not CustomData.Unlocks then return end
	
	for p = 21, 37 do
		local m = "Greed"
		if CustomData.Unlocks[tostring(p)][m].Variant == 70 and CustomData.Unlocks[tostring(p)][m].SubType == effect
		and isMarkUnlocked(p, m) then
			return true
		end
	end
	
	-- special
	return isMarkUnlocked(28, "Greed") and effect == CustomPills.YUCK or false
end
RepentancePlusMod.isPillEffectUnlocked = isPillEffectUnlocked

local function isChallengeCoreItem(item)
	local c = Isaac.GetChallenge()
	
	return c == CustomChallenges.THE_COMMANDER and item == CustomCollectibles.TANK_BOYS 
	or c == CustomChallenges.JUDGEMENT and (item == CustomCollectibles.BOOK_OF_JUDGES or item == CustomCollectibles.CHERUBIM)
	or c == CustomChallenges.BLOOD and item == CustomCollectibles.CEREMONIAL_BLADE 
	or c == CustomChallenges.IN_THE_LIGHT and item == CustomCollectibles.ANGELS_WINGS
end
--------------------------------------------

-- MANAGE UNLOCKABLE ITEMS (THEY ALL WORK NOW!) --
local function GetUnlockedVanillaCollectible(allPools, includeActives, excludeTags)
	allPools = allPools or false
	includeActives = includeActives or false
	excludeTags = excludeTags or ItemConfig.TAG_QUEST
    local itemPool = game:GetItemPool()
    
	repeat
		if allPools then 
			rng:SetSeed(Random() + 1, 1)
			local randomPool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
			colResult = itemPool:GetCollectible(randomPool, true)
		else
			local rt = game:GetRoom():GetType()
			local ip		-- item pool
			
			if rt == 2 or rt == 22 then ip = 1
			elseif rt == 5 then ip = 2
			elseif rt == 7 or rt == 8 then ip = 5
			elseif rt == 10 then ip = 12
			elseif rt == 14 then ip = 3
			elseif rt == 15 then ip = 4
			elseif rt == 24 then ip = 26
			elseif rt == 29 then ip = 24
			elseif rt == 12 then ip = includeActives and 6 or 0		-- libraries
			else ip = 0
			end
			
			colResult = itemPool:GetCollectible(ip, true)
		end
	until Isaac.GetItemConfig():GetCollectible(colResult).Tags & excludeTags ~= excludeTags	-- tags
	and (includeActives or Isaac.GetItemConfig():GetCollectible(colResult).Type % 3 == 1) 		-- passive or familiar (type 1 or 4)
	
	return colResult
end

local function GetUnlockedCollectibleFromCustomPool(poolTableEntry)
	local freezePreventChecker = 0
	local colResult = 25 -- good ol breakfast
	rng:SetSeed(Random() + 1, 1)
	
	repeat
		local tryID = GetUnlockedVanillaCollectible(true, true)
		for _, el in pairs(poolTableEntry) do
			if el == tryID then
				colResult = tryID
				Isaac.DebugString("INFO: successfully chosen unlocked collectible #" .. tostring(colResult) .. " from custom pool!")
				break
			end
		end
		freezePreventChecker = freezePreventChecker + 1
	until (colResult ~= 25) or freezePreventChecker == 7000
	
	if freezePreventChecker == 7000 and colResult == 25 then
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)		-- optional
		print("WARNING: item pool is likely exhausted and will not return any more valid items!")
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
	until game:GetItemPool():RemoveTrinket(trinketRes) or freezePreventChecker == 1000
	
	if freezePreventChecker == 1000 then
		print("WARNING: trinket pool is likely exhausted and will not return any more valid trinkets!")
		Isaac.DebugString("WARNING: trying to grab a new trinket from a pool that is exhausted; returning nothing...")
	end
	
	return trinketRes
end

local function blacklistCollectibles(Player, collectible1, collectible2)
	-- `Player` (EntityPlayer): a Player
	-- `collectible1` (int): what collectible should be blacklisted
	-- `collectible2` (int/table): what collectible(s) should collectible1 be blacklisted from
	if game:GetFrameCount() % 30 ~= 0 then return end
	Player = Player or Isaac.GetPlayer(0)
	
	if type(collectible2) == 'number' then
		if Player:HasCollectible(collectible1) then
			game:GetItemPool():RemoveCollectible(collectible2)
		end
		
		if Player:HasCollectible(collectible2) then
			game:GetItemPool():RemoveCollectible(collectible1)
		end
	elseif type(collectible2) == 'table' then
		for _, COL in pairs(collectible2) do
			if Player:HasCollectible(collectible1) then
				game:GetItemPool():RemoveCollectible(COL)
			end
			
			if Player:HasCollectible(COL) then
				game:GetItemPool():RemoveCollectible(collectible1)
			end
		end
	end
end
----------------------------------------------------------------------------------

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

local function isInGhostForm(Player, ignoreVisibleHealth)
	ignoreVisibleHealth = ignoreVisibleHealth or false
	
	if ignoreVisibleHealth then
		return Player:GetPlayerType() == 10 or Player:GetPlayerType() == 31
	else
		return Player:GetPlayerType() == 10 or Player:GetPlayerType() == 31 or
		Player:GetPlayerType() == 39 or	Player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
	end
end				

local function isPlayerDying(Player)
	if Player:GetBabySkin() == BabySubType.BABY_FOUND_SOUL then return end
	-- and by 'dying' I (unfortunately) mean 'playing death animation'
	local sprite = Player:GetSprite()
	
	return (sprite:IsPlaying("Death") and sprite:GetFrame() > 50) or
	(sprite:IsPlaying("LostDeath") and sprite:GetFrame() > 30)
end

local function reviveWithTwin(Player)
	-- allows you to revive the Player, give them short i-v frames, and revive their twin (e.g. Esau or Tainted Soul)
	Player:Revive()
	Player:SetMinDamageCooldown(40)
	if Player:GetOtherTwin() then
		Player:GetOtherTwin():Revive()
		Player:GetOtherTwin():SetMinDamageCooldown(40)
	end
end

local function isSelfDamage(damageFlags, data)
	-- `damageFlags` (int): damage flags passed from MC_ENTITY_TAKE_DMG callback
	-- `data` (string): can be used to specify what sources you want to include on checking (to ignore the rest)
	
	local selfDamageFlags = {
		['IVBag'] = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG,
		['Confessional'] = DamageFlag.DAMAGE_RED_HEARTS,
		['DemonBeggar'] = DamageFlag.DAMAGE_RED_HEARTS,
		['BloodDonationMachine'] = DamageFlag.DAMAGE_RED_HEARTS,
		['HellGame'] = DamageFlag.DAMAGE_RED_HEARTS,
		['CurseRoom'] = DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_CURSED_DOOR,
		['MausoleumDoor'] = DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS,
		['SacrificeRoom'] = DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES
	}
	
	if data == "greedsheart" then
		selfDamageFlags = {
			selfDamageFlags['IVBag'],
			selfDamageFlags['SacrificeRoom']
		}
	elseif data == "bloodvessel" then
		selfDamageFlags = {
			selfDamageFlags['SacrificeRoom'],
			selfDamageFlags['MausoleumDoor']
		}
	elseif data == "taintedhearts" then 
		selfDamageFlags = {
			selfDamageFlags['IVBag'],
			selfDamageFlags['Confessional'],
			selfDamageFlags['DemonBeggar'],
			selfDamageFlags['BloodDonationMachine'],
			selfDamageFlags['HellGame']
		}
	end
	
	for source, flags in pairs(selfDamageFlags) do
		if damageFlags & flags == flags then
			return true
		end
	end
	return false
end

local function getMothersLoveStatBoost(fVariant, insertCustom, boostMul)
	-- `fVariant` (int): familiar that you want to check (you can also insert info about it if `insertCustom` is true)
	-- `insertCustom` (boolean): default - false. If true, allows you to add a custom stat boost multiplier for familiar
	-- `boostMul` (float): if you want to insert a stat boost multiplier for familiar
	
	-- for Mother's Love, familiars will grant stronger or weaker stat boosts, depending on their rarity and effectiveness
	-- all Repentance+ familiars have to be listed here
	-- all vanilla familiars unlisted do NOT grant stat boosts (e.g. spiders, flies, dips, familiar spawned from trinkets and Isaac's body parts)
	FAMILIAR_STAT_MUL = {
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
		[FamiliarVariant.RUNE_BAG] = 1,
		[FamiliarVariant.SERAPHIM] = 1.25,
		[FamiliarVariant.GB_BUG] = math.random(85, 115) / 100,	-- like, glitch reference, get it guys?..
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
		[FamiliarVariant.LOST_SOUL] = 1.25,
		[FamiliarVariant.LIL_DUMPY] = 1,
		[FamiliarVariant.TINYTOMA] = 1,
		[FamiliarVariant.BOT_FLY] = 1,
		[FamiliarVariant.PASCHAL_CANDLE] = 1,
		[FamiliarVariant.FRUITY_PLUM] = 1,
		[FamiliarVariant.LIL_ABADDON] = 1,
		[FamiliarVariant.LIL_PORTAL] = 1,
		[FamiliarVariant.WORM_FRIEND] = 1,
		[FamiliarVariant.TWISTED_BABY] = 1,
		[FamiliarVariant.STAR_OF_BETHLEHEM] = 1,
		[FamiliarVariant.CUBE_BABY] = 1,
		[FamiliarVariant.BLOOD_PUPPY] = 1.25,
		[FamiliarVariant.VANISHING_TWIN] = 1.25,
		-- Repentance+
		[CustomFamiliars.BAG_O_TRASH] = 1,
		[CustomFamiliars.CHERUBIM] = 1,
		[CustomFamiliars.CHERRY] = 0,
		[CustomFamiliars.BIRD] = 0,
		[CustomFamiliars.ENRAGED_SOUL] = 0,
		[CustomFamiliars.TOY_TANK_1] = 0.75,
		[CustomFamiliars.TOY_TANK_2] = 0.75,
		[CustomFamiliars.SIBLING_1] = 0.75,
		[CustomFamiliars.SIBLING_2] = 0.75,
		[CustomFamiliars.FIGHTING_SIBLINGS] = 1.5,
	}	

	insertCustom = insertCustom or false
	boostMul = boostMul or nil
	if insertCustom == true and type(boostMul) == 'number' then
		FAMILIAR_STAT_MUL[fVariant] = boostMul
		return boostMul
	end
	
	if not FAMILIAR_STAT_MUL[fVariant] then
		if fVariant < 244 or fVariant == 900 then
			-- vanilla unlisted: 0
			return 0
		else
			-- modded unlisted: 1 (unless overriden by insertCustom)
			return 1
		end
	else
		return FAMILIAR_STAT_MUL[fVariant]
	end
end

local function getTrueFamiliarNum(Player, collectible)
	return Player:GetCollectibleNum(collectible) + Player:GetEffects():GetCollectibleEffectNum(collectible)
end

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

local function isCollidingWithAstralChain(entity)
	if not entity:IsVulnerableEnemy() or entity:GetData()['isChainedToPlayer'] then return end
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
	if sfx:IsPlaying(33) then sfx:Stop(33) end
end

local function isInPlayersLineOfSight(EntityNPC, Player)
	local v1 = DIRECTION_VECTOR[Player:GetHeadDirection()]
	local v2 = EntityNPC.Position - Player.Position
	local angle = math.abs(v1:GetAngleDegrees() - v2:GetAngleDegrees())
	
	return Player:GetHeadDirection() == Direction.LEFT and math.min(angle, 360 - angle) < 36 or angle < 36
end

local function isItemPocketSlotBlacklisted(i)
	return i == CollectibleType.COLLECTIBLE_GLASS_CANNON
	or i == CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON
	or i == CollectibleType.COLLECTIBLE_D_INFINITY
	or i == CollectibleType.COLLECTIBLE_ERASER
	or i == CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
	or i == CollectibleType.COLLECTIBLE_TELEKINESIS
	or i == CollectibleType.COLLECTIBLE_SPIN_TO_WIN
	or i == CollectibleType.COLLECTIBLE_DECAP_ATTACK
	or i == CollectibleType.COLLECTIBLE_PLACEBO
	or i == CollectibleType.COLLECTIBLE_BLANK_CARD
	or i == CollectibleType.COLLECTIBLE_CLEAR_RUNE
	or i == CustomCollectibles.STARGAZERS_HAT
	or i == CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD
	or i == CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP
	or i == CollectibleType.COLLECTIBLE_VOID
end

local function crippleEnemy(enemy)
	local d = enemy:GetData()
	if not d.IsCrippled and enemy:IsVulnerableEnemy() 
	and enemy:IsActiveEnemy(false) and not enemy:IsBoss() then
		-- applying custom debuffs to enemies
		d.IsCrippled = true
		d.CrippleStartFrame = game:GetFrameCount()
		d.CrippleDeathBurst = false
		local crippleHands = Isaac.Spawn(1000, CripplingHandsHelper, 0, enemy.Position + Vector(0, 5), Vector.Zero, enemy):ToEffect()
		crippleHands:GetSprite():Play("ClawsAppearing")
		
		return true
	end
	
	return false
end

local function makeLightbeams(room)
	if not CustomData.Data then return end

	CustomData.Data.Items.BOOK_OF_JUDGES.BeamTargets = {}
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
			table.insert(CustomData.Data.Items.BOOK_OF_JUDGES.BeamTargets, pos)
			local beamTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 3, pos, Vector.Zero, nil)
			beamTarget:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_beam_target.png")
			beamTarget:GetSprite():LoadGraphics()
			beamTarget:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 10000, 1, false, false)
		end
	until #CustomData.Data.Items.BOOK_OF_JUDGES.BeamTargets == roll
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

local function isNoRedHealthCharacter(Player)
	local t = Player:GetPlayerType()
	
	return t == PlayerType.PLAYER_BLUEBABY or t == PlayerType.PLAYER_THELOST or t == PlayerType.PLAYER_KEEPER
	or t == PlayerType.PLAYER_THESOUL or t == PlayerType.PLAYER_JUDAS_B or t == PlayerType.PLAYER_BLUEBABY_B
	or t == PlayerType.PLAYER_THELOST_B or t == PlayerType.PLAYER_KEEPER_B or t == PlayerType.PLAYER_THEFORGOTTEN_B
	or t == PlayerType.PLAYER_BETHANY_B or t == PlayerType.PLAYER_JACOB2_B or t == PlayerType.PLAYER_THESOUL_B
end

-- manipulating black heart bitmasks
local function bitmaskIntoNumber(Player, getFirstHeart, heartType)
	getFirstHeart = getFirstHeart or false
	if not getFirstHeart then heartType = "" end
	
	local s = Player:GetSoulHearts()	-- number of soul + black hearts
	local b = Player:GetBlackHearts()	-- bitmask of black hearts read right-to-left
	
	local y = {}
	while b > 0 do
		table.insert(y, b % 2)
		b = b // 2
	end
	
	if not getFirstHeart then
		-- if we just need the amount of black hearts, return right now
		local numB = 0
		for _, el in pairs(y) do
			if el == 1 then numB = numB + 1 end
		end
		
		return numB
	else
		--[[ getting the first heart of a kind will be a bit more complicated
		just having y table does not account for soul hearts at the back of the health bar
		so we need to add as many 0's to that as there are soul hearts left --]]
		local addBits = math.floor(s / 2 + 0.5) - #y	
		for j = 1, addBits do
			table.insert(y, 0)
		end
		
		-- reverse the table
		local y_r = {}
		for i = #y, 1, -1 do
			table.insert(y_r, y[i])
			--print(y[i])
		end
		y = y_r
	
		-- now that y table has ALL of our soul health, we can get the needed one
		for index, heart in pairs(y) do
			if (heart == 0 and heartType == "soul") or (heart == 1 and heartType == "black") then
				return {index, s % 2 == 1}	-- {first entry of the heart, whether your soul health has an odd number of units}
			end
		end
	end
end

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
		local bh_p = bitmaskIntoNumber(Player)
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
		newID = GetUnlockedVanillaCollectible(false, false)
		Player:AddItemWisp(newID, Player.Position, true)
	end
	sfx:Play(SoundEffect.SOUND_DEATH_CARD)
end
-------------------------

-- for UI Tainted hearts
------------------------
local function getRightMostHeartForRender(Player)
	-- I miserably failed in rendering hearts in separate containers, so they can be stacked on top of each other for now
	local rm 
	
	if Player:GetSoulHearts() > 0 then 
		rm = math.floor((Player:GetMaxHearts() + Player:GetSoulHearts()) / 2  + Player:GetBoneHearts() + 0.5)
	elseif Player:GetBoneHearts() > 0 then 
		rm = Player:GetBoneHearts() + Player:GetMaxHearts() / 2
	else 
		rm = math.floor(Player:GetHearts() / 2 + 0.5)
	end
	
	return rm
end

local function HeartRender(Player, heartData, heartAnim)
	--[[
		`Player` (EntityPlayer): Player whose Tainted hearts need to be rendered. CURRENTLY ONLY SUPPORTS MAIN PLAYER (index 0) !!!
		`heartData` (int): CustomData.Data entry that refers to the number of certain Tainted hearts that the Player owns
		`heartAnim` (string): animation that refers to a certain Tainted heart
	]]
	
	if not CustomData.Data or heartData == 0 or not game:GetHUD():IsVisible() 
	or game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN == LevelCurse.CURSE_OF_THE_UNKNOWN then return end
	
	local TopVector
	local HeartRenderOffset = Options.HUDOffset * HUDValueRenderOffset
	local heartBegin
	local heartEnd
	
	if heartData > 0 then
		local heartSprite = Sprite()
		heartSprite:Load("gfx/ui/ui_taintedhearts.anm2", true)
		heartSprite:Play(heartAnim, true)
		if heartAnim == "Miser" then
			heartEnd = getRightMostHeartForRender(Player) - Player:GetGoldenHearts()
		elseif heartAnim == "Baleful" then 
			heartEnd = getRightMostHeartForRender(Player) - Player:GetGoldenHearts() - CustomData.Data.TaintedHearts.MISER
		elseif heartAnim == "Dauntless" then 
			heartEnd = getRightMostHeartForRender(Player) - Player:GetGoldenHearts() - CustomData.Data.TaintedHearts.MISER - CustomData.Data.TaintedHearts.BALEFUL
		elseif heartAnim == "Soiled" then 
			heartEnd = math.floor(Player:GetHearts() / 2 + 0.5 - Player:GetBoneHearts() - Player:GetRottenHearts()) 
		elseif heartAnim == "Zealot" then 
			heartEnd = getRightMostHeartForRender(Player) - Player:GetGoldenHearts() - CustomData.Data.TaintedHearts.DAUNTLESS - CustomData.Data.TaintedHearts.MISER - CustomData.Data.TaintedHearts.BALEFUL
		else
			heartEnd = getRightMostHeartForRender(Player)
		end
		heartBegin = heartEnd + 1 - heartData
		
		for i = heartBegin, heartEnd do
			if (i < 7) then
				TopVector = Vector((i - 1) * 12 + 48, 12)
			elseif (i < 13) then
				TopVector = Vector((i - 7) * 12 + 48, 22)
			else
				TopVector = Vector((i - 13) * 12 + 48, 32)
			end
			heartSprite:Render(TopVector + Vector.One + HeartRenderOffset, Vector.Zero, Vector.Zero)
			heartSprite:Update()
		end
	end
end
---------------------

-- for animated Angel's Wings pedestal
--------------------------------------
local function hasEffectOnIt(ent)
	for _, eff in pairs(Isaac.FindByType(1000, AnimatedItemDummyEntity, 0, true, true)) do
		if eff.SpawnerEntity and GetPtrHash(eff.SpawnerEntity) == GetPtrHash(ent) then return true end
	end
	
	return false
end
---------------------------------



						-----------------------------
						-- CALLBACK TIED FUNCTIONS --
						-----------------------------

-- very epic and cool command to prevent game crash when reloading this mod through the mod menu
rplus:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
    if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
        Isaac.ExecuteCommand("reloadshaders")
    end
end)

						-- MC_POST_GAME_STARTED --				
						--------------------------
function rplus:OnGameStart(Continued)
	if not Continued then
		FLAG_HIDE_ERROR_MESSAGE = false
		FLAG_NO_TAINTED_HEARTS = false
		
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
			Isaac.DebugString("[REP PLUS] First launch of v1.27! Removing old custom data for restructure...")
			rplus:RemoveData()
		end
		--
		
		--[[
			if CustomData doesn't exist, then it's first launch of v1.27, LOAD the unlocks
			otherwise, do NOT do anything to not overwrite the table
		--]]
		local secondDataLoad = Isaac.LoadModData(rplus)
		if not secondDataLoad or secondDataLoad == "" then
			Isaac.DebugString("[REP PLUS] Creating a new saveX.dat file...")
			CustomData.Unlocks = { 
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
					["Mom's Heart"] = {Unlocked = false, Variant = 100, SubType = CustomTrinkets.RED_MAP, paper = "2-3"},
					["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomCollectibles.JACK_OF_DIAMONDS, paper = "3-3"}, 
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
					["Greed"] = {Unlocked = false, Variant = 70, SubType = CustomPills.ESTROGEN, paper = "7-6"}
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
					["Satan"] = {Unlocked = false, Variant = 100, SubType = DNA_REDACTOR, paper = "4-9"}, 
					["Isaac"] = {Unlocked = false, Variant = 100, SubType = CAT_IN_A_BOX, paper = "5-9"}, 
					["Blue Baby"] = {Unlocked = false, Variant = 100, SubType = NERVE_PINCH, paper = "6-9"}, 
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
				["34"] = {	--T.Appolyon
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
					["Mom's Heart"] = {Unlocked = false, Variant = 100, SubType = CustomTrinkets.SIBLING_RIVALRY, paper = "2-17"},
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

			FLAG_DISPLAY_UNLOCKS_TIP = true
			Isaac.SaveModData(rplus, json.encode(CustomData, "CustomData"))
		else
			Isaac.DebugString("[REP PLUS] Loading mod data from saveX.dat...")
			CustomData = json.decode(secondDataLoad)
		end
		
		--[[ Correct mistakes in CustomData.Unlocks 
			This has to be done manually, because unlocks table is already written into users' savedata
			Guess why I also need to do this? Riiight, to have other content mods not break it due to dynamic subtype assignment
		--]]
		-- items
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
		--
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
		--
		
		-- create new data entry for CustomData table
		CustomData.Data = {
			Items = {
				RUBIKS_CUBE = {Counter = 0},
				BIRD_OF_HOPE = {numRevivals = 0, birdCaught = false, catchingBird = false, dieFrame = nil, diePos = nil},
				BLACK_DOLL = {EntitiesGroupA = {}, EntitiesGroupB = {}},
				DNA_REDACTOR = {whitePillUsed = 0},
				RED_MAP = {ShownOnFloorOne = false},
				TWO_PLUS_ONE = {isEffectActive = false, itemsBought = 0},
				STARGAZERS_HAT = {UsedOnFloor = false},
				MOTHERS_LOVE = {NumStats = 0, NumFriends = 0},
				BLOODVESSEL = {DamageFlag = false},
				RED_KING = {redCrawlspacesData = {}},
				MAGIC_MARKER = {CardDrop = false},
				VAULT_OF_HAVOC = {EnemyList = {}, Data = false, SumHP = 0, EnemiesSpawned = false},
				PURE_SOUL = {isPortalSuperSecret = false},
				BOOK_OF_JUDGES = {BeamTargets = {}, NoBeams = false}
			},
			Cards = {
				JACK = {Type = "", FLAG_OPTIONS_SPECIAL = false}	-- used for Options?
			},
			Trinkets = {
				GREEDS_HEART = "CoinHeartEmpty",
				ANGELS_CROWN = {treasureRoomsData = {{index = -1, needToConvert = false},
												     {index = -1, needToConvert = false}}}
			},
			TaintedHearts = {
				HEART_NO_MORPH_FRAME = 0,
				HEART_RENDER_FRAME = 0,
				--
				ZEALOT = 0,
				EMPTY = 0,
				SOILED = 0,
				ENIGMA = 0,
				DAUNTLESS = 0,
				MISER = 0,
				BALEFUL = 0
			},
			NumTaintedRocks = 0,
			FleshChestConsumedHP = 0,
			ErasedEnemies = {}
		}
		
		if CustomData and CustomData.Data and CustomData.Unlocks then 
			print("Repentance Plus mod v" .. MOD_VERSION .. " initialized")
			print("For a list of functions, type `rplus_help`")
		else
			if not CustomData.Data then
				print("[ERR] Something went wrong! Custom data table is missing!")
			elseif not CustomData.Unlocks then
				print("[ERR] Something went wrong! Unlocks table is missing!")
			end
		end
		
		--[[ MOD CONFIG MENU COMPATIBILITY --]]
		if ModConfigMenu and FLAG_CONNECT_MCM then
			local RplusName = "Repentance Plus"

			ModConfigMenu.UpdateCategory(RplusName, {
				Info = {"Repentance Plus Unlocks",}
			})
			
			for id = 21, 37 do
				local charactername = playerTypeToName[id]
				ModConfigMenu.AddSpace(RplusName, charactername)
				for _, m in pairs(marks) do
					ModConfigMenu.AddSetting(RplusName, charactername, 
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
			
			ModConfigMenu.AddSpace(RplusName, "Special")
			for _, m in pairs({"Black Chest", "Scarlet Chest", "Flesh Chest", "Coffin", "Stargazer", "Tainted Rocks", "Birth Certificate"}) do
					ModConfigMenu.AddSetting(RplusName, "Special", 
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
		--[[ COMPATIBILITY END --]]
		
		--[[ Spawn items/trinkets or turn on debug commands for testing here if necessary
		DEBUG: 3 - INFINITE HP, 4 - HIGH DAMAGE, 8 - INFINITE CHARGES, 10 - INSTAKILL ENEMIES
		
		Isaac.Spawn(5, 350, CustomTrinkets.TestTrinket, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.Spawn(5, 100, CustomCollectibles.TestCollectible, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.ExecuteCommand("debug 0")
		--]]

		--[[ Process custom challenges --]]
		local p = Isaac.GetPlayer(0)
		if Isaac.GetChallenge() == CustomChallenges.JUDGEMENT then
			p:AddCollectible(CustomCollectibles.BOOK_OF_JUDGES)
			p:AddCollectible(CustomCollectibles.CHERUBIM)
		elseif Isaac.GetChallenge() == CustomChallenges.BLOOD then
			p:AddCollectible(CustomCollectibles.CEREMONIAL_BLADE)
		elseif Isaac.GetChallenge() == CustomChallenges.IN_THE_LIGHT then
			p:AddCollectible(CustomCollectibles.ANGELS_WINGS)
		end

		-- recalculating cache, just in case
		for i = 0, game:GetNumPlayers() - 1 do
			local Player = Isaac.GetPlayer(i)
			Player:AddCacheFlags(CacheFlag.CACHE_ALL)
			Player:EvaluateItems()

			-- removing locked trinkets from inventory
			for t = CustomTrinkets.BASEMENT_KEY, CustomTrinkets.EMPTY_PAGE do
				if not isPickupUnlocked(350, t) and Player:HasTrinket(t) then
					Player:TryRemoveTrinket(t)
				end
			end
		end
	else
		-- load CustomData into a continued run
		Isaac.DebugString("[REP PLUS] Loading custom mod data from source...")
		CustomData = json.decode(Isaac.LoadModData(rplus))
	end
	
	-- deleting certain trinkets from rotation
	local pool = game:GetItemPool()
	pool:RemoveTrinket(CustomTrinkets.WAIT_NO)
	for i = CustomTrinkets.BASEMENT_KEY, CustomTrinkets.EMPTY_PAGE do
		if not isPickupUnlocked(350, i) then
			pool:RemoveTrinket(i)
		end
	end
	
	if checkAllMarks(false, false) and not isMarkUnlocked("Special", "Birth Certificate") then
		unlockMark("Special", "Birth Certificate")
		playAchievementPaper("Special", "Birth Certificate")
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, rplus.OnGameStart)
						

						-- MC_PRE_GAME_EXIT --						
						----------------------
---@param ShouldSave boolean					
function rplus:PreGameExit(ShouldSave)
	-- save CustomData regardless of whether you should save on exit or not
	Isaac.DebugString("[REP PLUS] Saving custom mod data to source...")
	Isaac.SaveModData(rplus, json.encode(CustomData, "CustomData"))
end
rplus:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, rplus.PreGameExit)


						-- MC_POST_GAME_END --										
						----------------------
---@param isGameOver boolean
function rplus:GameEnded(isGameOver)
	local maxID = Isaac.GetItemConfig():GetCollectibles().Size - 1
	
    for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		
		if Player:HasCollectible(CustomCollectibles.HAND_ME_DOWNS) then
			-- actually can't write this into CustomData because lua tables are retarded
			GameOverStage = game:GetLevel():GetStage()
			GameOverItems = {}
			rng:SetSeed(Random() + 1, 1)
			local freezePreventChecker = 0
			
			repeat
				local roll = rng:RandomInt(maxID) + 1
				freezePreventChecker = freezePreventChecker + 1
				
				if Player:HasCollectible(roll) and 
				Isaac.GetItemConfig():GetCollectible(roll).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST and 
				roll ~= CustomCollectibles.HAND_ME_DOWNS then
					Player:RemoveCollectible(roll)
					table.insert(GameOverItems, roll)
				end
			until #GameOverItems == 3 or freezePreventChecker == 1000
		end
	end
	
	CustomData.Data.TaintedHearts.EMPTY = 0
	CustomData.Data.TaintedHearts.ZEALOT = 0
	CustomData.Data.TaintedHearts.DAUNTLESS = 0
	CustomData.Data.TaintedHearts.ENIGMA = 0
	CustomData.Data.TaintedHearts.MISER = 0
	CustomData.Data.TaintedHearts.BALEFUL = 0
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
		CustomData.Unlocks = { 
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
				["Boss Rush"] = {Unlocked = false, Variant = 300, SubType = CustomCollectibles.JACK_OF_DIAMONDS, paper = "3-3"}, 
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
				["Greed"] = {Unlocked = false, Variant = 70, SubType = CustomPills.ESTROGEN, paper = "7-6"}
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
			["34"] = {	--T.Appolyon
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
	
	-- TEST COMMAND
	if command == "rplus_test" then
		print('Let\'s test some shit')
		Isaac.ExecuteCommand("g glowing")
		Isaac.ExecuteCommand("macro qk")
		Isaac.ExecuteCommand("g k5")
		Isaac.ExecuteCommand("g roid rage")
	end
end
rplus:AddCallback(ModCallbacks.MC_EXECUTE_CMD, rplus.OnCommandExecute)


						-- MC_POST_NEW_LEVEL --										
						-----------------------
function rplus:OnNewLevel()
	if not CustomData.Data then return end
	local level = game:GetLevel()
	
	CustomData.Data.TaintedHearts.HEART_RENDER_FRAME = game:GetFrameCount()
	if CustomData.Data.Items.PURE_SOUL.isPortalSuperSecret then
		CustomData.Data.Items.PURE_SOUL.isPortalSuperSecret = false
	else
		CustomData.Data.Items.PURE_SOUL.isPortalSuperSecret = true
	end
	CustomData.Data.Cards.JACK = {Type = "", FLAG_OPTIONS_SPECIAL = false}
	CustomData.Data.NumTaintedRocks = 0
	CustomData.Data.Items.STARGAZERS_HAT.UsedOnFloor = false
	CustomData.Data.Items.RED_KING.redCrawlspacesData = {}
	CustomData.Data.Trinkets.ANGELS_CROWN.treasureRoomsData = {{index = -1, needToConvert = false},
														  		{index = -1, needToConvert = false}}
	CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList = {}
	CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive = false
	
	if GameOverStage and level:GetStage() == GameOverStage then 
		for _, item in pairs(GameOverItems) do
			Isaac.Spawn(5, 100, item, game:GetRoom():FindFreePickupSpawnPosition(Vector(300, 200)), Vector.Zero, nil):ToPickup()
		end		
		GameOverStage = nil
		GameOverItems = {}	
	end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL) then
			Player:GetEffects():RemoveCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL, Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.DEMON_FORM_NULL))
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			Player:EvaluateItems()
		end
		
		if Player:GetData()['enhancedSB'] then
			Player:GetData()['enhancedSB'] = false
		end
		
		if Player:HasCollectible(CustomCollectibles.CEILING_WITH_THE_STARS) 
		and not level:IsAscent() then
			for i = 1, 2 do
				local newID = GetUnlockedVanillaCollectible(false, false)
				Player:AddItemWisp(newID, Player.Position, true)
			end

			if Player:HasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
				for i = 1, 3 do
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

	if CustomData.Data then
		RepentancePlusMod.NumTaintedHearts = {
			HEART_BALEFUL = CustomData.Data.TaintedHearts.BALEFUL,
			HEART_EMPTY = CustomData.Data.TaintedHearts.EMPTY,
			HEART_ENIGMA = CustomData.Data.TaintedHearts.ENIGMA,
			HEART_SOILED = CustomData.Data.TaintedHearts.SOILED,
			HEART_MISER = CustomData.Data.TaintedHearts.MISER,
			HEART_ZEALOT = CustomData.Data.TaintedHearts.ZEALOT,
			HEART_DAUNTLESS = CustomData.Data.TaintedHearts.DAUNTLESS,
		}
	end

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
			local momNDadItem = Isaac.Spawn(5, 100, GetUnlockedCollectibleFromCustomPool(CustomItempools.MOMNDAD), room:FindFreePickupSpawnPosition(Vector(320,280), 1, true, false), Vector.Zero, nil):ToPickup()
			
			momNDadItem.OptionsPickupIndex = 3
			for _, entity in pairs(Isaac.FindByType(5, 100)) do
				entity:ToPickup().OptionsPickupIndex = 3
			end	
		end
		
		if Player:HasCollectible(CustomCollectibles.BLACK_DOLL) and room:IsFirstVisit() and Isaac.CountEnemies() > 1 then
			local sep = math.floor(Isaac.CountEnemies() / 2)
			CustomData.Data.Items.BLACK_DOLL.EntitiesGroupA = {}
			CustomData.Data.Items.BLACK_DOLL.EntitiesGroupB = {}
			local count = 0
			
			for _, entity in pairs(Isaac.GetRoomEntities()) do
				if entity:IsActiveEnemy(false) and not entity:IsBoss() 
				and entity:IsVulnerableEnemy() then
					count = count + 1
					if count <= sep then
						table.insert(CustomData.Data.Items.BLACK_DOLL.EntitiesGroupA, entity)
					else
						table.insert(CustomData.Data.Items.BLACK_DOLL.EntitiesGroupB, entity)
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
								cP = collectible:ToPickup()
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
		
		if CustomData.Data and CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive
		and CustomData.Data.Items.TWO_PLUS_ONE.itemsBought == 0 then
			for _, p in pairs(Isaac.FindByType(5)) do
				p:ToPickup().AutoUpdatePrice = p:ToPickup().Price == 1
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
		
		if Player:GetData()['enhancedBoB'] then				
			Player:GetData()['enhancedBoB'] = false
			Player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
			Player:EvaluateItems()
		end
		
		if Player:GetData()['usedCursedCard'] then 
			Player:GetData()['usedCursedCard'] = false
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
		
		if Player:GetData().JewelData_LUST == "isExtra" then
			Player:GetData().JewelData_LUST = nil
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
				
				local soul = Isaac.Spawn(1000, PureSoul, 0, Vector(400, 280), Vector.Zero, Player)
				soul:GetSprite():Play(sinToAnim[sinType] .. "_" .. sinVariant)
				Player:GetData().PureSoulSin = {sinType, sinVariant}
			end
			
			for i = 0, 7 do
				if room:GetDoor(i) and room:GetDoor(i).TargetRoomType == RoomType.ROOM_MINIBOSS then
					local soul = Isaac.Spawn(1000, PureSoul, 1, room:GetDoorSlotPosition(i), Vector.Zero, Player)
					local index = room:GetDoor(i).TargetRoomIndex
					local targetRoom = level:GetRoomByIdx(index, -1)
					local spawns = targetRoom.Data.Spawns
					
					for n = 0, #spawns - 1 do
						local entry = spawns:Get(n):PickEntry(0)
						
						if sinToAnim[entry.Type] then soul:GetSprite():Play(sinToAnim[entry.Type] .. "_" .. entry.Variant) end
					end
					
				end
			end
		end
		
		if Player:HasCollectible(CustomCollectibles.BOOK_OF_JUDGES) then
			CustomData.Data.Items.BOOK_OF_JUDGES.NoBeams = false

			if room:IsFirstVisit() and not room:IsClear() then
				makeLightbeams(room)
			end
		end

		if Player:HasCollectible(CustomCollectibles.CEILING_WITH_THE_STARS)
		and level:IsAscent() and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex() 
		and room:IsFirstVisit() then
			local newID = GetUnlockedVanillaCollectible(false, false)
			Player:AddItemWisp(newID, Player.Position, true)
		end
	end
	
	if CustomData.Data then
		-- handle red crawlspaces spawned by Red King item
		for _, r in pairs(Isaac.FindByType(6, 334, -1, false, false)) do
			if r.SubType == 0 then
				for i, v in pairs(CustomData.Data.Items.RED_KING.redCrawlspacesData) do
					if r.InitSeed == v.seed and v.isRoomDefeated then
						r.SubType = 1
						r:GetSprite():Play("Closed")
						r.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						r.DepthOffset = 10
					end
				end
			else
				r:GetSprite():Play("Closed")
				r.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			end
		end
		
		-- handle Vault of Havoc rooms
		if CustomData.Data.Items.VAULT_OF_HAVOC.Data then  
			-- turning placeholders (black flies) from BR into stored enemies
			for i, placeholder in pairs(Isaac.FindByType(13, 0, 0, false, false)) do
				placeholder:Remove()
				local enemyID = #CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList - i + 1
				if enemyID > 0 then
					local enemy = CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList[enemyID]
					Isaac.Spawn(enemy.Type, enemy.Variant, enemy.SubType, placeholder.Position, Vector.Zero, nil)
					CustomData.Data.Items.VAULT_OF_HAVOC.SumHP = CustomData.Data.Items.VAULT_OF_HAVOC.SumHP + enemy.MaxHitPoints
				end
			end
			
			CustomData.Data.Items.VAULT_OF_HAVOC.EnemiesSpawned = true
			CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList = {}
		elseif CustomData.Data.Items.VAULT_OF_HAVOC.EnemiesSpawned then
			CustomData.Data.Items.VAULT_OF_HAVOC.Data = false 
			CustomData.Data.Items.VAULT_OF_HAVOC.SumHP = 0
			CustomData.Data.Items.VAULT_OF_HAVOC.EnemiesSpawned = false 
		end
	end
	
	-- handle turning placeholders (Rules Cards) from BR into modded pickups
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

	
	-- handle bloody rocks placement
	if level:GetStage() ~= LevelStage.STAGE7 then
		-- setting the variant
		for ind = 1, room:GetGridSize() do
			local gridEnt = room:GetGridEntity(ind)
			
			if gridEnt and gridEnt:GetType() == GridEntityType.GRID_ROCK_SPIKED then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 100
				
				if roll < BLOODYROCKS_REPLACE_CHANCE and room:IsFirstVisit()
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
	
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		local sprite = Player:GetSprite()
		
		-- it turns out that more and more items 
		-- behave in unintentional ways together, 
		-- so let's BLACKLIST THEM HERE ---------
		-----------------------------------------
		
		-- there's just no nice synergy yet, it looks wacky
		blacklistCollectibles(Player, CustomCollectibles.RED_BOMBER, CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)
		
		-- some differently colored pills have same effects with PHD/False PHD, and since MC_USE_PILL asks for pill effect, there's no way to
		-- tell them apart and apply the DNA Redactor effect correctly
		blacklistCollectibles(Player, CustomCollectibles.DNA_REDACTOR, {CollectibleType.COLLECTIBLE_PHD, CollectibleType.COLLECTIBLE_FALSE_PHD,
																		CollectibleType.COLLECTIBLE_VIRGO, CollectibleType.COLLECTIBLE_LUCKY_FOOT})
		
		-- Mom's Knife and Spirit Sword have like... no difference in code, so while we added Knife synergy, Sword looks severely hurt from that
		-- plus we don't have the Sword resprite for a synergy
		blacklistCollectibles(Player, CustomCollectibles.CEREMONIAL_BLADE, CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
		
		-- Satanic Bible + Torn Page override MC_PRE_SPAWN_CLEAN_AWARD, so no red crawlspace will spawn
		-- might seem like a bit of an overkill but it's better this way
		blacklistCollectibles(Player, CustomCollectibles.RED_KING, CollectibleType.COLLECTIBLE_SATANIC_BIBLE)

		-- pretty self explanatory, you can't rewind your mod's code with this lol
		blacklistCollectibles(Player, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, {CustomCollectibles.COOKIE_CUTTER, CustomCollectibles.SCALPEL,
																					   CustomCollectibles.CHEESE_GRATER, CustomCollectibles.BIRD_OF_HOPE})
		-----------------------------------------
		
		-- handle temporary dmg boosts
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
		
		-- handle reviving players
		if isPlayerDying(Player) and not Player:WillPlayerRevive() then
			if Player:HasCollectible(CustomCollectibles.BIRD_OF_HOPE) then
				if not CustomData.Data.Items.BIRD_OF_HOPE.dieFrame then
					CustomData.Data.Items.BIRD_OF_HOPE.numRevivals = CustomData.Data.Items.BIRD_OF_HOPE.numRevivals + 1
					CustomData.Data.Items.BIRD_OF_HOPE.dieFrame = game:GetFrameCount()
					CustomData.Data.Items.BIRD_OF_HOPE.diePos = Player.Position
					CustomData.Data.Items.BIRD_OF_HOPE.catchingBird = true
					CustomData.Data.Items.BIRD_OF_HOPE.birdCaught = false
					reviveWithTwin(Player)
					sprite:Stop()
					Player:AddCacheFlags(CacheFlag.CACHE_FLYING)
					Player:EvaluateItems()
					Player:AddNullCostume(Costumes.BIRD_OF_HOPE)
					
					local Birb = Isaac.Spawn(3, CustomFamiliars.BIRD, 0, room:GetCenterPos(), Vector.FromAngle(math.random(360)) * CustomData.Data.Items.BIRD_OF_HOPE.numRevivals, Player) 
					Birb:GetSprite():Play("Flying")
				end
			end
			
			if Player:HasTrinket(CustomTrinkets.ADAMS_RIB) then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 100
				
				if roll < 22 then
					-- golden trinket
					if Player:GetTrinketMultiplier(CustomTrinkets.ADAMS_RIB) > 1 then
						SilentUseCard(Player, Card.CARD_SOUL_EVE)
					end
					
					reviveWithTwin(Player)
					Player:ChangePlayerType(PlayerType.PLAYER_EVE)
					Player:AddMaxHearts(4 - Player:GetMaxHearts())
					for _, startingItem in pairs({CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON, CollectibleType.COLLECTIBLE_DEAD_BIRD}) do
						if not Player:HasCollectible(startingItem) then Player:AddCollectible(startingItem) end
					end
				end
			end
			
			if Player:HasCollectible(CustomCollectibles.MARK_OF_CAIN) 
			and not Player:GetEffects():HasCollectibleEffect(CustomCollectibles.MARK_OF_CAIN) then
				local PlayerFamiliars = {}
				
				for i = 1, 1000 do
					if Isaac.GetItemConfig():GetCollectible(i) and Isaac.GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_FAMILIAR 
					and i ~= CustomCollectibles.MARK_OF_CAIN and Player:HasCollectible(i) then
						for j = 1, Player:GetCollectibleNum(i, true) do table.insert(PlayerFamiliars, i) end
					end
				end
				
				if #PlayerFamiliars > 0 then
					-- reviving the Player and making Enoch tainted
					reviveWithTwin(Player)
					
					Player:GetEffects():AddCollectibleEffect(CustomCollectibles.MARK_OF_CAIN)
					sfx:Play(SoundEffect.SOUND_SUPERHOLY)
					for _, enoch in pairs(Isaac.FindByType(3, CustomFamiliars.ENOCH, -1, false, false)) do enoch:Remove() end 
					
					for i = 1, #PlayerFamiliars do Player:RemoveCollectible(PlayerFamiliars[i]) end
				end
			end
			
			if i == 0 and CustomData.Data.TaintedHearts.ENIGMA > 0 then
				reviveWithTwin(Player)
				Player:AddHearts(4 * (CustomData.Data.TaintedHearts.ENIGMA - 1))
				sfx:Play(SoundEffect.SOUND_SUPERHOLY)
				CustomData.Data.TaintedHearts.ENIGMA = 0
			end
		end

		-- Bird of Hope dying part
		if CustomData.Data and CustomData.Data.Items.BIRD_OF_HOPE.dieFrame and game:GetFrameCount() > CustomData.Data.Items.BIRD_OF_HOPE.dieFrame + 150
		and not CustomData.Data.Items.BIRD_OF_HOPE.birdCaught then
			Player:Die()
		end

		-- COUNTDOWNS FOR PILLS
		if Player:GetData().yuckDuration and Player:GetData().yuckDuration > 0 then
			Player:GetData().yuckDuration = Player:GetData().yuckDuration - 1
		elseif Player:GetData().yumDuration and Player:GetData().yumDuration > 0 then
			Player:GetData().yumDuration = Player:GetData().yumDuration - 1
		elseif Player:GetData().phantomPainsDuration and Player:GetData().phantomPainsDuration > 0 then
			Player:GetData().phantomPainsDuration = Player:GetData().phantomPainsDuration - 1
		elseif Player:GetData().laxativeDuration and Player:GetData().laxativeDuration > 0 then
			Player:GetData().laxativeDuration = Player:GetData().laxativeDuration - 1
		end
		
		if Player:GetData()['reverseCardRoom'] and Player:GetData()['reverseCardRoom'] ~= game:GetLevel():GetCurrentRoomIndex() then
			Player:AnimateCard(CustomConsumables.UNO_REVERSE_CARD, "Pickup")
			for i = 0, 1 do
				if Player:GetCard(i) == CustomConsumables.UNO_REVERSE_CARD then Player:SetCard(i, 0) end
			end
			Player:GetData()['reverseCardRoom'] = nil
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
				Powder:Update()
			end
		end
		
		if CustomData.Data then
			if CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive then
				for _, entity in pairs(Isaac.FindByType(5)) do
					local entityPickup = entity:ToPickup()

					if entityPickup.Price > 0 and CustomData.Data.Items.TWO_PLUS_ONE.itemsBought == 2 then
						entityPickup.Price = 1
						entityPickup.AutoUpdatePrice = false
					end
				end
			elseif Player:HasCollectible(CustomCollectibles.TWO_PLUS_ONE) then
				CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive = true
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
			if CustomData.Data.Items.MOTHERS_LOVE.NumFriends ~= #Isaac.FindByType(3, -1, -1, false, false) then
				CustomData.Data.Items.MOTHERS_LOVE.NumStats = 0
				if #Isaac.FindByType(3, -1, -1, false, false) > 0 then
					for _, friend in pairs(Isaac.FindByType(3, -1, -1, false, false)) do
						local LoveStatMulGiven = getMothersLoveStatBoost(friend.Variant)
						
						CustomData.Data.Items.MOTHERS_LOVE.NumStats = CustomData.Data.Items.MOTHERS_LOVE.NumStats + LoveStatMulGiven
					end
				end
				Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_RANGE)
				Player:EvaluateItems()
				
				CustomData.Data.Items.MOTHERS_LOVE.NumFriends = #Isaac.FindByType(3, -1, -1, false, false)
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
		and game:GetFrameCount() % SIBLING_STATE_SWITCH_COOLDOWN == 0 then
			local d = Player:GetData()['fightingSiblings']
			if d == false or type(d) == 'nil' then 
				d = true 
				sfx:Play(SoundEffect.SOUND_CHILD_ANGRY_ROAR)
			else 
				d = false 
			end
			Player:GetData()['fightingSiblings'] = d
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
		and not CustomData.Data.Items.RED_MAP.ShownOnFloorOne then
			local USR = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, true, RNG(), true))
			
			if USR.Data and USR.Data.Type == RoomType.ROOM_ULTRASECRET and USR.DisplayFlags & 1 << 2 == 0 then
				USR.DisplayFlags = USR.DisplayFlags | 1 << 2
				level:UpdateVisibility()
			end
			CustomData.Data.Items.RED_MAP.ShownOnFloorOne = true
		end

		-- balancing the amount of active (main) and passive (technical) Rejection items
		if Player:GetCollectibleNum(CustomCollectibles.REJECTION) > Player:GetCollectibleNum(CustomCollectibles.REJECTION_P) then
			Player:AddCollectible(CustomCollectibles.REJECTION_P)
		elseif Player:GetCollectibleNum(CustomCollectibles.REJECTION) < Player:GetCollectibleNum(CustomCollectibles.REJECTION_P) then
			Player:RemoveCollectible(CustomCollectibles.REJECTION_P)
		end
		
		if Player:HasCollectible(CustomCollectibles.MAGIC_MARKER) and not CustomData.Data.Items.MAGIC_MARKER.CardDrop then
			CustomData.Data.Items.MAGIC_MARKER.CardDrop = true
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomInt(22) + 1
			local isReversed = rng:RandomInt(2) * 55		-- normal Fool is CARD 1, reversed Fool? is CARD 56
			
			Isaac.Spawn(5, 300, roll + isReversed, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, Player)
		end
		
		if Player:HasCollectible(CustomCollectibles.PURE_SOUL) and Player:GetData().PureSoulSin then
			for _, ps in pairs(Isaac.FindByType(1000, 777, 0)) do
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
		
		if Player:HasCollectible(CustomCollectibles.BOOK_OF_JUDGES) and not CustomData.Data.Items.BOOK_OF_JUDGES.NoBeams 
		and #Isaac.FindByType(1000, EffectVariant.TARGET, 3) > 0 and not room:IsClear() 
		and room:GetFrameCount() % 90 == 45 then
			local isChal = Isaac.GetChallenge() == CustomChallenges.JUDGEMENT
			for _, pos in pairs(CustomData.Data.Items.BOOK_OF_JUDGES.BeamTargets) do
				
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, pos, Vector.Zero, isChal and Player or nil)
				for _, enemy in pairs(Isaac.FindInRadius(pos, 25, EntityPartition.ENEMY)) do
					local burnMult = Player:HasTrinket(CustomTrinkets.TORN_PAGE) and 2 or 1
					if isChal then burnMult = burnMult * Player.Damage / 3.5 end
					
					enemy:AddBurn(EntityRef(Player), math.floor(45 * burnMult), 3.5 * burnMult)
				end
			end

			-- generating new crosshairs
			makeLightbeams(room)
		end
		
		if Player:GetData()['GluttonyRegen'] then 
			if Player:GetData()['GluttonyRegen'].regen
			and game:GetFrameCount() % 30 == 0 then
				Player:GetData()['GluttonyRegen'].duration = Player:GetData()['GluttonyRegen'].duration - 1
				if Player:CanPickRedHearts() then
					Player:AddHearts(1)
					sfx:Play(SoundEffect.SOUND_VAMP_GULP)
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, Player.Position + Vector(10,10), Vector.Zero, Player)
					
					Player:GetData()['GluttonyRegen'].amount = Player:GetData()['GluttonyRegen'].amount + 0.01
				end
				
				if Player:GetData()['GluttonyRegen'].duration <= 0 then Player:GetData()['GluttonyRegen'].regen = false end
				Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				Player:EvaluateItems()
			end
		end
		
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
		
		-- TAINTED HEARTS
		if CustomData.Data and i == 0 then 
			if CustomData.Data.TaintedHearts.HEART_RENDER_FRAME > 0 and game:GetFrameCount() == CustomData.Data.TaintedHearts.HEART_RENDER_FRAME + 1 then 
				for j = 1, CustomData.Data.TaintedHearts.ZEALOT do
					newID = GetUnlockedVanillaCollectible(false, false)
					Player:AddItemWisp(newID, Player.Position, true)
				end
				
				for j = 1, CustomData.Data.TaintedHearts.EMPTY do
					-- Abyss Locusts of any subtype greater than 0 don't disappear when the Player's familiar cache is re-evaluated
					-- ???
					local locust = Isaac.Spawn(3, FamiliarVariant.ABYSS_LOCUST, 77, Player.Position, Vector.Zero, Player):ToFamiliar()
				end
				
				CustomData.Data.TaintedHearts.HEART_RENDER_FRAME = 0
			end
			
			if CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME > 0 and game:GetFrameCount() > CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME + 1 then
				CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME = 0
			end
			
			-- Baleful heart main effect
			if CustomData.Data.TaintedHearts.BALEFUL > 0 then
				for _, enemy in pairs(Isaac.FindInRadius(Player.Position, (CustomData.Data.TaintedHearts.BALEFUL + 1) * 50, EntityPartition.ENEMY)) do
					if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false) 
					and (not Player:GetData().ghostSpawnCountdown or Player:GetData().ghostSpawnCountdown <= 0) then
						local ghost = Isaac.Spawn(1000, 189, 1, Player.Position, Vector.Zero, Player)
						ghost.CollisionDamage = CustomData.Data.TaintedHearts.BALEFUL * (Player.Damage / 1.5)
						Player:GetData().ghostSpawnCountdown = 90
					elseif Player:GetData().ghostSpawnCountdown then
						Player:GetData().ghostSpawnCountdown = Player:GetData().ghostSpawnCountdown - 1
					end
				end
			end
			
			-- Soiled heart check
			if CustomData.Data.TaintedHearts.SOILED > 0 then
				if Player:GetMaxHearts() == 0 then
					CustomData.Data.TaintedHearts.SOILED = 0 
				end
			end
		end
	end

	-- I don't even want to explain it
	if hiddenChest then
		hiddenChest.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

		if #Isaac.FindByType(1000, EffectVariant.MR_ME) == 0 then
			hiddenChest:Remove()
		end
	end
	
	-- stargazer
	for _, sg in pairs(Isaac.FindByType(6, CustomPickups.SLOT_STARGAZER, -1, false, false)) do
		if not isMarkUnlocked("Special", "Stargazer") then
			Isaac.Spawn(6, 3, 0, sg.Position, Vector.Zero, nil)
			sg:Remove()
		else
			local SGSprite = sg:GetSprite()
			
			if SGSprite:IsFinished("PayPrize") then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 100
				
				if roll * (sg:GetData().isBetterPayout and 2 or 1) <= STARGAZER_PAYOUT_CHANCE then
					SGSprite:Play("Teleport")
				else
					SGSprite:Play("Prize")
				end
			elseif SGSprite:IsFinished("Teleport") then
				sg:Remove()
			elseif SGSprite:IsFinished("Prize") then
				SGSprite:Play("Idle")
			end
			
			if SGSprite:IsPlaying("Teleport") and SGSprite:IsEventTriggered("Disappear") then
				repeat
					newID = GetUnlockedVanillaCollectible(true, true)
				until Isaac.GetItemConfig():GetCollectible(colResult).Tags & ItemConfig.TAG_STARS == ItemConfig.TAG_STARS
				Isaac.Spawn(5, 100, newID, Isaac.GetFreeNearPosition(Vector(sg.Position.X, sg.Position.Y + 40), 40), Vector.Zero, nil)
				sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
			end
			
			if SGSprite:IsPlaying("Prize") and SGSprite:IsEventTriggered("Prize") then
				rng:SetSeed(Random() + 1, 1)
				local Rune = rng:RandomInt(9) + 32
				Isaac.Spawn(5, 300, Rune, sg.Position, Vector.FromAngle(math.random(360)) * 5, nil)
				sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
			end
		end
	end
	
	-- bloody rocks
	for ind = 1, room:GetGridSize() do
		local gridEnt = room:GetGridEntity(ind)
		
		if gridEnt and gridEnt:GetType() == GridEntityType.GRID_ROCK_SPIKED and gridEnt:GetVariant() == 2
		and gridEnt.State == 2 and gridEnt.VarData == 0 then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100
			
			for i, v in pairs(DropTables.BLOODYROCKS) do
				if roll < DropTables.BLOODYROCKS[i][1] then
					for x, y in pairs(DropTables.BLOODYROCKS[i][2]) do
						Isaac.Spawn(5, y[1], y[2], gridEnt.Position, Vector.FromAngle(math.random(360)) * 3, Pickup)
					end
					break
				end
			end
			
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
			if rng:RandomFloat() * 100 < SOUL_BOND_HEARTDROP_CHANCE then 
				Isaac.Spawn(5, 10, HeartSubType.HEART_SOUL, t.Position, Vector.Zero, nil) 
			end
		-- breaking the chain if you get too far away from enemy or if the boss is chained for longer than 5 seconds
		elseif math.abs((chain.Parent.Position - t.Position):Length()) > 350 
		or (t and chain.Target:IsBoss() and game:GetFrameCount() >= t:GetData()['chainedOnFrame'] + 150) then
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
function rplus:OnItemUse(ItemUsed, _, Player, UseFlags, Slot, _)
	local level = game:GetLevel()
	local room = game:GetRoom()
	
	--[[ VANILLA ]]
	-- Genesis needs to remove all Tainted hearts Player has
	if ItemUsed == CollectibleType.COLLECTIBLE_GENESIS then
		CustomData.Data.TaintedHearts.EMPTY = 0
		CustomData.Data.TaintedHearts.ZEALOT = 0
		CustomData.Data.TaintedHearts.DAUNTLESS = 0
		CustomData.Data.TaintedHearts.ENIGMA = 0
		CustomData.Data.TaintedHearts.MISER = 0
		CustomData.Data.TaintedHearts.BALEFUL = 0
	end
	
	-- Crooked Penny 
	if ItemUsed == CollectibleType.COLLECTIBLE_CROOKED_PENNY or
	ItemUsed == CollectibleType.COLLECTIBLE_DIPLOPIA then
		CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME = game:GetFrameCount()
	end
	
	if Player:HasTrinket(CustomTrinkets.TORN_PAGE) and UseFlags & UseFlag.USE_OWNED == UseFlag.USE_OWNED then
		-- Bible removes one broken heart
		if ItemUsed == CollectibleType.COLLECTIBLE_BIBLE then
			Player:AddBrokenHearts(-2)
		
		-- Book of the Dead gives you a bone heart
		elseif ItemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD then
			Player:AddBoneHearts(1)
		
		-- Book of Belial also grants eye of belial effect for the room
		elseif ItemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL then
			Player:GetData()['enhancedBoB'] = true
			Player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
			Player:EvaluateItems()		
		
		-- Telepathy for Dummies also grants dunce cap effect for the room
		elseif ItemUsed == CollectibleType.COLLECTIBLE_TELEPATHY_BOOK then
			Player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_THE_WIZ, true, 1)
		
		-- Necronomicon spawns 3 locusts of death on use
		elseif ItemUsed == CollectibleType.COLLECTIBLE_NECRONOMICON then
			for i = 1, 3 do
				Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_DEATH, Player.Position, Vector.Zero, Player)
			end
		
		-- Book of Shadows has extended shield duration
		elseif ItemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS then
			SilentUseCard(Player, Card.RUNE_ALGIZ)
		
		-- Book of Secrets & Monster Manual get 2 charges back when used
		elseif ItemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS 
		or ItemUsed == CollectibleType.COLLECTIBLE_MONSTER_MANUAL then
			Player:SetActiveCharge(Player:GetActiveCharge(Slot) + 2, Slot)
		
		-- Satanic Bible gives you 2 devil deals to choose from
		elseif ItemUsed == CollectibleType.COLLECTIBLE_SATANIC_BIBLE then
			Player:GetData()['enhancedSB'] = true
			
		elseif ItemUsed == CollectibleType.COLLECTIBLE_LEMEGETON then
			Player:GetData()['usedLem'] = true
		end
	end
	--[[ VANILLA END ]]
	
	if ItemUsed == CustomCollectibles.COOKIE_CUTTER then
		Player:AddMaxHearts(2, true)
		Player:AddHearts(4)
		Player:AddBrokenHearts(1)
		sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN)
		if Player:GetBrokenHearts() >= 12 then
			Player:Die()
		end
		
		return {Discharge = true, Remove = false, ShowAnim = true}
	end
	
	if ItemUsed == CustomCollectibles.CHEESE_GRATER then
		if Player:GetMaxHearts() > 0 then
			Player:AddMaxHearts(-2, false)
			if Player:GetEffectiveMaxHearts() + Player:GetSoulHearts() == 0 then
				Player:Die()
			end
			
			for i = 1, 3 do
				Player:AddMinisaac(Player.Position, true)
			end
			sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN)
			Player:GetEffects():AddCollectibleEffect(CustomCollectibles.CHEESE_GRATER)
			Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			Player:EvaluateItems()
			
			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = false}
		end
	end
	
	if ItemUsed == CustomCollectibles.RUBIKS_CUBE 
	and UseFlags & (UseFlag.USE_OWNED | UseFlag.USE_CARBATTERY | UseFlag.USE_VOID) > 0 then
		rng:SetSeed(Random() + 1, 1)
		local solveChance = rng:RandomFloat() * 100
		
		if solveChance < 5 or CustomData.Data.Items.RUBIKS_CUBE.Counter == 20 then
			if UseFlags & UseFlag.USE_VOID == 0 then
				Player:RemoveCollectible(CustomCollectibles.RUBIKS_CUBE, true, ActiveSlot.SLOT_PRIMARY, true)
				Player:AddCollectible(CustomCollectibles.MAGIC_CUBE, 4, true, ActiveSlot.SLOT_PRIMARY, 0)
			end

			Player:AnimateHappy()
			CustomData.Data.Items.RUBIKS_CUBE.Counter = 0
			return false
		else
			CustomData.Data.Items.RUBIKS_CUBE.Counter = CustomData.Data.Items.RUBIKS_CUBE.Counter + 1
			return true
		end
	end
	
	if ItemUsed == CustomCollectibles.MAGIC_CUBE then
		for _, entity in pairs(Isaac.FindByType(5, 100, -1)) do
			if entity.SubType > 0 then
				entity:ToPickup():Morph(5, 100, GetUnlockedVanillaCollectible(true, true), true, false, true)
			end
		end
		
		return {Discharge = true, Remove = false, ShowAnim = true}
	end
	
	if ItemUsed == CustomCollectibles.QUASAR 
	and UseFlags & UseFlag.USE_CARBATTERY ~= UseFlag.USE_CARBATTERY then
		properQuasarUse(Player)
		return {Discharge = true, Remove = false, ShowAnim = true}
	end
	
	if ItemUsed == CustomCollectibles.TOWER_OF_BABEL then
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
	
	if ItemUsed == CustomCollectibles.BOOK_OF_GENESIS then 
		local freezePreventChecker = 0
		local ID
		local newID
		
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
				repeat 
					newID = GetUnlockedVanillaCollectible(true, false)
				until Isaac.GetItemConfig():GetCollectible(newID).Quality == Q
				
				local bookOfGenesisItem = Isaac.Spawn(5, 100, newID, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil):ToPickup()
				bookOfGenesisItem.OptionsPickupIndex = 6
			end

			return {Discharge = true, Remove = false, ShowAnim = false}
		else 
			return {Discharge = false, Remove = false, ShowAnim = false}
		end
	end
	
	if ItemUsed == CustomCollectibles.BLOOD_VESSELS[7] and Player:GetDamageCooldown() <= 0 then
		CustomData.Data.Items.BLOODVESSEL.DamageFlag = true
		local h = math.min(5, Player:GetHearts())
		Player:AddHearts(-h)
		Player:TakeDamage(6 - h, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 18)
		Player:RemoveCollectible(ItemUsed)
		Player:AddCollectible(CustomCollectibles.BLOOD_VESSELS[1])
		CustomData.Data.Items.BLOODVESSEL.DamageFlag = false
	end
	
	if Player:HasTrinket(CustomTrinkets.EMPTY_PAGE) then
		if Isaac.GetItemConfig():GetCollectible(ItemUsed).Tags & ItemConfig.TAG_BOOK == ItemConfig.TAG_BOOK
		and UseFlags & UseFlag.USE_OWNED == UseFlag.USE_OWNED then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100
			
			if roll < 4 ^ Isaac.GetItemConfig():GetCollectible(ItemUsed).MaxCharges then
				--[[
					1% for 0 charges (How to Jump)
					16% for 2 charges (Telepathy for Dummies)
					64% for 3 charges (Book of Shadows)
					100% for 4+ charges
				]]
				for i = 1, Player:GetTrinketMultiplier(CustomTrinkets.EMPTY_PAGE) do
					Player:UseActiveItem(CustomItempools.EMPTYPAGEACTIVES[math.random(#CustomItempools.EMPTYPAGEACTIVES)], UseFlag.USE_NOANIM, -1)
				end
			end
		end
	end
	
	if ItemUsed == CustomCollectibles.STARGAZERS_HAT then
		Player:AnimateCollectible(ItemUsed, "UseItem", "PlayerPickupSparkle")
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
		Isaac.Spawn(6, CustomPickups.SLOT_STARGAZER, 0, Isaac.GetFreeNearPosition(Player.Position, 40), Vector.Zero, Player)
		CustomData.Data.Items.STARGAZERS_HAT.UsedOnFloor = true
	end
	
	if ItemUsed == CustomCollectibles.BOTTOMLESS_BAG then
		Player:GetData().BOTTOMLESS_BAG = {
			usedBag = true,
			frame = game:GetFrameCount(),
			data = true,
			tearsCollected = 0
		}
		Player:AnimateCollectible(CustomCollectibles.BOTTOMLESS_BAG_OPENED, "LiftItem", "PlayerPickupSparkle")
	end
	
	if ItemUsed == CustomCollectibles.REJECTION then
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
	
	if ItemUsed == CustomCollectibles.AUCTION_GAVEL then
		Player:AnimateCollectible(ItemUsed, "UseItem", "PlayerPickupSparkle")
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
		local auctionCollectible = Isaac.Spawn(5, 100, GetUnlockedVanillaCollectible(false), Isaac.GetFreeNearPosition(Player.Position, 40), Vector.Zero, Player):ToPickup()
		auctionCollectible.AutoUpdatePrice = false
		auctionCollectible.Price = Player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) and 10 or 22
		auctionCollectible.ShopItemId = -321
		auctionCollectible:GetData().Data = Player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) and "sale price" or "normal price"
	end
	
	if ItemUsed == CustomCollectibles.SOUL_BOND then
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
			astralChain.Target:GetData()['isChainedToPlayer'] = true
			if astralChain.Target:IsBoss() then astralChain.Target:GetData()['chainedOnFrame'] = game:GetFrameCount() end
			
			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = false}
		end
	end
	
	if ItemUsed == CustomCollectibles.BOOK_OF_LEVIATHAN then
		if not room:IsClear()
		and (Player:GetNumKeys() > 0 or Player:HasGoldenKey() or Player:HasTrinket(CustomTrinkets.TORN_PAGE)) then
			if not Player:HasGoldenKey() and not Player:HasTrinket(CustomTrinkets.TORN_PAGE) then Player:AddKeys(-1) end
			rng:SetSeed(Random() + 1, 1)
			
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
						enemy:AddEntityFlags(Flags[math.random(#Flags)])
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
			
			return {Discharge = true, Remove = false, ShowAnim = true}
		else
			return {Discharge = false, Remove = false, ShowAnim = true}
		end
	end
	
	if ItemUsed == CustomCollectibles.MAGIC_MARKER then
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
		else																		-- WIP (runes, soulstones, playing cards and objects)
			return {Discharge = false, Remove = false, ShowAnim = false}
		end
	end
	
	if ItemUsed == CustomCollectibles.VAULT_OF_HAVOC then  
		if #CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList >= 12 then 
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomInt(5) + 1
			
			Isaac.ExecuteCommand("goto s.miniboss." .. roll + 55000)
			CustomData.Data.Items.VAULT_OF_HAVOC.Data = true
			return {Discharge = true, Remove = false, ShowAnim = true} 
		else
			return {Discharge = false, Remove = false, ShowAnim = true}
		end  
	end
	
	if ItemUsed == CustomCollectibles.HANDICAPPED_PLACARD then
		if not hasActiveChallenge(room) then
			return {Discharge = false, Remove = false, ShowAnim = true}
		else
			local placard = Isaac.Spawn(3, CustomFamiliars.HANDICAPPED_PLACARD, 0, Player.Position, Vector.Zero, Player)
			placard:GetData().area = 1 + (Player:GetEffectiveMaxHearts() - Player:GetHearts()) * 0.1
			local eff = Isaac.Spawn(1000, PlacardBorder, 0, placard.Position, Vector.Zero, placard):ToEffect()
			print(placard:GetData().area)
			eff.SpriteScale = Vector(placard:GetData().area * 2.75, placard:GetData().area * 2.75)
		end
	end
	
	if ItemUsed == CustomCollectibles.BOOK_OF_JUDGES then
		CustomData.Data.Items.BOOK_OF_JUDGES.NoBeams = true
		return {Discharge = true, Remove = false, ShowAnim = true}
	end
	
	if ItemUsed == CustomCollectibles.BIRTH_CERTIFICATE then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER)
		Isaac.ExecuteCommand("goto s.supersecret.890")
		return {Discharge = true, Remove = true, ShowAnim = false}
	end
	
	if ItemUsed == CustomCollectibles.SCALPEL 
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
end
rplus:AddCallback(ModCallbacks.MC_USE_ITEM, rplus.OnItemUse)

function rplus:OnCardUse(CardUsed, Player, _)	
	local room = game:GetRoom()
	--[[ VANILLA ]]
		-- opening Scarlet chests via Soul of Cain
		if CardUsed == Card.CARD_SOUL_CAIN then
			for _, chest in pairs(Isaac.FindByType(5, CustomPickups.SCARLET_CHEST, -1, false, false)) do
				if chest.SubType == 0 or chest.SubType == 2 then
					openScarletChest(chest)
				end
			end
		end
		
		-- backwards compatibility for Berkano Rune
		if CardUsed == Card.RUNE_BERKANO and not FLAG_FAKE_POPUP_PAUSE and not GiantBookAPI then
			LeviathanGiantBookAnim:Load("gfx/ui/giantbook/giantbook.anm2", true)
			LeviathanGiantBookAnim:ReplaceSpritesheet(0, "gfx/ui/giantbook/Rune_07_Berkand.png")
			LeviathanGiantBookAnim:LoadGraphics()
			LeviathanGiantBookAnim:Play("Appear", true)
			animLength = 33
		end

		-- some cards must not spawn Tainted hearts
		if CardUsed == Card.CARD_LOVERS or CardUsed == Card.CARD_HIEROPHANT or CardUsed == Card.CARD_REVERSE_HIEROPHANT
		or CardUsed == Card.RUNE_JERA or CardUsed == Card.CARD_REVERSE_FOOL or CardUsed == Card.QUEEN_OF_HEARTS then
			CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME = game:GetFrameCount()
		end
	--[[ VANILLA END ]]

	if CardUsed == CustomConsumables.JOKER_Q then
		game:StartRoomTransition(-6, -1, RoomTransitionAnim.TELEPORT, Player, -1)
	end
	
	if CardUsed == CustomConsumables.SPINDOWN_DICE_SHARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_SPINDOWN_DICE, UseFlag.USE_NOANIM, -1)
	end
	
	if CardUsed == CustomConsumables.BUSINESS_CARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, UseFlag.USE_NOANIM, -1)
	end
	
	if CardUsed == CustomConsumables.RED_RUNE then
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
				if math.random(100) <= 50 then
					Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, rng:RandomInt(5) + 1, pos, Vector.Zero, nil)
				end
			end
		end
	end
	
	if CardUsed == CustomConsumables.UNO_REVERSE_CARD then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1)
		Player:GetData()["reverseCardRoom"] = game:GetLevel():GetCurrentRoomIndex()
	end
	
	if CardUsed == CustomConsumables.NEEDLE_AND_THREAD then
		if Player:GetBrokenHearts() > 0 then
			Player:AddBrokenHearts(-1)
			Player:AddMaxHearts(2, true)
			Player:AddHearts(2)
		end
	end
	
	if CardUsed == CustomConsumables.BAG_TISSUE then
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
		local DesiredQuality = math.min(math.floor((SumWeight + 4) / 9), 4)
		local ID
		
		-- trying to get random item with desired quality
		repeat
			ID = GetUnlockedVanillaCollectible(true, false)
		until Isaac.GetItemConfig():GetCollectible(ID).Quality == DesiredQuality
		
		-- spawning the item
		Player:AnimateHappy()
		Isaac.Spawn(5, 100, ID, Isaac.GetFreeNearPosition(Player.Position, 5.0), Vector.Zero, Player)
	end
	
	if CardUsed == CustomConsumables.LOADED_DICE then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.LOADED_DICE_NULL, false, 1)
		
		Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		Player:EvaluateItems()
	end
	
	if CardUsed == CustomConsumables.QUASAR_SHARD then
		for _, entity in pairs(Isaac.FindInRadius(Player.Position, 1000, EntityPartition.ENEMY)) do
			entity:TakeDamage(40, 0, EntityRef(Player), 0)
		end
		
		properQuasarUse(Player)
	end
	
	if CardUsed == CustomConsumables.SACRIFICIAL_BLOOD and CustomData.Data then
		addTemporaryDmgBoost(Player)
		
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES) then 
			Player:AddHearts(2) 
		end
		sfx:Play(SoundEffect.SOUND_VAMP_GULP)
	end
	
	if CardUsed == CustomConsumables.FLY_PAPER then
		for i = 1, 9 do
			Player:AddSwarmFlyOrbital(Player.Position)
		end
	end
	
	if CardUsed == CustomConsumables.LIBRARY_CARD then
		Player:UseActiveItem(game:GetItemPool():GetCollectible(ItemPoolType.POOL_LIBRARY, false, Random() + 1, 0), true, false, true, true, -1)
	end
	
	if CardUsed == CustomConsumables.FUNERAL_SERVICES then
		Isaac.Spawn(5, PickupVariant.PICKUP_OLDCHEST, 0, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil)
	end
	
	if CardUsed == CustomConsumables.MOMS_ID then
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 860, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() then
				local knifeTear = Isaac.Spawn(1000, FallingKnifeHelper, 0, enemy.Position, Vector.Zero, enemy)
				knifeTear:GetData().Damage = Player.Damage * 2
			end
		end
	end
	
	if CardUsed == CustomConsumables.ANTIMATERIAL_CARD then
		local antimaterialCardTear = Isaac.Spawn(2, CustomTearVariants.ANTIMATERIAL_CARD, 0, Player.Position, DIRECTION_VECTOR[Player:GetMovementDirection()]:Resized(10), Player)
		antimaterialCardTear:GetSprite():Play("Rotate")
	end
	
	if CardUsed == CustomConsumables.VALENTINES_CARD then
		local valentinesTear = Isaac.Spawn(2, CustomTearVariants.VALENTINES_CARD, 0, Player.Position, DIRECTION_VECTOR[Player:GetMovementDirection()]:Resized(10), Player)
		valentinesTear:GetSprite():Play("Rotate")
		Isaac.Spawn(5, 10, HeartSubType.HEART_FULL, Player.Position, Vector.Zero, nil)
		sfx:Play(SoundEffect.SOUND_KISS_LIPS1)
	end
	
	if CardUsed == CustomConsumables.DEMON_FORM then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL, false, 1)
	end
	
	if CardUsed == CustomConsumables.FIEND_FIRE then 
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
	end

	if CardUsed == CustomConsumables.SPIRITUAL_RESERVES then
		if not Player:GetData()['usedSpiritualReserves'] then
			Player:GetData()['usedSpiritualReserves'] = {1, 1}
		else
			for i = 1, 2 do Player:GetData()['usedSpiritualReserves'][i] = Player:GetData()['usedSpiritualReserves'][i] + 1 end
		end
		Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
		Player:EvaluateItems()
	end
	
	if CardUsed == CustomConsumables.MIRRORED_LANDSCAPE then
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
	end
	
	if CardUsed == CustomConsumables.CURSED_CARD then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.CURSED_CARD_NULL, false, 1)
		sfx:Play(SoundEffect.SOUND_DEVIL_CARD)
	end
	
	-- Jacks
	if CardUsed == CustomConsumables.JACK_OF_DIAMONDS then
		CustomData.Data.Cards.JACK.Type = "Diamonds"
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_OPTIONS) then CustomData.Data.Cards.JACK.FLAG_OPTIONS_SPECIAL = true end
	elseif CardUsed == CustomConsumables.JACK_OF_CLUBS then
		CustomData.Data.Cards.JACK.Type = "Clubs"
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_OPTIONS) then CustomData.Data.Cards.JACK.FLAG_OPTIONS_SPECIAL = true end
	elseif CardUsed == CustomConsumables.JACK_OF_SPADES then
		CustomData.Data.Cards.JACK.Type = "Spades"
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_OPTIONS) then CustomData.Data.Cards.JACK.FLAG_OPTIONS_SPECIAL = true end
	elseif CardUsed == CustomConsumables.JACK_OF_HEARTS then
		CustomData.Data.Cards.JACK.Type = "Hearts"
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_OPTIONS) then CustomData.Data.Cards.JACK.FLAG_OPTIONS_SPECIAL = true end
	end
	
	-- Kings
	if room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_BOSSRUSH then
		local NumPickups = 0
		
		if CardUsed == CustomConsumables.KING_OF_SPADES then
			sfx:Play(SoundEffect.SOUND_GOLDENKEY)
			NumPickups = math.min(math.floor(Player:GetNumKeys() / 3), 11)
			Player:AddKeys(-math.min(Player:GetNumKeys(), 33))
			if Player:HasGoldenKey() then Player:RemoveGoldenKey() NumPickups = NumPickups + 2 end
		elseif CardUsed == CustomConsumables.KING_OF_CLUBS then
			NumPickups = math.min(math.floor(Player:GetNumBombs() / 3), 11)
			Player:AddBombs(-math.min(Player:GetNumBombs(), 33))
			if Player:HasGoldenBomb() then Player:RemoveGoldenBomb() NumPickups = NumPickups + 2 end
		elseif CardUsed == CustomConsumables.KING_OF_DIAMONDS then
			NumPickups = math.min(math.floor(Player:GetNumCoins() / 6), 11)
			Player:AddCoins(-math.min(Player:GetNumCoins(), 66))
		end
		
		if NumPickups > 0 then
			for i = 1, NumPickups do
				room:SpawnClearAward()
				for _, sewM in pairs(Isaac.FindByType(6)) do
					if sewM.FrameCount == 0 then sewM:Remove() end
				end
			end
			
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100
			
			if roll < 25 * NumPickups then Isaac.Spawn(5, 350, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, Player) end
			if roll < 14 * NumPickups then Isaac.Spawn(5, 100, 0, Player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, Player) end
		end
	end
	
	-- Queens
	if CardUsed == CustomConsumables.QUEEN_OF_DIAMONDS then
		for i = 1, math.random(12) do
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat()
			local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false)
			
			if roll < 0.92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 1, spawnPos, Vector.Zero, nil)
			elseif roll < 0.98 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 2, spawnPos, Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 3, spawnPos, Vector.Zero, nil)
			end
		end
	elseif CardUsed == CustomConsumables.QUEEN_OF_CLUBS then
		for i = 1, math.random(12) do
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat()
			local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false)
			
			if roll < 0.92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, 1, spawnPos, Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, 2, spawnPos, Vector.Zero, nil)
			end
		end
	elseif CardUsed == CustomConsumables.BEDSIDE_QUEEN then		
		for i = 1, math.random(12) do
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat()
			
			if roll < 0.95 then
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 1, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 4, game:GetRoom():FindFreePickupSpawnPosition(Player.Position, 0, true, false), Vector.Zero, nil)
			end
		end
	end
	
	-- Jewels
	if CardUsed == CustomConsumables.CROWN_OF_GREED then
		rng:SetSeed(Random() + 1, 1)
		local roll = rng:RandomInt(2) + 1
		
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.CROWN_OF_GREED_NULL, false, roll)
		
		for i = 1, roll do
			Isaac.Spawn(5, 20, CoinSubType.COIN_GOLDEN, Isaac.GetFreeNearPosition(Player.Position, 20), Vector.Zero, nil)
		end
		Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		Player:EvaluateItems()
	elseif CardUsed == CustomConsumables.FLOWER_OF_LUST then
		Player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, false, false, true, false, -1)
		Player:GetData().JewelData_LUST = "isExtra"
	elseif CardUsed == CustomConsumables.ACID_OF_SLOTH then
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 1500, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false) and not enemy:IsBoss() then
				enemy:AddSlowing(EntityRef(Player), 1000, 0.5, Color(0.08, 0.3, 0.05, 1, 0, 0, 0))
				enemy:GetData().isSpawningCreep = true
			end
		end
	elseif CardUsed == CustomConsumables.VOID_OF_GLUTTONY then
		Player:GetData()['GluttonyRegen'] = {regen = true, amount = 0, duration = 7}
	elseif CardUsed == CustomConsumables.APPLE_OF_PRIDE then
		Player:GetEffects():AddCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_RANGE)
		Player:EvaluateItems()
	elseif CardUsed == CustomConsumables.CANINE_OF_WRATH then
		for _, enemy in pairs(Isaac.FindInRadius(Player.Position, 1500, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false) then
				local bomb = Isaac.Spawn(4, 0, 0, enemy.Position, Vector.Zero, enemy):ToBomb()
				bomb.ExplosionDamage = 15.1
				bomb:SetExplosionCountdown(1)
				bomb.Visible = false
				
				if enemy.HitPoints <= 15 then
					addTemporaryDmgBoost(Player)
				end
			end
		end
	elseif CardUsed == CustomConsumables.MASK_OF_ENVY then
		if Player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER_B and Player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER then
			local hearts = Player:GetMaxHearts()
			local soulhearts = Player:GetSoulHearts()
			Player:AddSoulHearts(-soulhearts)
			Player:AddMaxHearts(-hearts)
			Player:AddBoneHearts(hearts / 2)
			Player:AddRottenHearts(hearts)
			Player:AddSoulHearts(soulhearts)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_CARD, rplus.OnCardUse)

function rplus:OnPillUse(pillEffect, Player, _)
	-- a way to distinguish the "horse-ness" of the pill:
	-- if the Player holds a horse pill in the main slot at the moment of using the pill,
	-- it is most likely a horse pill (thanks API)
	local pillColor = game:GetItemPool():ForceAddPillEffect(pillEffect)
	if Player:GetPill(0) >= 2048 then 
		pillColor = pillColor + 2048 
	end
	
	if pillEffect == CustomPills.ESTROGEN then	-- no horse bonus effects
		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
		local BloodClots = Player:GetHearts() - 2 
		
		Player:AddHearts(-BloodClots)
		for i = 1, BloodClots do
			Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, 0, Player.Position, Vector.Zero, Player)
		end
	end
	
	if pillEffect == CustomPills.LAXATIVE then
		Player:GetData().laxativeDuration = pillColor < 2048 and 90 or 360
		sfx:Play(SoundEffect.SOUND_FART)
		Player:AnimateSad()
	end
	
	if Player:HasCollectible(CustomCollectibles.DNA_REDACTOR) then
		-- I honestly don't want to look at this ever again
		if pillColor % 2048 == PillColor.PILL_BLUE_BLUE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_CLICKER, true, true, false, false, -1)			-- change character
		elseif pillColor == PillColor.PILL_WHITE_BLUE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, true, true, false, false, -1)		-- wavy cap use
		elseif pillColor == PillColor.PILL_WHITE_BLUE + 2048 then
			for n = 1, 4 do
				Player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, true, true, false, false, -1)	-- 4 wavy cap uses
			end
		elseif pillColor % 2048 == PillColor.PILL_ORANGE_ORANGE then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_D100, true, true, false, false, -1)			-- D100 use
		elseif pillColor % 2048 == PillColor.PILL_WHITE_WHITE then
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100
			if roll < 100 - CustomData.Data.Items.DNA_REDACTOR.whitePillUsed * 10 then
				Player:AddPill(pillColor)																		-- the pill replicates itself constantly
			end
			CustomData.Data.Items.DNA_REDACTOR.whitePillUsed = CustomData.Data.Items.DNA_REDACTOR.whitePillUsed + 1
		elseif pillColor % 2048 == PillColor.PILL_REDDOTS_RED then
			Isaac.Explode(Player.Position, Player, 110)														-- explosion
			if pillColor == PillColor.PILL_REDDOTS_RED then
				Player:TakeDamage(1, 0, EntityRef(Player), 30)
			end
		elseif pillColor % 2048 == PillColor.PILL_PINK_RED then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_BERSERK, true, true, false, false, -1)			-- Berserk mode
			if pillColor == PillColor.PILL_PINK_RED + 2048 then
				Player:GetData().isSuperBerserk = true
			end
		elseif pillColor % 2048 == PillColor.PILL_BLUE_CADETBLUE then
			game:StartRoomTransition(-2, -1, RoomTransitionAnim.TELEPORT, Player, -1)						-- teleport to the Error room
		elseif pillColor == PillColor.PILL_YELLOW_ORANGE then
			Player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)												-- discharge your active item
		elseif pillColor == PillColor.PILL_YELLOW_ORANGE + 2048 then
			Player:SetActiveCharge(12, ActiveSlot.SLOT_PRIMARY)
		elseif pillColor % 2048 == PillColor.PILL_ORANGEDOTS_WHITE then
			SilentUseCard(Player, Card.CARD_GET_OUT_OF_JAIL)												-- open all doors
			if pillColor == PillColor.PILL_ORANGEDOTS_WHITE + 2048 then
				SilentUseCard(Player, Card.CARD_SOUL_CAIN)													-- and the red doors too
			end
		elseif pillColor % 2048 == PillColor.PILL_WHITE_AZURE then
			local myPocketItem = Player:GetActiveItem(ActiveSlot.SLOT_POCKET)
			Player:SetPill(0, 0)
			SilentUseCard(Player, Card.CARD_REVERSE_FOOL)													-- reverse Fool (drop all your stuff)
			if myPocketItem ~= 0 then 
				Player:AddCollectible(myPocketItem, 12, false, ActiveSlot.SLOT_POCKET, 0)
			end
			if pillColor == PillColor.PILL_WHITE_AZURE + 2048 then
				SilentUseCard(Player, Card.CARD_JUSTICE)													-- add some more stuff
			end
		elseif pillColor % 2048 == PillColor.PILL_BLACK_YELLOW then
			if pillColor == PillColor.PILL_BLACK_YELLOW + 2048 then
				for i = 1, 3 do
					Isaac.GridSpawn(GridEntityType.GRID_POOP, 3, game:GetRoom():FindFreeTilePosition(Player.Position, 500), true)
				end
			end
			SilentUseCard(Player, Card.CARD_HUMANITY)														-- Card against humanity (shit on the floor)
		elseif pillColor == PillColor.PILL_WHITE_BLACK then
			Isaac.Spawn(5, 350, 0, Player.Position, Vector.Zero, nil)										-- spawn a random trinket
		elseif pillColor == PillColor.PILL_WHITE_BLACK + 2048 then
			Isaac.Spawn(5, 350, TrinketType.TRINKET_GOLDEN_FLAG + math.random(1, 189), Player.Position, Vector.Zero, nil)	
		elseif pillColor == PillColor.PILL_WHITE_YELLOW then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, true, true, false, false, -1)	-- restart the floor
		elseif pillColor == PillColor.PILL_WHITE_YELLOW + 2048 then
			Player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, true, true, false, false, -1)			-- restart the run (R key)
			Player:RemoveCollectible(CustomCollectibles.DNA_REDACTOR)
		end
	end
	
	if pillEffect == CustomPills.PHANTOM_PAINS
	and not isInGhostForm(Player) then
		if pillColor >= 2048 then
			Player:GetData().isHorsePhantomPainsEffect = true	-- taking fake damage will also cause to shoot 8 bone tears in all directions
		end
		Player:GetData().phantomPainsDuration = 902
	end
	
	if pillEffect == CustomPills.YUCK then
		Player:GetData().yuckDuration = pillColor < 2048 and 900 or 1800
		Isaac.Spawn(5, 10, 12, Player.Position, Vector.Zero, nil)
		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
	end
	
	if pillEffect == CustomPills.YUM then
		Player:GetData().yumDuration = pillColor < 2048 and 900 or 1800
		rng:SetSeed(Random() + 1, 1)
		local roll = rng:RandomInt(4) + 2
		for i = 1, roll do
			Isaac.Spawn(5, 10, 2, Isaac.GetFreeNearPosition(Player.Position, 10), Vector.Zero, nil)
		end
		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_PILL, rplus.OnPillUse)

function rplus:PreUseItem(ItemUsed, RNG, Player, UseFlags, ActiveSlot, CustomVarData)
	if Player:HasTrinket(CustomTrinkets.TORN_PAGE) then
		-- Book of Revelations doesn't cause harbingers to spawn
		if ItemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS then
			Player:AddSoulHearts(2)
			Player:AnimateCollectible(ItemUsed, "UseItem", "PlayerPickupSparkle")
			return true
			
		-- Book of Sin has a small chance to spawn an item or a chest instead of a pickup
		elseif ItemUsed == CollectibleType.COLLECTIBLE_BOOK_OF_SIN then
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
				Player:AnimateCollectible(ItemUsed, "UseItem", "PlayerPickupSparkle")
				return true
			end
			
		-- Anarchist Cookbook spawns a golden troll bomb instead
		elseif ItemUsed == CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK then
			Isaac.Spawn(5, 40, 6, game:GetRoom():GetRandomPosition(20), Vector.Zero, Player)
			Player:AnimateCollectible(ItemUsed, "UseItem", "PlayerPickupSparkle")
			return true
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, rplus.PreUseItem)


						-- MC_POST_PLAYER_UPDATE --									
						---------------------------
function rplus:PostPlayerUpdate(Player)
	-- this callback handles inputs, because it rolls in 60 fps, unlike MC_POST_UPDATE, so inputs won't be missed out
	local level = game:GetLevel()
	local room = game:GetRoom()
	
	if Input.IsButtonTriggered(Keyboard.KEY_H, Player.ControllerIndex) and not FLAG_HIDE_ERROR_MESSAGE then
		print('Error message hidden. To see it again, type `show` into the console')
		FLAG_HIDE_ERROR_MESSAGE = true
	end
	
	if FLAG_DISPLAY_UNLOCKS_TIP and game:GetFrameCount() >= 150 
	and (Input.IsButtonTriggered(Keyboard.KEY_E, Player.ControllerIndex) or Input.IsButtonTriggered(Keyboard.KEY_ENTER, Player.ControllerIndex)
	or Input.IsButtonTriggered(Keyboard.KEY_SPACE, Player.ControllerIndex)) then
		FLAG_DISPLAY_UNLOCKS_TIP = false
	end
	
	-- replacing locked items in Player's inventory and removing them from item pool
	for item = CustomCollectibles.ORDINARY_LIFE, CustomCollectibles.SIBLING_RIVALRY do
		if not isChallengeCoreItem(item) and not isPickupUnlocked(100, item) then
			if Player.FrameCount > 1 and Player:HasCollectible(item, true) then
				local newItem = GetUnlockedVanillaCollectible(true, false)
				if Isaac.GetItemConfig():GetCollectible(item).Type == ItemType.ITEM_ACTIVE then
					repeat
						newItem = GetUnlockedVanillaCollectible(true, true)
					until Isaac.GetItemConfig():GetCollectible(newItem).Type == ItemType.ITEM_ACTIVE
				end
				Player:AddCollectible(newItem, 0, true, ActiveSlot.SLOT_PRIMARY, 0)
				print("Inventory item " .. item .. " -> " .. newItem)
				
				Player:RemoveCollectible(item, false, ActiveSlot.SLOT_PRIMARY, true)
			end

			game:GetItemPool():RemoveCollectible(item)
		end
	end
	--
	
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
				-- ITEM DOUBLE TAP MECHANICS HERE
				---------------------------------
				
				-- Enraged Soul
				if Player:HasCollectible(CustomCollectibles.ENRAGED_SOUL) and
				(not Player:GetData().ENRAGED_SOUL_Cooldown or Player:GetData().ENRAGED_SOUL_Cooldown <= 0) then
					local Velocity
					local DashAnim
					if (Player:GetData().ButtonPressed == 4 and not room:IsMirrorWorld()) or (Player:GetData().ButtonPressed == 5 and room:IsMirrorWorld()) then
						Velocity = DIRECTION_VECTOR[Direction.LEFT]
						DashAnim = "DashHoriz"
					elseif (Player:GetData().ButtonPressed == 5 and not room:IsMirrorWorld()) or (Player:GetData().ButtonPressed == 4 and room:IsMirrorWorld()) then
						Velocity = DIRECTION_VECTOR[Direction.RIGHT]
						DashAnim = "DashHoriz"
					elseif Player:GetData().ButtonPressed == 6 then
						Velocity = DIRECTION_VECTOR[Direction.UP]
						DashAnim = "DashUp"
					else
						Velocity = DIRECTION_VECTOR[Direction.DOWN]
						DashAnim = "DashDown"
					end

					local enragedSoul = Isaac.Spawn(3, CustomFamiliars.ENRAGED_SOUL, 0, Player.Position, Velocity * 15, Player)
					enragedSoul.CollisionDamage = 3.5 * (1 + math.sqrt(level:GetStage()))	-- calculacting the Soul's damage
					enragedSoul:GetData().launchRoom = level:GetCurrentRoomIndex()
					
					local SoulSprite = enragedSoul:GetSprite()
					SoulSprite:Load("gfx/003.214_enragedsoul.anm2", true)
					SoulSprite:Play(DashAnim, true)
					if (Player:GetData().ButtonPressed == 4 and not room:IsMirrorWorld()) or (Player:GetData().ButtonPressed == 5 and room:IsMirrorWorld()) then 
						SoulSprite.FlipX = true 
					end
					sfx:Play(SoundEffect.SOUND_ANIMA_BREAK)
					sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A)

					Player:GetData().ENRAGED_SOUL_Cooldown = ENRAGED_SOUL_COOLDOWN
				end
				
				-- Magic Pen
				if Player:HasCollectible(CustomCollectibles.MAGIC_PEN) and
				(not Player:GetData().MAGIC_PEN_Cooldown or Player:GetData().MAGIC_PEN_Cooldown <= 0) then
					local creepDirection = DIRECTION_VECTOR[Player:GetFireDirection()]:Resized(20)
					for i = 1, 15 do
						local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 4, Player.Position + creepDirection * i, Vector.Zero, Player)
						creep:ToEffect().Timeout = 120
					end
					
					sfx:Play(SoundEffect.SOUND_BLOODSHOOT)
					Player:GetData().MAGIC_PEN_Cooldown = MAGICPEN_CREEP_COOLDOWN
				end
				
				-- Angel's Wings
				if Player:HasCollectible(CustomCollectibles.ANGELS_WINGS) and 
				(not Player:GetData().ANGELS_WINGS_Cooldown or Player:GetData().ANGELS_WINGS_Cooldown <= 0) then
					if not Player:GetData().ANGELS_WINGS_NextAttack then
						Player:GetData().ANGELS_WINGS_NextAttack = 1
					end

					if Player:GetData().ANGELS_WINGS_NextAttack == 1 then
						local dogmaBaby = Isaac.Spawn(950, 10, 0, Player.Position, Vector.Zero, Player) 
						dogmaBaby:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
						dogmaBaby:AddEntityFlags(EntityFlag.FLAG_CHARM)
					elseif Player:GetData().ANGELS_WINGS_NextAttack == 2 then
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
						sfx:Play(SoundEffect.SOUND_DOGMA_BRIMSTONE_SHOOT)
					end
					
					if Player:GetData().ANGELS_WINGS_NextAttack < 3 then 
						Player:GetData().ANGELS_WINGS_NextAttack = Player:GetData().ANGELS_WINGS_NextAttack + 1 
					else 
						Player:GetData().ANGELS_WINGS_NextAttack = 1 
					end	

					Player:GetData().ANGELS_WINGS_Cooldown = Isaac.GetChallenge() == CustomChallenges.IN_THE_LIGHT and DOGMA_ATTACK_COOLDOWN / 2 or DOGMA_ATTACK_COOLDOWN	
				end
		
				-- Nerve Pinch
				if Player:HasCollectible(CustomCollectibles.NERVE_PINCH) and 
				(not Player:GetData().NERVE_PINCH_Cooldown or Player:GetData().NERVE_PINCH_Cooldown <= 0) then
					Player:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(Player), 30)
					local primaryItem = Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
					local charges = Isaac.GetItemConfig():GetCollectible(primaryItem).MaxCharges

					Player:GetEffects():AddCollectibleEffect(CustomCollectibles.NERVE_PINCH, false, charges >= 6 and 2 or 1)
					Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
					Player:EvaluateItems()
					
					rng:SetSeed(Random() + 1, 1)
					local roll = rng:RandomFloat() * 100
					if charges > 0
					and not (primaryItem == 490 or primaryItem == 585)
					and roll <= NERVEPINCH_USE_CHANCE then
						Player:UseActiveItem(primaryItem, 0, -1)
					end

					Player:GetData().NERVE_PINCH_Cooldown = NERVEPINCH_HOLD
				end
				
				Player:GetData().ButtonState = nil
			end
		else
			Player:GetData().ButtonState = nil
		end
	end
	
	if CustomData.Data then
		if Player:GetData().ENRAGED_SOUL_Cooldown then 
			Player:GetData().ENRAGED_SOUL_Cooldown = Player:GetData().ENRAGED_SOUL_Cooldown - 1
		end

		if Player:GetData().MAGIC_PEN_Cooldown then 
			Player:GetData().MAGIC_PEN_Cooldown = Player:GetData().MAGIC_PEN_Cooldown - 1
		end

		if Player:GetData().ANGELS_WINGS_Cooldown then 
			Player:GetData().ANGELS_WINGS_Cooldown = Player:GetData().ANGELS_WINGS_Cooldown - 1
		end

		if Player:GetData().NERVE_PINCH_Cooldown then 
			Player:GetData().NERVE_PINCH_Cooldown = Player:GetData().NERVE_PINCH_Cooldown - 1
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
				game:GetHUD():ShowFortuneText("The Dead protect you")
				level:RemoveCurses(level:GetCurses())
				Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				Player:EvaluateItems()
			elseif Player:HasTrinket(CustomTrinkets.NIGHT_SOIL) then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 100
				
				if roll < NIGHT_SOIL_CHANCE  * Player:GetTrinketMultiplier(CustomTrinkets.NIGHT_SOIL) then
					level:RemoveCurses(level:GetCurses())
					game:GetHUD():ShowFortuneText("Night Soil protects you")
					Player:AnimateHappy()
				end
			end
		end
	end

	if Player:HasCollectible(CustomCollectibles.RED_BOMBER) then
		if Input.IsActionTriggered(ButtonAction.ACTION_BOMB, Player.ControllerIndex) 
		and (Player:GetData().RED_BOMBER_Cooldown <= 0 or not Player:GetData().RED_BOMBER_Cooldown) then
			if Player:GetNumBombs() > 0 then
				Player:GetData().RED_BOMBER_Cooldown = REDBOMBER_LAUNCH_COOLDOWN
			end
		end
		
		if Player:GetData().RED_BOMBER and Player:GetData().RED_BOMBER_Cooldown then
			Player:GetData().RED_BOMBER_Cooldown = Player:GetData().RED_BOMBER_Cooldown - 1
		end
	end
	
	if Player:GetData().RejectionUsed then
		if Player:GetFireDirection() ~= Direction.NO_DIRECTION then
			Player:GetData().RejectionUsed = false
			sfx:Play(SoundEffect.SOUND_WHIP)
			-- launching the familiars
			local rejectedBabyTear = Isaac.Spawn(2, CustomTearVariants.REJECTED_BABY, 0, Player.Position, DIRECTION_VECTOR[Player:GetFireDirection()] * 12.5, Player):ToTear()
			rejectedBabyTear.TearFlags = TearFlags.TEAR_PIERCING | TearFlags.TEAR_POISON | TearFlags.TEAR_BURSTSPLIT
			rejectedBabyTear.Scale = 1.5
			rejectedBabyTear:GetSprite():Play(Player:GetData().RejectionAnimName)
			rejectedBabyTear.CollisionDamage = Player.Damage * 4 * #Player:GetData().FamiliarsInBelly
			
			if not Player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION, false) then
				Player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_C_SECTION), true)
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
					enemy:GetData()['catInBoxFrozen'] = true
				end
			end
			
			if enemy:GetData()['catInBoxFrozen']
			and (isInPlayersLineOfSight(enemy, Player) or not Player:HasCollectible(CustomCollectibles.CAT_IN_A_BOX)) then
				enemy:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
				enemy:GetData()['catInBoxFrozen'] = false
			end
		end
	end
	
	-- handle Lemegeton + Torn Page
	if Input.IsButtonTriggered(Keyboard.KEY_SPACE, Player.ControllerIndex)
	and Player:HasTrinket(CustomTrinkets.TORN_PAGE) and Player:GetActiveItem(0) == CollectibleType.COLLECTIBLE_LEMEGETON
	and Player:GetActiveCharge(0) < 6 then
		if not Player:GetData()['usedLem'] then
			local heartcharges = math.min(6 - Player:GetActiveCharge(0), Player:GetHearts() + Player:GetSoulHearts() - 1)
			Player:SetActiveCharge(Player:GetActiveCharge(0) + heartcharges, 0)
			Player:TakeDamage(heartcharges, DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 0)
		else
			Player:GetData()['usedLem'] = false
		end
	end
	
	-- MC_PRE_PLAYER_COLLISION
	if #Isaac.FindByType(6) > 0 then
		for _, moddedSlot in pairs(Isaac.FindByType(6)) do
			if moddedSlot.Position:Distance(Player.Position) < 20 then
				local s = moddedSlot:GetSprite()

				-- for Red King crawlspaces
				if moddedSlot.Variant == 334 and moddedSlot.SubType == 0 then
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
				if moddedSlot.Variant == CustomPickups.SLOT_STARGAZER and Player:GetNumCoins() >= 7 
				and s:IsPlaying("Idle") then
					Player:AddCoins(-7)
					s:Play("PayPrize")
					moddedSlot:GetData().isBetterPayout = Player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
					sfx:Play(SoundEffect.SOUND_SCAMPER)
				end

				-- for Trick Penny
				if Player:HasTrinket(CustomTrinkets.TRICK_PENNY) then
					rng:SetSeed(Random() + 1, 1)
					local roll = rng:RandomFloat() * 100

					if roll < TRICKPENNY_CHANCE * Player:GetTrinketMultiplier(CustomTrinkets.TRICK_PENNY) then
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
	
	-- control Player's and room's behaviour inside of Birth Certificate area
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
			if Player.QueuedItem.Item and Player.QueuedItem.Item:IsTrinket() then
				Player:GetData().StartBirthCertificateOutTransition = game:GetFrameCount()
				for _, p in pairs(Isaac.FindByType(5)) do
					p:Remove()
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
				end
			end
			
			if Player:GetData().StartBirthCertificateOutTransition then
				if game:GetFrameCount() <= Player:GetData().StartBirthCertificateOutTransition + 30 then
					game:ShakeScreen(2)
				else
					SilentUseCard(Player, Card.CARD_FOOL)
					Player:GetData().StartBirthCertificateOutTransition = nil
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
			and game:GetHUD():IsVisible() then
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
			
			if Player:HasCollectible(CustomCollectibles.RED_MAP) and game:GetHUD():IsVisible() then
				RedMapIcon:SetFrame("RedMap", 0)
				RedMapIcon:Render(getNextMapIconPos() + Vector(-HUDValueRenderOffset.X, HUDValueRenderOffset.Y) * ho, Vector.Zero, Vector.Zero)
			end
			
			if Player:HasCollectible(CustomCollectibles.ENRAGED_SOUL) and Player:GetData().ENRAGED_SOUL_Cooldown
			and Player:GetData().ENRAGED_SOUL_Cooldown <= 0 and Player:GetData().ENRAGED_SOUL_Cooldown >= -40 then
				SoulIcon:Update()
				SoulIcon:Render(Isaac.WorldToScreen(Player.Position + Vector(25, -45)), Vector.Zero, Vector.Zero)
			end
			
			if Player:HasCollectible(CustomCollectibles.MAGIC_PEN) and Player:GetData().MAGIC_PEN_Cooldown
			and Player:GetData().MAGIC_PEN_Cooldown <= 0 and Player:GetData().MAGIC_PEN_Cooldown >= -34 then
				PenIcon:Update()
				PenIcon:Render(Isaac.WorldToScreen(Player.Position + Vector(25, -45)), Vector.Zero, Vector.Zero)
			end
			
			if Player:HasCollectible(CustomCollectibles.ANGELS_WINGS) and Player:GetData().ANGELS_WINGS_Cooldown 
			and Player:GetData().ANGELS_WINGS_Cooldown <= 0 and Player:GetData().ANGELS_WINGS_Cooldown >= -40 then
				DogmaAttackIcon:Update()
				DogmaAttackIcon:Render(Isaac.WorldToScreen(Player.Position + Vector(25, -45)), Vector.Zero, Vector.Zero)
			end
			
			if Player:GetActiveItem(0) == CustomCollectibles.VAULT_OF_HAVOC and game:GetHUD():IsVisible() then
				Isaac.RenderScaledText('x' .. tostring(math.min(12, #CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList)), 21 + 20 * ho, 23 + 12 * ho, 0.85, 0.85, 0.8, 0.7, 0.7, 1) 
			end
			
			if i == 0 and CustomData.Data.TaintedHearts.ENIGMA > 0 and game:GetHUD():IsVisible() then
				EnigmaHeartSprite:Render(EnigmaRenderPos + HUDValueRenderOffset * ho, Vector.Zero, Vector.Zero)
				Isaac.RenderScaledText('x' .. tostring(CustomData.Data.TaintedHearts.ENIGMA), EnigmaRenderPos.X + 20 * ho, EnigmaRenderPos.Y - 4 + 12 * ho, 0.9, 0.9, 0.8, 0.7, 0.7, 1) 
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_RENDER, rplus.OnGameRender)


						-- MC_ENTITY_TAKE_DMG --									
						------------------------
function rplus:EntityTakeDmg(Entity, Amount, Flags, SourceRef, CooldownFrames)
	local Source = SourceRef.Entity
	local Player = Entity:ToPlayer()
	rng:SetSeed(Random() + 1, 1)

	-- damage inflicted to Player; this also allows for better co-op compatibility
	if Player then

		if Player:HasCollectible(CustomCollectibles.TEMPER_TANTRUM) then
			local roll = rng:RandomFloat() * 100

			if roll < SUPERBERSERK_ENTER_CHANCE then
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
			
			newID = GetUnlockedVanillaCollectible(true, false)
			Player:AddCollectible(newID, 0, false, -1, 0)
			
			sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)
		end
		
		if Player:HasCollectible(CustomCollectibles.RED_BOMBER)
		and Flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION then
			return false
		end
		
		if Flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE 
		and not isInGhostForm(Player) and not CustomData.Data.Items.BLOODVESSEL.DamageFlag
		and not isSelfDamage(Flags, "bloodvessel") and Player:GetPlayerType() ~= PlayerType.PLAYER_EDEN_B then
			for i = 1, #CustomCollectibles.BLOOD_VESSELS do
				if Player:HasCollectible(CustomCollectibles.BLOOD_VESSELS[i]) then
					if (i == 6 and Amount == 2) or (i == 7 and Amount == 1) then
						CustomData.Data.Items.BLOODVESSEL.DamageFlag = true
						-- apparently, if the Player doesn't have 3.5 red hearts, DAMAGE_RED_HEARTS damage will take soul hearts instead,
						-- and it can take away way less than intended
						-- you also can't call TakeDamage() twice because of i-frames, so I will just remove this retarded flag
						local h = math.min(6, Player:GetHearts())
						Player:AddHearts(-h)
						Player:TakeDamage(7 - h, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 18)
						Player:RemoveCollectible(CustomCollectibles.BLOOD_VESSELS[i])
						Player:AddCollectible(CustomCollectibles.BLOOD_VESSELS[1])
						CustomData.Data.Items.BLOODVESSEL.DamageFlag = false
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
			
			if roll < DARK_ARTS_CHANCE * Player:GetTrinketMultiplier(CustomTrinkets.KEY_KNIFE) then
				Player:UseActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS, UseFlag.USE_NOANIM, -1)
			end
		end
		
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.CURSED_CARD_NULL) 
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
		
		-- Tainted hearts
		if Flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE 
		and not isSelfDamage(Flags, "taintedhearts") then
			if Amount == 2 or Player:GetSoulHearts() % 2 == 1 or (Player:GetSoulHearts() == 0 and Player:GetHearts() % 2 == 1) then
				if CustomData.Data.TaintedHearts.EMPTY > 0 then
					CustomData.Data.TaintedHearts.EMPTY = CustomData.Data.TaintedHearts.EMPTY - 1
				end
				
				if Player:GetGoldenHearts() == 0 then
					if CustomData.Data.TaintedHearts.MISER > 0 then
						CustomData.Data.TaintedHearts.MISER = CustomData.Data.TaintedHearts.MISER - 1
						Player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, UseFlag.USE_NOANIM)
						Player:UseActiveItem(CollectibleType.COLLECTIBLE_D20, UseFlag.USE_NOANIM)
						sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
					elseif CustomData.Data.TaintedHearts.BALEFUL > 0  then
						CustomData.Data.TaintedHearts.BALEFUL = CustomData.Data.TaintedHearts.BALEFUL - 1
					elseif CustomData.Data.TaintedHearts.DAUNTLESS > 0  then
						CustomData.Data.TaintedHearts.DAUNTLESS = CustomData.Data.TaintedHearts.DAUNTLESS - 1
					elseif CustomData.Data.TaintedHearts.ZEALOT > 0 then
						CustomData.Data.TaintedHearts.ZEALOT = CustomData.Data.TaintedHearts.ZEALOT - 1
					end
				end
			end
			
			if CustomData.Data.TaintedHearts.SOILED > 0 and Player:GetSoulHearts() == 0 and Player:GetBoneHearts() == 0 then
				if Amount == 2 and Player:GetRottenHearts() == 1 or Player:GetRottenHearts() == 0 then 
					CustomData.Data.TaintedHearts.SOILED = CustomData.Data.TaintedHearts.SOILED - 1
					Player:AddHearts(-1)
				elseif Amount == 2 and CustomData.Data.TaintedHearts.SOILED >= 2 then 
					CustomData.Data.TaintedHearts.SOILED = CustomData.Data.TaintedHearts.SOILED - 2
					Player:AddHearts(-2)
				end
			end
		end
		
	-- damage inflicted to enemies
	elseif Source and Entity:IsVulnerableEnemy() then
		if Source.Type == 1000 and Source.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL and Source.SubType == 4 then
			local roll = rng:RandomFloat() * 150
			
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
				Entity:AddShrink(EntityRef(Entity), 60)
			elseif roll < 4 then
				Entity:AddBurn(EntityRef(Entity), 90, 0.5, Color(1, 1, 1, 1, 0, 0, 0))
			end
			
			return false
		end
		
		if Source.Type == 1000 and Source.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL and Source.SubType == 5 then
			Entity.Friction = 0
			return false
		end
		
		if Source:ToPlayer() and Source:GetData().isSuperBerserk 
		and not Entity:IsBoss() and Entity.Type ~= 951 -- for the Beast fight protection, lmao 
		then
			local roll = rng:RandomFloat() * 100

			if roll < SUPERBERSERK_DELETE_CHANCE then
				table.insert(CustomData.Data.ErasedEnemies, Entity.Type)
			end
		end
		
		if CustomData.Data.Items.BLACK_DOLL.ABSepNumber then
			for i = 1, #CustomData.Data.Items.BLACK_DOLL.EntitiesGroupA do 
				if Entity.InitSeed == CustomData.Data.Items.BLACK_DOLL.EntitiesGroupA[i].InitSeed and CustomData.Data.Items.BLACK_DOLL.EntitiesGroupB[i] and Source and Source.Type < 9 then 
					CustomData.Data.Items.BLACK_DOLL.EntitiesGroupB[i]:TakeDamage(Amount * 0.6, 0, EntityRef(Entity), 0)
				end 
			end
			for i = 1, #CustomData.Data.Items.BLACK_DOLL.EntitiesGroupB do 
				if Entity.InitSeed == CustomData.Data.Items.BLACK_DOLL.EntitiesGroupB[i].InitSeed and CustomData.Data.Items.BLACK_DOLL.EntitiesGroupA[i] and Source and Source.Type < 9 then 
					CustomData.Data.Items.BLACK_DOLL.EntitiesGroupA[i]:TakeDamage(Amount * 0.6, 0, EntityRef(Entity), 0)
				end 
			end
		end
		
		if Source.Type == 2 and Source.Variant == CustomTearVariants.CEREMONIAL_BLADE then
			Entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
			sfx:Play(SoundEffect.SOUND_KNIFE_PULL)
		end
		
		if Source.Type == 8 and Source:GetData().IsCeremonial and math.random(100) <= CEREM_DAGGER_LAUNCH_CHANCE then -- knife synergy
			Entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
		end
		
		if Entity:GetData()['catInBoxFrozen'] then 
			return false 
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, rplus.EntityTakeDmg)


--[[NPC callbacks:	MC_POST_NPC_INIT
					MC_POST_NPC_RENDER
					MC_NPC_UPDATE
					MC_POST_NPC_DEATH						
-----------------------]]
function rplus:OnNPCInit(NPC)
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		
		if Player:HasTrinket(CustomTrinkets.BABY_SHOES) then
			NPC.Size = NPC.Size * (1 - 0.1 * Player:GetTrinketMultiplier(CustomTrinkets.BABY_SHOES))
			NPC.Scale = NPC.Scale * (1 - 0.1 * Player:GetTrinketMultiplier(CustomTrinkets.BABY_SHOES))
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_INIT, rplus.OnNPCInit)

function rplus:OnNPCRender(NPC, _)
	if type(NPC:GetData().IsCrippled) == 'boolean' and NPC:GetData().IsCrippled == true then
		
		NPC.Friction = 90 / (90 + game:GetFrameCount() - NPC:GetData().CrippleStartFrame)
		
		if (NPC:HasMortalDamage() or NPC.Friction <= 0.2) and not NPC:GetData().CrippleDeathBurst then
			if NPC.Friction <= 0.2 then NPC:Kill() end
			
			rng:SetSeed(Random() + 1, 1)
			local NumTears = rng:RandomInt(5) + 5
			
			for i = 1, NumTears do
				local newTear = Isaac.Spawn(2, 0, 0, NPC.Position, Vector.FromAngle(math.random(360)) * (math.random(20) / 10), NPC):ToTear()
				newTear.FallingSpeed = -20
				newTear.FallingAcceleration = 0.4
				newTear:AddTearFlags(TearFlags.TEAR_SLOW)
				newTear:SetColor(Color(0.15, 0.15, 0.15, 1, 0, 0, 0), 300, 1, false, false)
			end
			
			-- handle custom cripple deaths
			if NPC:GetData().dropSoulHeart then
				Isaac.Spawn(5, 10, HeartSubType.HEART_HALF_SOUL, NPC.Position, Vector.Zero, nil)
			elseif NPC:GetData().dropRedHeart then
				Isaac.Spawn(5, 10, HeartSubType.HEART_HALF, NPC.Position, Vector.Zero, nil)
			elseif NPC:GetData().dropPickup then
				Isaac.Spawn(5, NPC:GetData().dropPickup, 0, NPC.Position, Vector.Zero, nil)
			elseif NPC:GetData().spawnBoneOrbital then
				Isaac.Spawn(3, FamiliarVariant.BONE_ORBITAL, 0, NPC.Position, Vector.Zero, nil)
			end
			
			NPC:GetData().CrippleDeathBurst = true
		end
	end
	
	if NPC:GetData()['catInBoxFrozen'] then
		LineOfSightEyes:SetFrame("EyesClosed", 0)
		LineOfSightEyes:Render(Isaac.WorldToScreen(NPC.Position + Vector(0, -40)), Vector.Zero, Vector.Zero)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, rplus.OnNPCRender)

function rplus:NPCUpdate(NPC)
	if NPC:GetData().isSpawningCreep and game:GetFrameCount() % 60 == 0 then
		local gasCloud = Isaac.Spawn(1000, 141, 0, NPC.Position, Vector.Zero, NPC):ToEffect()
		gasCloud.Timeout = 150
	end
end
rplus:AddCallback(ModCallbacks.MC_NPC_UPDATE, rplus.NPCUpdate)

function rplus:OnNPCDeath(NPC)
	local level = game:GetLevel()
	local room = game:GetRoom()
	rng:SetSeed(NPC.InitSeed, 1)
	local roll = rng:RandomFloat() * 100
	
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		
		if Player:HasCollectible(CustomCollectibles.GUSTY_BLOOD) and NPC:IsEnemy() and Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.GUSTY_BLOOD) < 10 then
			Player:GetEffects():AddCollectibleEffect(CustomCollectibles.GUSTY_BLOOD, 1)
			Player:SetColor(Color(1, 0.5, 0.5, 1, 0, 0, 0), 15, 1, false, false)
			Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			Player:EvaluateItems()
		end
		
		if Player:HasCollectible(CustomCollectibles.KEEPERS_PENNY) and room:GetType() == RoomType.ROOM_SHOP 
		and NPC.Type == EntityType.ENTITY_GREED then
			rng:SetSeed(Random() + 1, 1)
			local numNewItems = rng:RandomInt(2) + 3
			local V = {}
			
			if numNewItems == 3 then
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
				local Item = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(pool, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), V[i], Vector.Zero, nil):ToPickup()
				Item.Price = 15
				Item.ShopItemId = -13 * i
			end
		end
	
		if Player:GetTrinketMultiplier(CustomTrinkets.GREEDS_HEART) > 1 and CustomData.Data.Trinkets.GREEDS_HEART == "CoinHeartEmpty" 
		and roll <= 15 then
			Isaac.Spawn(5, 20, 1, NPC.Position, Vector.FromAngle(roll * 3.6), Player)
		end
		
		if Player:HasCollectible(CustomCollectibles.VAULT_OF_HAVOC) and not CustomData.Data.Items.VAULT_OF_HAVOC.Data 
		and NPC.MaxHitPoints >= 10 and NPC:IsEnemy() and not NPC:IsBoss() then
			table.insert(CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList, NPC)
		end
	
		-- killing sins has a chance to spawn its Jewel
		if NPC.Type >= EntityType.ENTITY_SLOTH and NPC.Type <= EntityType.ENTITY_PRIDE 
		and room:GetType() ~= RoomType.ROOM_BOSS and isMarkUnlocked(35, "Isaac") then
			local trueChance = JEWEL_DROP_CHANCE * (NPC.Variant + 1) * (Player:HasCollectible(CustomCollectibles.PURE_SOUL) and 21 or 1)
			
			if roll < trueChance then
				if NPC.Type == EntityType.ENTITY_GREED then
					Isaac.Spawn(5, 300, CustomConsumables.CROWN_OF_GREED, NPC.Position, Vector.Zero, NPC)
				elseif NPC.Type == EntityType.ENTITY_LUST then
					rng:SetSeed(Random() + 1, 1)
					local roll2 = rng:RandomInt(3)
					if roll2 == 0 then
						Isaac.Spawn(5, 300, CustomConsumables.FLOWER_OF_LUST, NPC.Position, Vector.Zero, NPC)
					end
				elseif NPC.Type == EntityType.ENTITY_SLOTH then
					Isaac.Spawn(5, 300, CustomConsumables.ACID_OF_SLOTH, NPC.Position, Vector.Zero, NPC)
				elseif NPC.Type == EntityType.ENTITY_GLUTTONY then
					Isaac.Spawn(5, 300, CustomConsumables.VOID_OF_GLUTTONY, NPC.Position, Vector.Zero, NPC)
				elseif NPC.Type == EntityType.ENTITY_PRIDE then
					Isaac.Spawn(5, 300, CustomConsumables.APPLE_OF_PRIDE, NPC.Position, Vector.Zero, NPC)
				elseif NPC.Type == EntityType.ENTITY_WRATH then
					Isaac.Spawn(5, 300, CustomConsumables.CANINE_OF_WRATH, NPC.Position, Vector.Zero, NPC)
				elseif NPC.Type == EntityType.ENTITY_ENVY and NPC.Variant == 0 then
					Isaac.Spawn(5, 300, CustomConsumables.MASK_OF_ENVY, NPC.Position, Vector.Zero, NPC)
				end
			end
		end
		
		if Player:GetData()['GluttonyRegen'] then 
			if Player:GetData()['GluttonyRegen'].regen then
				NPC:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
				Player:GetData()['GluttonyRegen'].duration = Player:GetData()['GluttonyRegen'].duration + 2
			end
		end
		
		if CustomData.Data.TaintedHearts.DAUNTLESS > 0 and i == 0 then 
			local hearts = Player:GetHearts() + Player:GetSoulHearts()
			local subtype = Player:GetSoulHearts() > 0 and HeartSubType.HEART_HALF_SOUL or HeartSubType.HEART_HALF
			local angle = rng:RandomInt(360)
			
			if hearts % 2 == 1 and roll <= 20 and NPC.MaxHitPoints > 5 then 
				local fadingHeart = Isaac.Spawn(5, PickupVariant.PICKUP_HEART, subtype, NPC.Position, Vector.FromAngle(angle) * 12.5, NPC)
				fadingHeart:GetData().fadeTimeout = 45
			end 
		end
		
		if Player:HasCollectible(CustomCollectibles.CEREMONIAL_BLADE) and not NPC:IsBoss() and NPC:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT) 
		and isPickupUnlocked(300, CustomConsumables.SACRIFICIAL_BLOOD) then
			Isaac.Spawn(5, 300, CustomConsumables.SACRIFICIAL_BLOOD, NPC.Position, Vector.Zero, Player)
			break
		end
		
		if Player:HasTrinket(CustomTrinkets.KEY_TO_THE_HEART) 
		and roll <= HEARTKEY_CHANCE * Player:GetTrinketMultiplier(CustomTrinkets.KEY_TO_THE_HEART) 
		and NPC.MaxHitPoints >= 10 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, CustomPickups.FLESH_CHEST, 0, NPC.Position, NPC.Velocity, nil)
			break
		end
		
		if Player:HasCollectible(CustomCollectibles.CHERRY_FRIENDS) and roll <= CHERRY_SPAWN_CHANCE then
			Isaac.Spawn(3, CustomFamiliars.CHERRY, 1, NPC.Position, Vector.Zero, nil)
			sfx:Play(SoundEffect.SOUND_BABY_HURT)
			break
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rplus.OnNPCDeath)


--[[Pickup callbacks:	MC_POST_PICKUP_INIT
						MC_PRE_PICKUP_COLLISION
						MC_POST_PICKUP_UPDATE				
--------------------------]]
function rplus:OnPickupInit(Pickup)	
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stage = level:GetStage()
	
	-- CHALLENGE
	if Pickup.Variant == 100 and Isaac.GetChallenge() == CustomChallenges.THE_COMMANDER
	and Isaac.GetItemConfig():GetCollectible(Pickup.SubType).Tags & ItemConfig.TAG_QUEST == 0 then
		Pickup:Morph(5, 100, CustomCollectibles.TANK_BOYS, true, true, true)
	end
	-- CHALLENGE END
	
	-- morph modded content if it hasn't been unlocked yet
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
		local isRune = Pickup.SubType == CustomConsumables.RED_RUNE or Pickup.SubType == CustomConsumables.QUASAR_SHARD
		local card = game:GetItemPool():GetCard(Random() + 1, not isRune, isRune, isRune)
		print("Card/Rune -> " .. card)
		
		Pickup:Morph(5, 300, card, true, true, true)
	end
	
	-- JEWELS
	if Pickup.Variant == 300 and Pickup.SubType >= CustomConsumables.CANINE_OF_WRATH and Pickup.SubType <= CustomConsumables.ACID_OF_SLOTH
	and not isMarkUnlocked(35, "Isaac") then	-- is Pure Soul unlocked?
		local rune = game:GetItemPool():GetCard(Random() + 1, false, true, true)
		print("Jewel -> " .. rune)
		
		Pickup:Morph(5, 300, rune, true, true, true)
	end
	
	-- HEARTS
	if Pickup.Variant == 10 and Pickup.SubType >= CustomPickups.TaintedHearts.HEART_BROKEN and Pickup.SubType <= CustomPickups.TaintedHearts.HEART_DESERTED
	and (not isPickupUnlocked(10, Pickup.SubType) or FLAG_NO_TAINTED_HEARTS) then
		if Pickup.SubType == 98 or Pickup.SubType == 99 then
			Pickup:Morph(5, 10, HeartSubType.HEART_SOUL, true, true, false)
		elseif Pickup.SubType == 85 or Pickup.SubType == 92 or Pickup.SubType == 94 then
			Pickup:Morph(5, 10, HeartSubType.HEART_ETERNAL, true, true, false)
		elseif Pickup.SubType == 86 then
			Pickup:Morph(5, 10, HeartSubType.HEART_DOUBLEPACK, true, true, false)
		elseif Pickup.SubType == 91 or Pickup.SubType == 100 then
			Pickup:Morph(5, 10, HeartSubType.HEART_BLACK, true, true, false)
		elseif Pickup.SubType == 96 then
			Pickup:Morph(5, 10, HeartSubType.HEART_GOLDEN, true, true, false)
		elseif Pickup.SubType == 97 or Pickup.SubType == 88 then
			Pickup:Morph(5, 10, HeartSubType.HEART_ROTTEN, true, true, false)
		else
			Pickup:Morph(5, 10, HeartSubType.HEART_FULL, true, true, false)
		end
	end
	--
	
	-- morph Joker? on final floors
	if Pickup.Variant == 300 and Pickup.SubType == CustomConsumables.JOKER_Q
	and (stage >= LevelStage.STAGE6 and stage <= LevelStage.STAGE8
	or level:IsAscent() or level:IsPreAscent()) then
		Pickup:Morph(5, 300, Card.CARD_JOKER, true, true, true)
	end

	-- Blood Vessels
	if Pickup.Variant == 100 then
		for i = 2, 7 do
			if Pickup.SubType == CustomCollectibles.BLOOD_VESSELS[i] then
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
				local c = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, Pickup.Position, Vector.Zero, nil):ToEffect()
				c.Timeout = 600
				c.Scale = 3
				for j = 1, math.floor(i / 2) do
					Isaac.Spawn(5, 10, HeartSubType.HEART_HALF, Pickup.Position, Vector.FromAngle(math.random(360)) * 2, Pickup)
				end
				for _, p in pairs(Isaac.FindByType(1, 0)) do
					local Player = p:ToPlayer()
					local h = math.min(i - 1, Player:GetHearts())
					Player:AddHearts(-h)
					Player:TakeDamage(i - 1 - h, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(Player), 18)
				end
				Pickup:Remove()
			end
		end
	end
	
	if Pickup.Price > 0 and CustomData.Data.TaintedHearts.MISER > 0 then
		Pickup.Price = math.max(1, math.ceil(Pickup.Price * (1 - 0.15 * CustomData.Data.TaintedHearts.MISER)))
		Pickup.AutoUpdatePrice = false
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
		
		-- handle Flesh chest replacement
		if roll <= FLESHCHEST_REPLACE_CHANCE 
		and (Pickup.Variant == PickupVariant.PICKUP_SPIKEDCHEST or Pickup.Variant == PickupVariant.PICKUP_MIMICCHEST) 
		and room:GetType() ~= RoomType.ROOM_CHALLENGE 
		-- make sure there are no players nearby to prevent mimic chests turning into Flesh chests when approached
		and #Isaac.FindInRadius(Pickup.Position, 60, EntityPartition.PLAYER) == 0  then
			Pickup:Morph(5, CustomPickups.FLESH_CHEST, 0, true, true, false)
			sfx:Play(SoundEffect.SOUND_CHEST_DROP)
		end
		
		-- removing pickups that spawn near Red Crawlspaces (presumably by it being bombed)
		for _, rc in pairs(Isaac.FindByType(6, 334, -1, false, false)) do
			if rc.Position:Distance(Pickup.Position) < 5 and Pickup.Variant ~= 100 then
				Pickup:Remove()
			end
		end
	
		for i = 0, game:GetNumPlayers() - 1 do
			local Player = Isaac.GetPlayer(i)
	
			if Player:HasTrinket(CustomTrinkets.BASEMENT_KEY) and Pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST 
			and roll <= BASEMENTKEY_CHANCE * Player:GetTrinketMultiplier(CustomTrinkets.BASEMENT_KEY) then
				Pickup:Morph(5, PickupVariant.PICKUP_OLDCHEST, 0, true, true, false)
			end
			
			if Pickup.Variant == 20 and Pickup.SubType ~= 7 and Player:HasTrinket(CustomTrinkets.SLEIGHT_OF_HAND) 
			and roll <= SLEIGHTOFHAND_UPGRADE_CHANCE * Player:GetTrinketMultiplier(CustomTrinkets.SLEIGHT_OF_HAND) then
				local coinSubTypesByVal = {1, 4, 6, 2, 3, 5, 7} -- penny, doublepack, sticky nickel, nickel, dime, lucky penny, golden penny
				local curType
				
				for i = 1, #coinSubTypesByVal do
					if coinSubTypesByVal[i] == Pickup.SubType then curType = i break end
				end
				
				Pickup:Morph(5, 20, coinSubTypesByVal[curType + 1], true, true, false)
				sfx:Play(SoundEffect.SOUND_THUMBSUP)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, rplus.OnPickupInit)

function rplus:PickupCollision(Pickup, Collider, _)	
	if not Collider:ToPlayer() then return end
	local Player = Collider:ToPlayer()
	local sp = Pickup:GetSprite()
	
	if CustomData.Data and CustomData.Data.Items.TWO_PLUS_ONE.isEffectActive
	and Pickup.Price > -6 and Pickup.Price ~= 0 		-- this pickup costs something
	and not Player:IsHoldingItem()						-- we're not holding another pickup right now
	then
		if Pickup.Price > 0 and Player:GetNumCoins() >= Pickup.Price						-- this shop item is affordable
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
			local newID

			repeat
				newID = GetUnlockedVanillaCollectible()
			until Isaac.GetItemConfig():GetCollectible(newID).Type % 3 == 1
			Player:AddItemWisp(newID, Player.Position, true)
		end

		if Player:HasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
			for i = 1, 3 do
				Player:AddWisp(1, Player.Position, true, false)
			end
		end
	end
	
	if Player:HasTrinket(CustomTrinkets.GREEDS_HEART) and CustomData.Data.Trinkets.GREEDS_HEART == "CoinHeartEmpty" and Pickup.Variant == 20 and Pickup.SubType ~= 6 
	and not isInGhostForm(Player) 
	-- if the Player's Keeper, they should be at full health to gain a new coin heart
	and (Player:GetHearts() == Player:GetMaxHearts() or (Player:GetPlayerType() ~= 14 and Player:GetPlayerType() ~= 33)) then
		Player:AddCoins(-1)
		CustomData.Data.Trinkets.GREEDS_HEART = "CoinHeartFull"
	end
	
	if Pickup.Variant == 10 and Player:CanPickRedHearts()
	and (Pickup.SubType == 1 or Pickup.SubType == 2 or Pickup.SubType == 5 
	or Pickup.SubType == HeartSubType.HEART_SCARED or Pickup.SubType == CustomPickups.TaintedHearts.HEART_HOARDED) then
		-- different hearts gives different boosts
		local mult = 2
		if Pickup.SubType == 2 then mult = 1
		elseif Pickup.SubType == 5 then mult = 4
		elseif Pickup.SubType == CustomPickups.TaintedHearts.HEART_HOARDED then mult = 8 end
		
		-- bonuses should apply according to how many hearts were FILLED, not how many were picked up
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
				
				if yumStat == 0 then -- damage
					Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)					
				elseif yumStat == 1 then -- tears	
					Player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)					
				elseif yumStat == 2 then -- range
					Player:AddCacheFlags(CacheFlag.CACHE_RANGE)
				elseif yumStat == 3 then -- luck
					Player:AddCacheFlags(CacheFlag.CACHE_LUCK)
				elseif yumStat == 4 then -- speed
					Player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				end
			end
			
			Player:EvaluateItems()
		end
	end
	
	if Pickup.Variant == CustomPickups.FLESH_CHEST and Pickup.SubType == 0 then
		if Player:GetDamageCooldown() > 0 then return false end
		
		Player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(Pickup), 30)
		CustomData.Data.FleshChestConsumedHP = CustomData.Data.FleshChestConsumedHP + 1
		sp:Play("TakeHealth")
		
		if ((CustomData.Data.FleshChestConsumedHP > 2 and math.random(100) < FLESHCHEST_OPEN_CHANCE) or CustomData.Data.FleshChestConsumedHP == 6) then
			CustomData.Data.FleshChestConsumedHP = 0
			-- subtype 1: opened chest (need to remove)
			Pickup.SubType = 1
			-- setting some data for pickup, because it is deleted on entering a new room, and the pickup is removed as well
			Pickup:GetData()["IsInRoom"] = true
			sp:Play("Open")
			sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
			rng:SetSeed(Pickup.DropSeed, 1)
			local DieRoll = rng:RandomFloat() * 100
			
			if DieRoll < 30 then
				local newID = GetUnlockedCollectibleFromCustomPool(CustomItempools.FLESH_CHEST)
				local fleshChest = Isaac.Spawn(5, 100, newID, Pickup.Position, Vector(0, 0), Pickup)
				fleshChest:GetSprite():ReplaceSpritesheet(5, "gfx/items/fleshchest_itemaltar.png") 
				fleshChest:GetSprite():LoadGraphics()
				
				Pickup:Remove()
			else
				local NumOfPickups = rng:RandomInt(4) + 3 -- 3 to 6 pickups
				
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
				if t then Isaac.Spawn(5, 350, t, Pickup.Position, Vector.FromAngle(math.random(360)) * 4, Pickup) end
			end
		end
	end
	
	if Pickup.Variant == CustomPickups.BLACK_CHEST and Pickup.SubType == 0 then		
		-- setting some data for pickup, because it is deleted on entering a new room, and the pickup is removed as well
		Pickup:GetData()["IsInRoom"] = true
		sp:Play("Open")
		sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
		Player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(Pickup), 24)
		rng:SetSeed(Random() + 1, 1)
		local DieRoll = rng:RandomFloat() * 100
		
		if DieRoll < 15 then
			local BlackChestPedestal = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_CURSE, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), Pickup.Position, Vector(0, 0), Pickup)
			BlackChestPedestal:GetSprite():ReplaceSpritesheet(5,"gfx/items/blackchest_itemaltar.png") 
			BlackChestPedestal:GetSprite():LoadGraphics()
			
			Pickup:Remove()
		elseif DieRoll < 70 then
			-- subtype 2: opened chest with consumables (need to close again later)
			Pickup.SubType = 2
			Pickup:GetData()['OpenFrame'] = game:GetFrameCount()
			local roll = rng:RandomFloat() * 100
			
			for i, v in pairs(DropTables.BLACK_CHEST) do
				if roll < DropTables.BLACK_CHEST[i][1] then
					for x, y in pairs(DropTables.BLACK_CHEST[i][2]) do
						Isaac.Spawn(5, y[1], y[2], Pickup.Position, Vector.FromAngle(math.random(360)) * 3, Player)
					end
					break
				end
			end
		else
			-- subtype 1: opened chest with nothing (need to remove)
			Pickup.SubType = 1		
		end
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
	
	-- TAINTED HEARTS
	if Pickup.Variant == 10 and Pickup.SubType >= CustomPickups.TaintedHearts.HEART_BROKEN and Pickup.SubType <= CustomPickups.TaintedHearts.HEART_DESERTED 
	and not sp:IsPlaying("Collect") then
		local hasBow = Player:HasCollectible(CollectibleType.COLLECTIBLE_MAGGYS_BOW) and 2 or 1
		local hasApple = Player:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_BROKEN then
			Player:AddMaxHearts(2)
			Player:AddHearts(2)
			Player:AddBrokenHearts(1)
			sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_DAUNTLESS then
			if getRightMostHeartForRender(Player) - Player:GetGoldenHearts() - CustomData.Data.TaintedHearts.ZEALOT - CustomData.Data.TaintedHearts.MISER - CustomData.Data.TaintedHearts.BALEFUL > CustomData.Data.TaintedHearts.DAUNTLESS 
			and not isInGhostForm(Player, true) then
				CustomData.Data.TaintedHearts.DAUNTLESS = CustomData.Data.TaintedHearts.DAUNTLESS + 1
				sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION)
			else 
				return false 
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_HOARDED then			
			if Player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM) then
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
				for i = 1, 2 do
					CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME = game:GetFrameCount()
					Isaac.Spawn(5, 10, HeartSubType.HEART_DOUBLEPACK, Pickup.Position, Vector.FromAngle(math.random(360)) * 3, Player)
				end
			elseif hasApple then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 100
				
				if roll <= 50 * (Player:CanPickRedHearts() and 1 or 2) then
					-- fart and spiders
					Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS, UseFlag.USE_NOANIM, -1)
					Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS, UseFlag.USE_NOANIM, -1)
					game:Fart(Pickup.Position, 85, Pickup, 1, 0, Color.Default)
					sfx:Play(SoundEffect.SOUND_FART)
				else
					Player:AddHearts(8 * hasBow)
					sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
				end
			else
				if Player:CanPickRedHearts() then
					Player:AddHearts(8 * hasBow)
					sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
				else
					return false
				end
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_SOILED then
			if Player:GetMaxHearts() / 2 - Player:GetBoneHearts() - CustomData.Data.TaintedHearts.SOILED > 0 and not isInGhostForm(Player) then
				CustomData.Data.TaintedHearts.SOILED = CustomData.Data.TaintedHearts.SOILED + 1
				if Player:GetHearts() % 2 == 1 then 
					Player:AddHearts(3)
				else 
					Player:AddHearts(2)
				end
				sfx:Play(SoundEffect.SOUND_ROTTEN_HEART)
			else 
				return false 
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_CURDLED then
			if Player:CanPickRedHearts() or isNoRedHealthCharacter(Player) then
				Player:AddHearts(2 * hasBow)
				sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
				sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
				local s = isNoRedHealthCharacter(Player) and 1 or 0
				Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, s, Player.Position, Vector.Zero, Player)
			else 
				return false 
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_SAVAGE then
			addTemporaryDmgBoost(Player)
			if Player:CanPickRedHearts() then
				Player:AddHearts(2 * hasBow)
				addTemporaryDmgBoost(Player)
			else
				addTemporaryDmgBoost(Player)
			end
			sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_BENIGHTED then
			if Player:CanPickBlackHearts() then				
				Player:AddBlackHearts(2)
				Player = Player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and Player:GetOtherTwin() or Player
				Player:GetEffects():AddCollectibleEffect(CustomCollectibles.HEART_BENIGHTED_NULL)
				Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				Player:EvaluateItems()
				sfx:Play(SoundEffect.SOUND_UNHOLY)
			else
				return false 
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_ENIGMA then
			CustomData.Data.TaintedHearts.ENIGMA = CustomData.Data.TaintedHearts.ENIGMA + 1
			sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_CAPRICIOUS then
			rng:SetSeed(Pickup.DropSeed, 1)
			local roll2 = rng:RandomFloat() * 100
			local num = 1
			if roll2 < 10 then
				num = 3
			elseif roll2 < 40 then
				num = 2
			end
			
			for i = 1, num do
				local roll = rng:RandomInt(12) + 1
				Isaac.Spawn(5, 10, roll, Pickup.Position, Vector.FromAngle(roll * 30) * 3, Player)
			end
			sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_BALEFUL then
			if getRightMostHeartForRender(Player) - Player:GetGoldenHearts() > CustomData.Data.TaintedHearts.BALEFUL 
			and not isInGhostForm(Player, true) then
				CustomData.Data.TaintedHearts.BALEFUL = CustomData.Data.TaintedHearts.BALEFUL + 1
				sfx:Play(SoundEffect.SOUND_SUPERHOLY)
			else 
				return false 
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_HARLOT then
			if Player:CanPickRedHearts() then
				Player:AddHearts(2)
				Isaac.Spawn(3, FamiliarVariant.LEPROSY, 0, Player.Position, Vector.Zero, Player)
			else
				return false
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_MISER then
			if getRightMostHeartForRender(Player) > CustomData.Data.TaintedHearts.MISER and not isInGhostForm(Player, true) then
				CustomData.Data.TaintedHearts.MISER = CustomData.Data.TaintedHearts.MISER + 1
				sfx:Play(SoundEffect.SOUND_GOLD_HEART)
			else return false end
			
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_EMPTY then
			if getRightMostHeartForRender(Player) > CustomData.Data.TaintedHearts.EMPTY and not isInGhostForm(Player, true) then
				CustomData.Data.TaintedHearts.EMPTY = CustomData.Data.TaintedHearts.EMPTY + 1
				sfx:Play(SoundEffect.SOUND_ROTTEN_HEART)
			else return false end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_FETTERED then
			if (Player:GetNumKeys() > 0 or Player:HasGoldenKey()) and Player:CanPickSoulHearts() then
				Player:AddSoulHearts(2)
				local fren = Isaac.Spawn(3, CustomFamiliars.SPIRITUAL_RESERVES_SUN, 0, Player.Position, Vector.Zero, Player)
				fren:ToFamiliar():AddKeys(3)
				if not Player:GetData()['usedSpiritualReserves'] then
					Player:GetData()['usedSpiritualReserves'] = {0, 1}
				else
					Player:GetData()['usedSpiritualReserves'][2] = Player:GetData()['usedSpiritualReserves'][2] + 1
				end
				Player:AddKeys(Player:HasGoldenKey() and 0 or -1)
				sfx:Play(SoundEffect.SOUND_GOLDENKEY)
				sfx:Play(SoundEffect.SOUND_HOLY)
			else 
				return false 
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_ZEALOT then
			if getRightMostHeartForRender(Player) - Player:GetGoldenHearts() - CustomData.Data.TaintedHearts.DAUNTLESS - CustomData.Data.TaintedHearts.MISER - CustomData.Data.TaintedHearts.BALEFUL > CustomData.Data.TaintedHearts.ZEALOT 
			and not isInGhostForm(Player, true) then
				CustomData.Data.TaintedHearts.ZEALOT = CustomData.Data.TaintedHearts.ZEALOT + 1
				sfx:Play(SoundEffect.SOUND_HOLY)
			else 
				return false 
			end
		end
		
		if Pickup.SubType == CustomPickups.TaintedHearts.HEART_DESERTED then
			if not (Player:CanPickRedHearts() or Player:CanPickBlackHearts()) then return false end
			if Player:CanPickRedHearts() then Player:AddHearts(1) sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES) elseif Player:CanPickBlackHearts() then Player:AddBlackHearts(1) sfx:Play(SoundEffect.SOUND_UNHOLY) end
			if Player:CanPickRedHearts() then Player:AddHearts(1) sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES) elseif Player:CanPickBlackHearts() then Player:AddBlackHearts(1) sfx:Play(SoundEffect.SOUND_UNHOLY) end
		end
		
		sp:Play("Collect")
		
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_OPTIONS) 
		and Pickup.OptionsPickupIndex > 0 then
			for _, p in pairs(Isaac.FindByType(5)) do
				if p:ToPickup().OptionsPickupIndex == Pickup.OptionsPickupIndex 
				and GetPtrHash(p) ~= GetPtrHash(Pickup) then
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, p.Position, Vector.Zero, Pickup)
					p:Remove()
				end
			end
		end
	end
	
	if Player:HasCollectible(CustomCollectibles.STARGAZERS_HAT) 
	and Pickup.Variant == 10 and (Pickup.SubType == HeartSubType.HEART_SOUL or Pickup.SubType == HeartSubType.HEART_HALF_SOUL)
	and not (Pickup.Price > 0 and Player:GetNumCoins() < Pickup.Price) and not CustomData.Data.Items.STARGAZERS_HAT.UsedOnFloor then
		local HatSlot = 0
		local addCharges = 2
	
		if Pickup.SubType == HeartSubType.HEART_HALF_SOUL then addCharges = 1 end
		if Player:GetActiveItem(0) ~= CustomCollectibles.STARGAZERS_HAT then HatSlot = 1 end
		
		if Player:GetActiveCharge(HatSlot) < 2 then 
			Player:SetActiveCharge(Player:GetActiveCharge(HatSlot) + addCharges, HatSlot)
			if Player:GetActiveCharge(HatSlot) >= 2 then sfx:Play(SoundEffect.SOUND_BATTERYCHARGE) else sfx:Play(SoundEffect.SOUND_BEEP) end
			Pickup:Remove()
			return false
		end
	end
	
	if Player:HasTrinket(CustomTrinkets.SHATTERED_STONE) 
	and (Pickup.Variant == 20 or Pickup.Variant == 30 or Pickup.Variant == 40) then
		local locustSpawnChance = 0
		rng:SetSeed(Pickup.DropSeed, 1)
		local roll = rng:RandomFloat() * 100
		
		if PickupWeights[Pickup.Variant] and PickupWeights[Pickup.Variant][Pickup.SubType] then
			locustSpawnChance = PickupWeights[Pickup.Variant][Pickup.SubType] * 20
		end
		
		if roll < locustSpawnChance + 1 then
			local locustRoll = rng:RandomInt(5) + 1
			local locust = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, locustRoll, Player.Position, Vector.Zero, Player)
			locust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, rplus.PickupCollision)

function rplus:PostPickupUpdate(Pickup)
	if not CustomData.Data then return end
	
	local room = game:GetRoom()
	local sp = Pickup:GetSprite()
	local stage = game:GetLevel():GetStage()
	
	-- TAINTED HEARTS REPLACEMENT --
		for i = 0, game:GetNumPlayers() - 1 do
			local Player = Isaac.GetPlayer(i)
			
			if Pickup.Variant == 10 and not FLAG_NO_TAINTED_HEARTS and room:GetType() ~= RoomType.ROOM_SUPERSECRET and Pickup.Price == 0 
			and CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME == 0 
			and (Pickup:GetSprite():IsPlaying("Appear") or Pickup:GetSprite():IsPlaying("AppearFast")) and Pickup:GetSprite():GetFrame() == 1 then
				rng:SetSeed(Random() + 1, 1)
				local roll = rng:RandomFloat() * 1000
				local capriciousRoll = rng:RandomFloat() * 1000
				local st = Pickup.SubType
				
				if st == HeartSubType.HEART_FULL then
					local baseChance = 7.5
					if Player:HasCollectible(CollectibleType.COLLECTIBLE_OLD_BANDAGE) or
					Player:HasCollectible(CollectibleType.COLLECTIBLE_SHARD_OF_GLASS) then
						baseChance = 3.75
					end
				
					-- 0.75% broken heart
					if roll < baseChance then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_BROKEN)
					-- 1.125% curdled heart
					elseif roll < baseChance * 2.5 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_CURDLED)
					-- 1.125% savage heart
					elseif roll < baseChance * 4 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_SAVAGE)
					-- 0.75% harlot heart
					elseif roll < baseChance * 5 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_HARLOT)
					-- 0.75% deceiver heart
					elseif roll < baseChance * 6 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_DECEIVER)
					-- 0.75% enigma heart
					elseif roll < baseChance * 7 and game:GetNumPlayers() == 1 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_ENIGMA) end
				elseif st == HeartSubType.HEART_SOUL then
					local baseChance = 50
					if Player:HasCollectible(CollectibleType.COLLECTIBLE_RELIC) or
					Player:HasCollectible(CollectibleType.COLLECTIBLE_MITRE) or
					Player:HasCollectible(CollectibleType.COLLECTIBLE_GIMPY) then
						baseChance = 25
					end
					
					if stage == 1 then
						-- 2.5% zealot heart
						if roll < baseChance * 0.5 and game:GetNumPlayers() == 1 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_ZEALOT) end
					else
						-- 5% fettered heart
						if roll < baseChance then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_FETTERED)
						-- 2.5% zealot heart
						elseif roll < baseChance * 1.5 and game:GetNumPlayers() == 1 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_ZEALOT) end
					end
				elseif st == HeartSubType.HEART_ETERNAL then
					local baseChance = 100
					
					if game:GetNumPlayers() == 1 then
						-- 10% dauntless heart
						if roll < baseChance then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_DAUNTLESS) end
						-- 10% baleful heart
						if roll < baseChance * 2 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_BALEFUL) end
					end
				elseif st == HeartSubType.HEART_DOUBLEPACK then
					local baseChance = 250
					if Player:HasCollectible(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE) then
						baseChance = 50
					end
					
					-- 25% hoarded heart
					if roll < baseChance then 
						morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_HOARDED)
					end
				elseif st == HeartSubType.HEART_BLACK then
					local baseChance = 200
					if Player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM) or
					Player:HasTrinket(TrinketType.TRINKET_BLACK_LIPSTICK) or
					Player:HasTrinket(TrinketType.TRINKET_DAEMONS_TAIL) then
						baseChance = 75
					end
				
					-- 20% deserted heart
					if roll < baseChance then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_DESERTED)
					-- 20% benighted heart
					elseif roll < baseChance * 2 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_BENIGHTED) end
				elseif st == HeartSubType.HEART_GOLDEN then
					local baseChance = 250
					
					-- 25% miser heart
					if roll < baseChance and game:GetNumPlayers() == 1 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_MISER) end
				elseif st == HeartSubType.HEART_HALF_SOUL then
					
				elseif st == HeartSubType.HEART_SCARED then
					
				elseif st == HeartSubType.HEART_BLENDED then
					local baseChance = 350
					
					-- 35% deserted heart
					if roll < baseChance then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_DESERTED) end
				elseif st == HeartSubType.HEART_BONE then
					local baseChance = 100
					
					-- 10% dauntless heart
					if roll < baseChance and game:GetNumPlayers() == 1 then Pickup:Morph(5, 10, CustomPickups.TaintedHearts.HEART_DAUNTLESS) end
				elseif st == HeartSubType.HEART_ROTTEN and game:GetNumPlayers() == 1 then
					local baseChance = 75
					
					if game:GetNumPlayers() == 1 then
						-- 7.5% empty heart
						if roll < baseChance then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_EMPTY)
						-- 15% soiled heart
						elseif roll < baseChance * 3 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_SOILED) end
					end
				end
				
				-- 0.75% capricious heart (for ANY heart)
				if capriciousRoll < 7.5 then morphToTaintedIfUnlocked(Pickup, CustomPickups.TaintedHearts.HEART_CAPRICIOUS) end
			end
		end
	-- TAINTED HEARTs REPLACEMENT END --
	
	-- hearts
	if Pickup.Variant == 10 then
		if (Pickup.SubType == HeartSubType.HEART_HALF_SOUL or Pickup.SubType == HeartSubType.HEART_HALF)
		and Pickup:GetData().fadeTimeout then
			if Pickup:GetData().fadeTimeout == 0 then
				Pickup:Remove()
			else
				Pickup:GetData().fadeTimeout = Pickup:GetData().fadeTimeout - 1
				if Pickup:GetData().fadeTimeout <= 30 then
					if Pickup:GetData().fadeTimeout % 2 == 1 then
						Pickup.Visible = false
					else
						Pickup.Visible = true
					end
				end
			end
		end
		
		if Pickup.SubType >= CustomPickups.TaintedHearts.HEART_BROKEN and Pickup.SubType <= CustomPickups.TaintedHearts.HEART_DESERTED then
			if sp:IsPlaying("Collect") then Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE end
			if sp:IsFinished("Collect") then Pickup:Remove() end
			
			if Pickup.SubType == CustomPickups.TaintedHearts.HEART_HARLOT then
				if not Pickup:GetData().TargetPlayer then
					for i = 0, game:GetNumPlayers() - 1 do
						if Isaac.GetPlayer(i):CanPickRedHearts() then
							Pickup:GetData().TargetPlayer = Isaac.GetPlayer(i)
							break
						end
					end
				else
					Pickup.Velocity = (Pickup:GetData().TargetPlayer.Position - Pickup.Position):Normalized() * 2
				end
			end
			
			if Pickup.SubType == CustomPickups.TaintedHearts.HEART_DECEIVER then
				if #Isaac.FindInRadius(Pickup.Position, 30, EntityPartition.PLAYER) > 0 then
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, Pickup.Position, Vector.Zero, Pickup)
					rng:SetSeed(Random() + 1, 1)
					local roll = (rng:RandomInt(3) + 2) * 10	-- 20, 30 or 40
					Isaac.Spawn(5, 10, HeartSubType.HEART_HALF, Pickup.Position, Vector.FromAngle(math.random(360)), Pickup)
					Isaac.Spawn(5, roll, roll == 20 and 2 or 1, Pickup.Position, Vector.FromAngle(math.random(360)), Pickup)
					Pickup:Remove()
					sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
				end
			end
		end
	end
	
	-- items spawned by Auction Gavel
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
	
	-- chests
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
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, rplus.PostPickupUpdate)


						-- MC_POST_FIRE_TEAR --
						-----------------------
function rplus:OnTearFired(Tear)
	local Player
	if Tear.Parent then Player = Tear.Parent:ToPlayer() elseif Tear.SpawnerEntity then Player = Tear.SpawnerEntity:ToPlayer() end
	if not Player then return end
	local tearSprite = Tear:GetSprite()
	
	if Player:HasCollectible(CustomCollectibles.CEREMONIAL_BLADE) and math.random(100) <= CEREM_DAGGER_LAUNCH_CHANCE then
		-- launching the dagger
		local BladeTear = Isaac.Spawn(2, CustomTearVariants.CEREMONIAL_BLADE, 0, Player.Position, Tear.Velocity, Player):ToTear()
		BladeTear:AddTearFlags(TearFlags.TEAR_PIERCING) 
		local s = BladeTear:GetSprite()
		s:Play("Move")
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
function rplus:OnTearUpdate(Tear)
	local Player
	if Tear.Parent then Player = Tear.Parent:ToPlayer() elseif Tear.SpawnerEntity then Player = Tear.SpawnerEntity:ToPlayer() end
	if not Player then return end
	local tearSprite = Tear:GetSprite()
	
	if Tear.Variant == 120 or Tear.Variant == 121 or Tear.Variant == 125 then
		tearSprite.Rotation = Tear.Velocity:GetAngleDegrees() + 90
	end
	
	if Tear.Variant == CustomTearVariants.DOGMA_FEATHER and Tear.FrameCount % 3 == 0 then
		Tear.CollisionDamage = Tear.CollisionDamage * 1.02
	end
	
	if Tear.Height >= -5 then
		-- manually making tears leave splashes when they land
		local tearToSplashCol = {
			[CustomTearVariants.CEREMONIAL_BLADE] = Color(0.56, 0.56, 0.56, 1, 0, 0, 0),
			[CustomTearVariants.SINNERS_HEART] = Color(0.93, 0.22, 0.56, 1, 0, 0, 0),
			[CustomTearVariants.REJECTED_BABY] = Color(0.87, 0.24, 0.18, 1, 0, 0, 0),
			[CustomTearVariants.DOGMA_FEATHER] = Color(0.53, 0.51, 0.59, 1, 0, 0, 0)
		}
		
		if tearToSplashCol[Tear.Variant] then
			local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0, Tear.Position, Vector.Zero, Tear):ToEffect()
			
			splash:SetColor(tearToSplashCol[Tear.Variant], 100, 1, false, false)
			-- remove laser impacts left by Trisagion
			for _, impact in pairs(Isaac.FindByType(1000, 50)) do
				if impact.SpawnerType == 7 then impact:Remove() end
			end
			
			Tear:Remove()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, rplus.OnTearUpdate)


						-- MC_PRE_TEAR_COLLISION --										
						---------------------------	
function rplus:TearCollision(Tear, Collider, _)
	if not (Collider:IsVulnerableEnemy() and not Collider:IsBoss()) then return end
	
	local Player
	if Tear.Parent then Player = Tear.Parent:ToPlayer()
	elseif Tear.SpawnerEntity then Player = Tear.SpawnerEntity:ToPlayer() end
	if not Player then return end
	
	if Tear.Variant == CustomTearVariants.ANTIMATERIAL_CARD and Collider.Type ~= 951 then
		table.insert(CustomData.Data.ErasedEnemies, Collider.Type)
		Tear:Remove()
	end
	
	if Tear.Variant == CustomTearVariants.VALENTINES_CARD and Collider.Type ~= 951 then
		Collider:AddCharmed(EntityRef(Player), -1)
	end
	
	if Player:HasCollectible(CustomCollectibles.CROSS_OF_CHAOS) and not Collider:GetData().IsCrippled then
		rng:SetSeed(Random() + 1, 1)
		local roll = rng:RandomFloat() * 100
		local trueCrippleChance = math.max(CRIPPLE_TEAR_CHANCE, CRIPPLE_TEAR_CHANCE + Player.Luck / 2)
		trueCrippleChance = math.min(trueCrippleChance, 7)
		
		if roll < trueCrippleChance then
			crippleEnemy(Collider)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, rplus.TearCollision)


						-- MC_POST_LASER_UPDATE --
						--------------------------
function rplus:OnLaserUpdate(Laser)
	-- replacing the spritesheet of static Dogma laser
	if Laser.FrameCount <= 2 and Laser.SpawnerEntity and Laser.SpawnerEntity:ToPlayer() 
	and Laser:GetData().IsDogmaLaser and Laser.Variant == 3 then
		Laser.CollisionDamage = 3.5
		
		sfx:Stop(SoundEffect.SOUND_BLOOD_LASER)
		Laser:GetSprite():ReplaceSpritesheet(0, "gfx/dogma_laser.png")
		Laser:GetSprite():LoadGraphics()
		
		if Laser.Child then
			Laser.Child:GetSprite():ReplaceSpritesheet(0, "gfx/dogma_laser_end.png")
			Laser.Child:GetSprite():LoadGraphics()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, rplus.OnLaserUpdate)


						-- MC_EVALUATE_CACHE --							
						-----------------------
function rplus:OnCacheEvaluate(Player, Flag) 
	if not CustomData.Data then return end
	
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
		
		if Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CHEESE_GRATER) > 0 then
			Player.Damage = Player.Damage * CustomStatups.Damage.CHEESE_GRATER_MUL ^ (Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CHEESE_GRATER))
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
		
		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) then
			Player.Damage = Player.Damage + CustomStatups.Damage.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.NumStats
		end
		
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.DEMON_FORM_NULL) then 
			Player.Damage = Player.Damage + CustomStatups.Damage.DEMON_FORM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.DEMON_FORM_NULL)
		end
		
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.HEART_BENIGHTED_NULL) then
			Player.Damage = Player.Damage + Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.HEART_BENIGHTED_NULL) * 0.16
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
		
		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) then
			Player.MaxFireDelay = GetFireDelay(GetTears(Player.MaxFireDelay) + CustomStatups.Tears.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.NumStats)
		end
		
		if Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CURSED_CARD_NULL) > 1 then
			Player.MaxFireDelay = GetFireDelay(GetTears(Player.MaxFireDelay) + CustomStatups.Tears.CURSED_CARD * (Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.CURSED_CARD_NULL) - 1))
		end
		
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) then
			Player.MaxFireDelay = Player.MaxFireDelay * CustomStatups.Tears.APPLE_OF_PRIDE_MUL ^ Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		end
	end
	
	if Flag == CacheFlag.CACHE_TEARFLAG then
		if Player:HasCollectible(CustomCollectibles.SINNERS_HEART) then
			Player.TearFlags = Player.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
		end
		
		if Player:HasTrinket(CustomTrinkets.TORN_PAGE) and Player:GetData()['enhancedBoB'] then
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
		
		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) then
			Player.TearRange = Player.TearRange + CustomStatups.Range.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.NumStats * 40
		end
		
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.APPLE_OF_PRIDE_NULL) then
			Player.TearRange = Player.TearRange + CustomStatups.Range.APPLE_OF_PRIDE * 40 * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.APPLE_OF_PRIDE_NULL)
		end
	end
	
	if Flag == CacheFlag.CACHE_FAMILIARS then
		Player:CheckFamiliar(CustomFamiliars.BAG_O_TRASH, getTrueFamiliarNum(Player, CustomCollectibles.BAG_O_TRASH), Player:GetCollectibleRNG(CustomCollectibles.BAG_O_TRASH))
		Player:CheckFamiliar(CustomFamiliars.CHERUBIM, getTrueFamiliarNum(Player, CustomCollectibles.CHERUBIM), Player:GetCollectibleRNG(CustomCollectibles.CHERUBIM))
		Player:CheckFamiliar(CustomFamiliars.TOY_TANK_1, getTrueFamiliarNum(Player, CustomCollectibles.TANK_BOYS), Player:GetCollectibleRNG(CustomCollectibles.TANK_BOYS))
		Player:CheckFamiliar(CustomFamiliars.TOY_TANK_2, getTrueFamiliarNum(Player, CustomCollectibles.TANK_BOYS), Player:GetCollectibleRNG(CustomCollectibles.TANK_BOYS))
		if not Player:GetData()['fightingSiblings'] then
			Player:CheckFamiliar(CustomFamiliars.SIBLING_1, getTrueFamiliarNum(Player, CustomCollectibles.SIBLING_RIVALRY), Player:GetCollectibleRNG(CustomCollectibles.SIBLING_RIVALRY))
			Player:CheckFamiliar(CustomFamiliars.SIBLING_2, getTrueFamiliarNum(Player, CustomCollectibles.SIBLING_RIVALRY), Player:GetCollectibleRNG(CustomCollectibles.SIBLING_RIVALRY))
		else
			Player:CheckFamiliar(CustomFamiliars.FIGHTING_SIBLINGS, getTrueFamiliarNum(Player, CustomCollectibles.SIBLING_RIVALRY), Player:GetCollectibleRNG(CustomCollectibles.SIBLING_RIVALRY))
		end
		Player:CheckFamiliar(CustomFamiliars.REJECTION_FETUS, getTrueFamiliarNum(Player, CustomCollectibles.REJECTION_P), Player:GetCollectibleRNG(CustomCollectibles.REJECTION_P))
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.MARK_OF_CAIN) then
			Player:CheckFamiliar(CustomFamiliars.ENOCH_B, getTrueFamiliarNum(Player, CustomCollectibles.MARK_OF_CAIN), Player:GetCollectibleRNG(CustomCollectibles.MARK_OF_CAIN))
		else
			Player:CheckFamiliar(CustomFamiliars.ENOCH, getTrueFamiliarNum(Player, CustomCollectibles.MARK_OF_CAIN), Player:GetCollectibleRNG(CustomCollectibles.MARK_OF_CAIN))
		end
		if Player:GetData()['usedSpiritualReserves'] then
			Player:CheckFamiliar(CustomFamiliars.SPIRITUAL_RESERVES_MOON, Player:GetData()['usedSpiritualReserves'][1], Player:GetCollectibleRNG(1))
			Player:CheckFamiliar(CustomFamiliars.SPIRITUAL_RESERVES_SUN, Player:GetData()['usedSpiritualReserves'][2], Player:GetCollectibleRNG(1))
		end
		Player:CheckFamiliar(CustomFamiliars.FRIENDLY_SACK, getTrueFamiliarNum(Player, CustomCollectibles.FRIENDLY_SACK), Player:GetCollectibleRNG(CustomCollectibles.FRIENDLY_SACK))
		if Player:GetData()['UFCLevel'] == 1 or not Player:GetData()['UFCLevel'] then
			Player:CheckFamiliar(CustomFamiliars.ULTRA_FLESH_KID_L1, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))
		elseif Player:GetData()['UFCLevel'] == 2 then
			Player:CheckFamiliar(CustomFamiliars.ULTRA_FLESH_KID_L2, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))
		elseif Player:GetData()['UFCLevel'] == 3 then
			Player:CheckFamiliar(CustomFamiliars.ULTRA_FLESH_KID_L3, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))
		end
		Player:CheckFamiliar(FamiliarVariant.LEECH, getTrueFamiliarNum(Player, CustomCollectibles.ULTRA_FLESH_KID) + getTrueFamiliarNum(Player, CollectibleType.COLLECTIBLE_LEECH), Player:GetCollectibleRNG(CustomCollectibles.ULTRA_FLESH_KID))
	end
	
	if Flag == CacheFlag.CACHE_LUCK then
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.LOADED_DICE_NULL) then
			Player.Luck = Player.Luck + CustomStatups.Luck.LOADED_DICE * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.LOADED_DICE_NULL)
		end
		
		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.YUM_LUCK_NULL) then
			Player.Luck = Player.Luck + CustomStatups.Luck.PILL_YUM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.YUM_LUCK_NULL)
		end
		
		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) then
			Player.Luck = Player.Luck + CustomStatups.Luck.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.NumStats
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
		
		if Player:HasCollectible(CustomCollectibles.MOTHERS_LOVE) then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.MOTHERS_LOVE * CustomData.Data.Items.MOTHERS_LOVE.NumStats
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
		
		if Player:GetData()['GluttonyRegen'] then
			if Player:GetData()['GluttonyRegen'].regen then
				Player.MoveSpeed = Player.MoveSpeed - Player:GetData()['GluttonyRegen'].amount
			end
		end

		if Player:GetEffects():HasCollectibleEffect(CustomCollectibles.YUM_SPEED_NULL) then
			Player.MoveSpeed = Player.MoveSpeed + CustomStatups.Speed.PILL_YUM * Player:GetEffects():GetCollectibleEffectNum(CustomCollectibles.YUM_SPEED_NULL)
		end
	end
	
	if Flag == CacheFlag.CACHE_FLYING then
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
	
	if Familiar.Variant == CustomFamiliars.TOY_TANK_1 or Familiar.Variant == CustomFamiliars.TOY_TANK_2 then
		Familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		Familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		if Familiar.Variant == CustomFamiliars.TOY_TANK_1 then
			Familiar:GetData().Data = {lineOfSightDist = 450, lineOfSightAngle = 40, tankVelocityMul = 3.5, 
										tankAttackBuffer = 8, currBuffer = 0, projectileVelocityMul = 20, newRoomAttackHold = 5}
		else
			Familiar:GetData().Data = {lineOfSightDist = 300, lineOfSightAngle = 10, tankVelocityMul = 1.75, 
										tankAttackBuffer = 90, currBuffer = 0, projectileVelocityMul = 10, newRoomAttackHold = 60}
		end		
	end
	
	if Familiar.Variant == CustomFamiliars.SIBLING_1 or Familiar.Variant == CustomFamiliars.SIBLING_2 or Familiar.Variant == CustomFamiliars.FIGHTING_SIBLINGS then
		Familiar:AddToOrbit(25)
		fSprite:Play("Idle")
		fSprite.PlaybackSpeed = 0.75
	end
	
	if Familiar.Variant == CustomFamiliars.SPIRITUAL_RESERVES_MOON or Familiar.Variant == CustomFamiliars.SPIRITUAL_RESERVES_SUN then
		Familiar:AddToOrbit(30)
	end
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, rplus.FamiliarInit)

function rplus:FamiliarUpdate(Familiar)
	--[[ VANILLA --]]
		if Familiar.Variant == FamiliarVariant.WISP
		and Familiar.FrameCount == 5 and Familiar.Player:HasTrinket(CustomTrinkets.TORN_PAGE) then
			Familiar.MaxHitPoints = Familiar.MaxHitPoints * 1.5
			Familiar.HitPoints = Familiar.MaxHitPoints
		end
		
		if Familiar.Variant == FamiliarVariant.ISAACS_HEART
		and Isaac.GetChallenge() == CustomChallenges.IN_THE_LIGHT 
		and Familiar.FrameCount <= 10 then
			Familiar:GetSprite():Load("gfx/challenge_isaacs_tv.anm2", true)
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
		Familiar.Friction = 0
		
		if game:GetRoom():IsClear() then
			Familiar:GetSprite():Play("Collect")
			if Familiar:GetSprite():IsFinished("Collect") then
				Familiar:Remove()
				Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, Familiar.Position, Vector.Zero, nil)
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
			local Tear = Familiar:FireProjectile(TearVector):ToTear()
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
	
	if Familiar.Variant == CustomFamiliars.TOY_TANK_1 or Familiar.Variant == CustomFamiliars.TOY_TANK_2 then 
		-- moving around (BASEMENT DRIFT YOOO)
		-- change direction naturally; they change direction when colliding with grid automatically
		if game:GetFrameCount() % 48 == 0 then
			Familiar.Velocity = VECTOR_CARDINAL[math.random(#VECTOR_CARDINAL)] * Familiar:GetData().Data.tankVelocityMul
		end
		
		-- correct the velocity when colliding with grid so that the tanks don't move diagonally
		local TX = Familiar.Velocity.X
		local TY = Familiar.Velocity.Y
		if TY > 0 and TX <= TY and TX >= -TY then
			Familiar.Velocity = VECTOR_CARDINAL[1] * Familiar:GetData().Data.tankVelocityMul
		elseif TX > 0 and TY < TX and TY > -TX then
			Familiar.Velocity = VECTOR_CARDINAL[4] * Familiar:GetData().Data.tankVelocityMul
		elseif TX <= 0 and TY < -TX and TY > TX then
			Familiar.Velocity = VECTOR_CARDINAL[2] * Familiar:GetData().Data.tankVelocityMul
		else
			Familiar.Velocity = VECTOR_CARDINAL[3] * Familiar:GetData().Data.tankVelocityMul
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
				
				if game:GetRoom():CheckLine(enemy.Position, Familiar.Position, 3, 0, false, false) and 
				math.abs(curVel:GetAngleDegrees() - posDiff:GetAngleDegrees()) < Familiar:GetData().Data.lineOfSightAngle then
					if game:GetFrameCount() > Familiar:GetData().Data.currBuffer + Familiar:GetData().Data.tankAttackBuffer 
					and game:GetRoom():GetFrameCount() > Familiar:GetData().Data.newRoomAttackHold then
						if Familiar.Variant == CustomFamiliars.TOY_TANK_1 then
							local tankBullet = Isaac.Spawn(2, TearVariant.METALLIC, 0, Familiar.Position, posDiff * Familiar:GetData().Data.projectileVelocityMul, nil):ToTear()
							tankBullet.CollisionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 7 or 3.5)
							
							if Sewn_API then
								if Sewn_API:GetLevel(Familiar:GetData()) >= 1 then
									tankBullet:AddTearFlags(TearFlags.TEAR_HOMING)
								end
								
								if Sewn_API:GetLevel(Familiar:GetData()) == 2 then
									for _, familiarInRoom in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, CustomFamiliars.TOY_TANK_2, -1, false, false)) do
										local tankLaser = EntityLaser.ShootAngle(2,	familiarInRoom.Position, (enemy.Position - familiarInRoom.Position):Normalized():GetAngleDegrees(), 7, Vector.Zero, familiarInRoom)
										tankLaser.CollisionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 7 or 3.5)
									end
								end
							end
						elseif Familiar.Variant == CustomFamiliars.TOY_TANK_2 then
							local tankRocket = Isaac.Spawn(4, 19, 0, Familiar.Position, Vector.Zero, nil):ToBomb()
							tankRocket.SpriteScale = Vector(0.6, 0.6)
							tankRocket:GetData().forcedRocketTargetVel = curVel * Familiar:GetData().Data.projectileVelocityMul
							tankRocket.ExplosionDamage = (Familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 70 or 35)
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
			
			-- randomly shooting tooth tears and spawning blood creep
			if game:GetFrameCount() % 12 == 0 then
				local toothTear = Familiar:FireProjectile(Vector.FromAngle(math.random(360)))
				toothTear:ChangeVariant(TearVariant.TOOTH)
				toothTear.Velocity = toothTear.Velocity / 2
			end
			
			if game:GetFrameCount() % 18 == 0 then
				local creepPuddle = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, Familiar.Position, Vector.Zero, nil):ToEffect()
			end
		end
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

			if Player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
				Familiar.FireCooldown = 12
			else
				Familiar.FireCooldown = 18
			end
		end

		Familiar.FireCooldown = Familiar.FireCooldown - 1
	end
	
	if Familiar.Variant == CustomFamiliars.SPIRITUAL_RESERVES_MOON or Familiar.Variant == CustomFamiliars.SPIRITUAL_RESERVES_SUN then
		local s = Familiar:GetSprite()
		local Player = Familiar.Player
		Familiar.Velocity = Familiar:GetOrbitPosition(Familiar.Player.Position + Familiar.Player.Velocity) - Familiar.Position
		Familiar.OrbitDistance = Vector(20, 20)
		Familiar.OrbitSpeed = 0.03
		
		if Familiar.Keys == 3 then
			for i = 0, 1 do Familiar:GetSprite():ReplaceSpritesheet(i, "gfx/familiar/10a_fettered_soul.png") end
			Familiar:GetSprite():LoadGraphics()
		end
		
		if Familiar:GetData()['BlockedShots'] == 3 then
			Familiar:GetData()['BlockedShots'] = 0
			s:Play("Death")
			sfx:Play(SoundEffect.SOUND_ISAACDIES, 1, 2, false, 1.5, 0)
			s.PlaybackSpeed = 1
		end
		
		if s:IsPlaying("Death") then
			if s:IsEventTriggered("Remove") then
				Familiar:Remove()
				if Familiar.Variant == CustomFamiliars.SPIRITUAL_RESERVES_MOON then 
					Player:GetData()['usedSpiritualReserves'][1] = Player:GetData()['usedSpiritualReserves'][1] - 1
				else 
					Player:GetData()['usedSpiritualReserves'][2] = Player:GetData()['usedSpiritualReserves'][2] - 1 
				end
				Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
				Player:EvaluateItems()
				Isaac.Spawn(5, 10, HeartSubType.HEART_HALF_SOUL, Familiar.Position, Vector.Zero, Familiar)
			end
		else
			local name
			if Familiar.Variant == CustomFamiliars.SPIRITUAL_RESERVES_MOON then name = 'Moon' else name = 'Sun' end
			local TearVector
			
			if Player:GetFireDirection() == Direction.NO_DIRECTION then
				s:Play("Float_" .. name)
				s.PlaybackSpeed = 0.5
			else
				TearVector = DIRECTION_VECTOR[Player:GetFireDirection()]
				s:Play("Shoot_" .. name)
			end
			
			if Player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and #Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true) > 0 then
				TearVector = (Isaac.FindByType(1000, EffectVariant.TARGET, -1, false, true)[1].Position - Familiar.Position):Normalized()
				s:Play("Shoot_" .. name)
			end
			
			if Familiar.FireCooldown <= 0 and TearVector then
				local Tear = Familiar:FireProjectile(TearVector):ToTear()
				Tear.TearFlags = Tear.TearFlags | TearFlags.TEAR_SPECTRAL
				Tear.CollisionDamage = Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 4 or 2
				Tear:Update()

				Familiar.FireCooldown = 24
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
				local roll2
				if roll == 1 then
					roll2 = rng:RandomInt(5) + 1
				elseif roll == 3 then
					roll2 = rng:RandomInt(14) + 1
				elseif roll == 4 then
					roll2 = rng:RandomInt(8) + 1
				elseif roll == 5 then
					roll2 = rng:RandomInt(6) + 1
				else
					roll2 = 0
				end
				
				fsp.PlaybackSpeed = 0.5
				fsp:Play("Spawn")
				Isaac.Spawn(3, friends[roll], roll2, Familiar.Position, Vector.Zero, Familiar.Player)
			end
			
			Familiar.RoomClearCount = 0
		end
	end
	
	if Familiar.Variant >= CustomFamiliars.ULTRA_FLESH_KID_L1 and Familiar.Variant <= CustomFamiliars.ULTRA_FLESH_KID_L3 then
		local d = Familiar:GetData()
		local sprite = Familiar:GetSprite()
		
		if not d.helper then
			for _, leech in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEECH)) do
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
				--[[if Familiar:GetData()['heartToChase'] then
					d.helper.Velocity = (Familiar:GetData()['heartToChase'].Position - d.helper.Position):Normalized() * 4
				else
					Familiar:GetData()['heartToChase'] = findClosestHeart(d.helper, getRedHeartPickups())
				end]]
				
				for _, h in pairs(getRedHeartPickups()) do
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
								Player:GetData()['UFCLevel'] = 2
							else
								Player:GetData()['UFCLevel'] = 3
							end
							Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
							Player:EvaluateItems()
						end
						d.familiarState = "normal"
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
			for _, e in pairs(Isaac.FindByType(1000, PlacardBorder)) do
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
					
					if (enemy:IsDead() or enemy:HasMortalDamage()) and not enemy:GetData().placardDeathBurst then
						rng:SetSeed(enemy.DropSeed, 1)
						local roll = rng:RandomInt(2) + 1
						
						for i = 1, roll do
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
end
rplus:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, rplus.FamiliarUpdate)

function rplus:FamiliarCollision(Familiar, Collider, _)
	if Familiar.Variant == CustomFamiliars.CHERRY then
		if Collider:IsActiveEnemy(true) and not Collider:IsBoss() and game:GetFrameCount() % 10 == 0 then
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
			Player:TryRemoveNullCostume(Costumes.BIRD_OF_HOPE)
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
				Familiar:GetData().attachmentFrames = ENRAGED_SOUL_COOLDOWN / 2
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
				--local newBomb = Isaac.Spawn(4, 0, 0, Bomb.Position, Bomb.Velocity, nil):ToBomb()
				local newBomb = Player:FireBomb(Bomb.Position, Bomb.Velocity, nil)
				newBomb:AddTearFlags(Player:GetData().bombFlags)
				newBomb:SetExplosionCountdown(1)
				newBomb:GetData()['isNewBomb'] = true
				Bomb:Remove()
			end		
		end
	end
	
	-- helper function for pointing Tank Boy's rockets in a right direction
	if Bomb.Variant == BombVariant.BOMB_ROCKET then
		if Bomb:GetData().forcedRocketTargetVel then
			Bomb.Velocity = Bomb:GetData().forcedRocketTargetVel
			Bomb.SpriteRotation = Bomb:GetData().forcedRocketTargetVel:GetAngleDegrees()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, rplus.BombUpdate)


						-- MC_POST_KNIFE_UPDATE --									
						--------------------------
function rplus:KnifeUpdate(Knife)
	if Knife.FrameCount == 1 then
		if Knife.Parent then
			local Player = Knife.Parent:ToPlayer()
		elseif Knife.SpawnerEntity then
			local Player = Knife.SpawnerEntity:ToPlayer()
		end
		
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
	-- prevent familiars soaking projectiles shot by friendly monsters
	if Projectile:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then return end

	if Collider.Type == 3 then
		if Collider.Variant == CustomFamiliars.BAG_O_TRASH then
			Projectile:Remove()
			rng:SetSeed(Random() + 1, 1)
			local roll = rng:RandomFloat() * 100
			
			if roll < TRASHBAG_BREAK_CHANCE 
			and (not Sewn_API or (Sewn_API and Sewn_API:GetLevel(Collider:ToFamiliar():GetData()) < 1)) then
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 1, false, 1, 0)
				Collider:ToFamiliar().Player:RemoveCollectible(CustomCollectibles.BAG_O_TRASH)
				if roll < 66 then
					Isaac.Spawn(5, 100, CollectibleType.COLLECTIBLE_BREAKFAST, Collider.Position, Vector.Zero, Collider)
				else
					Isaac.Spawn(5, 350, CustomTrinkets.NIGHT_SOIL, Collider.Position, Vector.Zero, Collider)
				end
			end
		end
		
		if Collider.Variant == CustomFamiliars.SIBLING_1 or
		Collider.Variant == CustomFamiliars.SIBLING_2 or 
		Collider.Variant == CustomFamiliars.FIGHTING_SIBLINGS then
			Projectile:Remove()
		end
		
		if (Collider.Variant == CustomFamiliars.SPIRITUAL_RESERVES_MOON or
		Collider.Variant == CustomFamiliars.SPIRITUAL_RESERVES_SUN)
		and not Collider:GetSprite():IsPlaying("Death") then
			Projectile:Remove()
			
			if not Collider:GetSprite():IsOverlayPlaying("Hit") then
				Collider:GetData()['BlockedShots'] = Collider:GetData()['BlockedShots'] and Collider:GetData()['BlockedShots'] + 1 or 1
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
	rng:SetSeed(room:GetAwardSeed(), 1)
	local roll = rng:RandomFloat() * 100
	
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		
	--[[ UNLOCK STUFF --]]
	local mark = getFinalBossMark()
	if mark and isMarkUnlocked(Player, mark) == false then 
		unlockMark(Player, mark)
		playAchievementPaper(Player:GetPlayerType(), mark)
	end
	--
		
		if Player:HasCollectible(CustomCollectibles.RED_KING) and room:GetType() == RoomType.ROOM_BOSS and level:GetStage() < 8 then
			if level:GetCurrentRoomDesc().Data.Weight == 0 
			and level:GetCurrentRoomDesc().Data.Variant >= 44000 and level:GetCurrentRoomDesc().Data.Variant < 44200 then
				-- these are special boss rooms used by Red King
				for i, v in pairs(CustomData.Data.Items.RED_KING.redCrawlspacesData) do
					if v.associatedRoom == level:GetCurrentRoomDesc().Data.Variant then
						v.isRoomDefeated = true
					end
				end
				local Item1 = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				local Item2 = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), room:FindFreePickupSpawnPosition(c + Vector(-40, 40), 10, true, false), Vector.Zero, nil)
					Item1:ToPickup().OptionsPickupIndex = 7
					Item2:ToPickup().OptionsPickupIndex = Item1:ToPickup().OptionsPickupIndex
				return true
			elseif level:GetCurrentRoomDesc().Data.Weight > 0 then
				-- these are normal boss rooms
				local roll = rng:RandomInt(4)
				local chapterAdd = (level:GetStage() + 1) // 2
				local isAltPath = level:GetStageType() > 3 and 100 or 0
				
				local redCrawlspace = Isaac.Spawn(6, 334, 0, c, Vector.Zero, nil)
				redCrawlspace.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				redCrawlspace:GetSprite():Play("OpenAnim")
				table.insert(CustomData.Data.Items.RED_KING.redCrawlspacesData, {seed = redCrawlspace.InitSeed,
																			associatedRoom = 44000 + isAltPath + chapterAdd * 10 + roll,
																			isRoomDefeated = false})
				break	-- so that multiple crawlspaces don't generate for multiple players														
			end
		end
		
		if CustomData.Data.Items.VAULT_OF_HAVOC.Data and level:GetCurrentRoomDesc().Data.Weight == 0 
		and level:GetCurrentRoomDesc().Data.Variant >= 55000 and level:GetCurrentRoomDesc().Data.Variant < 55010 then
			-- spawn reward after clearing Vault of Havoc room
			if CustomData.Data.Items.VAULT_OF_HAVOC.SumHP < 120 + 25 * level:GetStage() then 
				Isaac.Spawn(5, 10, HeartSubType.HEART_FULL, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, 10, HeartSubType.HEART_SOUL, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, 10, HeartSubType.HEART_GOLDEN, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
			elseif CustomData.Data.Items.VAULT_OF_HAVOC.SumHP < 140 + 30 * level:GetStage() then
				Isaac.Spawn(5, PickupVariant.PICKUP_CHEST, 0, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, PickupVariant.PICKUP_LOCKEDCHEST, 0, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
				Isaac.Spawn(5, 350, 0, room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
			else
				Isaac.Spawn(5, 100, GetUnlockedVanillaCollectible(true, true), room:FindFreePickupSpawnPosition(c + Vector(40, 40), 10, true, false), Vector.Zero, nil)
			end
			
			CustomData.Data.Items.VAULT_OF_HAVOC.EnemyList = {}
			CustomData.Data.Items.VAULT_OF_HAVOC.Data = false 
			CustomData.Data.Items.VAULT_OF_HAVOC.SumHP = 0
			return true
		end
		
		if Player:GetData()['enhancedSB'] and room:GetType() == RoomType.ROOM_BOSS 
		and level:GetStage() < 8 and level:GetStage() ~= 6 then
			if Player:HasCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS) then
				for i = 1, 3 do
					local it = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), room:FindFreePickupSpawnPosition(c + Vector(-160 + 80*i, 80), 10, true, false), Vector.Zero, nil):ToPickup()
					it.OptionsPickupIndex = 666
					it.Price = -1
					it.AutoUpdatePrice = true
				end
			else
				for i = 1, 2 do
					local it = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), room:FindFreePickupSpawnPosition(c + Vector(-120 + 80*i, 80), 10, true, false), Vector.Zero, nil):ToPickup()
					it.OptionsPickupIndex = 666
					it.Price = -1
					it.AutoUpdatePrice = true
				end
			end
			room:DestroyGrid(room:GetGridIndex(c + Vector(0, -80)), true)
			Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, c + Vector(0, -80), true)
			return true
		end
		
		if Player:GetData().JewelData_LUST == "isExtra" then
			local roll = rng:RandomFloat() * 100
			
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
					Isaac.Spawn(5, subt[2][1], subt[2][2], game:GetRoom():FindFreePickupSpawnPosition(Pos, 0, true, false), Vector.Zero, nil)
					break
				end
			end
			
			Player:GetData().JewelData_LUST = nil
			return true
		end
		
		if CustomData.Data and CustomData.Data.TaintedHearts.SOILED > 0 and i == 0 then 
			for i = 1, CustomData.Data.TaintedHearts.SOILED * 2 do
				local randomdip = rng:RandomInt(45)
				
				if randomdip < 15 then 
					Isaac.Spawn(3, FamiliarVariant.DIP, randomdip, Player.Position, Vector.Zero, Player)
				end	
			end
		end
	end
	
	if roll < JACK_CHANCE and CustomData.Data.Cards.JACK.Type ~= ""
	and room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_BOSSRUSH then
		for i = 1, (CustomData.Data.Cards.JACK.FLAG_OPTIONS_SPECIAL and 2 or 1) do
			local Variant
			local SubType
			local roll = rng:RandomFloat() * 100
			
			if CustomData.Data.Cards.JACK.Type == "Diamonds" then
				Variant = 20
				
				if roll < 80 then
					SubType = 1 --penny
				elseif roll < 95 then
					SubType = 2 --nickel 
				else
					SubType = 3 --dime
				end
			elseif CustomData.Data.Cards.JACK.Type == "Clubs" then
				Variant = 40
				
				if roll < 80 then
					SubType = 1 --bomb
				else
					SubType = 2	--double bomb
				end
			elseif CustomData.Data.Cards.JACK.Type == "Spades" then
				Variant = 30
				
				if roll < 80 then
					SubType = 1 --key
				elseif roll < 95 then
					SubType = 3	--double key
				else
					SubType = 4 --charged key
				end
			elseif CustomData.Data.Cards.JACK.Type == "Hearts" then
				Variant = 10
				
				if roll < 40 then
					SubType = 1 --Heart
				elseif roll < 60 then
					SubType = 2 --Half Heart
				elseif roll < 70 then
					SubType = 5 --Double Heart
				elseif roll < 85 then
					SubType = 3 --Soul Heart
				elseif roll < 93 then
					SubType = 10 --Blended Heart
				elseif roll < 98 then
					SubType = 6  --Black Heart
				else
					SubType = 4  --Eternal Heart
				end
			end
			
			local p = Isaac.Spawn(5, Variant, SubType, game:GetRoom():FindFreePickupSpawnPosition(Pos, 20, true, false), Vector.Zero, nil):ToPickup()
			p.OptionsPickupIndex = 2
		end
		return true
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, rplus.PickupAwardSpawn)


						-- MC_GET_PILL_EFFECT --							
						------------------------
function rplus:ChangePillEffects(pillEffect, pillColor)
	for _, e in pairs({CustomPills.PHANTOM_PAINS, CustomPills.YUM, CustomPills.YUCK, CustomPills.ESTROGEN, CustomPills.LAXATIVE}) do
		if pillEffect == e and not isPillEffectUnlocked(e) then
			return PillEffect.PILLEFFECT_EXPERIMENTAL
		end
	end

	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_PHD)
		or Player:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO) 
		or Player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
			if pillEffect == CustomPills.PHANTOM_PAINS then
				return PillEffect.PILLEFFECT_FULL_HEALTH
			end
		end
		
		if Player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then
			if pillEffect == CustomPills.YUM or pillEffect == CustomPills.YUCK
			or pillEffect == CustomPills.ESTROGEN then
				return PillEffect.PILLEFFECT_ADDICTED
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, rplus.ChangePillEffects)


						-- MC_POST_EFFECT_UPDATE --							
						---------------------------
function rplus:PostEffectUpdate(Effect)
	-- helper for killing stargazer beggars and opening coffins when the explosion is nearby
	if Effect.Variant == EffectVariant.BOMB_EXPLOSION or Effect.Variant == EffectVariant.MAMA_MEGA_EXPLOSION then
		local trueExplosionDist = Effect.Variant == EffectVariant.MAMA_MEGA_EXPLOSION and 1500 or 90
	
		for _, slot in pairs(Isaac.FindByType(6, CustomPickups.SLOT_STARGAZER, -1, false, true)) do
			if slot.Position:Distance(Effect.Position) <= trueExplosionDist then
				slot:Kill()
				slot:Remove()
				game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
			end
		end
		
		for _, cof in pairs(Isaac.FindByType(5, CustomPickups.COFFIN, -1)) do
			if cof.Position:Distance(Effect.Position) <= trueExplosionDist 
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
						CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME = game:GetFrameCount()
						for j = 1, 2 do
							Isaac.Spawn(5, 10, HeartSubType.HEART_BONE, cof.Position, Vector.FromAngle(math.random(360)) * 3, cof)
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
	
	if Effect.Variant == FallingKnifeHelper then
		local s = Effect:GetSprite()
		
		if s:IsEventTriggered("Fall") then
			Effect.SpawnerEntity:TakeDamage(Effect:GetData().Damage, 0, EntityRef(Effect), 0)
		elseif s:IsEventTriggered("Remove") then
			Effect:Remove()
		end
	end
	
	-- cripple hands
	if Effect.Variant == CripplingHandsHelper then
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
							p.SubType = 1
							p:GetData()["IsInRoom"] = true
							p:GetSprite():Play("Open")
							sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
							rng:SetSeed(p.DropSeed, 1)
							local DieRoll = rng:RandomFloat() * 100
							
							if DieRoll < 30 then
								local newID = GetUnlockedCollectibleFromCustomPool(CustomItempools.FLESH_CHEST)
								local fleshChest = Isaac.Spawn(5, 100, newID, p.Position, Vector(0, 0), p)
								fleshChest:GetSprite():ReplaceSpritesheet(5, "gfx/items/fleshchest_itemaltar.png") 
								fleshChest:GetSprite():LoadGraphics()
								p:Remove()
							else
								local NumOfPickups = rng:RandomInt(4) + 3 -- 3 to 6 pickups
								
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
										
										Isaac.Spawn(5, 10, heart, p.Position, Vector.FromAngle(math.random(360)) * 4, p)
									else
										Isaac.Spawn(5, 70, 0, p.Position, Vector.FromAngle(math.random(360)) * 4, p)
									end
								end
								
								local t = GetUnlockedTrinketFromCustomPool(CustomItempools.FLESH_CHEST_TRINKETS)
								if t then Isaac.Spawn(5, 350, t, p.Position, Vector.FromAngle(math.random(360)) * 4, p) end
							end
						elseif s == CustomPickups.BLACK_CHEST then
							p:GetData()["IsInRoom"] = true
							p:GetSprite():Play("Open")
							sfx:Play(SoundEffect.SOUND_CHEST_OPEN)
							rng:SetSeed(Random() + 1, 1)
							local DieRoll = rng:RandomFloat() * 100
							
							if DieRoll < 15 then
								local BlackChestPedestal = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_CURSE, false, Random() + 1, CollectibleType.COLLECTIBLE_NULL), p.Position, Vector(0, 0), p)
								BlackChestPedestal:GetSprite():ReplaceSpritesheet(5,"gfx/items/blackchest_itemaltar.png") 
								BlackChestPedestal:GetSprite():LoadGraphics()
								p:Remove()
							elseif DieRoll < 70 then
								p.SubType = 2
								p:GetData()['OpenFrame'] = game:GetFrameCount()
								local roll = rng:RandomFloat() * 100
								
								for i, v in pairs(DropTables.BLACK_CHEST) do
									if roll < DropTables.BLACK_CHEST[i][1] then
										for x, y in pairs(DropTables.BLACK_CHEST[i][2]) do
											Isaac.Spawn(5, y[1], y[2], p.Position, Vector.FromAngle(math.random(360)) * 3, p)
										end
										break
									end
								end
							else
								p.SubType = 1		
							end
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
								CustomData.Data.TaintedHearts.HEART_NO_MORPH_FRAME = game:GetFrameCount()
								for j = 1, 2 do
									Isaac.Spawn(5, 10, HeartSubType.HEART_BONE, p.Position, Vector.FromAngle(math.random(360)) * 3, p)
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


						-- MC_GET_SHADER_PARAMS --										
						--------------------------
function rplus:GetShaderParams(shaderName)
	if not CustomData.Data then return end
	-- only used for rendering Tainted hearts, and ONLY FOR THE MAIN PLAYER !!!
	if shaderName == 'Hearts' then
		HeartRender(Isaac.GetPlayer(0), CustomData.Data.TaintedHearts.MISER, "Miser")
		HeartRender(Isaac.GetPlayer(0), CustomData.Data.TaintedHearts.SOILED, "Soiled")
		HeartRender(Isaac.GetPlayer(0), CustomData.Data.TaintedHearts.BALEFUL, "Baleful")
		HeartRender(Isaac.GetPlayer(0), CustomData.Data.TaintedHearts.DAUNTLESS, "Dauntless")
		HeartRender(Isaac.GetPlayer(0), CustomData.Data.TaintedHearts.ZEALOT, "Zealot")
		HeartRender(Isaac.GetPlayer(0), CustomData.Data.TaintedHearts.EMPTY, "Empty")
		return nil
	end
end
rplus:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, rplus.GetShaderParams)


---------------------------------------------------------
-- helpers for animating the Angel's Wings' item pedestal
-- code shamelessly stolen from THE ANIMATED ITEMS MOD
function rplus:PostPickupRender(pickup)
	if pickup.SubType == CustomCollectibles.ANGELS_WINGS 
	and game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND ~= LevelCurse.CURSE_OF_BLIND
	and not hasEffectOnIt(pickup) then
		Isaac.Spawn(1000, AnimatedItemDummyEntity, 0, pickup.Position, Vector.Zero, pickup)
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
rplus:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, rplus.PostEffectInit, AnimatedItemDummyEntity)

function rplus:PostEffectRender(effect)
	local spawner = effect.SpawnerEntity
	if not spawner then effect:Remove() end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local Player = Isaac.GetPlayer(i)
		
		if Player.QueuedItem.Item and Player.QueuedItem.Item.ID == CustomCollectibles.ANGELS_WINGS then
			if not hasEffectOnIt(Player) then
				effect:Remove()
				Isaac.Spawn(1000, AnimatedItemDummyEntity, 0, Player.Position, Vector.Zero, Player)
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
rplus:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, rplus.PostEffectRender, AnimatedItemDummyEntity)


								----------------------------------
								--- EXTERNAL ITEM DESCRIPTIONS ---
								----------------------------------
								
if EID then
	include("scripts/EID.lua")
end

								---------------------
								--- ENCYCLOPEDIA  ---
								---------------------

if Encyclopedia then	
	include("scripts/Encyclopedia.lua")
end

								----------------
								--- MINIMAPI ---
								----------------
if MinimapAPI then
	include("scripts/MinimAPI.lua")
end

								----------------------
								--- SEWING MACHINE ---
								----------------------
if Sewn_API then
	-- Tank Boys
	Sewn_API:MakeFamiliarAvailable(CustomFamiliars.TOY_TANK_1, CustomCollectibles.TANK_BOYS)
	Sewn_API:AddFamiliarDescription(CustomFamiliars.TOY_TANK_1, 'The green Tank Boy gains homing ammunition', 'Red Tank Boy will fire lasers at whatever enemy is attacked by the green Tank Boy')
	
	-- Bag-o-Trash
	Sewn_API:MakeFamiliarAvailable(CustomFamiliars.BAG_O_TRASH, CustomCollectibles.BAG_O_TRASH)
    Sewn_API:AddFamiliarDescription(CustomFamiliars.BAG_O_TRASH, 'Bag can no longer be destroyed', 'Bag will also spawn blue spiders on room clear')
	
	-- Cherubim
    Sewn_API:MakeFamiliarAvailable(CustomFamiliars.CHERUBIM, CustomCollectibles.CHERUBIM)
    Sewn_API:AddFamiliarDescription(CustomFamiliars.CHERUBIM, 'Cherubim gains increased God Head aura size and tear damage', 'Cherubim gains Pop! tears')
end

								-------------
								--- S & G ---
								-------------
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


































