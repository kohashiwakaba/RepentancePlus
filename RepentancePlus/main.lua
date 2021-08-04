
---------------------
----- VARIABLES -----
---------------------

local game = Game()
local rplus = RegisterMod("Repentance Plus", 1)
local sfx = SFXManager()
local music = MusicManager()

local BASEMENTKEY_CHANCE = 5
local HEARTKEY_CHANCE = 25
local CARDRUNE_REPLACE_CHANCE = 2

local reverseCardBuffer = 0 --don't know any elegant solution

Collectibles = {
	ORDLIFE = Isaac.GetItemIdByName("Ordinary Life"),
	MISSINGMEMORY = Isaac.GetItemIdByName("Missing Memory"),
	COOKIECUTTER = Isaac.GetItemIdByName("Cookie Cutter")
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


---------------------
-- GLOBAL FUNCTIONS --
---------------------

-- GAME STARTED --
function rplus:OnGameStart(continued)
	if not continued then
		ORDLIFE_DATA = nil
		MISSINGMEMORY_DATA = nil
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, rplus.OnGameStart)

-- ACTIVE ITEM USED --
function rplus:OnItemUse(itemused, rng, player, flags, slot, customdata)
	local level = game:GetLevel()
	local player = Isaac.GetPlayer(0)
	
	if itemused == Collectibles.ORDLIFE then
		if not ORDLIFE_DATA then
			ORDLIFE_DATA = "used"
			ORDLIFE_STAGE = level:GetStage()
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
		if player:GetBrokenHearts() >= 12 then
			player:Die()
		end
		return {Discharge = true, Remove = false, ShowAnim = true}
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
		if ORDLIFE_STAGE ~= level:GetStage() then
			player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
			player:UseActiveItem(Collectibles.ORDLIFE, false, false, true, false, -1)
			ORDLIFE_DATA = "notused"
		end
		if player:GetSprite():IsFinished("PickupWalkDown") then
			level:RemoveCurses(LevelCurse.CURSE_OF_DARKNESS)
			ORDLIFE_DATA = nil
			music:Enable()
			player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
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
	if player:HasTrinket(Trinkets.KEYTOTHEHEART) and math.random(100) <= HasBox(BASEMENTKEY_CHANCE) then
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
		player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false, -1) --currently shows anim, I don't have a clue why
		reverseCardBuffer = 200 -- works mostly consistent, needs some work though
	end
end
rplus:AddCallback(ModCallbacks.MC_USE_CARD, rplus.CardUsed)

function rplus:DelReverseCard()
	local player = Isaac.GetPlayer(0)
	local secondary = player:GetCard(1)
	reverseCardBuffer = math.min(0, reverseCardBuffer - 1)
	if reverseCardBuffer == 0 and secondary == 0 then --weird shenanigans because secondary stays secondary when primary is deleted
		player:SetCard(0, 0)
	elseif reverseCardBuffer == 0 then
		player:SetCard(0, secondary)
		player:SetCard(1, 0)
	end
end
rplus:AddCallback(ModCallbacks.MC_POST_UPDATE, rplus.DelReverseCard)

function rplus:OpenScarletChest(pickup, collider, low)
	local player = Isaac.GetPlayer(0)
	if collider.Type == 1 and pickup.SubType == 0 then
		pickup.SubType = 1
		pickup:GetSprite():Play("Open")
		pickup:GetData()["IsRoom"] = true
		local die = RNG()
		local dieroll = die:RandomInt(10)
		if dieroll < 2 then
		elseif dieroll < 4 then
		
		elseif dieroll <10 then
		
		end
	end
end
rplus:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, rplus.OpenScarletChest, PickUps.SCARLETCHEST)















































