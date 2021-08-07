
---------------------
----- VARIABLES -----
---------------------

local game = Game()
local rplus = RegisterMod("Repentance Plus", 1)
local sfx = SFXManager()
local music = MusicManager()
local rdm = RNG()

local BASEMENTKEY_CHANCE = 5
local HEARTKEY_CHANCE = 5
local CARDRUNE_REPLACE_CHANCE = 2

Collectibles = {
	ORDLIFE = Isaac.GetItemIdByName("Ordinary Life"),
	MISSINGMEMORY = Isaac.GetItemIdByName("The Missing Memory"),
	COOKIECUTTER = Isaac.GetItemIdByName("Cookie Cutter"),
	RUBIKSCUBE = Isaac.GetItemIdByName("Rubik's Cube"),
	MAGICCUBE = Isaac.GetItemIdByName("Magic Cube"),
	MAGICPEN = Isaac.GetItemIdByName("Magic Pen"),
	SINNERSHEART = Isaac.GetItemIdByName("Sinner's Heart")
}

Trinkets = {
	BASEMENTKEY = Isaac.GetTrinketIdByName("Basement Key"),
	KEYTOTHEHEART = Isaac.GetTrinketIdByName("Key to the Heart")
}

PocketItems = {
	RJOKER = Isaac.GetCardIdByName("Joker?"),
	SDDSHARD = Isaac.GetCardIdByName("Spindown Dice Shard"),
	REVERSECARD = Isaac.GetCardIdByName("Reverse Card"),
	REDRUNE = Isaac.GetCardIdByName("Red Rune"),
	KINGOFSPADES = Isaac.GetCardIdByName("King of Spades"),
	NEEDLEANDTHREAD = Isaac.GetCardIdByName("Needle and Thread"),
	QUEENOFDIAMONDS = Isaac.GetCardIdByName("Queen of Diamonds")
}

PickUps = {
	SCARLETCHEST = Isaac.GetEntityVariantByName("Scarlet Chest")
}

ScarletChestItems = { --just indent
	13, --The Virus
	16, --Raw Liver
	26, --Rotten Meat
	36, --The Poop
	73, --Cube of Meat
	155, --The Peeper
	157, --Bloody Lust
	176, --Stem Cells
	214, --Anemic
	218, --Placenta
	236, --E. Coli
	253, --Magic Scab
	411, --Lusty Blood
	440, --Kidney Stone
	446, --Dead Tooth
	452, --Varicose Veins
	502, --Large Zit
	509, --Bloodshot Eye
	529, --Pop!
	539, --Mystery Egg
	541, --Marrow
	542, --Slipped Rib
	544, --Pointy Rib
	548, --Jaw Bone
	549, --Brittle Boney
	553, --Mucormycosis
	612, --Lost Soul
	639, --Yuck Heart
	642, --Magic Skin
	657, --Vasculitis
	676, --Empty Heart
	684, --Hungry Soul
	688, --Inner Child
	694, --Heartbreak
	695  --Bloody Gust
}

ScarletChestHearts = {
	1, 2, 5, 10 --every Heart with red in it which is automatically unlocked
}

StatUps = {
	SINNERSHEART_DMG = 1.5,
	SINNERSHEART_SHSP = -0.3,
	SINNERSHEART_TEARHEIGHT = -3 --negative TearHeight = positive Range
}

CreepColors = {
	Color(255, 0, 0), --red
	Color(255, 127, 0), --orange
	Color(255, 255, 0), --yellow
	Color(0, 255, 0), --green
	Color(0, 0, 255), --blue
	Color(75, 0, 130), --indigo
	Color(143, 0, 255) --violet
}

---------------------
-- LOCAL FUNCTIONS --
---------------------

-- If Isaac has Mom's Box, trinkets' effects are doubled.
local function HasBox(TrinketChance)
	if Isaac.GetPlayer(0):HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
		TrinketChance = TrinketChance * 2
	end
	return TrinketChance
end

