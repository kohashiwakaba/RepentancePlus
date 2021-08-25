
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
local rplus = RegisterMod("Repentance Plus", 1)
local sfx = SFXManager()
local music = MusicManager()
local rdm = RNG()
local CustomData

local BASEMENTKEY_CHANCE = 5	-- chance to replace golden chest with the old chest
local HEARTKEY_CHANCE = 5	-- chance for enemy to drop Scarlet chest on death
local SCARLETCHEST_CHANCE = 2	-- chance for Scarlet chest to appear normally
local CARDRUNE_REPLACE_CHANCE = 2	-- chance to replace vanilla card with card from our mod
local SUPERBERSERKSTATE_CHANCE = 25		-- chance to enter berserk state via Temper Tantrum
local SUPERBERSERK_DELETE_CHANCE = 10	-- chance to erase enemies while in this state
local TRASHBAG_BREAK_CHANCE = 1		-- chance of Bag o' Trash breaking
local CHERRY_SPAWN_CHANCE = 20		-- chance to spawn cherry friend on enemy death
local SLEIGHTOFHAND_CHANCE = 12		-- chance to save your consumable when using it via Sleight of Hand
local JACKOF_CHANCE = 50	-- chance for Jack cards to spawn their respective type of pickup
local BITTENPENNY_UPGRADECHANCE = 20	-- chance to 'upgrade' coins via Bitten Penny
local REDKEY_TURN_CHANCE = 25		-- chance for any card to turn into Cracked Key via Red Map trinket

Costumes = {
	ORDLIFE = Isaac.GetCostumeIdByPath("gfx/characters/costume_001_ordinarylife.anm2"),
	CHERRYFRIENDS = Isaac.GetCostumeIdByPath("gfx/characters/costume_002_cherryfriends.anm2")
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
	MISSINGMEMORY = Isaac.GetItemIdByName("The Missing Memory"),
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
	BIRDOFHOPE = Isaac.GetItemIdByName("Bird of Hope"),
	ENRAGEDSOUL = Isaac.GetItemIdByName("Enraged Soul"),
	CEREMDAGGER = Isaac.GetItemIdByName("Ceremonial Dagger"),
	ADAMSRIB = Isaac.GetItemIdByName("Adam's Rib")
}

Trinkets = {
	BASEMENTKEY = Isaac.GetTrinketIdByName("Basement Key"),
	KEYTOTHEHEART = Isaac.GetTrinketIdByName("Key to the Heart"),
	SLEIGHTOFHAND = Isaac.GetTrinketIdByName("Sleight of Hand"),
	JUDASKISS = Isaac.GetTrinketIdByName("Judas' Kiss"),
	BITTENPENNY = Isaac.GetTrinketIdByName("Bitten Penny"),
	GREEDSHEART = Isaac.GetTrinketIdByName("Greed's Heart"),
	ANGELSCROWN = Isaac.GetTrinketIdByName("Angel's Crown"),
	REDMAP = Isaac.GetTrinketIdByName("Red Map")
}

PocketItems = {
	RJOKER = Isaac.GetCardIdByName("Joker?"),
	SDDSHARD = Isaac.GetCardIdByName("Spindown Dice Shard"),
	REVERSECARD = Isaac.GetCardIdByName("Reverse Card"),
	REDRUNE = Isaac.GetCardIdByName("Red Rune"),
	KINGOFSPADES = Isaac.GetCardIdByName("King of Spades"),
	NEEDLEANDTHREAD = Isaac.GetCardIdByName("Needle and Thread"),
	QUEENOFDIAMONDS = Isaac.GetCardIdByName("Queen of Diamonds"),
	BAGTISSUE = Isaac.GetCardIdByName("Bag Tissue"),
	LOADEDDICE = Isaac.GetCardIdByName("Loaded Dice"),
	JACKOFDIAMONDS = Isaac.GetCardIdByName("Jack of Diamonds"),
	JACKOFCLUBS = Isaac.GetCardIdByName("Jack of Clubs"),
	JACKOFSPADES = Isaac.GetCardIdByName("Jack of Spades"),
	JACKOFHEARTS = Isaac.GetCardIdByName("Jack of Hearts"),
	BEDSIDEQUEEN = Isaac.GetCardIdByName("Bedside Queen")
}

PickUps = {
	SCARLETCHEST = Isaac.GetEntityVariantByName("Scarlet Chest")
}

Pills = {
	ESTROGEN = Isaac.GetPillEffectByName("Estrogen")
}

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

ScarletChestHearts = {
	1, 2, 5, 10 --every Heart with red in it which is automatically unlocked
}

