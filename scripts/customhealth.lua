local mod = RepentancePlusMod
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local HeartKey = {
    [mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS] = "HEART_DAUNTLESS",
    [mod.CustomPickups.TaintedHearts.HEART_SOILED] = "HEART_SOILED",
    [mod.CustomPickups.TaintedHearts.HEART_BALEFUL] = "HEART_BALEFUL",
    [mod.CustomPickups.TaintedHearts.HEART_EMPTY] = "HEART_EMPTY",
    [mod.CustomPickups.TaintedHearts.HEART_MISER] = "HEART_MISER",
    [mod.CustomPickups.TaintedHearts.HEART_ZEALOT] = "HEART_ZEALOT",
}

local HeartPickupSound = {
    [mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS] = SoundEffect.SOUND_DIVINE_INTERVENTION,
    [mod.CustomPickups.TaintedHearts.HEART_SOILED] = SoundEffect.SOUND_ROTTEN_HEART,
    [mod.CustomPickups.TaintedHearts.HEART_BALEFUL] = SoundEffect.SOUND_SUPERHOLY,
    [mod.CustomPickups.TaintedHearts.HEART_EMPTY] = SoundEffect.SOUND_ROTTEN_HEART,
    [mod.CustomPickups.TaintedHearts.HEART_MISER] = SoundEffect.SOUND_GOLD_HEART,
    [mod.CustomPickups.TaintedHearts.HEART_ZEALOT] = SoundEffect.SOUND_HOLY,
}

local HeartNumFlies = {
    [mod.CustomPickups.TaintedHearts.HEART_BROKEN] = 3,
    [mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS] = 4,
    [mod.CustomPickups.TaintedHearts.HEART_HOARDED] = 5,
    [mod.CustomPickups.TaintedHearts.HEART_DECEIVER] = 2,
    [mod.CustomPickups.TaintedHearts.HEART_SOILED] = 3,
    [mod.CustomPickups.TaintedHearts.HEART_CURDLED] = 3,
    [mod.CustomPickups.TaintedHearts.HEART_SAVAGE] = 2,
    [mod.CustomPickups.TaintedHearts.HEART_BENIGHTED] = 4,
    [mod.CustomPickups.TaintedHearts.HEART_ENIGMA] = 3,
    [mod.CustomPickups.TaintedHearts.HEART_CAPRICIOUS] = 2,
    [mod.CustomPickups.TaintedHearts.HEART_BALEFUL] = 5,
    [mod.CustomPickups.TaintedHearts.HEART_HARLOT] = 2,
    [mod.CustomPickups.TaintedHearts.HEART_MISER] = 4,
    [mod.CustomPickups.TaintedHearts.HEART_EMPTY] = 3,
    [mod.CustomPickups.TaintedHearts.HEART_FETTERED] = 3,
    [mod.CustomPickups.TaintedHearts.HEART_ZEALOT] = 4,
    [mod.CustomPickups.TaintedHearts.HEART_DESERTED] = 2
}

local function isNoRedHealthCharacter(p)
	local t = p:GetPlayerType()

	return t == PlayerType.PLAYER_BLUEBABY or t == PlayerType.PLAYER_THESOUL or t == PlayerType.PLAYER_JUDAS_B
    or t == PlayerType.PLAYER_BLUEBABY_B or t == PlayerType.PLAYER_THEFORGOTTEN_B
	or t == PlayerType.PLAYER_BETHANY_B or t == PlayerType.PLAYER_JACOB2_B or t == PlayerType.PLAYER_THESOUL_B
end

local function keeperFlyCheck(pickup, numFlies)
    numFlies = numFlies or 2

    local numKeepers = 0
    local numNonKeepers = 0
    for i = 0, game:GetNumPlayers() - 1 do
        local ptype = Isaac.GetPlayer(i):GetPlayerType()
        if ptype == PlayerType.PLAYER_KEEPER or ptype == PlayerType.PLAYER_KEEPER_B then
            numKeepers = numKeepers + 1
        else
            numNonKeepers = numNonKeepers + 1
        end
    end

    if numKeepers == 0 or numNonKeepers > 0 then
        return
    end

    for i = 1, numFlies do
        local afly = Isaac.Spawn(3, 43, 0, pickup.Position, Vector.Zero, pickup)
        afly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        afly:Update()
    end
    pickup:Remove()
end

--------------------
-- HEART REPLACEMENT
--------------------
--------------------------------------------------------
-- PREVENT MORPHING HEARTS TO THEIR TAINTED COUNTERPARTS
-- WHEN USING SPECIFIC CARDS AND ITEMS
-- OR WHEN IN SPECIFIC ROOMS

local SusCards = {
    Card.CARD_LOVERS,
    Card.CARD_HIEROPHANT,
    Card.CARD_REVERSE_HIEROPHANT,
    Card.CARD_QUEEN_OF_HEARTS,
    Card.CARD_REVERSE_FOOL
}

local function isSusCard(thisCard)
    for _, card in pairs(SusCards) do
        if card == thisCard then
            return true
        end
    end

    return false
end

local function cancelTaintedMorph()
    local h = Isaac.FindByType(5, 10)

    for _, heart in pairs(h) do
        if heart.FrameCount == 0 then
            heart:GetData().noTaintedMorph = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, _, _)
    if isSusCard(card) then
        cancelTaintedMorph()
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, _, _, _)
    cancelTaintedMorph()
