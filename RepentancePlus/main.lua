
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
	SINNERSHEART = Isaac.GetItemIdByName("Heart of a Sinner")
}

Trinkets = {
	BASEMENTKEY = Isaac.GetTrinketIdByName("Basement Key"),
	KEYTOTHEHEART = Isaac.GetTrinketIdByName("Key to the Heart")
}

PocketItems = {
	RJOKER = Isaac.GetCardIdByName("Joker?"),
	SDDSHARD = Isaac.GetCardIdByName("Spindown Dice Shard"),
	REVERSECARD = Isaac.GetCardIdByName("Reverse Card"),
	REDRUNE = Isaac.GetCardIdByName("Red Rune")
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
	SINNERSHEART_THEIGHT = -3 --negative TearHeight = positive Range
}
---------------------
-- LOCAL FUNCTIONS --
---------------------

-- If Isaac has Mom's Box, trinkets' effects are doubled.
local function HasBox(trinketchance)
	if Isaac.GetPlayer(0):HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
		trinketchance = trinketchance * 2
	end
	return trinketchance
end

-- Helper function to return a random custom card to take place of the normal one.
local function GetRandomCustomCard()
	local keys = {}
	for k in pairs(PocketItems) do
	  table.insert(keys, k)
	end

	local random_key = keys[math.random(1, #keys)]
	return PocketItems[random_key]
end

local function isCollectibleUnlocked(collectibleType)
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
function rplus:OnGameStart(continued)
	if not continued then
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

-- ACTIVE ITEM USED --
function rplus:OnItemUse(itemused, rng, player, flags, slot, customdata)
	local level = game:GetLevel()
	local player = Isaac.GetPlayer(0)
	
	if itemused == Collectibles.ORDLIFE then
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
	elseif itemused == Collectibles.COOKIECUTTER then
		player:AddMaxHearts(2, true)
		player:AddBrokenHearts(1)
		sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 2, false, 1, 0)
		if player:GetBrokenHearts() >= 12 then
			player:Die()
		end
		return true
	elseif itemused == Collectibles.RUBIKSCUBE then
		local solve_chance = math.random(100)
		
		if solve_chance <= 5 or CUBE_COUNTER == 20 then
			player:RemoveCollectible(Collectibles.RUBIKSCUBE, true, ActiveSlot.SLOT_PRIMARY, true)
			Isaac.Spawn(5, 100, Collectibles.MAGICCUBE, player.Position + Vector(20, 20), Vector.Zero, nil)
			player:AnimateHappy()
			CUBE_COUNTER = 0
			return false
		else
			CUBE_COUNTER = CUBE_COUNTER + 1
			return true
		end
	elseif itemused == Collectibles.MAGICCUBE then
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
		secondary_card = player:GetCard(1)
		player:SetCard(1, 0)
		player:SetCard(0, secondary_card)
		REVERSECARD_DATA = nil
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_UPDATE, rplus.OnFrame)

-- WHEN NPC (ENEMY) DIES --
function rplus:OnNPCDeath(npc)
	local player = Isaac.GetPlayer(0)
	
	if player:HasCollectible(Collectibles.MISSINGMEMORY) and npc.Type == EntityType.ENTITY_MOTHER then
		if player:HasCollectible(328) then
			Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Vector(320,280), false)
			MISSINGMEMORY_DATA = "dark"
		elseif player:HasCollectible(327) then
			Isaac.Spawn(1000, EffectVariant.HEAVEN_LIGHT_DOOR, 0, Vector(320,280), Vector.Zero, nil)
			MISSINGMEMORY_DATA = "light"
		end
	end	
	
	if player:HasTrinket(Trinkets.KEYTOTHEHEART) and math.random(100) <= HasBox(HEARTKEY_CHANCE) then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickUps.SCARLETCHEST, 0, npc.Position, npc.Velocity, nil)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rplus.OnNPCDeath)

-- ON PICKUP INITIALIZATION -- 
function rplus:OnPickupInit(pickup)
	local player = Isaac.GetPlayer(0)
	
	if player:HasTrinket(Trinkets.BASEMENTKEY) and pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and math.random(100) <= HasBox(BASEMENTKEY_CHANCE) then
		pickup:Morph(5, PickupVariant.PICKUP_OLDCHEST, 0, true, true, false)
	end
	if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickUps.SCARLETCHEST and pickup.SubType == 1 and type(pickup:GetData()["IsRoom"]) == type(nil) then
		pickup:Remove()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, rplus.OnPickupInit)