StatUps = {
	SINNERSHEART_DMG_MUL = 1.5,
	SINNERSHEART_DMG_ADD = 2,
	SINNERSHEART_SHSP = -0.3,
	SINNERSHEART_TEARHEIGHT = -3, --negative TearHeight = positive Range
	--
	MARKCAIN_DMG = 0.3,
	--
	LOADEDDICE_LUCK = 10
}

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
	  if k ~= REDRUNE then table.insert(keys, k) end
	end

	local random_key = keys[math.random(1, #keys)]
	return PocketItems[random_key]
end

-- Is this collectible unlocked?
local function IsCollectibleUnlocked(collectibleType)
	local isUnlocked = false
	local itemPool = game:GetItemPool()
	local player = Isaac.GetPlayer(0)
	local hasChaos = false
	
	itemPool:AddRoomBlacklist(CollectibleType.COLLECTIBLE_SAD_ONION)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) == true then
		player:RemoveCollectible(CollectibleType.COLLECTIBLE_CHAOS)
		hasChaos = true
	end
	local seed = game:GetSeeds():GetNextSeed()
	local testCollectible = itemPool:GetCollectible(ItemPoolType.POOL_24, false, seed)
	if testCollectible == collectibleType then
		isUnlocked = true
	end
	if hasChaos == true then
		player:AddCollectible(CollectibleType.COLLECTIBLE_CHAOS, 0, false)
	end
	itemPool:ResetRoomBlacklist()
	
	return isUnlocked	
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
								----------------------
								-- GLOBAL FUNCTIONS --
								----------------------

						-- GAME STARTED --
						------------------
function rplus:OnGameStart(Continued)
	if not Continued then
		CustomData = {
			Items = {
				BIRDOFHOPE = {NumRevivals = 0, BirdCaught = true},
				ORDLIFE = nil,
				MISSINGMEMORY = nil,
				RUBIKSCUBE = {Counter = 0},
				MARKCAIN = nil,
				BAGOTRASH = {Levels = 0},
				TEMPERTANTRUM = {ErasedEnemies = {}},
				ENRAGEDSOUL = {SoulLaunchCooldown = nil, AttachedEnemy = nil}
			},
			Cards = {
				REVERSECARD = nil,
				LOADEDDICE = {Data = false, Room = nil},
				JACK = nil
			},
			Trinkets = {
				GREEDSHEART = "CoinHeartEmpty"
			}
		}
		
		-- recalculating cache, just in case
		Isaac.GetPlayer(0):AddCacheFlags(CacheFlag.CACHE_ALL)
		Isaac.GetPlayer(0):EvaluateItems()
		
		--[[ Spawn items/trinkets or turn on debug commands for testing here if necessary
		! DEBUG: 3 - INFINITE HP, 4 - HIGH DAMAGE, 8 - INFINITE CHARGES, 10 - INSTAKILL ENEMIES !
		
		Isaac.Spawn(5, 350, Trinkets.TestTrinket, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.Spawn(5, 100, Collectibles.TestCollectible, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.ExecuteCommand("debug 0")
		
		--]]
		Isaac.Spawn(5, 350, Trinkets.REDMAP, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.Spawn(5, 350, Trinkets.GREEDSHEART, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		Isaac.Spawn(5, 350, Trinkets.ANGELSCROWN, Isaac.GetFreeNearPosition(Vector(320,280), 10.0), Vector.Zero, nil)
		--]]
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, rplus.OnGameStart)

						-- EVERY NEW LEVEL --
						---------------------
function rplus:OnNewLevel()
	local player = Isaac.GetPlayer(0)
	local level = game:GetLevel()
	
	if player:HasCollectible(Collectibles.ORDLIFE) and CustomData.Items.ORDLIFE == "used" then
		level:RemoveCurses(LevelCurse.CURSE_OF_DARKNESS)
		music:Enable()
		player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
		CustomData.Items.ORDLIFE = nil
	end
	
	if player:HasCollectible(Collectibles.BAGOTRASH) then
		CustomData.Items.BAGOTRASH.Levels = CustomData.Items.BAGOTRASH.Levels + 1
	end
	
	if CustomData then CustomData.Cards.JACK = nil end
	
	if player:HasTrinket(Trinkets.REDMAP) then
		local USR = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, true, RNG(), true))
		
		if USR.Data and USR.Data.Type == RoomType.ROOM_ULTRASECRET and USR.DisplayFlags & 1 << 2 == 0 then
			USR.DisplayFlags = USR.DisplayFlags | 1 << 2
			level:UpdateVisibility()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, rplus.OnNewLevel)

						-- EVERY NEW ROOM --
						--------------------
function rplus:OnNewRoom()
	local player = Isaac.GetPlayer(0)
	local level = game:GetLevel()
	local room = game:GetRoom()

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
	
	if player:HasTrinket(Trinkets.ANGELSCROWN) and room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then
		for i = 1, room:GetGridSize() do
			if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() ~= GridEntityType.GRID_DOOR then
				room:RemoveGridEntity(i, 0, false)
			end
		end
		Isaac.GridSpawn(GridEntityType.GRID_STATUE, 1, Vector(320,200), false)
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 then entity:Remove() end
		end
		
		local AngelItem = Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL, false, Random(), CollectibleType.COLLECTIBLE_NULL), Vector(320,280), Vector.Zero, nil):ToPickup()
		AngelItem.Price = 15
	end 
end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, rplus.OnNewRoom)

						-- ACTIVE ITEM USED --
						----------------------