-- Helper function to return a random custom Card to take place of the normal one.
local function GetRandomCustomCard()
	local keys = {}
	for k in pairs(PocketItems) do
	  table.insert(keys, k)
	end

	local random_key = keys[math.random(1, #keys)]
	return PocketItems[random_key]
end

local function GetRandomElement(List)
	return List[math.random(#List) + 1]
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

---------------------
-- GLOBAL FUNCTIONS --
---------------------

-- GAME STARTED --
function rplus:OnGameStart(Continued)
	if not Continued then
		ORDLIFE_DATA = nil
		MISSINGMEMORY_DATA = nil
		REVERSECARD_DATA = nil
		CUBE_COUNTER = 0
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, rplus.OnGameStart)

-- EVERY NEW LEVEL 
function rplus:OnNewLevel()
	local player = Isaac.GetPlayer(0)
	local level = game:GetLevel()
	
	if player:HasCollectible(Collectibles.ORDLIFE) and ORDLIFE_DATA == "used" then
		level:RemoveCurses(LevelCurse.CURSE_OF_DARKNESS)
		music:Enable()
		player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
		ORDLIFE_DATA = nil
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, rplus.OnNewLevel)

-- EVERY NEW ROOM
function rplus:OnNewRoom()
	local player = Isaac.GetPlayer(0)

end
rplus:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, rplus.OnNewRoom)

-- ACTIVE ITEM USED --
function rplus:OnItemUse(ItemUsed, _, player, _, _, _)
	local level = game:GetLevel()
	local player = Isaac.GetPlayer(0)
	
	if ItemUsed == Collectibles.ORDLIFE then
		if not ORDLIFE_DATA then
			ORDLIFE_DATA = "used"
			music:Disable()
			level:AddCurse(LevelCurse.CURSE_OF_DARKNESS, false)
			PlayerSprite = player:GetSprite()
			PlayerSprite:Load("gfx/characters/character_001_ordinarylife.anm2", true)
			return {Discharge = false, Remove = false, ShowAnim = false}
		elseif ORDLIFE_DATA == "used" then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, true, true, false, false, -1)
			return {Discharge = true, Remove = false, ShowAnim = true}
		end
	elseif ItemUsed == Collectibles.COOKIECUTTER then
		player:AddMaxHearts(2, true)
		player:AddBrokenHearts(1)
		sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 2, false, 1, 0)
		if player:GetBrokenHearts() >= 12 then
			player:Die()
		end
		return true
	elseif ItemUsed == Collectibles.RUBIKSCUBE then
		local SolveChance = math.random(100)
		
		if SolveChance <= 5 or CUBE_COUNTER == 20 then
			player:RemoveCollectible(Collectibles.RUBIKSCUBE, true, ActiveSlot.SLOT_PRIMARY, true)
			Isaac.Spawn(5, 100, Collectibles.MAGICCUBE, player.Position + Vector(20, 20), Vector.Zero, nil)
			player:AnimateHappy()
			CUBE_COUNTER = 0
			return false
		else
			CUBE_COUNTER = CUBE_COUNTER + 1
			return true
		end
	elseif ItemUsed == Collectibles.MAGICCUBE then
		player:UseCard(Card.CARD_SOUL_EDEN, UseFlag.USE_NOANIM | UseFlag.USE_OWNED | UseFlag.USE_NOANNOUNCER)
		return true
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_ITEM, rplus.OnItemUse)