-- ON GETTING A CARD --
function rplus:OnCardInit(rng, card, playingcards, runes, onlyrunes)
	if playingcards or runes then
		if math.random(100) <= CARDRUNE_REPLACE_CHANCE then
			GetRandomCustomCard()
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_GET_CARD, rplus.OnCardInit)

-- ON USING CARD -- 
function rplus:CardUsed(card, player, useflags)
	local player = Isaac.GetPlayer(0)
	
	if card == PocketItems.RJOKER then
		game:StartRoomTransition(-6, -1, RoomTransitionAnim.TELEPORT, player, -1)
	elseif card == PocketItems.SDDSHARD then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				local id = entity.SubType - 1
				entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, 100, id, true, true, false)
			end
		end
	elseif card == PocketItems.REDRUNE then
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
	elseif card == PocketItems.REVERSECARD then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1)
		REVERSECARD_DATA = "used"
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_CARD, rplus.CardUsed)

function rplus:OpenScarletChest(pickup, collider, low)
	local player = Isaac.GetPlayer(0)
	if collider.Type == 1 and pickup.Variant == PickUps.SCARLETCHEST and pickup.SubType == 0 then
		pickup.SubType = 1
		pickup:GetSprite():Play("Open")
		pickup:GetData()["IsRoom"] = true
		local dieroll = rdm:RandomInt(10)
		if dieroll < 2 then
			local item = ScarletChestItems[rdm:RandomInt(#ScarletChestItems) + 1]
			while not isCollectibleUnlocked(item) do
				item = ScarletChestItems[rdm:RandomInt(#ScarletChestItems) + 1]
			end
			item = Isaac.Spawn(5, 100, item, pickup.Position, Vector(0, 0), pickup)
			pickup:Remove()
		elseif dieroll < 4 then
			Isaac.Spawn(5, 350, game:GetItemPool():GetTrinket(), pickup.Position, Vector.FromAngle(math.random(360)) * 5, pickup)
		elseif dieroll < 10 then
			local numOfPickUps = rdm:RandomInt(5) + 2 -- 2 to 6 pickups
			for i=1, numOfPickUps do
				local variant = nil
				local subtype = nil
				if rdm:RandomInt(100) < 75 then
					variant = 10
					subtype = ScarletChestHearts[rdm:RandomInt(#ScarletChestHearts) + 1]
				else
					variant = 70
					subtype = game:GetItemPool():GetPill(game:GetSeeds():GetNextSeed())
				end
				Isaac.Spawn(5, variant, subtype, pickup.Position, Vector.FromAngle(math.random(360)) * 5, pickup)
			end
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, rplus.OpenScarletChest)

function rplus:RenderScarletPedestal(pickup)
	if pickup.Type == 5 and pickup.Variant == 100 and pickup.SpawnerVariant == 392 then
		for i = 3, 5 do pickup:GetSprite():ReplaceSpritesheet(i,"gfx/items/slots/levelitem_scarletchest_itemaltar_dlc4.png") end
		pickup:GetSprite():LoadGraphics()
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, rplus.RenderScarletPedestal)

function rplus:UpdateStats(player, flag) --If any Stat-Changes are done, just check for the collectible in the cacheflag (be sure to set the cacheflag in the items.xml
	if flag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			player.Damage = player.Damage + StatUps.SINNERSHEART_DMG
		end
	end
	if flag == CacheFlag.CACHE_TEARFLAG then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
		end
	end
	if flag == CacheFlag.CACHE_SHOTSPEED then
		if player:HasCollectible(Collectibles.SINNERSHEART)  then
			player.ShotSpeed = player.ShotSpeed + StatUps.SINNERSHEART_SHSP
		end
	end
	if flag == CacheFlag.CACHE_RANGE then --Range currently not functioning, blame edmund
		if player:HasCollectible(Collectibles.SINNERSHEART)  then
			player.TearHeight = player.TearHeight + StatUps.SINNERSHEART_THEIGHT
		end
	end
	if flag == CacheFlag.CACHE_TEARCOLOR then
		if player:HasCollectible(Collectibles.SINNERSHEART) then
			Isaac.DebugString("pink")
			player.TearColor = Color(0.4, 0.1, 0.38, 1, 0.27843, 0, 0.4549)
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rplus.UpdateStats)






