function rplus:OnItemUse(ItemUsed, _, player, _, _, _)
	local level = game:GetLevel()
	local player = Isaac.GetPlayer(0)
	
	if ItemUsed == Collectibles.ORDLIFE then
		if not CustomData.Items.ORDLIFE then
			CustomData.Items.ORDLIFE = "used"
			music:Disable()
			level:AddCurse(LevelCurse.CURSE_OF_DARKNESS, false)
			PlayerSprite = player:GetSprite()
			PlayerSprite:Load("gfx/characters/costume_001_ordinarylife.anm2", true)
			return {Discharge = false, Remove = false, ShowAnim = false}
		elseif CustomData.Items.ORDLIFE == "used" then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, true, true, false, false, -1)
			return {Discharge = true, Remove = false, ShowAnim = true}
		end
	end
	
	if ItemUsed == Collectibles.COOKIECUTTER then
		player:AddMaxHearts(2, true)
		player:AddBrokenHearts(1)
		sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 2, false, 1, 0)
		if player:GetBrokenHearts() >= 12 then
			player:Die()
		end
		return true
	end
	
	if ItemUsed == Collectibles.RUBIKSCUBE then
		local SolveChance = math.random(100)
		
		if SolveChance <= 5 or CustomData.Items.RUBIKSCUBE.Counter == 20 then
			player:RemoveCollectible(Collectibles.RUBIKSCUBE, true, ActiveSlot.SLOT_PRIMARY, true)
			Isaac.Spawn(5, 100, Collectibles.MAGICCUBE, player.Position + Vector(20, 20), Vector.Zero, nil)
			player:AnimateHappy()
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
				repeat
					ID = math.random(729)
				until Isaac.GetItemConfig():GetCollectible(ID) and Isaac.GetItemConfig():GetCollectible(ID).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
				entity:ToPickup():Morph(5, 100, ID, true, false, true)
			end
		end
		return true
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_ITEM, rplus.OnItemUse)

						-- EVERY FRAME --
						-----------------
function rplus:OnFrame()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local player = Isaac.GetPlayer(0)
	local stage = level:GetStage()
	local sprite = player:GetSprite()
	
	if player:HasCollectible(Collectibles.ORDLIFE) and CustomData.Items.ORDLIFE == "used" then
		for i = 0,7 do
			door = room:GetDoor(i)
			if door then door:Open() end
		end
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type > 4 and entity.Type ~= 33 and entity.Type ~= 1000 and entity.Type ~= 17 then
				entity:Remove()
			end
		end
		if sfx:IsPlaying(SoundEffect.SOUND_DOOR_HEAVY_CLOSE) or sfx:IsPlaying(SoundEffect.SOUND_DOOR_HEAVY_OPEN) then
			sfx:Stop(SoundEffect.SOUND_DOOR_HEAVY_CLOSE)
			sfx:Stop(SoundEffect.SOUND_DOOR_HEAVY_OPEN)
		end
		if player:GetSprite():IsFinished("PickupWalkDown") then
			level:RemoveCurses(LevelCurse.CURSE_OF_DARKNESS)
			music:Enable()
			player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
			CustomData.Items.ORDLIFE = nil
		end
	end
	
	if player:HasCollectible(Collectibles.MISSINGMEMORY) then
		if CustomData.Items.MISSINGMEMORY == "dark" or CustomData.Items.MISSINGMEMORY == "light" then
			if player:GetSprite():IsPlaying("Trapdoor") or player:GetSprite():IsPlaying("LightTravel") then
				level:SetStage(LevelStage.STAGE4_2, 0)
				CustomData.Items.MISSINGMEMORY = nil
			end
		end
	end
	
	if CustomData and CustomData.Cards.REVERSECARD == "used" and sprite:IsFinished("PickupWalkDown") then
		secondary_Card = player:GetCard(1)
		player:SetCard(1, 0)
		player:SetCard(0, secondary_Card)
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
	
	if player:HasCollectible(Collectibles.MARKCAIN) then
		if sprite:IsPlaying("Death") and sprite:GetFrame() > 25 then
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
				player:Revive()
				sprite:Stop()
				CustomData.Items.MARKCAIN = "player revived"
				player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, UseFlag.USE_NOANIM, -1)
				sfx:Play(SoundEffect.SOUND_SUPERHOLY, 1, 2, false, 1, 0)
				
				for i = 1, #MyFamiliars do player:RemoveCollectible(MyFamiliars[i]) end
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
			end
		end
	end
	
	if player:HasCollectible(Collectibles.TEMPERTANTRUM) then
		if SUPERBERSERKSTATE and sfx:IsPlaying(SoundEffect.SOUND_BERSERK_END) then SUPERBERSERKSTATE = false end
		
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
	end
	
	if CustomData and CustomData.Cards.LOADEDDICE.Data and (game:GetLevel():GetCurrentRoomIndex() ~= CustomData.Cards.LOADEDDICE.Room) then
		CustomData.Cards.LOADEDDICE.Room = nil
		CustomData.Cards.LOADEDDICE.Data = false
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
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
		if sprite:IsPlaying("Death") and CustomData.Items.BIRDOFHOPE.BirdCaught then
			CustomData.Items.BIRDOFHOPE.BirdCaught = false
			DieFrame = game:GetFrameCount()
			CustomData.Items.BIRDOFHOPE.NumRevivals = CustomData.Items.BIRDOFHOPE.NumRevivals + 1
			
			player:Revive()
			sprite:Stop()
			player:UseCard(Card.CARD_SOUL_LOST, UseFlag.USE_NOANIM | UseFlag.USE_OWNED | UseFlag.USE_NOANNOUNCER)
			player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, UseFlag.USE_NOANIM, -1)
			
			Birdy = Isaac.Spawn(3, Familiars.BIRD, 0, room:GetCenterPos(), Vector.FromAngle(math.random(360)) * CustomData.Items.BIRDOFHOPE.NumRevivals, nil) 
			Birdy:GetSprite():Play("Flying")
		elseif DieFrame and game:GetFrameCount() > DieFrame + 120 and not CustomData.Items.BIRDOFHOPE.BirdCaught then
			player:Die()
			CustomData.Items.BIRDOFHOPE.BirdCaught = "blah blah"	-- just so that it's not true and player doesn't die over and over until all his extra lives deplete
			-- !!! THIS IS A SERIOUS CROTCH !!! since you end up near the door when reviving, and the bird familiar doesn't despawn if you don't catch her,
			-- you automatically pick her up and this allows you to repeat the cycle (since it switches data to true) and doesn't take away your extra lives
			-- so don't touch it if you don't think it through. like, for real.
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
			if Input.IsActionTriggered(i, 0) and not ButtonState then
				ButtonPressed = i
				ButtonState = "listening for second tap"
				PressFrame = game:GetFrameCount()
				--print('button ' .. ButtonPressed .. ' is pressed on frame ' .. PressFrame)
			end
		end
		
		if PressFrame and game:GetFrameCount() <= PressFrame + 4 then -- listening for next inputs in the next 4 frames
			if not Input.IsActionTriggered(ButtonPressed, 0) and ButtonState == "listening for second tap" then
				ButtonState = "button released"
			end
			
			if ButtonState == "button released" and Input.IsActionTriggered(ButtonPressed, 0) and 
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
				CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown = 600 -- so 10 seconds
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
		
		if CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown then CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown = CustomData.Items.ENRAGEDSOUL.SoulLaunchCooldown - 1 end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, rplus.PostPlayerUpdate)

						-- POST RENDERING --
						--------------------