-- EVERY FRAME --
function rplus:OnFrame()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local player = Isaac.GetPlayer(0)
	local stage = level:GetStage()
	
	if player:HasCollectible(Collectibles.ORDLIFE) and ORDLIFE_DATA == "used" then
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
			ORDLIFE_DATA = nil
		end
	end
	
	if player:HasCollectible(Collectibles.MISSINGMEMORY) then
		if MISSINGMEMORY_DATA == "dark" and player:GetSprite():IsPlaying("Trapdoor") then
			level:SetStage(LevelStage.STAGE4_2, StageType.STAGETYPE_ORIGINAL)
			MISSINGMEMORY_DATA = nil
		elseif MISSINGMEMORY_DATA == "light" and player:GetSprite():IsPlaying("LightTravel") then
			level:SetStage(LevelStage.STAGE4_2, StageType.STAGETYPE_ORIGINAL)
			MISSINGMEMORY_DATA = nil
		end
	end
	
	if REVERSECARD_DATA == "used" and player:GetSprite():IsFinished("PickupWalkDown") then
		secondary_Card = player:GetCard(1)
		player:SetCard(1, 0)
		player:SetCard(0, secondary_Card)
		REVERSECARD_DATA = nil
	end
	
	if player:HasCollectible(Collectibles.MAGICPEN) and game:GetFrameCount() % 100 == 0 then
		RandomCreepColor = math.random(#CreepColors)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_UPDATE, rplus.OnFrame)

-- WHEN NPC (ENEMY) DIES --
function rplus:OnNPCDeath(NPC)
	local player = Isaac.GetPlayer(0)
	
	if player:HasCollectible(Collectibles.MISSINGMEMORY) and NPC.Type == EntityType.ENTITY_MOTHER then
		if player:HasCollectible(328) then
			Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Vector(320,280), false)
			MISSINGMEMORY_DATA = "dark"
		elseif player:HasCollectible(327) then
			Isaac.Spawn(1000, EffectVariant.HEAVEN_LIGHT_DOOR, 0, Vector(320,280), Vector.Zero, nil)
			MISSINGMEMORY_DATA = "light"
		end
	end	
	
	if player:HasTrinket(Trinkets.KEYTOTHEHEART) and math.random(100) <= HasBox(HEARTKEY_CHANCE) then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickUps.SCARLETCHEST, 0, NPC.Position, NPC.Velocity, nil)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rplus.OnNPCDeath)

-- ON PICKUP INITIALIZATION -- 
function rplus:OnPickupInit(Pickup)
	local player = Isaac.GetPlayer(0)
	
	if player:HasTrinket(Trinkets.BASEMENTKEY) and Pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and math.random(100) <= HasBox(BASEMENTKEY_CHANCE) then
		Pickup:Morph(5, PickupVariant.PICKUP_OLDCHEST, 0, true, true, false)
	end
	if Pickup.Type == EntityType.ENTITY_PICKUP and Pickup.Variant == PickUps.SCARLETCHEST and Pickup.SubType == 1 and type(Pickup:GetData()["IsRoom"]) == type(nil) then
		Pickup:Remove()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, rplus.OnPickupInit)

-- ON GETTING A CARD --
function rplus:OnCardInit(_, _, PlayingCards, Runes, OnlyRunes)
	if PlayingCards or Runes then
		if math.random(100) <= CARDRUNE_REPLACE_CHANCE then
			GetRandomCustomCard()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_GET_CARD, rplus.OnCardInit)

-- ON USING CARD -- 
function rplus:CardUsed(Card, player, _)
	local player = Isaac.GetPlayer(0)
	
	if Card == PocketItems.RJOKER then
		game:StartRoomTransition(-6, -1, RoomTransitionAnim.TELEPORT, player, -1)
	elseif Card == PocketItems.SDDSHARD then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				local id = entity.SubType - 1
				entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, 100, id, true, true, false)
			end
		end
	elseif Card == PocketItems.REDRUNE then
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
	elseif Card == PocketItems.REVERSECARD then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1)
		REVERSECARD_DATA = "used"
	elseif Card == PocketItems.KINGOFSPADES then
		sfx:Play(SoundEffect.SOUND_GOLDENKEY, 1, 2, false, 1, 0)
		local NumPickups = math.floor(player:GetNumKeys() / 4)
		player:AddKeys(-player:GetNumKeys())
		if player:HasGoldenKey() then player:RemoveGoldenKey() NumPickups = NumPickups + 2 end
		for i = 1, NumPickups do
			player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SIN, false, false, true, false, -1)
		end
		if NumPickups >= 3 then Isaac.Spawn(5, 350, 0, player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
		if NumPickups >= 5 then Isaac.Spawn(5, 100, 0, player.Position + Vector.FromAngle(math.random(360)) * 20, Vector.Zero, nil) end
	elseif Card == PocketItems.NEEDLEANDTHREAD then
		if player:GetBrokenHearts() > 0 then
			player:AddBrokenHearts(-1)
			player:AddMaxHearts(2, true)
			player:AddHearts(2)
		end
	elseif Card == PocketItems.QUEENOFDIAMONDS then
		for i=1, math.random(12) do
			local QueenOfDiamondsRandom = math.random(100)
			if QueenOfDiamondsRandom <= 92 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN,1 , game:GetRoom():FindFreePickupSpawnPosition ( player.Position, 0, true, false ), Vector.Zero, nil)
			elseif QueenOfDiamondsRandom <= 98 then
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN,2 , game:GetRoom():FindFreePickupSpawnPosition ( player.Position, 0, true, false ), Vector.Zero, nil)
			else
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN,3 , game:GetRoom():FindFreePickupSpawnPosition ( player.Position, 0, true, false ), Vector.Zero, nil)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_CARD, rplus.CardUsed)