end, CollectibleType.COLLECTIBLE_THE_JAR)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SubType < 84 or pickup.SubType > 100 then return end

	if not mod.isPickupUnlocked(10, pickup.SubType) or mod.FLAG_NO_TAINTED_HEARTS then
        local subtype = pickup.SubType

		if subtype == mod.CustomPickups.TaintedHearts.HEART_FETTERED
        or subtype == mod.CustomPickups.TaintedHearts.HEART_ZEALOT then
			pickup:Morph(5, 10, HeartSubType.HEART_SOUL, true, true, false)

		elseif subtype == mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS
        or subtype == mod.CustomPickups.TaintedHearts.HEART_ENIGMA
        or subtype == mod.CustomPickups.TaintedHearts.HEART_BALEFUL then
			pickup:Morph(5, 10, HeartSubType.HEART_ETERNAL, true, true, false)

		elseif subtype == mod.CustomPickups.TaintedHearts.HEART_HOARDED then
			pickup:Morph(5, 10, HeartSubType.HEART_DOUBLEPACK, true, true, false)

		elseif subtype == mod.CustomPickups.TaintedHearts.HEART_BENIGHTED then
			pickup:Morph(5, 10, HeartSubType.HEART_BLACK, true, true, false)

		elseif subtype == mod.CustomPickups.TaintedHearts.HEART_MISER then
			pickup:Morph(5, 10, HeartSubType.HEART_GOLDEN, true, true, false)

		elseif subtype == mod.CustomPickups.TaintedHearts.HEART_EMPTY
        or subtype == mod.CustomPickups.TaintedHearts.HEART_SOILED then
			pickup:Morph(5, 10, HeartSubType.HEART_ROTTEN, true, true, false)

		else
			pickup:Morph(5, 10, HeartSubType.HEART_FULL, true, true, false)

		end

        pickup:GetData().noTaintedMorph = true
	end

	keeperFlyCheck(pickup, HeartNumFlies[pickup.SubType])
end, PickupVariant.PICKUP_HEART)

------------------------------------------------
-- HANDLE DUPLICATING HEARTS WITH JERA, DIPLOPIA
-- OR CROOKED PENNY, TO MAKE SURE THAT ALL 
-- ORIGINAL HEARTS ARE COPIED 1:1

local function handleHeartsDupe()
    -- iterate through all pickups that have FrameCount of 0 (they've just spawned)
    -- find an older pickup with the same InitSeed
    -- assign its subtype to the newer pickup's subtype
    local h = Isaac.FindByType(5, 10)

    for _, newHeart in pairs(h) do
        if newHeart.FrameCount == 0 then
           for _, oldHeart in pairs(h) do
                if oldHeart.FrameCount > 0
                and newHeart.InitSeed == oldHeart.InitSeed then
                    newHeart:GetData().noTaintedMorph = true
                end
           end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, _, _, _)
    handleHeartsDupe()
end, CollectibleType.COLLECTIBLE_DIPLOPIA)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, _, _, _)
    handleHeartsDupe()
end, CollectibleType.COLLECTIBLE_CROOKED_PENNY)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, _)
    handleHeartsDupe()
end, Card.RUNE_JERA)

-------
-- CORE

local function taintedMorph(heartPickup, taintedSubtype)
	if mod.isPickupUnlocked(10, taintedSubtype) then
		heartPickup:Morph(5, 10, taintedSubtype, true, true, true)
	end
end

local function getTrueTaintedMorphChance(kind)
    if kind == "red" then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_SHARD_OF_GLASS)
            or player:HasCollectible(CollectibleType.COLLECTIBLE_OLD_BANDAGE) then
                return 4
            end

            return 8
        end
    elseif kind == "double" then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE) then
                return 50
            end

            return 250
        end
    elseif kind == "soul" then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_MITRE)
            or player:HasCollectible(CollectibleType.COLLECTIBLE_GIMPY)
            or player:HasCollectible(CollectibleType.COLLECTIBLE_RELIC) then
                return 25
            end

            if player:HasCollectible(mod.CustomCollectibles.THE_HOOD) then
                return 150
            end

            return 50
        end
    elseif kind == "black" then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM)
            or player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) then
                return 50
            end

            return 125
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if not mod.FLAG_NO_TAINTED_HEARTS and not pickup:GetData().noTaintedMorph
        and pickup.Price == 0 and game:GetRoom():GetType() ~= RoomType.ROOM_SUPERSECRET
        and (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast"))
        -- BE WARNED THAT FRAMECOUNT == 1 IS NOT SPRITE:GETFRAME() == 1, SPRITE FRAME IS ACTUALLY 1 HIGHER THAN THE NORMAL FRAME
        -- and I don't even know whom to blame for that
        and pickup.FrameCount == 1
    then
        rng:SetSeed(pickup.InitSeed + Random(), 1)
        local roll = rng:RandomFloat() * 1000
        local subtype = pickup.SubType
        local baseChance

        if subtype == HeartSubType.HEART_FULL then
            baseChance = getTrueTaintedMorphChance("red")
            if roll < baseChance then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_BROKEN)
            elseif roll < baseChance * 2 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_CURDLED)
            elseif roll < baseChance * 3 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_SAVAGE)
            elseif roll < baseChance * 4 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_HARLOT)
            elseif roll < baseChance * 5 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_DECEIVER)
            elseif roll < baseChance * 6 and game:GetNumPlayers() == 1 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_ENIGMA) end

        elseif subtype == HeartSubType.HEART_SOUL then
            baseChance = getTrueTaintedMorphChance("soul")
            if game:GetLevel():GetStage() == LevelStage.STAGE1_1
            and game:GetLevel():GetStageType() < StageType.STAGETYPE_REPENTANCE then
                if roll < baseChance * 0.5 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_ZEALOT) end
            else
                if roll < baseChance then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_FETTERED)
                elseif roll < (baseChance < 150 and baseChance * 1.5 or 175) then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_ZEALOT) end
            end

        elseif subtype == HeartSubType.HEART_ETERNAL then
            if roll < 100 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS)
            elseif roll < 200 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_BALEFUL) end

        elseif subtype == HeartSubType.HEART_DOUBLEPACK then
            baseChance = getTrueTaintedMorphChance("double")
            if roll < baseChance then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_HOARDED) end

        elseif subtype == HeartSubType.HEART_BLACK then
            baseChance = getTrueTaintedMorphChance("black")
            if roll < baseChance then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_BENIGHTED) end

        elseif subtype == HeartSubType.HEART_GOLDEN then
            if roll < 250 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_MISER) end

        elseif subtype == HeartSubType.HEART_BLENDED then
            if roll < 400 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_DESERTED) end

        elseif subtype == HeartSubType.HEART_BONE then
            if roll < 100 then pickup:Morph(5, 10, mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS) end

        elseif subtype == HeartSubType.HEART_ROTTEN then
            if roll < 75 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_EMPTY)
            elseif roll < 225 then taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_SOILED) end

        end

        -- 0.5% capricious heart (for any heart except for half red)
        local capriciousRoll = rng:RandomFloat() * 1000
        if capriciousRoll < 5 and subtype ~= HeartSubType.HEART_HALF then
            taintedMorph(pickup, mod.CustomPickups.TaintedHearts.HEART_CAPRICIOUS)
        end
    end