function rplus:OnGameRender()
	DisplayErrorMessage()
	local player = Isaac.GetPlayer(0)
	local level = game:GetLevel()
	local room = game:GetRoom()
	
	if player:HasTrinket(Trinkets.GREEDSHEART) and not (player:GetPlayerType() == 10 or player:GetPlayerType() == 10)then
		CoinHeartSprite = Sprite()
		
		CoinHeartSprite:Load("gfx/ui/ui_coinhearts.anm2", true)
		CoinHeartSprite:SetFrame(CustomData.Trinkets.GREEDSHEART, 0)
		CoinHeartSprite:Render(Vector(134, 18), Vector.Zero, Vector.Zero)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_RENDER, rplus.OnGameRender)

						-- WHEN NPC DIES --
						-------------------
function rplus:OnNPCDeath(NPC)
	local player = Isaac.GetPlayer(0)
	
	if player:HasCollectible(Collectibles.MISSINGMEMORY) then
		if NPC.Type == EntityType.ENTITY_MOTHER and NPC:GetSprite():IsFinished("Death") then
			if player:HasCollectible(328) then
				Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Vector(280,280), false)
				CustomData.Items.MISSINGMEMORY = "dark"
			end
			if player:HasCollectible(327) then
				Isaac.Spawn(1000, EffectVariant.HEAVEN_LIGHT_DOOR, 0, Vector(360,280), Vector.Zero, nil)
				CustomData.Items.MISSINGMEMORY = "light"
			end
		end
	end
	if NPC.Type == EntityType.ENTITY_MOMS_HEART and NPC:GetSprite():IsFinished("Death") and game:GetLevel():GetStageType() >= 4 then
		Isaac.Spawn(5, 100, Collectibles.MISSINGMEMORY, Vector(320,280), Vector.Zero, nil)
	end
	
	if player:HasTrinket(Trinkets.KEYTOTHEHEART) and math.random(100) <= HEARTKEY_CHANCE * player:GetTrinketMultiplier(Trinkets.KEYTOTHEHEART) then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickUps.SCARLETCHEST, 0, NPC.Position, NPC.Velocity, nil)
	end
	
	if player:HasCollectible(Collectibles.CHERRYFRIENDS) and math.random(100) <= CHERRY_SPAWN_CHANCE then
		Isaac.Spawn(3, Familiars.CHERRY, 1, NPC.Position, Vector.Zero, nil)
		sfx:Play(SoundEffect.SOUND_BABY_HURT, 1, 2, false, 1, 0)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rplus.OnNPCDeath)

						-- ON PICKUP INIT -- 
						--------------------
function rplus:OnPickupInit(Pickup)
	local player = Isaac.GetPlayer(0)
	
	if Pickup.Variant > 49 and Pickup.Variant < 61 and math.random(100) <= SCARLETCHEST_CHANCE then
		Pickup:Morph(5, PickUps.SCARLETCHEST, 0, 0, true, true, false)
	end
	if Pickup.Variant == PickUps.SCARLETCHEST and Pickup.SubType == 1 and type(Pickup:GetData()["IsRoom"]) == type(nil) then
		Pickup:Remove()
	end
	
	if player:HasTrinket(Trinkets.BASEMENTKEY) and Pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST 
	and math.random(100) <= BASEMENTKEY_CHANCE * player:GetTrinketMultiplier(Trinkets.BASEMENTKEY) then
		Pickup:Morph(5, PickupVariant.PICKUP_OLDCHEST, 0, true, true, false)
	end
	
	local CoinSubTypesByVal = {1, 4, 6, 2, 7, 3, 5} -- penny, doublepack, sticky nickel, nickel, golden penny, dime, lucky penny
	if Pickup.Type == 5 and Pickup.Variant == 20 and Pickup.SubType ~= 5 and player:HasTrinket(Trinkets.BITTENPENNY) 
	and math.random(100) <= BITTENPENNY_UPGRADECHANCE * player:GetTrinketMultiplier(Trinkets.BITTENPENNY) then
		player:AnimateHappy()
		for i = 1, #CoinSubTypesByVal do
			if CoinSubTypesByVal[i] == Pickup.SubType then CurType = i break end
		end
		Pickup:Morph(5, 20, CoinSubTypesByVal[CurType + 1], true, true, false)
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
	if OnlyRunes and math.random(100) <= CARDRUNE_REPLACE_CHANCE then return PocketItems[REDRUNE] end