-- ON PICKUP COLLISION
function rplus:OpenScarletChest(Pickup, Collider, _)
	local player = Isaac.GetPlayer(0)
	if Collider.Type == 1 and Pickup.Variant == PickUps.SCARLETCHEST and Pickup.SubType == 0 then
		Pickup.SubType = 1
		Pickup:GetSprite():Play("Open")
		Pickup:GetData()["IsRoom"] = true
		local DieRoll = rdm:RandomInt(10)
		if DieRoll < 2 then
			local item = GetRandomElement(ScarletChestItems)
			while not IsCollectibleUnlocked(item) do
				item = GetRandomElement(ScarletChestItems)
			end
			item = Isaac.Spawn(5, 100, item, Pickup.Position, Vector(0, 0), Pickup)
			Pickup:Remove()
		elseif DieRoll < 4 then
			Isaac.Spawn(5, 350, game:GetItemPool():GetTrinket(), Pickup.Position, Vector.FromAngle(math.random(360)) * 5, Pickup)
		elseif DieRoll < 10 then
			local NumOfPickUps = rdm:RandomInt(5) + 2 -- 2 to 6 Pickups
			for i = 1, NumOfPickUps do
				local variant = nil
				local subtype = nil
				if rdm:RandomInt(100) < 75 then
					variant = 10
					subtype = GetRandomElement(ScarletChestHearts)
				else
					variant = 70
					subtype = game:GetItemPool():GetPill(game:GetSeeds():GetNextSeed())
				end
				Isaac.Spawn(5, variant, subtype, Pickup.Position, Vector.FromAngle(math.random(360)) * 5, Pickup)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, rplus.OpenScarletChest)

-- ON UPDATING THE PICKUPS
function rplus:PickupUpdate(Pickup)
	if Pickup.Type == 5 and Pickup.Variant == 100 and Pickup.SpawnerVariant == 392 then
		for i = 3, 5 do Pickup:GetSprite():ReplaceSpritesheet(i,"gfx/items/slots/levelitem_scarletchest_itemaltar_dlc4.png") end
		Pickup:GetSprite():LoadGraphics()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, rplus.PickupUpdate)

-- ON TEAR UPDATE
function rplus:OnTearUpdate(Tear)
	local player = Isaac.GetPlayer(0)
	
	if player:HasCollectible(Collectibles.MAGICPEN) then
		local CreepTrail = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, Tear.Position, Vector.Zero, nil):ToEffect()
		CreepTrail.Scale = 0.4
		if RandomCreepColor then CreepTrail:SetColor(CreepColors[RandomCreepColor], 500, 1, false, false) end
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, rplus.OnTearUpdate)

-- UPDATING PLAYER STATS
function rplus:UpdateStats(player, Flag) 
	--If any Stat-Changes are done, just check for the collectible in the cacheflag (be sure to set the cacheflag in the items.xml
	if Flag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			player.Damage = player.Damage + StatUps.SINNERSHEART_DMG
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
		--Range currently not functioning, blame Edmund
		if player:HasCollectible(Collectibles.SINNERSHEART)  then
			player.TearHeight = player.TearHeight + StatUps.SINNERSHEART_TEARHEIGHT
		end
	end
	if Flag == CacheFlag.CACHE_TEARCOLOR then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			player.TearColor = Color(0.4, 0.1, 0.38, 1, 0.27843, 0, 0.4549)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rplus.UpdateStats)















