end, PickupVariant.PICKUP_HEART)


--[[---------------------------
    HEARTS TO ADD:

    done! DAUNTLESS - SOUL HEALTH
        - always stays as the rightmost heart
        - gives the Wafer effect while held
        - while only half-filled, enemies killed have a chance to drop half-daunless heart that quickly disappear (like Hypercoagulation)

    done! SOILED - ROTTEN HEALTH
        - stays after rotten hearts
        - spawns 0-2 dips when clearing a room
        
    done! BALEFUL - OVERLAY HEART
        - spawns purgatory ghosts when staying close to enemies while held

    done! EMPTY - OVERLAY HEART
        - grants a permanent Abyss locust if held on to until the next floor

    done! MISER - SOUL HEALTH
        - rerolls all items in the room when depleted
        - passively gives shop discounts while held

    done! ZEALOT - SOUL HEALTH
        - grants a Lemegeton wisp if held on to until the next floor
]]-----------------------------


--------------------
-- REGISTERING HEARTS
---------------------

---------
-- ZEALOT
---------
CustomHealthAPI.Library.RegisterSoulHealth(
    "HEART_ZEALOT",
    {
        AnimationFilename = "gfx/ui/ui_taintedhearts.anm2",
        AnimationName = {"ZealotHeartHalf", "ZealotHeartFull"},
        SortOrder = 200,
        AddPriority = 225,
        HealFlashRO = 189/255,
        HealFlashGO = 95/255,
        HealFlashBO = 182/255,
        MaxHP = 2,
        PrioritizeHealing = true,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = mod.CustomPickups.TaintedHearts.HEART_ZEALOT}
        },
        SumptoriumSubType = mod.ClotIds.ZEALOT,
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_MEAT_IMPACTS,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if CustomHealthAPI.Library.GetHPOfKey(player, "HEART_ZEALOT") > 0 then
            for _ = 1, (CustomHealthAPI.Library.GetHPOfKey(player, "HEART_ZEALOT") + 1) // 2 do
                player:AddItemWisp(mod.GetUnlockedVanillaCollectible(false, false), player.Position, true)
            end
        end
    end
end)

--------
-- MISER
--------
CustomHealthAPI.Library.RegisterSoulHealth(
    "HEART_MISER",
    {
        AnimationFilename = "gfx/ui/ui_taintedhearts.anm2",
        AnimationName = {"MiserHeartHalf", "MiserHeartFull"},
        SortOrder = 150,
        AddPriority = 175,
        HealFlashRO = 245/255,
        HealFlashGO = 240/255,
        HealFlashBO = 66/255,
        MaxHP = 2,
        PrioritizeHealing = true,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = mod.CustomPickups.TaintedHearts.HEART_MISER}
        },
        SumptoriumSubType = 4,  -- golden heart clot
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_MEAT_IMPACTS,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