end
rplus:AddCallback(ModCallbacks.MC_GET_CARD, rplus.OnCardInit)

						-- ON USING CARD -- 
						-------------------
function rplus:CardUsed(Card, player, _)
	local player = Isaac.GetPlayer(0)
	
	if Card == PocketItems.RJOKER then
		game:StartRoomTransition(-6, -1, RoomTransitionAnim.TELEPORT, player, -1)
	end
	
	if Card == PocketItems.SDDSHARD then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				local id = entity.SubType - 1
				entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, 100, id, true, true, false)
			end
		end
	end
	
	if Card == PocketItems.REDRUNE then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_ABYSS, false, false, true, false, -1)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, false, false, true, false, -1)
		local locustRNG = RNG()
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PICKUP then
				if (entity.Variant < 100 and entity.Variant > 0) or entity.Variant == 300 or entity.Variant == 350 or entity.Variant == 360 then
					local pos = entity.Position
					entity:Remove()
					if math.random(100) <= 50 then
						Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, locustRNG:RandomInt(5) + 1, pos, Vector.Zero, nil)
					end
				end
			end
		end
	end
	
	if Card == PocketItems.REVERSECARD then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1)
		CustomData.Cards.REVERSECARD = "used"
	end
	
	if Card == PocketItems.KINGOFSPADES then
		sfx:Play(SoundEffect.SOUND_GOLDENKEY, 1, 2, false, 1, 0)
		local NumPickups = math.floor(player:GetNumKeys() / 4)
		player:AddKeys(-player:GetNumKeys())
		if player:HasGoldenKey() then player:RemoveGoldenKey() NumPickups = NumPickups + 2 end
		for i = 1, NumPickups do
			player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SIN, false, false, true, false, -1)
		end
		if NumPickups >= 3 then Isaac.Spawn(5, 350, 0, player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
		if NumPickups >= 7 then Isaac.Spawn(5, 100, 0, player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
	end
	
	if Card == PocketItems.NEEDLEANDTHREAD then
		if player:GetBrokenHearts() > 0 then
			player:AddBrokenHearts(-1)
			player:AddMaxHearts(2, true)
			player:AddHearts(2)
		end
	end
	
	if Card == PocketItems.QUEENOFDIAMONDS then
		for i = 1, math.random(12) do
			local QueenOfDiamondsRandom = math.random(100)
			if QueenOfDiamondsRandom <= 92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 1, game:GetRoom():FindFreePickupSpawnPosition ( player.Position, 0, true, false ), Vector.Zero, nil)
			elseif QueenOfDiamondsRandom <= 98 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 2, game:GetRoom():FindFreePickupSpawnPosition ( player.Position, 0, true, false ), Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 3, game:GetRoom():FindFreePickupSpawnPosition ( player.Position, 0, true, false ), Vector.Zero, nil)
			end
		end
	end
	
	if Card == PocketItems.BAGTISSUE then
		local Weights = {}
		local SumWeight = 0
		local EnoughConsumables = true
		
		-- getting total weight of 8 most valuable pickups in a room
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == 5 then
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
				EnoughConsumables = false player:AnimateSad() break
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
				ID = math.random(729)
			until Isaac.GetItemConfig():GetCollectible(ID).Quality == DesiredQuality and 
			Isaac.GetItemConfig():GetCollectible(ID).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
			
			-- spawning the item
			player:AnimateHappy()
			Isaac.Spawn(5, 100, ID, Isaac.GetFreeNearPosition(player.Position, 5.0), Vector.Zero, nil)
		end
	end
	
	if Card == PocketItems.LOADEDDICE then
		CustomData.Cards.LOADEDDICE.Data = true
		CustomData.Cards.LOADEDDICE.Room = game:GetLevel():GetCurrentRoomIndex()
		
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
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
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 1, game:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true, false), Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_KEY, 4, game:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true, false), Vector.Zero, nil)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_CARD, rplus.CardUsed)

						-- ON PICKUP COLLISION --
						-------------------------
