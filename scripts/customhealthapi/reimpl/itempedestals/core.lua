function CustomHealthAPI.Helper.AddStrawmanDetectionCallback()
	CustomHealthAPI.PersistentData.OriginalAddCallback(CustomHealthAPI.Mod, ModCallbacks.MC_POST_PLAYER_INIT, CustomHealthAPI.Mod.StrawmanDetectionCallback, -1)
end
CustomHealthAPI.OtherCallbacksToAdd[ModCallbacks.MC_POST_PLAYER_INIT] = CustomHealthAPI.OtherCallbacksToAdd[ModCallbacks.MC_POST_PLAYER_INIT] or {}
table.insert(CustomHealthAPI.OtherCallbacksToAdd[ModCallbacks.MC_POST_PLAYER_INIT], CustomHealthAPI.Helper.AddStrawmanDetectionCallback)

function CustomHealthAPI.Helper.RemoveStrawmanDetectionCallback()
	CustomHealthAPI.Mod:RemoveCallback(ModCallbacks.MC_POST_PLAYER_INIT, CustomHealthAPI.Mod.StrawmanDetectionCallback)
end
CustomHealthAPI.OtherCallbacksToRemove[ModCallbacks.MC_POST_PLAYER_INIT] = CustomHealthAPI.OtherCallbacksToRemove[ModCallbacks.MC_POST_PLAYER_INIT] or {}
table.insert(CustomHealthAPI.OtherCallbacksToRemove[ModCallbacks.MC_POST_PLAYER_INIT], CustomHealthAPI.Helper.RemoveStrawmanDetectionCallback)

function CustomHealthAPI.Mod:StrawmanDetectionCallback(player)
	player:GetData().CustomHealthAPIPersistent = player:GetData().CustomHealthAPIPersistent or {}
	player:GetData().CustomHealthAPIPersistent.SpawnedAsKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER -- For item pickup callback to be able to detect Strawmen
end

function CustomHealthAPI.Helper.AddItemPedestalCollisionCallback()
	CustomHealthAPI.PersistentData.OriginalAddCallback(CustomHealthAPI.Mod, ModCallbacks.MC_PRE_PICKUP_COLLISION, CustomHealthAPI.Mod.ItemPedestalCollisionCallback, PickupVariant.PICKUP_COLLECTIBLE)
end
CustomHealthAPI.ForceEndCallbacksToAdd[ModCallbacks.MC_PRE_PICKUP_COLLISION] = CustomHealthAPI.ForceEndCallbacksToAdd[ModCallbacks.MC_PRE_PICKUP_COLLISION] or {}
CustomHealthAPI.ForceEndCallbacksToAdd[ModCallbacks.MC_PRE_PICKUP_COLLISION][PickupVariant.PICKUP_COLLECTIBLE] = CustomHealthAPI.ForceEndCallbacksToAdd[ModCallbacks.MC_PRE_PICKUP_COLLISION][PickupVariant.PICKUP_COLLECTIBLE] or {}
table.insert(CustomHealthAPI.ForceEndCallbacksToAdd[ModCallbacks.MC_PRE_PICKUP_COLLISION][PickupVariant.PICKUP_COLLECTIBLE], CustomHealthAPI.Helper.AddItemPedestalCollisionCallback)

function CustomHealthAPI.Helper.RemoveItemPedestalCollisionCallback()
	CustomHealthAPI.Mod:RemoveCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CustomHealthAPI.Mod.ItemPedestalCollisionCallback)
end
CustomHealthAPI.ForceEndCallbacksToRemove[ModCallbacks.MC_PRE_PICKUP_COLLISION] = CustomHealthAPI.ForceEndCallbacksToRemove[ModCallbacks.MC_PRE_PICKUP_COLLISION] or {}
CustomHealthAPI.ForceEndCallbacksToRemove[ModCallbacks.MC_PRE_PICKUP_COLLISION][PickupVariant.PICKUP_COLLECTIBLE] = CustomHealthAPI.ForceEndCallbacksToRemove[ModCallbacks.MC_PRE_PICKUP_COLLISION][PickupVariant.PICKUP_COLLECTIBLE] or {}
table.insert(CustomHealthAPI.ForceEndCallbacksToRemove[ModCallbacks.MC_PRE_PICKUP_COLLISION][PickupVariant.PICKUP_COLLECTIBLE], CustomHealthAPI.Helper.RemoveItemPedestalCollisionCallback)