CustomHealthAPI.Library.AddCallback("RepentancePlus", CustomHealthAPI.Enums.Callbacks.POST_HEALTH_DAMAGED, 0, function(player, flags, key, hpDamaged, wasDepleted, wasLastDamaged)
	if key == "HEART_MISER" then
		if wasDepleted then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, UseFlag.USE_NOANIM)
            sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if pickup.Price <= 0 then return end

    for i = 0, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i)
        local m = CustomHealthAPI.Library.GetHPOfKey(player, "HEART_MISER")

        if m > 0 then
            pickup.Price = math.max(1, math.floor(pickup.Price * (1 - 0.1 * ((m + 1) // 2))))
            pickup.AutoUpdatePrice = false
        end
    end
end)

------------
-- DAUNTLESS
------------
CustomHealthAPI.Library.RegisterSoulHealth(
    "HEART_DAUNTLESS",
    {
        AnimationFilename = "gfx/ui/ui_taintedhearts.anm2",
        AnimationName = {"DauntlessHeartHalf", "DauntlessHeartFull"},
        SortOrder = 300,
        AddPriority = 300,
        HealFlashRO = 155/255,
        HealFlashGO = 168/255,
        HealFlashBO = 171/255,
        MaxHP = 2,
        PrioritizeHealing = false,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS_HALF},
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS}
        },
        SumptoriumSubType = mod.ClotIds.DAUNTLESS,
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_MEAT_IMPACTS,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

CustomHealthAPI.Library.AddCallback("RepentancePlus", CustomHealthAPI.Enums.Callbacks.POST_HEALTH_DAMAGED, 0, function(player, flags, key, hpDamaged, wasDepleted, wasLastDamaged)
	if key == "HEART_DAUNTLESS"
    and CustomHealthAPI.Library.GetHPOfKey(player, "HEART_DAUNTLESS") == 0 then
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_WAFER, 1)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if CustomHealthAPI.Library.GetHPOfKey(player, "HEART_DAUNTLESS") > 0
    and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_WAFER) then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_WAFER, false, 1)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc.MaxHitPoints <= 5 then return end

    for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

        if CustomHealthAPI.Library.GetHPOfKey(player, "HEART_DAUNTLESS") == 1
        or CustomHealthAPI.Library.GetHPOfKey(player, "HEART_DAUNTLESS") > 2 then
			local angle = rng:RandomInt(360)
            local roll = rng:RandomFloat()

			if roll < 0.2 then
				local fadingHeart = Isaac.Spawn(5, PickupVariant.PICKUP_HEART, mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS_HALF, npc.Position, Vector.FromAngle(angle) * 12.5, player)
                fadingHeart:GetData().isFading = true
                fadingHeart:GetData().fadeTimeout = 45
			end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if not pickup:GetData().isFading then return end

    if not pickup:GetData().fadeTimeout or pickup:GetData().fadeTimeout <= 0 then
        pickup:Remove()
    else
        pickup:GetData().fadeTimeout = pickup:GetData().fadeTimeout - 1
        if pickup:GetData().fadeTimeout <= 30 then
            if pickup:GetData().fadeTimeout % 2 == 1 then
                pickup.Visible = false
            else
                pickup.Visible = true
            end
        end
    end
end, PickupVariant.PICKUP_HEART)

---------
-- SOILED
---------
CustomHealthAPI.Library.RegisterRedHealth(
    "HEART_SOILED",
    {
            AnimationFilenames = {
            EMPTY_HEART = "gfx/ui/ui_taintedhearts.anm2",
            BONE_HEART = "gfx/ui/ui_taintedhearts.anm2",
        },
        AnimationNames = {
            EMPTY_HEART = {"SoiledHeart"},
            BONE_HEART = {"SoiledBoneHeart"},
        },
        SortOrder = 175,
        AddPriority = 175,
        HealFlashRO = 107/255,
        HealFlashGO = 33/255,
        HealFlashBO = 6/255,
        MaxHP = 1,
        ProtectsDealChance = true,
        PrioritizeHealing = false,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = mod.CustomPickups.TaintedHearts.HEART_SOILED}
        },
        SumptoriumSubType = mod.ClotIds.SOILED,
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_ROTTEN_HEART,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_)
    for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

        if CustomHealthAPI.Library.GetHPOfKey(player, "HEART_SOILED") > 0 then
            rng:SetSeed(player.InitSeed + Random(), 1)

            for _ = 1, CustomHealthAPI.Library.GetHPOfKey(player, "HEART_SOILED") do
                -- normal dips (subtypes 0-14, so 14/45 ~ 30% to spawn any dip)
                local randomDip = rng:RandomInt(70)
                if randomDip < 15 then
                    Isaac.Spawn(3, FamiliarVariant.DIP, randomDip, player.Position, Vector.Zero, player)
                end

                -- Fiend Folio special dips (12% chance to spawn one)
                if FiendFolio and rng:RandomFloat() < 0.12 then
                    local FFDips = {
                        666,    -- drop
                        667,    -- cursed
                        668,    -- bee
                        669,    -- platinum
                        670,    -- spider
                        671     -- evil
                    }
                    local randomFFDip = FFDips[rng:RandomInt(#FFDips) + 1]
                    Isaac.Spawn(3, FamiliarVariant.DIP, randomFFDip, player.Position, Vector.Zero, player)
                end
            end
        end
    end
end)

-----------------------------
-- helper for displaying
-- overlay hearts since
-- they aren't actually fully
-- supported by the CHAPI

-- put the getters beforehand because they are needed for GetRightmostHeartForRender
local function GetBalefulHearts(player)
    return player:GetData().CustomHealthAPISavedata and player:GetData().CustomHealthAPISavedata.Overlays["HEART_BALEFUL"] or 0
end
local function GetEmptyHearts(player)
    return player:GetData().CustomHealthAPISavedata and player:GetData().CustomHealthAPISavedata.Overlays["HEART_EMPTY"] or 0
end

local function GetRightmostHeartForRender(player, reduceHigherPriority)
    -- If true, reduce the number of Baleful hearts from the value, because they have higher rendering priority then Empty hearts
    reduceHigherPriority = reduceHigherPriority or false
	local rm

	if player:GetSoulHearts() > 0 then
		rm = math.floor((player:GetMaxHearts() + player:GetSoulHearts()) / 2  + player:GetBoneHearts() + 0.5)
	elseif player:GetBoneHearts() > 0 then
		rm = player:GetBoneHearts() + player:GetMaxHearts() / 2
	else
		rm = math.floor(player:GetHearts() / 2 + 0.5)
	end

    if reduceHigherPriority then rm = rm - GetBalefulHearts(player) end
	return rm - 1 - player:GetGoldenHearts()
end

local function CanPickOverlayHeart(player)
    return GetRightmostHeartForRender(player) >= GetBalefulHearts(player) + GetEmptyHearts(player)
end

mod.CanPickOverlayHeart = CanPickOverlayHeart

----------
-- BALEFUL
----------
CustomHealthAPI.Library.RegisterHealthOverlay(
    "HEART_BALEFUL",
    {
        AnimationFilename = "gfx/ui/ui_taintedhearts.anm2",
        AnimationName = "BalefulHeart",
        IgnoreBleeding = true,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = mod.CustomPickups.TaintedHearts.HEART_BALEFUL}
        },
        SumptoriumSubType = 3,  -- eternal clot
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_MEAT_IMPACTS,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

local balefulSprite = Sprite()
balefulSprite:Load("gfx/ui/ui_taintedhearts.anm2", true)
balefulSprite:Play("BalefulHeart", true)

local function AddBalefulHearts(player, amount)
    -- remove them with negative numbers

    local b = player:GetData().CustomHealthAPISavedata.Overlays["HEART_BALEFUL"]

    if amount >= 0 then
        b = (b or 0) + amount
        sfx:Play(SoundEffect.SOUND_SUPERHOLY, 1, 2, false, 1, 0)
    else
        if not b or b == 0 then return end

        b = math.max(0, b + amount)
    end

    player:GetData().CustomHealthAPISavedata.Overlays["HEART_BALEFUL"] = b
end

mod.AddBalefulHearts = AddBalefulHearts

CustomHealthAPI.Library.AddCallback("RepentancePlus", CustomHealthAPI.Enums.Callbacks.POST_RENDER_HP_BAR, 0,
    function(player, playerSlot, renderOffset)
        if GetBalefulHearts(player) > 0 then
            for i = 0, GetBalefulHearts(player) - 1 do
                local slot = GetRightmostHeartForRender(player) - i
                CustomHealthAPI.Helper.RenderHealth(balefulSprite, player, playerSlot, slot, renderOffset, 0, Vector.Zero)
            end
        end
    end
)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if GetBalefulHearts(player) > 0 then
        local enemies = Isaac.FindInRadius(player.Position, (GetBalefulHearts(player) + 1) * 50, EntityPartition.ENEMY)

        for _, enemy in pairs(enemies) do
            if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy(false)
            and (not player:GetData().ghostSpawnCountdown or player:GetData().ghostSpawnCountdown <= 0) then
                local ghost = Isaac.Spawn(1000, 189, 1, player.Position, Vector.Zero, player)
                ghost.CollisionDamage = GetBalefulHearts(player) * (player.Damage / 1.25)
                player:GetData().ghostSpawnCountdown = 90
            end
        end

        if player:GetData().ghostSpawnCountdown then
            player:GetData().ghostSpawnCountdown = player:GetData().ghostSpawnCountdown - 1
        end
    end
end)