function rplus:PickupCollision(Pickup, Collider, _)
	local player = Isaac.GetPlayer(0)
	
	if Collider.Type == 1 and Pickup.Variant == PickUps.SCARLETCHEST and Pickup.SubType == 0 then
		Pickup.SubType = 1
		Pickup:GetSprite():Play("Open")
		Pickup:GetData()["IsRoom"] = true
		sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 2, false, 1, 0)
		player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(Pickup), 30)
		local DieRoll = math.random(100)
		
		if DieRoll < 15 then
			repeat
				Item = ScarletChestItems[math.random(#ScarletChestItems)]
			until IsCollectibleUnlocked(Item)
			Isaac.Spawn(5, 100, Item, Pickup.Position, Vector(0, 0), Pickup)
			Pickup:Remove()
		elseif DieRoll < 80 then
			local NumOfPickUps = rdm:RandomInt(4) + 1 -- 1 to 4 Pickups
			
			for i = 1, NumOfPickUps do
				local variant = nil
				local subtype = nil
				
				if rdm:RandomInt(100) < 66 then
					variant = 10
					subtype = ScarletChestHearts[math.random(#ScarletChestHearts)]
				else
					variant = 70
					subtype = 0
				end
				Isaac.Spawn(5, variant, subtype, Pickup.Position, Vector.FromAngle(math.random(360)) * 5, Pickup)
			end
		else
			EntityNPC.ThrowSpider(Pickup.Position, Pickup, Pickup.Position + Vector.FromAngle(math.random(360)) * 200, false, 0)
		end
	end
	
	if player:HasTrinket(Trinkets.GREEDSHEART) and CustomData.Trinkets.GREEDSHEART == "CoinHeartEmpty" and Pickup.Variant == 20 and Pickup.SubType ~= 6 
	and not (player:GetPlayerType() == 10 or player:GetPlayerType() == 10) then
		player:AddCoins(-1)
		CustomData.Trinkets.GREEDSHEART = "CoinHeartFull"
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
	local player = Isaac.GetPlayer(0)
	
	if player:HasCollectible(Collectibles.MAGICPEN) and EntityRef(Tear).Entity.SpawnerType == EntityType.ENTITY_PLAYER then
		local CreepTrail = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 4, Tear.Position, Vector.Zero, nil):ToEffect()
		CreepTrail.Scale = 0.4
		CreepTrail:Update()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, rplus.OnTearUpdate)

						-- UPDATING PLAYER STATS (CACHE) --
						-----------------------------------
function rplus:UpdateStats(player, Flag) 
	-- If any Stat-Changes are done, just check for the collectible in the cacheflag (be sure to set the cacheflag in the items.xml)
	if Flag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			player.Damage = player.Damage + StatUps.SINNERSHEART_DMG_ADD
			player.Damage = player.Damage * StatUps.SINNERSHEART_DMG_MUL
		end
		
		if CustomData and CustomData.Items.MARKCAIN == "player revived" then
			player.Damage = player.Damage + #MyFamiliars * StatUps.MARKCAIN_DMG
		end
	end
	
	if Flag == CacheFlag.CACHE_TEARFLAG then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
		end
	end
	
	if Flag == CacheFlag.CACHE_SHOTSPEED then
		if player:HasCollectible(Collectibles.SINNERSHEART)  then
			player.ShotSpeed = player.ShotSpeed + StatUps.SINNERSHEART_SHSP
		end
	end
	
	if Flag == CacheFlag.CACHE_RANGE then 
		-- Range currently not functioning, blame Edmund
		if player:HasCollectible(Collectibles.SINNERSHEART)  then
			player.TearHeight = player.TearHeight + StatUps.SINNERSHEART_TEARHEIGHT
		end
	end
	
	if Flag == CacheFlag.CACHE_TEARCOLOR then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			player.TearColor = Color(0.4, 0.1, 0.38, 1, 0.27843, 0, 0.4549)
		end
	end
	
	if Flag == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(Familiars.BAGOTRASH, player:GetCollectibleNum(Collectibles.BAGOTRASH), player:GetCollectibleRNG(Collectibles.BAGOTRASH))
		player:CheckFamiliar(Familiars.ZENBABY, player:GetCollectibleNum(Collectibles.ZENBABY), player:GetCollectibleRNG(Collectibles.ZENBABY))
	end
	
	if Flag == CacheFlag.CACHE_LUCK then
		if CustomData and CustomData.Cards.LOADEDDICE.Data then
			player.Luck = player.Luck + StatUps.LOADEDDICE_LUCK
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rplus.UpdateStats)

						-- ENTITY TAKES DAMAGE --
						-------------------------
function rplus:EntityTakeDmg(Entity, Amount, Flags, Source, CDFrames)
	local player = Isaac.GetPlayer(0)
	
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
	
	if player:HasCollectible(Collectibles.TEMPERTANTRUM) then 
		if Entity.Type == 1 and math.random(100) <= SUPERBERSERKSTATE_CHANCE then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_BERSERK, true, true, false, true, -1)
			SUPERBERSERKSTATE = true
		elseif SUPERBERSERKSTATE and Entity:IsActiveEnemy(false) and not Entity:IsBoss() and math.random(100) <= SUPERBERSERK_DELETE_CHANCE then
			table.insert(CustomData.Items.TEMPERTANTRUM.ErasedEnemies, Entity.Type)
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
	local player = Isaac.GetPlayer(0)
	
	if player:GetFireDirection() == Direction.NO_DIRECTION then
		Sprite:Play(DIRECTION_FLOAT_ANIM[player:GetMovementDirection()], false)
	else
		local TearVector = DIRECTION_VECTOR[player:GetFireDirection()]:Normalized()

		if Familiar.FireCooldown <= 0 then
			local Tear = Familiar:FireProjectile(TearVector):ToTear()
			Tear.TearFlags = TearFlags.TEAR_GLOW | TearFlags.TEAR_HOMING
			Tear:Update()

			if player:HasTrinket(Isaac.GetTrinketIdByName("Forgotten Lullaby")) then
				Familiar.FireCooldown = 8
			else
				Familiar.FireCooldown = 14
			end
		end

		Sprite:Play(DIRECTION_SHOOT_ANIM[player:GetFireDirection()], false)
	end

	Familiar.FireCooldown = Familiar.FireCooldown - 1
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
		CustomData.Items.BIRDOFHOPE.BirdCaught = true
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, rplus.BirdCollision, Familiars.BIRD)