function CustomHealthAPI.Mod:ItemPedestalCollisionCallback(pickup, collider)
	local collectibleConfig = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
	local isActive = nil
	if collectibleConfig then
		isActive = collectibleConfig.Type == ItemType.ITEM_ACTIVE
	end

	if collider.Type == EntityType.ENTITY_PLAYER and
	   collider.Variant == 0
	then
		local player = collider:ToPlayer()
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() ~= nil then
			player = player:GetOtherTwin()
		end
		local data = player:GetData().CustomHealthAPISavedata
		local pdata = player:GetData().CustomHealthAPIPersistent

		if not CustomHealthAPI.Helper.PlayerIsIgnored(player) and
		   player:CanPickupItem() and
		   player:IsExtraAnimationFinished() and
		   player.ItemHoldCooldown <= 0 and
		   not player:IsCoopGhost() and
		   (collider.Parent == nil or (pdata and pdata.SpawnedAsKeeper and not isActive)) and --Strawman
		   player:GetPlayerType() ~= PlayerType.PLAYER_CAIN_B and
		   pickup.SubType ~= 0 and
		   pickup.Wait <= 0 and
		   not pickup.Touched and
		   CustomHealthAPI.Helper.CanAffordPickup(player, pickup) and
		   data ~= nil
		then
			if player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B or
			   player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
			then
				data.CurrentQueuedItem = pickup.SubType
				return
			end
			
			local updatingPrice = false
			if pickup.Price == -1 then
				--1 Red
				CustomHealthAPI.Library.AddHealth(player, "EMPTY_HEART", -2)
				updatingPrice = true
			elseif pickup.Price == -2 then
				--2 Red
				CustomHealthAPI.Library.AddHealth(player, "EMPTY_HEART", -4)
				updatingPrice = true
			elseif pickup.Price == -3 then
				--3 soul
				local soulHp = CustomHealthAPI.Helper.GetTotalSoulHP(player)
				local soulToRemove = math.min(6, math.ceil(soulHp / 2) * 2)
				local maxToRemove = 6 - soulToRemove
				
				if soulToRemove > 0 then
					CustomHealthAPI.Library.AddHealth(player, "SOUL_HEART", soulToRemove * -1)
				end
				if maxToRemove > 0 and not CustomHealthAPI.Helper.PlayerIsTheSoul(player) then
					CustomHealthAPI.Library.AddHealth(player, "EMPTY_HEART", maxToRemove * -1)
				end
				
				updatingPrice = true
			elseif pickup.Price == -4 then
				--1 Red, 2 Soul
				CustomHealthAPI.Library.AddHealth(player, "EMPTY_HEART", -2)
				CustomHealthAPI.Library.AddHealth(player, "SOUL_HEART", -4)
				updatingPrice = true
			elseif pickup.Price == -7 then
				--1 Soul
				CustomHealthAPI.Library.AddHealth(player, "SOUL_HEART", -2)
				updatingPrice = true
			elseif pickup.Price == -8 then
				--2 Souls
				CustomHealthAPI.Library.AddHealth(player, "SOUL_HEART", -4)
				updatingPrice = true
			elseif pickup.Price == -9 then
				--1 Red, 1 Soul
				CustomHealthAPI.Library.AddHealth(player, "EMPTY_HEART", -2)
				CustomHealthAPI.Library.AddHealth(player, "SOUL_HEART", -2)
				updatingPrice = true
			end
			
			if updatingPrice then
				pickup.AutoUpdatePrice = false
				pickup.Price = PickupPrice.PRICE_FREE
				if CustomHealthAPI.Helper.GetTotalHP(player) == 0 then
					if CustomHealthAPI.Helper.PlayerIsTheForgotten(player) then
						CustomHealthAPI.PersistentData.OverriddenFunctions.AddBoneHearts(player, 1)
						CustomHealthAPI.PersistentData.OverriddenFunctions.AddHearts(player, 2)
						pickup.Price = -1
					elseif CustomHealthAPI.Helper.PlayerIsTheSoul(player) then
						CustomHealthAPI.PersistentData.OverriddenFunctions.AddSoulHearts(player, 2)
						pickup.Price = -7
					elseif CustomHealthAPI.PersistentData.CharactersThatConvertMaxHealth[player:GetPlayerType()] then
						CustomHealthAPI.PersistentData.OverriddenFunctions.AddSoulHearts(player, 2)
						pickup.Price = -7
					else
						CustomHealthAPI.PersistentData.OverriddenFunctions.AddMaxHearts(player, 2)
						CustomHealthAPI.PersistentData.OverriddenFunctions.AddHearts(player, 2)
						pickup.Price = -1
					end
				end
			end
			
			data.CurrentQueuedItem = pickup.SubType
		end
	end