--------
-- EMPTY
--------
CustomHealthAPI.Library.RegisterHealthOverlay(
    "HEART_EMPTY",
    {
        AnimationFilename = "gfx/ui/ui_taintedhearts.anm2",
        AnimationName = "EmptyHeart",
        IgnoreBleeding = true,
        PickupEntities = {
            {ID = EntityType.ENTITY_PICKUP, Var = PickupVariant.PICKUP_HEART, Sub = mod.CustomPickups.TaintedHearts.HEART_EMPTY}
        },
        SumptoriumSubType = 6,  -- rotten clot
        SumptoriumSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumTrailColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00),
        SumptoriumCollectSoundSettings = {
            ID = SoundEffect.SOUND_ROTTEN_HEART,
            Volume = 1.0,
            FrameDelay = 0,
            Loop = false,
            Pitch = 1.0,
            Pan = 0
        }
    }
)

local emptySprite = Sprite()
emptySprite:Load("gfx/ui/ui_taintedhearts.anm2", true)
emptySprite:Play("EmptyHeart", true)

local function AddEmptyHearts(player, amount)
    local b = player:GetData().CustomHealthAPISavedata.Overlays["HEART_EMPTY"]

    if amount >= 0 then
        b = (b or 0) + amount
        sfx:Play(SoundEffect.SOUND_ROTTEN_HEART, 1, 2, false, 1, 0)
    else
        if not b or b == 0 then return end

        b = math.max(0, b + amount)
    end

    player:GetData().CustomHealthAPISavedata.Overlays["HEART_EMPTY"] = b
end

mod.AddEmptyHearts = AddEmptyHearts

CustomHealthAPI.Library.AddCallback("RepentancePlus", CustomHealthAPI.Enums.Callbacks.POST_RENDER_HP_BAR, 0,
    function(player, playerSlot, renderOffset)
        if GetEmptyHearts(player) > 0 then
            for i = 0, GetEmptyHearts(player) - 1 do
                local slot = GetRightmostHeartForRender(player, true) - i
                CustomHealthAPI.Helper.RenderHealth(emptySprite, player, playerSlot, slot, renderOffset, 0, Vector.Zero)
            end
        end
    end
)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if GetEmptyHearts(player) > 0 then
            for _ = 1, GetEmptyHearts(player) do
                Isaac.Spawn(3, FamiliarVariant.ABYSS_LOCUST, 7, player.Position, Vector.Zero, player)
            end
        end
    end
end)


-----------------
-- overlay health
-- damage callback
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, tookDamage, amount, flags, sourceRef, countdownFrames)
    if flags & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE or mod.isSelfDamage(flags, "taintedhearts") then return end

    local player = tookDamage:ToPlayer()
    if not player or GetBalefulHearts(player) + GetEmptyHearts(player) == 0
    or player:GetGoldenHearts() > 0 then return end

    if amount == 2 or player:GetSoulHearts() % 2 == 1
    or (player:GetSoulHearts() == 0 and player:GetHearts() % 2 == 1) then
        if GetBalefulHearts(player) > 0 then
            AddBalefulHearts(player, -1)
        else
            AddEmptyHearts(player, -1)
        end
    end
end)


----------------
-- ENIGMA HEARTS
--[[
    While not technically being overlay hearts,
    they'd still use FF's save manager, for convenience purposes.
]]