function rplus:SoulCollision(Familiar, Collider, _)
	if Collider:IsActiveEnemy(true) and not CustomData.Items.ENRAGEDSOUL.AttachedEnemy then
		Familiar.Velocity = Vector.Zero
		CustomData.Items.ENRAGEDSOUL.AttachedEnemy = Collider
		AttachFrames = 300
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
			Isaac.Spawn(5, 100, CollectibleType.COLLECTIBLE_BREAKFAST, Collider.Position, Vector.Zero, nil)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, rplus.ProjectileCollision)

						-- PLAYER COLLISION --
						----------------------
function rplus:PlayerCollision(Player, Collider, _)
	if Player:HasTrinket(Trinkets.SLEIGHTOFHAND) and math.random(100) <= SLEIGHTOFHAND_CHANCE * Player:GetTrinketMultiplier(Trinkets.SLEIGHTOFHAND) then
		-- cuz slots don't have their own collision callback, thanks api lmao
		if Collider.Type == 6 then
			local S = Collider:GetSprite()
			
			-- make sure that we don't infinitely collide with them, results in infinite consumables!!!
			if S:GetFrame() == 1 and 
			(S:IsPlaying("PayPrize") or S:IsPlaying("PayNothing") or S:IsPlaying("PayShuffle") or S:IsPlaying("Wiggle")) then
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
			(Collider.Variant == 53 or Collider.Variant == 55 or Collider.Variant == 57 or Collider.Variant == 60) and	-- no golden keys or lockpicks allowed!!
			not Player:HasGoldenKey() and not Player:HasTrinket(TrinketType.TRINKET_PAPER_CLIP) then 
				Player:AddKeys(1) 
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, rplus.PlayerCollision, 0)

						-- PRE ROOM CLEAR AWARD SPAWN --
						--------------------------------
function rplus:PickupAwardSpawn(_, Pos)
	local player = Isaac.GetPlayer(0)
	local room = game:GetRoom()
	
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
	
	if player:HasTrinket(Trinkets.REDMAP) and math.random(100) <= REDKEY_TURN_CHANCE and room:GetType() ~= RoomType.ROOM_BOSS then
		Isaac.Spawn(5, 300, Card.CARD_CRACKED_KEY, game:GetRoom():FindFreePickupSpawnPosition(Pos, 0, true, false), Vector.Zero, nil)
		return true
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, rplus.PickupAwardSpawn)

						-- ON USING PILL --
						-------------------
function rplus:UsePill(Pill, _)
	local player = Isaac.GetPlayer(0)
	
	if Pill == Pills.ESTROGEN then
		local BloodClots = player:GetHearts() - 1 
		
		player:AddHearts(-BloodClots)
		for i = 1, BloodClots do
			Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, 0, player.Position, Vector.Zero, nil)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_PILL, rplus.UsePill)


								-----------------------------------------
								--- EXTERNAL ITEM DESCRIPTIONS COMPAT ---
								-----------------------------------------
								