end

function CustomHealthAPI.Helper.HandleCollectibleHP(player, item)
	local playerType = player:GetPlayerType()
	
	if item == CollectibleType.COLLECTIBLE_BIRTHRIGHT then
		if playerType == PlayerType.PLAYER_MAGDALENE or playerType == PlayerType.PLAYER_MAGDALENE_B then
			CustomHealthAPI.Helper.UpdateHealthMasks(player, "EMPTY_HEART", 2)
			CustomHealthAPI.Helper.UpdateHealthMasks(player, "RED_HEART", 2)
			CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
		end
	elseif item == CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT then
		-- not handled atm
	elseif item == CollectibleType.COLLECTIBLE_GREEDS_GULLET then
		-- not handled atm
	elseif item == CollectibleType.COLLECTIBLE_ABADDON then
		CustomHealthAPI.Helper.HandleAbaddon(player)
		CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
	elseif item == CollectibleType.COLLECTIBLE_MARROW then
		CustomHealthAPI.Helper.UpdateHealthMasks(player, "BONE_HEART", 1)
		CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
	elseif item == CollectibleType.COLLECTIBLE_DIVORCE_PAPERS then
		CustomHealthAPI.Helper.UpdateHealthMasks(player, "BONE_HEART", 1)
		CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
	elseif item == CollectibleType.COLLECTIBLE_BRITTLE_BONES then
		CustomHealthAPI.Helper.HandleBrittleBones(player)
		CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
	elseif item == CollectibleType.COLLECTIBLE_HEARTBREAK then
		CustomHealthAPI.Helper.UpdateHealthMasks(player, "BROKEN_HEART", 3)
		CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
	elseif item == CollectibleType.COLLECTIBLE_FATE then
		CustomHealthAPI.Helper.UpdateHealthMasks(player, "ETERNAL_HEART", 1)
		CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
	elseif item == CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION then
		CustomHealthAPI.Helper.UpdateHealthMasks(player, "ETERNAL_HEART", 1)
		CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
	else
		local config = Isaac:GetItemConfig():GetCollectible(item)
		if config ~= nil then
			local maxHpToAdd = config.AddMaxHearts
			local redHpToAdd = config.AddHearts
			local soulHpToAdd = config.AddSoulHearts
			local blackHpToAdd = config.AddBlackHearts
			
			local needToUpdateState = false
			if soulHpToAdd ~= 0 then
				CustomHealthAPI.Helper.UpdateHealthMasks(player, "SOUL_HEART", soulHpToAdd)
				needToUpdateState = true
			end
			if blackHpToAdd ~= 0 then
				CustomHealthAPI.Helper.UpdateHealthMasks(player, "BLACK_HEART", blackHpToAdd)
				needToUpdateState = true
			end
			if maxHpToAdd ~= 0 then
				CustomHealthAPI.Helper.UpdateHealthMasks(player, "EMPTY_HEART", maxHpToAdd)
				needToUpdateState = true
			end
			if redHpToAdd ~= 0 then
				CustomHealthAPI.Helper.UpdateHealthMasks(player, "RED_HEART", redHpToAdd)
				needToUpdateState = true
			end
			
			if needToUpdateState then
				CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
			end
		end
	end
end

function CustomHealthAPI.Helper.HandleCollectiblePickup(player)
	if not CustomHealthAPI.Helper.PlayerIsIgnored(player) then
		local data = player:GetData().CustomHealthAPISavedata
		
		local queuedItem = player.QueuedItem
		
		if data ~= nil and data.CurrentQueuedItem ~= nil and (queuedItem.Item == nil or queuedItem.Item.ID ~= data.CurrentQueuedItem) then
			local item = data.CurrentQueuedItem
			data.CurrentQueuedItem = nil
			CustomHealthAPI.Helper.HandleCollectibleHP(player, item)
		end
		if data ~= nil and data.CurrentQueuedItem == nil and queuedItem.Item ~= nil and not queuedItem.Touched and queuedItem.Item:IsCollectible() then
			data.CurrentQueuedItem = queuedItem.Item.ID
		end
	end
end