local EnigmaRenderPos = Vector(122, 22)
local enigmaSprite = Sprite()
enigmaSprite:Load("gfx/ui/ui_taintedhearts.anm2", true)
enigmaSprite:SetFrame("EnigmaHeart", 0)

local function GetEnigmaHearts(player)
    return player:GetData().CustomHealthAPISavedata and player:GetData().CustomHealthAPISavedata.NumEnigmaHearts or 0
end
mod.GetEnigmaHearts = GetEnigmaHearts

local function SetEnigmaHearts(player, amount)
    player:GetData().CustomHealthAPISavedata.NumEnigmaHearts = amount
end
mod.SetEnigmaHearts = SetEnigmaHearts

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function(_)
    local mainPlayer = Isaac.GetPlayer(0)
    local hudOffset = Options.HUDOffset

    if GetEnigmaHearts(mainPlayer) > 0 and game:GetHUD():IsVisible() then
        enigmaSprite:Render(EnigmaRenderPos + Vector(20, 12) * hudOffset, Vector.Zero, Vector.Zero)
        Isaac.RenderScaledText('x' .. tostring(GetEnigmaHearts(mainPlayer)),
            EnigmaRenderPos.X + 20 * hudOffset, EnigmaRenderPos.Y - 4 + 12 * hudOffset,
            0.9, 0.9, 0.75, 0.75, 0.75, 1
        )
    end
end)

-------------
-- SUMPTORIUM
-------------
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, Tear)
	if Tear.SpawnerEntity and Tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
		local familiars = Isaac.FindInRadius(Tear.Position - Tear.Velocity, 0.0001, EntityPartition.FAMILIAR)

		for _, familiar in ipairs(familiars) do
			if familiar.Variant == FamiliarVariant.BLOOD_BABY then
				if familiar.SubType == mod.ClotIds.DAUNTLESS then
                    Tear:GetData().isDauntlessClot = true
                elseif familiar.SubType == mod.ClotIds.SOILED then
                    Tear:GetData().isSoiledClot = true
                elseif familiar.SubType == mod.ClotIds.EMPTY then
                    Tear:GetData().isEmptyClot = true
                elseif familiar.SubType == mod.ClotIds.ZEALOT then
                    Tear:GetData().isZealotClot = true
                end
			end
		end
	elseif Tear.SpawnerEntity and Tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR then
		local familiar = Tear.SpawnerEntity:ToFamiliar()
		if familiar.Variant == FamiliarVariant.BLOOD_BABY then
			if familiar.SubType == mod.ClotIds.DAUNTLESS then
                Tear:GetData().isDauntlessClot = true
            elseif familiar.SubType == mod.ClotIds.SOILED then
                Tear:GetData().isSoiledClot = true
            elseif familiar.SubType == mod.ClotIds.EMPTY then
                Tear:GetData().isEmptyClot = true
            elseif familiar.SubType == mod.ClotIds.ZEALOT then
                Tear:GetData().isZealotClot = true
            end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, Tear)
    if Tear.FrameCount ~= 1 then return end

	if Tear:GetData().isDauntlessClot or Tear:GetData().isSoiledClot
	or Tear:GetData().isEmptyClot or Tear:GetData().isZealotClot then
		rng:SetSeed(Tear.InitSeed + Random(), 1)
		local roll = rng:RandomFloat() * 100

		if Tear:GetData().isDauntlessClot then
			Tear.Color = Color(1.5, 2, 2, 0.5, 0, 0, 0)
			Tear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_SHIELDED)
		elseif Tear:GetData().isSoiledClot then
			Tear.Color = Color(204 / 255, 102 / 255, 0, 1.0, 0, 0, 0)
			if roll < 5 then
				Tear:AddTearFlags(TearFlags.TEAR_ECOLI)
			end
		elseif Tear:GetData().isEmptyClot then
			Tear.Color = Color(0.27, 0.9, 0.4, 1, 0, 0, 0)
			Tear:AddTearFlags(TearFlags.TEAR_MULLIGAN)
		else
			Tear.Color = Color(204 / 255, 0, 102 / 255, 1.0, 0, 0, 0)
			if roll < 7.5 then
				Tear:AddTearFlags(TearFlags.TEAR_CONFUSION)
			elseif roll < 15 then
				Tear:AddTearFlags(TearFlags.TEAR_FEAR)
			end
		end
	end
end)

--------------------
-- PICKING HEARTS UP
-- HEARTS UPDATE
--------------------
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if pickup.SubType < 84 or pickup.SubType > 100 then return end

	local sprite = pickup:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle", false)
	end
	if sprite:IsPlaying("Collect") and sprite:GetFrame() > 5 then
		pickup:Remove()
	end

    if pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_HARLOT then
        if not pickup:GetData().TargetPlayer then
            for i = 0, game:GetNumPlayers() - 1 do
                local p = Isaac.GetPlayer(i)
                if p:CanPickRedHearts() then
                    pickup:GetData().TargetPlayer = p
                    break
                end
            end
        else
            pickup.Velocity = (pickup:GetData().TargetPlayer.Position - pickup.Position):Normalized() * 2.25
        end
    elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_DECEIVER then
        if #Isaac.FindInRadius(pickup.Position, 30, EntityPartition.PLAYER) > 0 then
            rng:SetSeed(Random() + 1, 1)
            local roll = (rng:RandomInt(3) + 2) * 10	-- 20, 30 or 40

            Isaac.Spawn(5, 10, HeartSubType.HEART_HALF, pickup.Position, Vector.FromAngle(math.random(360)), pickup)
            Isaac.Spawn(5, roll, 1, pickup.Position, Vector.FromAngle(math.random(360)), pickup)
            Isaac.Spawn(1000, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
            pickup:Remove()
            sfx:Play(SoundEffect.SOUND_BROWNIE_LAUGH)
        end
    elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_ENIGMA then
        -- Reset transparency
        pickup.Color = pickup.Color * Color(1, 1, 1, 1 / pickup.Color.A, 0, 0, 0)

        local playersNearby = false

        for j = 1, 20 do
            if not playersNearby and #Isaac.FindInRadius(pickup.Position, j * 15, EntityPartition.PLAYER) > 0 then
                pickup.Color = pickup.Color * Color(1, 1, 1, (21 - j) / 20, 0, 0, 0)
                playersNearby = true
            end
        end

        if not playersNearby then
            pickup.Color = pickup.Color * Color(1, 1, 1, 0.05, 0, 0, 0)
        end
    end
end, PickupVariant.PICKUP_HEART)

