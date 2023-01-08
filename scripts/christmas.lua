--[[local mod = RepentancePlusMod
local hud = Game():GetHUD()

local PICKUP_CHRISTMAS_GIFT = 103

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        local sg = Isaac.Spawn(6, mod.CustomSlots.SLOT_STARGAZER, 1, Vector(200, 160), Vector.Zero, nil)
        sg:GetSprite():Play("Idle")
    end
end)


--
    beggar

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
    for _, sg in pairs(Isaac.FindByType(6, mod.CustomSlots.SLOT_STARGAZER, 1, false, false)) do

        if not Game():GetRoom():IsFirstVisit()
        or Game():GetLevel():GetStartingRoomIndex() ~= Game():GetLevel():GetCurrentRoomIndex() then
            sg:Remove()
        end

		local sprite = sg:GetSprite()

		if sprite:IsFinished("PayPrize") then
            sg:GetData().payouts = sg:GetData().payouts and sg:GetData().payouts + 1 or 1
            if sg:GetData().payouts == 3 then
			    sprite:Play("Teleport")
            else
                sprite:Play("Prize")
            end
		elseif sprite:IsFinished("Teleport") then
			sg:Remove()
		elseif sprite:IsFinished("Prize") then
			sprite:Play("Idle")
		end

		if sprite:IsPlaying("Teleport")
		and sprite:IsEventTriggered("Disappear") then
            Isaac.Spawn(5, 100, mod.CustomCollectibles.TANK_BOYS, Vector(200, 240), Vector.Zero, nil)
            SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
		end

		if sprite:IsPlaying("Prize")
		and sprite:IsEventTriggered("Prize") then
            Isaac.Spawn(5, PickupVariant.PICKUP_GRAB_BAG, PICKUP_CHRISTMAS_GIFT, sg.Position, Vector.FromAngle(math.random(360)) * 5, nil)
            SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if #Isaac.FindByType(6, mod.CustomSlots.SLOT_STARGAZER, 1) > 0 then
		for _, moddedSlot in pairs(Isaac.FindByType(6, mod.CustomSlots.SLOT_STARGAZER, 1)) do
			if moddedSlot.Position:Distance(player.Position) < 32 then
				local s = moddedSlot:GetSprite()

				if s:IsPlaying("Idle") then
					s:Play("PayPrize")
					SFXManager():Play(SoundEffect.SOUND_SCAMPER)
				end
            end
        end
    end
end)

--
    present

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if pickup.SubType ~= PICKUP_CHRISTMAS_GIFT then return end

    local sp = pickup:GetSprite()
    if sp:IsFinished("Appear") then
        sp:Play("Idle")
    elseif sp:IsFinished("Collect") then
        pickup:Remove()
    end
end, PickupVariant.PICKUP_GRAB_BAG)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, _)
    if pickup.SubType ~= PICKUP_CHRISTMAS_GIFT then return end

    local player = collider:ToPlayer()
    local sp = pickup:GetSprite()
    if not player or not sp:IsPlaying("Idle") then return end

    sp:Play("Collect")
    pickup:Die()
    player:AnimateHappy()
    hud:ShowFortuneText("Merry Christmas!", "(and Happy Year+)")
end, PickupVariant.PICKUP_GRAB_BAG)
--]]