if EID then
	EID:addCollectible(Collectibles.ORDLIFE, "On first use, Isaac enters a state where no enemies or pickups spawn and he can freely walk between rooms #On second use, the effect is deactivated, time is reverted to the previous room and the item discharges #{{Warning}} Travelling to the next floor will automatically deactivate the effect and discharge the item")	
	EID:addCollectible(Collectibles.MISSINGMEMORY, "{{BossRoom}} Allows to continue run past Mother, spawning a trapdoor or a beam of light if Isaac has Negative or Polaroid respectively")
	EID:addCollectible(Collectibles.COOKIECUTTER, "Gives you one {{Heart}} heart container and one broken heart #{{Warning}} Having 12 broken hearts kills you!")
	EID:addCollectible(Collectibles.SINNERSHEART, "{{ArrowUp}} Damage +2 then x1.5 #{{ArrowDown}} Shot speed down #Homing tears")
	EID:addCollectible(Collectibles.RUBIKSCUBE, "After each use, has a 5% (100% on 20-th use) chance to be 'solved', removed from the player and spawn a Magic Cube on the ground")
	EID:addCollectible(Collectibles.MAGICCUBE, "{{DiceRoom}} Rerolls item pedestals #Rerolled items can be drawn from any item pool")
	EID:addCollectible(Collectibles.MAGICPEN, "Tears leave {{ColorRainbow}}rainbow{{CR}} creep underneath them #Random permanent status effects is applied to enemies walking over that creep")
	EID:addCollectible(Collectibles.MARKCAIN, "On death, if you have any familiars, removes them instead and revives you #On revival, you keep your heart containers, gain +0.3 DMG for each consumed familiar and gain invincibility shield for 5 seconds #{{Warning}} Works only once!")
	EID:addCollectible(Collectibles.TEMPERTANTRUM, "Upon taking damage, there is a 25% chance to enter a Berserk state #While in this state, every enemy damaged has a 10% chance to be erased for the rest of the run")
	EID:addCollectible(Collectibles.BAGOTRASH, "A familiar that creates blue flies upon clearing a room #Blocks enemy projectiles, and after blocking it has a 2% chance to be destroyed and drop Breakfast #The more floors it is not destroyed, the more flies it spawns")
	EID:addCollectible(Collectibles.ZENBABY, "A familiar that shoots Godhead tears at a fast firerate")
	EID:addCollectible(Collectibles.CHERRYFRIENDS, "Killing an enemy has a 20% chance to drop cherry familiar on the ground #Those cherries emit a charming fart when an enemy walks over them, and drop half a heart when a room is cleared")
	EID:addCollectible(Collectibles.BLACKDOLL, "Upon entering a new room, all enemies will be split in pairs. Dealing damage to one enemy in each pair will deal half of that damage to another enemy in that pair")
	EID:addCollectible(Collectibles.BIRDOFHOPE, "Upon dying you turn into a ghost, gain invincibility shield and a bird flies out of a room center in a random direction. Catching the bird in 5 seconds will revive you, otherwise you will die #{{Warning}} Every time you die, the bird will fly faster and faster, making it harder to catch her #{{Warning}} Only works once per room!")
	EID:addCollectible(Collectibles.ENRAGEDSOUL, "Double tap shooting button to launch a ghost familiar in the direction you are firing #The ghost will latch onto the first enemy it collides with, dealing damage over time for 10 seconds or until that enemy is killed #The ghost can latch onto bosses aswell #{{Warning}} Has a 10 seconds cooldown")
	
	EID:addTrinket(Trinkets.BASEMENTKEY, "{{ChestRoom}} While held, every Golden Chest has a 5% chance to be replaced with Old Chest")
	EID:addTrinket(Trinkets.KEYTOTHEHEART, "While held, every enemy has a chance to drop Scarlet Chest upon death #Scarlet Chests can contain 1-4 {{Heart}} heart/{{Pill}} pills or a random body-related item")
	EID:addTrinket(Trinkets.JUDASKISS, "Enemies touching you become targeted by other enemies (effect similar to Rotten Tomato)")
	EID:addTrinket(Trinkets.SLEIGHTOFHAND, "Using coin, bomb or key has a 12% chance to not subtract it from your inventory count")
	EID:addTrinket(Trinkets.BITTENPENNY, "Upon spawning, every coin has a 20% chance to be upgraded to a higher value: #penny -> doublepack pennies -> sticky nickel -> nickel -> golden penny -> dime -> lucky penny")
	EID:addTrinket(Trinkets.GREEDSHEART, "Gives you one empty coin heart #It is depleted before any of your normal hearts and can only be refilled by directly picking up money")
	EID:addTrinket(Trinkets.REDMAP, "Displays the location of Ultra Secret Room on all subsequent floors #Cracked Key drops on a room clear with 25% chance")
	EID:addTrinket(Trinkets.ANGELSCROWN, "All new treasure rooms will have an angel item for sale instead of a normal item #Angels spawned from statues will not drop Key Pieces!")
	
	EID:addCard(PocketItems.SDDSHARD, "Invokes the effect of Spindown Dice")
	EID:addCard(PocketItems.REDRUNE, "Damages all enemies in a room, turns any item pedestals into red locusts and turns pickups into random locusts with a 50% chance")
	EID:addCard(PocketItems.NEEDLEANDTHREAD, "Removes one broken heart and grants one {{Heart}} heart container")
	EID:addCard(PocketItems.QUEENOFDIAMONDS, "Spawns 1-12 random {{Coin}} coins (those can be nickels or dimes as well)")
	EID:addCard(PocketItems.KINGOFSPADES, "Lose all your keys and spawn a number of pickups proportional to the amount of keys lost #At least 12 {{Key}} keys is needed for a trinket, and at least 28 for an item #If Isaac has {{GoldenKey}} Golden key, it is removed too and significantly increases total value")
	EID:addCard(PocketItems.BAGTISSUE, "All pickups in a room are destroyed, and 8 most valuables pickups form an item quality based on their total weight; the item of such quality is then spawned #The most valuable pickups are the rarest ones, e.g. {{EthernalHeart}} Eternal hearts or {{Battery}} Mega batteries #{{Warning}} If used in a room with less then 8 pickups, no item will spawn!")
	EID:addCard(PocketItems.RJOKER, "Teleports Isaac to a {{SuperSecretRoom}} Black Market")
	EID:addCard(PocketItems.REVERSECARD, "Invokes the effect of Glowing Hourglass")
	EID:addCard(PocketItems.LOADEDDICE, "{{ArrowUp}}  grants 10 Luck for the current room")
	EID:addCard(PocketItems.BEDSIDEQUEEN, "Spawns 1-12 random {{Key}} keys #There is a small chance to spawn a charged key")
	EID:addCard(PocketItems.JACKOFCLUBS, "Bombs will drop more often from clearing rooms for current floor, and the average quality of bombs is increased")
	EID:addCard(PocketItems.JACKOFDIAMONDS, "Coins will drop more often from clearing rooms for current floor, and the average quality of coins is increased")
	EID:addCard(PocketItems.JACKOFSPADES, "Keys will drop more often from clearing rooms for current floor, and the average quality of keys is increased")
	EID:addCard(PocketItems.JACKOFHEARTS, "Hearts will drop more often from clearing rooms for current floor, and the average quality of hearts is increased")

	EID:addPill(Pills.ESTROGEN, "Turns all your red health into blood clots #Leaves you at half-a-heart, doesn't affect soul/black hearts")
end

								-----------------------------------------
								----------- MINIMAP API COMPAT ----------
								-----------------------------------------

if MinimapAPI then
	--MinimapAPI:AddPickup(id, Icon, EntityType, number variant, number subtype, function, icongroup, number priority)
	--MinimapAPI:AddIcon(id, Sprite, string animationName, number frame, (optional) Color color)
	
	local Icons = Sprite()
	Icons:Load("gfx/ui/minimap_icons_rplus.anm2", true)
	
	
	-- scarlet chests
	MinimapAPI:AddIcon("scarletchest", Icons, "scarletchest", 0)
	MinimapAPI:AddPickup("scarletchest", "scarletchest", 5, 392, -1, MinimapAPI.PickupNotCollected, "chests", 7450)
end






