---@param pickup EntityPickup
---@param collider EntityPlayer
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if (pickup.SubType < 84 or pickup.SubType > 101) and pickup.SubType ~= HeartSubType.HEART_GOLDEN then return end
    if collider.Type ~= EntityType.ENTITY_PLAYER then return end

    local collider = collider:ToPlayer()
    local bowMultiplier = collider:HasCollectible(CollectibleType.COLLECTIBLE_MAGGYS_BOW) and 2 or 1
	local hasApple = collider:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
    local sprite = pickup:GetSprite()

    if pickup:IsShopItem() and (pickup.Price > collider:GetNumCoins() or not collider:IsExtraAnimationFinished()) then
        return true
    elseif sprite:IsPlaying("Collect") then
        return true
    elseif pickup.Wait > 0 then
        return not sprite:IsPlaying("Idle")
    elseif sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
        if pickup.Price == PickupPrice.PRICE_SPIKES then
            local tookDamage = collider:TakeDamage(2.0, 268435584, EntityRef(nil), 30)
            if not tookDamage then
                return pickup:IsShopItem()
            end
        end

        -- SOUL HEALTH
        if CustomHealthAPI.Library.CanPickKey(collider, HeartKey[pickup.SubType]) then
            CustomHealthAPI.Library.AddHealth(collider, HeartKey[pickup.SubType], 2, true)
            sfx:Play(HeartPickupSound[pickup.SubType], 1, 0, false, 1.0)

        elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_DAUNTLESS_HALF then
            CustomHealthAPI.Library.AddHealth(collider, "HEART_DAUNTLESS", 1, true)
            sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION, 1, 0, false, 1.0)

        -- NON-UI HEARTS
        elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_BROKEN then
			collider:AddMaxHearts(2)
			collider:AddBrokenHearts(1)
            if collider:GetBrokenHearts() >= 12 then
                collider:Die()
            end
			sfx:Play(SoundEffect.SOUND_BONE_SNAP)

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_HOARDED then
			local heartsLeft = math.min(math.max(0, collider:GetEffectiveMaxHearts() - collider:GetHearts()), 8)
			if hasApple then
				rng:SetSeed(Random() + 1, 1)

				if rng:RandomFloat() <= (collider:CanPickRedHearts() and 0.5 or 1) then
					collider:UseActiveItem(CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS, UseFlag.USE_NOANIM, -1)
					collider:UseActiveItem(CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS, UseFlag.USE_NOANIM, -1)
					game:Fart(pickup.Position, 85, pickup, 1, 1, Color.Default)
					sfx:Play(SoundEffect.SOUND_FART)
				else
					sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
					collider:AddHearts(8 * bowMultiplier)
					if collider:GetJarHearts() < 8 then
						collider:AddJarHearts(8 - heartsLeft)
					end
				end
			else
				if collider:CanPickRedHearts()
				or (collider:GetJarHearts() < 8 and collider:HasCollectible(CollectibleType.COLLECTIBLE_THE_JAR)) then
					collider:AddHearts(8 * bowMultiplier)
					collider:AddJarHearts(8 - heartsLeft)
					sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
				else
					return pickup:IsShopItem()
				end
			end

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_CURDLED then
            if collider:CanPickRedHearts() or isNoRedHealthCharacter(collider) then
                collider:AddHearts(2 * bowMultiplier)
                sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
                sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
                local s = isNoRedHealthCharacter(collider) and 1 or 0
                if collider:GetPlayerType() == PlayerType.PLAYER_THELOST
                or collider:GetPlayerType() == PlayerType.PLAYER_THELOST_B
                or collider:GetPlayerType() == PlayerType.PLAYER_BETHANY then
                    s = 3
                elseif collider:GetPlayerType() == PlayerType.PLAYER_KEEPER
                or collider:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                    s = 4
                elseif collider:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                    s = 5
                end
                local trueCollider = collider:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and collider:GetOtherTwin() or collider
                CustomHealthAPI.PersistentData.IgnoreSumptoriumHandling = true
                Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, s, trueCollider.Position, Vector.Zero, trueCollider)
                CustomHealthAPI.PersistentData.IgnoreSumptoriumHandling = false
            else
                return pickup:IsShopItem()
            end

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_SAVAGE then
			if collider:CanPickRedHearts() then
				collider:AddHearts(2 * bowMultiplier)
			else
				mod.addTemporaryDmgBoost(collider)
			end
			mod.addTemporaryDmgBoost(collider)
			sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_BENIGHTED then
			if collider:CanPickBlackHearts() then
				collider:AddBlackHearts(2)
				collider = collider:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and collider:GetOtherTwin() or collider
				collider:GetEffects():AddCollectibleEffect(mod.CustomCollectibles.HEART_BENIGHTED_NULL)
				collider:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				collider:EvaluateItems()
				sfx:Play(SoundEffect.SOUND_UNHOLY)
			else
				return pickup:IsShopItem()
			end

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_ENIGMA then
			SetEnigmaHearts(collider, GetEnigmaHearts(collider) + 1)
            if collider:GetSubPlayer() then
                SetEnigmaHearts(collider:GetSubPlayer(), GetEnigmaHearts(collider))
            end
            sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)

        elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_CAPRICIOUS then
			rng:SetSeed(pickup.DropSeed, 1)
			local roll2 = rng:RandomFloat() * 100
			local num = 1
			if roll2 < 10 then
				num = 3
			elseif roll2 < 40 then
				num = 2
			end

			for _ = 1, num do
				local roll = rng:RandomInt(12) + 1
				Isaac.Spawn(5, 10, roll, pickup.Position, Vector.FromAngle(roll * 30) * 3, collider)
			end
			sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_HARLOT then
			local heartsLeft = math.min(math.max(0, collider:GetEffectiveMaxHearts() - collider:GetHearts()), 2)

			if collider:CanPickRedHearts()
			or (collider:GetJarHearts() < 8 and collider:HasCollectible(CollectibleType.COLLECTIBLE_THE_JAR)) then
				collider:AddHearts(2 * bowMultiplier)
				collider:AddJarHearts(2 - heartsLeft)
				local lep = Isaac.Spawn(3, FamiliarVariant.LEPROSY, 0, collider.Position, Vector.Zero, collider):ToFamiliar()
                lep:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/harlot_heart_leprosy.png")
                lep:GetSprite():LoadGraphics()
				sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
			else
				return pickup:IsShopItem()
			end

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_FETTERED then
			if (collider:GetNumKeys() > 0 or collider:HasGoldenKey())
            and (collider:CanPickSoulHearts() or collider:HasCollectible(mod.CustomCollectibles.THE_HOOD)) then
				collider:AddSoulHearts(2)
				collider:GetEffects():AddCollectibleEffect(mod.CustomCollectibles.ORBITAL_GHOSTS, false, 100)
                collider:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
				collider:AddKeys(collider:HasGoldenKey() and 0 or -1)
				sfx:Play(SoundEffect.SOUND_HOLY)
			else
				return pickup:IsShopItem()
			end

		elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_DESERTED then
			if collider:CanPickRedHearts() or collider:CanPickBlackHearts() then
                local redHeartsToFill = collider:GetEffectiveMaxHearts() - collider:GetHearts() - collider:GetRottenHearts()

                if redHeartsToFill == 0 then
                    collider:AddBlackHearts(2)
                    sfx:Play(SoundEffect.SOUND_UNHOLY)
                elseif redHeartsToFill == 1 then
                    collider:AddBlackHearts(1)
                    collider:AddHearts(1)
                    sfx:Play(SoundEffect.SOUND_UNHOLY)
                else
                    collider:AddHearts(2)
                    sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
                end
            else
                return pickup:IsShopItem()
            end

        -- OVERLAY HEARTS
        elseif CanPickOverlayHeart(collider) then
            if pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_BALEFUL  then
                AddBalefulHearts(collider, 1)
            elseif pickup.SubType == mod.CustomPickups.TaintedHearts.HEART_EMPTY  then
                AddEmptyHearts(collider, 1)
            elseif pickup.SubType == HeartSubType.HEART_GOLDEN then
                collider:AddGoldenHearts(1)
                sfx:Play(SoundEffect.SOUND_GOLD_HEART, 1, 2, false, 1, 0)
            end

        else
            return pickup:IsShopItem()
        end

        if pickup.OptionsPickupIndex ~= 0 then
            for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
                (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed) then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
                    entity:Remove()
                end
            end
        end

        if pickup:IsShopItem() then
            local pickupSprite = pickup:GetSprite()
            local holdSprite = Sprite()

            holdSprite:Load(pickupSprite:GetFilename(), true)
            holdSprite:Play(pickupSprite:GetAnimation(), true)
            holdSprite:SetFrame(pickupSprite:GetFrame())
            collider:AnimatePickup(holdSprite)

            if pickup.Price > 0 then
                collider:AddCoins(-1 * pickup.Price)
            end

            CustomHealthAPI.Library.TriggerRestock(pickup)
            CustomHealthAPI.Helper.TryRemoveStoreCredit(collider)

            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            pickup:Remove()
        else
            sprite:Play("Collect", true)
            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            pickup:Die()
        end

        game:GetLevel():SetHeartPicked()
        game:ClearStagesWithoutHeartsPicked()
        game:SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

        return true
    else
        return false
    end
end, PickupVariant.PICKUP_HEART)

----------------------------
-- custom Dark Bum behaviour
-- that allows him to
-- pick up Hoarded Hearts
----------------------------
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
    local roomHoardedHearts = {}
    for _, heart in pairs(Isaac.FindByType(5, 10, mod.CustomPickups.TaintedHearts.HEART_HOARDED)) do
        if heart:GetSprite():IsPlaying("Idle") then
            table.insert(roomHoardedHearts, heart)
        end
    end

    if #roomHoardedHearts == 0 then
        familiar:GetData().toGo = nil
        return
    else
        familiar:GetData().toGo = roomHoardedHearts[1]
    end

    if familiar:GetData().toGo then
        familiar.Velocity = (familiar:GetData().toGo.Position - familiar.Position):Normalized() * 5

        if familiar.Position:Distance(familiar:GetData().toGo.Position) < 5 then
            familiar:AddHearts(8)
            familiar:GetData().toGo:GetSprite():Play("Collect", true)
            familiar:GetData().toGo.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            familiar:GetData().toGo:Die()
            familiar:GetData().toGo = nil
        end
    end
end, FamiliarVariant.DARK_BUM)