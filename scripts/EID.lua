-- storing descriptions for helpers --
--------------------------------------
TornPageDesc = {}
TornPageDesc["en_us"] = {
	[-1] = "<Modded book, no effect>", --Modded books
	[CustomCollectibles.BOOK_OF_GENESIS] = "Gives you 4 options to choose from instead of 3",
	[CustomCollectibles.BOOK_OF_LEVIATHAN] = "Doesn't require keys to be used",
	[CustomCollectibles.BOOK_OF_JUDGES] = "Doubles burning damage and duration",
	[CollectibleType.COLLECTIBLE_NECRONOMICON] = "Spawns 3 locusts of death on use",
	[CollectibleType.COLLECTIBLE_BIBLE] = "Removes a broken heart",
	[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = "Prevents Harbingers from spawning in boss rooms",
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = "Also grants Eye of Belial effect for the room",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = "Has a 3% chance to spawn a pedestal item, normal chest or a golden chest",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = "The shield has extended durability",
	[CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = "Grants a bone heart on use",
	[CollectibleType.COLLECTIBLE_HOW_TO_JUMP] = "When landing, shoot tears in X or + pattern",
	[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "All wisps have 1.5x more health",
	[CollectibleType.COLLECTIBLE_SATANIC_BIBLE] = "Grants you a choice of 2 devil deal items after defeating a boss",
	[CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = "Grants the Wiz (Dunce Cap) effect on use",
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = "Spawns a golden troll bomb instead",
	[CollectibleType.COLLECTIBLE_LEMEGETON] = "Can be used at partial charge to gain remaining charges at the cost of player's red health (as if you have {{Collectible205}})",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS] = "Gains 2 charges back when used",
	[CollectibleType.COLLECTIBLE_MONSTER_MANUAL] = "Gains 2 charges back when used",
}
TornPageDesc["ko_kr"] = {
	[-1] = "<추가 효과 없음>", --Modded books
	[CustomCollectibles.BOOK_OF_GENESIS] = "3개가 아닌 4개의 선택지가 주어집니다.",
	[CustomCollectibles.BOOK_OF_LEVIATHAN] = "열쇠 없이 사용할 수 있습니다.",
	[CustomCollectibles.BOOK_OF_JUDGES] = "화염 피해 및 지속 시간 2배.",
	[CollectibleType.COLLECTIBLE_NECRONOMICON] = "죽음의 메뚜기 파리 3마리를 소환합니다.",
	[CollectibleType.COLLECTIBLE_BIBLE] = "소지 불가능 하트 하나를 제거합니다.",
	[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = "보스가 4기사로 교체되지 않습니다.",
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = "현재 방에서 Eye of Belial 아이템의 효과를 얻습니다.",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = "3%의 확률로 아이템, 상자, 혹은 황금상자를 드랍합니다.",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = "보호막의 지속 시간이 증가합니다.",
	[CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = "{{BoneHeart}}뼈하트 +1",
	[CollectibleType.COLLECTIBLE_HOW_TO_JUMP] = "착지 시 십자, 혹은 X자 방향으로 눈물을 쏩니다.",
	[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "불꽃의 체력이 1.5배로 증가합니다.",
	[CollectibleType.COLLECTIBLE_SATANIC_BIBLE] = "보스방의 악마 거래 아이템이 하나 추가됩니다. 둘 중 하나만 획득할 수 있습니다.",
	[CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = "사용시 the Wiz 아이템의 효과를 얻습니다.",
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = "황금 트롤 폭탄이 대신 소환됩니다.",
	[CollectibleType.COLLECTIBLE_LEMEGETON] = "{{Collectible205}}충전량이 부족한 경우 빨간하트를 소모하여 재충전할 수 있습니다.",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS] = "사용시 2칸의 충전량을 보존합니다.",
	[CollectibleType.COLLECTIBLE_MONSTER_MANUAL] = "사용시 2칸의 충전량을 보존합니다.",
}
TornPageDesc["zh_cn"] = {
	[-1] = "<其他Mod的书，无效果>", --Modded books
	[CustomCollectibles.BOOK_OF_GENESIS] = "使用时获得4个选择而不是3个",
	[CustomCollectibles.BOOK_OF_LEVIATHAN] = "不需要钥匙也可以使用",
	[CustomCollectibles.BOOK_OF_JUDGES] = "双倍燃烧伤害和持续时间",
	[CollectibleType.COLLECTIBLE_NECRONOMICON] = "使用时产生三只死亡蝗虫",
	[CollectibleType.COLLECTIBLE_BIBLE] = "移除一颗碎心",
	[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = "天启四骑士不会在Boss房生成",
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = "同时获得彼列之眼的效果",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = "有3%的几率生成一个底座道具、普通箱子或者金箱子",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = "护盾持续时间更久",
	[CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = "使用时获得一个骨心",
	[CollectibleType.COLLECTIBLE_HOW_TO_JUMP] = "落地时，以X或者+的形式发射眼泪",
	[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "被动道具火焰精灵（所罗门魔典）的生命值提高1.5倍",
	[CollectibleType.COLLECTIBLE_SATANIC_BIBLE] = "本层使用并击败Boss后，有两个恶魔房道具可以选择",
	[CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = "使用时获得蠢巫帽(你是巫师吗)效果",
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = "改为生成金色即爆炸弹",
	[CollectibleType.COLLECTIBLE_LEMEGETON] = "可以在拥有部分充能的情况下以红心为代价进行充能并使用",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS] = "使用后立即获得2充能",
	[CollectibleType.COLLECTIBLE_MONSTER_MANUAL] = "使用后立即获得2充能",
}
TornPageDesc["ru"] = {
	[-1] = "<Эффекта нет>", --Modded books
	[CustomCollectibles.BOOK_OF_GENESIS] = "Дает выбор из 4 предметов, вместо 3",
	[CustomCollectibles.BOOK_OF_LEVIATHAN] = "Не нуждается в ключах для использования",
	[CustomCollectibles.BOOK_OF_JUDGES] = "Удваивает урон от горения и продолжительность",
	[CollectibleType.COLLECTIBLE_NECRONOMICON] = "Призывает 3 саранчи смерти",
	[CollectibleType.COLLECTIBLE_BIBLE] = "Убирает сломанное сердце",
	[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = "Предотвращает появление всадников в босс комнатах",
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = "Дает эффект Глаза Белиала",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = "Имеет 3% шанс призвать предмет на пьедестале, сундук или золотой сундук",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = "Увеличивает продолжительность эффекта",
	[CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = "Дает костяное сердце",
	[CollectibleType.COLLECTIBLE_HOW_TO_JUMP] = "При приземлении стреляет слезами в 4 направлениях",
	[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "Все огоньки имеют увеличенное здоровье",
	[CollectibleType.COLLECTIBLE_SATANIC_BIBLE] = "После убийства босса призывает 2 предмета дьявола на выбор",
	[CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = "Дает эффект {{Collectible358}}Волшебника",
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = "Вместо этого призывает золотую тролль бомбу",
	[CollectibleType.COLLECTIBLE_LEMEGETON] = "Может быть использован при неполном заряде, за оставшиеся заряды вы платите красным здоровьем",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS] = "+2 заряда после использования",
	[CollectibleType.COLLECTIBLE_MONSTER_MANUAL] = "+2 заряда после использования",
}
TornPageDesc["spa"] = {
	[-1] = "<Libro de mod, no tiene efecto>", --Modded books
	[CustomCollectibles.BOOK_OF_GENESIS] = "Te da a elegir 4 opciones en vez de 3",
	[CustomCollectibles.BOOK_OF_LEVIATHAN] = "No necesitas llaves para usarlo",
	[CustomCollectibles.BOOK_OF_JUDGES] = "Duplica el daño de fuego y la duración",
	[CollectibleType.COLLECTIBLE_NECRONOMICON] = "Genera 3 langostaas de Muerte",
	[CollectibleType.COLLECTIBLE_BIBLE] = "{{BrokenHeart}} Remueve un corazón roto al usarlo",
	[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = "Evita que los jinetes aparezcan en la sala del jefe",
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = "Otorga el efecto del Ojo de Belial durante la sala",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = "3% de posibilidad de generar un pedestal de item, un cofre regular o un cofre dorado",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = "Duración del escudo extendida",
	[CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = "{{EmptyBoneHeart}} Otorga un corazón de hueso al usarlo",
	[CollectibleType.COLLECTIBLE_HOW_TO_JUMP] = "Al aterrizar, dispararás lágrimas en un patrón 'x' o '+'",
	[CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = "Las flamas tienen 1.5 veces más HP",
	[CollectibleType.COLLECTIBLE_SATANIC_BIBLE] = "Otorga 2 opciones de trato con el Diablo al vencer a un jefe",
	[CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = "Grants the Wiz (Dunce Cap) effect on use",
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = "Generará una bomba troll dorada",
	[CollectibleType.COLLECTIBLE_LEMEGETON] = "Puede usarse sin cargar por completo, recargándose a cambio de dañar al jugador",
	[CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS] = "Recibe 2 cargas tras usarlo",
	[CollectibleType.COLLECTIBLE_MONSTER_MANUAL] = "Recibe 2 cargas tras usarlo"
}

KeyTrinketsDesc = {}
KeyTrinketsDesc["en_us"] = {
	[CustomTrinkets.BASEMENT_KEY] = "Crippled enemies can spawn bone orbitals on death",
	[CustomTrinkets.KEY_TO_THE_HEART] = "Crippled enemies can drop half red heart on death",
	[CustomTrinkets.KEY_KNIFE] = "Applies bleed to crippled enemies",
	[TrinketType.TRINKET_STORE_KEY] = "Crippled enemies can drop random pickup on death",
	[TrinketType.TRINKET_RUSTED_KEY] = "Applies confusion to crippled enemies",
	[TrinketType.TRINKET_CRYSTAL_KEY] = "Can randomly freeze enemies on death",
	[TrinketType.TRINKET_BLUE_KEY] = "Crippled enemies can drop half soul heart on death",
	[TrinketType.TRINKET_STRANGE_KEY] = "Applies random status effect to enemies",
	[TrinketType.TRINKET_GILDED_KEY] = "Can randomly Midas freeze enemies on use",
}
KeyTrinketsDesc["ko_kr"] = {
	[CustomTrinkets.BASEMENT_KEY] = "무력화된 적 처치 시 확률적으로 캐릭터 주변을 도는 뼛조각을 소환합니다.",
	[CustomTrinkets.KEY_TO_THE_HEART] = "무력화된 적 처치 시 확률적으로 빨간하트 반칸을 드랍합니다.",
	[CustomTrinkets.KEY_KNIFE] = "방 안의 적에게 출혈 효과를 추가로 적용합니다.",
	[TrinketType.TRINKET_STORE_KEY] = "무력화된 적 처치 시 확률적으로 픽업 아이템을 드랍합니다.",
	[TrinketType.TRINKET_RUSTED_KEY] = "방 안의 적에게 혼란 효과를 추가로 적용합니다.",
	[TrinketType.TRINKET_CRYSTAL_KEY] = "무력화된 적 처치 시 확률적으로 얼립니다.",
	[TrinketType.TRINKET_BLUE_KEY] = "무력화된 적 처치 시 확률적으로 소울하트 반칸을 드랍합니다.",
	[TrinketType.TRINKET_STRANGE_KEY] = "방 안의 적에게 랜덤 상태이상 효과를 추가로 적용합니다.",
	[TrinketType.TRINKET_GILDED_KEY] = "방 안의 적에게 추가로 일정 확률로 석화시킵니다.",
}
KeyTrinketsDesc["zh_cn"] = {
	[CustomTrinkets.BASEMENT_KEY] = "瘫痪的敌人死后生成骨刺",
	[CustomTrinkets.KEY_TO_THE_HEART] = "瘫痪的敌人死后掉落半颗红心",
	[CustomTrinkets.KEY_KNIFE] = "对瘫痪的敌人施加流血效果",
	[TrinketType.TRINKET_STORE_KEY] = "瘫痪的敌人死后75%概率掉落随机掉落物（炸弹、硬币或钥匙）",
	[TrinketType.TRINKET_RUSTED_KEY] = "对瘫痪的敌人施加混乱效果",
	[TrinketType.TRINKET_CRYSTAL_KEY] = "瘫痪的敌人死亡时75%概率被冰冻",
	[TrinketType.TRINKET_BLUE_KEY] = "瘫痪的敌人死后掉落半颗魂心",
	[TrinketType.TRINKET_STRANGE_KEY] = "对敌人施加随机状态效果",
	[TrinketType.TRINKET_GILDED_KEY] = "使用时随机石化敌人",
}
KeyTrinketsDesc["ru"] = {
	[CustomTrinkets.BASEMENT_KEY] = "Ослабленные враги призывают кости при смерти",
	[CustomTrinkets.KEY_TO_THE_HEART] = "Ослабленные враги призывают половину красного сердца при смерти",
	[CustomTrinkets.KEY_KNIFE] = "Накладывает кровотечение на ослабленных врагов",
	[TrinketType.TRINKET_STORE_KEY] = "Ослабленные враги призывают случайные пикапы при смерти",
	[TrinketType.TRINKET_RUSTED_KEY] = "Накладывает оглушение на ослабленных врагов",
	[TrinketType.TRINKET_CRYSTAL_KEY] = "Может заморозить врагов при смерти",
	[TrinketType.TRINKET_BLUE_KEY] = "Ослабленные враги призывают полвину сердца души при смерти",
	[TrinketType.TRINKET_STRANGE_KEY] = "Накладывает случайные эффекта на врагов",
	[TrinketType.TRINKET_GILDED_KEY] = "Может превратить врагов в золотые статуи при использовании",
}
KeyTrinketsDesc["spa"] = {
	[CustomTrinkets.BASEMENT_KEY] = "Los enemigos lisiados podrán generar orbitales de hueso al morir",
	[CustomTrinkets.KEY_TO_THE_HEART] = "Los enemigos lisiados podrán generar medios corazones rojos de hueso al morir",
	[CustomTrinkets.KEY_KNIFE] = "{{BleedingOut}} Aplica sangrado a los enemigos lisiados",
	[TrinketType.TRINKET_STORE_KEY] = "Los enemigos lisiados pueden soltar un recolectable al morir",
	[TrinketType.TRINKET_RUSTED_KEY] = "{{Confusion}} Aplica confusión a los enemigos lisiados",
	[TrinketType.TRINKET_CRYSTAL_KEY] = "{{Freezing}} Los enemigos se congelan al morir",
	[TrinketType.TRINKET_BLUE_KEY] = "Los enemigos lisiados pueden soltar medio corazón de alma al morir",
	[TrinketType.TRINKET_STRANGE_KEY] = "Aplica un efecto de estado aleatorio a los enemigos",
	[TrinketType.TRINKET_GILDED_KEY] = "Puede aplicar el efecto del Toque de Midas a los enemigos"
}

-- making a Spindown Dice Shard roll helper --
----------------------------------------------
local function SpindownDiceCallback(descObj)
	EID:appendToDescription(descObj, "#{{Collectible723}}:")
	local refID = descObj.ObjSubType
	
	for i = 1,EID.Config["SpindownDiceResults"] do
		local spinnedID = EID:getSpindownResult(refID)
		refID = spinnedID
		if refID > 0 and refID < 4294960000 then
			EID:appendToDescription(descObj, "{{Collectible"..refID.."}}")
			if EID.itemUnlockStates[refID] == false then EID:appendToDescription(descObj, "?") end
			if i ~= EID.Config["SpindownDiceResults"] then
				EID:appendToDescription(descObj, " ->")
			end
		else
			local errorMsg = EID:getDescriptionEntry("spindownError") or ""
			EID:appendToDescription(descObj, errorMsg)
			break
		end
	end
	
	return descObj
end

local function SpindownDiceShardCondition(descObj)
	if descObj.ObjType ~= 5 or descObj.ObjVariant ~= PickupVariant.PICKUP_COLLECTIBLE then
		return false
	end
	
	if EID.player:GetCard(0) == CustomConsumables.SPINDOWN_DICE_SHARD then
		return true
	end
	
	return false
end
EID:addDescriptionModifier("Spindown Dice Shard", SpindownDiceShardCondition, SpindownDiceCallback)


-- making custom helper for Torn Page bonuses to book effects --
----------------------------------------------------------------
local function TornPageCallback(descObj)
	local lang = EID:getLanguage() or "en_us"
	EID:appendToDescription(descObj, "#{{Trinket" .. tostring(CustomTrinkets.TORN_PAGE) .. "}}: ")
	local refID = descObj.ObjSubType
	local refTables = TornPageDesc[lang] or TornPageDesc["en_us"]

	if refTables[refID] then
		EID:appendToDescription(descObj, refTables[refID])
	else
		EID:appendToDescription(descObj, refTables[-1])
	end
	
	return descObj
end

local function TornPageCondition(descObj)
	if descObj.ObjType ~= 5 or descObj.ObjVariant ~= PickupVariant.PICKUP_COLLECTIBLE 
	or (Isaac.GetItemConfig():GetCollectible(descObj.ObjSubType).Tags & ItemConfig.TAG_BOOK ~= ItemConfig.TAG_BOOK) then
		return false
	end
	
	if EID.player:HasTrinket(CustomTrinkets.TORN_PAGE) then
		return true
	end
	
	return false
end
EID:addDescriptionModifier("Torn Page", TornPageCondition, TornPageCallback)


-- making helper for Book of Leviathan + key trinkets --
--------------------------------------------------------
local function KeyTrinketsCallback(descObj)
	local lang = EID:getLanguage() or "en_us"
	local refID = descObj.ObjSubType % 32768
	local refTables = KeyTrinketsDesc[lang] or KeyTrinketsDesc["en_us"]

	if refTables[refID] then
		EID:appendToDescription(descObj, "#{{Collectible" .. tostring(CustomCollectibles.BOOK_OF_LEVIATHAN) .. "}}: ")
		EID:appendToDescription(descObj, refTables[refID])
	end
	return descObj
end

local function KeyTrinketsCondition(descObj)
	if descObj.ObjType ~= 5 or descObj.ObjVariant ~= PickupVariant.PICKUP_TRINKET then
		return false
	end
	
	if EID.player:HasCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN) then
		return true
	end
	
	return false
end
EID:addDescriptionModifier("Key Trinkets for Book of Leviathan", KeyTrinketsCondition, KeyTrinketsCallback)


-- changing mod's name and indicator for EID --
-----------------------------------------------
EID:setModIndicatorName("Repentance Plus")
local iconSprite = Sprite()
iconSprite:Load("gfx/eid_logo_icon.anm2", true)
EID:addIcon("RPlus Icon", "Icon", 0, 8, 8, 6, 6, iconSprite)
EID:setModIndicatorIcon("RPlus Icon")


-- adding icons for cards/runes --
----------------------------------
if true then
	local SPINDOWN_DICE_SHARD_CARDFRONT = Sprite()
	SPINDOWN_DICE_SHARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.SPINDOWN_DICE_SHARD, "Spindown Dice Shard", 0, 9, 9, 0.5, 1.5, SPINDOWN_DICE_SHARD_CARDFRONT)

	local RED_RUNE_CARDFRONT = Sprite()
	RED_RUNE_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.RED_RUNE, "Red Rune", 0, 9, 9, 0.5, 1.5, RED_RUNE_CARDFRONT)

	local NEEDLE_AND_THREAD_CARDFRONT = Sprite()
	NEEDLE_AND_THREAD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.NEEDLE_AND_THREAD, "Needle and Thread", 0, 9, 9, 0.5, 1.5, NEEDLE_AND_THREAD_CARDFRONT)

	local QUEEN_OF_DIAMONDS_CARDFRONT = Sprite()
	QUEEN_OF_DIAMONDS_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.QUEEN_OF_DIAMONDS, "Queen of Diamonds", 0, 9, 9, 0.5, 1.5, QUEEN_OF_DIAMONDS_CARDFRONT)

	local KING_OF_SPADES_CARDFRONT = Sprite()
	KING_OF_SPADES_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.KING_OF_SPADES, "King of Spades", 0, 9, 9, 0.5, 1.5, KING_OF_SPADES_CARDFRONT)

	local KING_OF_CLUBS_CARDFRONT = Sprite()
	KING_OF_CLUBS_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.KING_OF_CLUBS, "King of Clubs", 0, 9, 9, 0.5, 1.5, KING_OF_CLUBS_CARDFRONT)

	local KING_OF_DIAMONDS_CARDFRONT = Sprite()
	KING_OF_DIAMONDS_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.KING_OF_DIAMONDS, "King of Diamonds", 0, 9, 9, 0.5, 1.5, KING_OF_DIAMONDS_CARDFRONT)

	local BAG_TISSUE_CARDFRONT = Sprite()
	BAG_TISSUE_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.BAG_TISSUE, "Bag Tissue", 0, 9, 9, 0.5, 1.5, BAG_TISSUE_CARDFRONT)

	local JOKER_Q_CARDFRONT = Sprite()
	JOKER_Q_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.JOKER_Q, "Joker?", 0, 9, 9, 0.5, 1.5, JOKER_Q_CARDFRONT)

	local UNO_REVERSE_CARD_CARDFRONT = Sprite()
	UNO_REVERSE_CARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.UNO_REVERSE_CARD, "Reverse Card", 0, 9, 9, 0.5, 1.5, UNO_REVERSE_CARD_CARDFRONT)

	local LOADED_DICE_CARDFRONT = Sprite()
	LOADED_DICE_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.LOADED_DICE, "Loaded Dice", 0, 9, 9, 0.5, 1.5, LOADED_DICE_CARDFRONT)

	local BEDSIDE_QUEEN_CARDFRONT = Sprite()
	BEDSIDE_QUEEN_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.BEDSIDE_QUEEN, "Bedside Queen", 0, 9, 9, 0.5, 1.5, BEDSIDE_QUEEN_CARDFRONT)

	local QUEEN_OF_CLUBS_CARDFRONT = Sprite()
	QUEEN_OF_CLUBS_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.QUEEN_OF_CLUBS, "Queen of Clubs", 0, 9, 9, 0.5, 1.5, QUEEN_OF_CLUBS_CARDFRONT)

	local JACK_OF_CLUBS_CARDFRONT = Sprite()
	JACK_OF_CLUBS_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.JACK_OF_CLUBS, "Jack of Clubs", 0, 9, 9, 0.5, 1.5, JACK_OF_CLUBS_CARDFRONT)

	local JACK_OF_DIAMONDS_CARDFRONT = Sprite()
	JACK_OF_DIAMONDS_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.JACK_OF_DIAMONDS, "Jack of Diamonds", 0, 9, 9, 0.5, 1.5, JACK_OF_DIAMONDS_CARDFRONT)

	local JACK_OF_SPADES_CARDFRONT = Sprite()
	JACK_OF_SPADES_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.JACK_OF_SPADES, "Jack of Spades", 0, 9, 9, 0.5, 1.5, JACK_OF_SPADES_CARDFRONT)

	local JACK_OF_HEARTS_CARDFRONT = Sprite()
	JACK_OF_HEARTS_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.JACK_OF_HEARTS, "Jack of Hearts", 0, 9, 9, 0.5, 1.5, JACK_OF_HEARTS_CARDFRONT)

	local QUASAR_SHARD_CARDFRONT = Sprite()
	QUASAR_SHARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.QUASAR_SHARD, "Quasar Shard", 0, 9, 9, 0.5, 1.5, QUASAR_SHARD_CARDFRONT)

	local BUSINESS_CARD_CARDFRONT = Sprite()
	BUSINESS_CARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.BUSINESS_CARD, "Business Card", 0, 9, 9, 0.5, 1.5, BUSINESS_CARD_CARDFRONT)

	local SACRIFICIAL_BLOOD_CARDFRONT = Sprite()
	SACRIFICIAL_BLOOD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.SACRIFICIAL_BLOOD, "Sacrificial Blood", 0, 9, 9, 0.5, 1.5, SACRIFICIAL_BLOOD_CARDFRONT)

	local LIBRARY_CARD_CARDFRONT = Sprite()
	LIBRARY_CARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.LIBRARY_CARD, "Library Card", 0, 9, 9, 0.5, 1.5, LIBRARY_CARD_CARDFRONT)

	local ANTIMATERIAL_CARD_CARDFRONT = Sprite()
	ANTIMATERIAL_CARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.ANTIMATERIAL_CARD, "Antimaterial Card", 0, 9, 9, 0.5, 1.5, ANTIMATERIAL_CARD_CARDFRONT)

	local FUNERAL_SERVICES_CARDFRONT = Sprite()
	FUNERAL_SERVICES_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.FUNERAL_SERVICES, "Funeral Services", 0, 9, 9, 0.5, 1.5, FUNERAL_SERVICES_CARDFRONT)

	local MOMS_ID_CARDFRONT = Sprite()
	MOMS_ID_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.MOMS_ID, "Mom's ID", 0, 9, 9, 0.5, 1.5, MOMS_ID_CARDFRONT)

	local FIEND_FIRE_CARDFRONT = Sprite()
	FIEND_FIRE_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.FIEND_FIRE, "Fiend Fire", 0, 9, 9, 0.5, 1.5, FIEND_FIRE_CARDFRONT)

	local DEMON_FORM_CARDFRONT = Sprite()
	DEMON_FORM_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.DEMON_FORM, "Demon Form", 0, 9, 9, 0.5, 1.5, DEMON_FORM_CARDFRONT)

	local VALENTINES_CARD_CARDFRONT = Sprite()
	VALENTINES_CARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.VALENTINES_CARD, "Valentine's Card", 0, 9, 9, 0.5, 1.5, VALENTINES_CARD_CARDFRONT)

	local SPIRITUAL_RESERVES_CARDFRONT = Sprite()
	SPIRITUAL_RESERVES_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.SPIRITUAL_RESERVES, "Spectral Reserves", 0, 9, 9, 0.5, 1.5, SPIRITUAL_RESERVES_CARDFRONT)

	local MIRRORED_LANDSCAPE_CARDFRONT = Sprite()
	MIRRORED_LANDSCAPE_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.MIRRORED_LANDSCAPE, "Mirrored Landscape", 0, 9, 9, 0.5, 1.5, MIRRORED_LANDSCAPE_CARDFRONT)

	local CURSED_CARD_CARDFRONT = Sprite()
	CURSED_CARD_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.CURSED_CARD, "Cursed Card", 0, 9, 9, 0.5, 1.5, CURSED_CARD_CARDFRONT)

	local CROWN_OF_GREED_CARDFRONT = Sprite()
	CROWN_OF_GREED_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.CROWN_OF_GREED , "Crown of Greed", 0, 9, 9, 0.5, 1.5, CROWN_OF_GREED_CARDFRONT)

	local FLOWER_OF_LUST_CARDFRONT = Sprite()
	FLOWER_OF_LUST_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.FLOWER_OF_LUST, "Flower of Lust", 0, 9, 9, 0.5, 1.5, FLOWER_OF_LUST_CARDFRONT)

	local ACID_OF_SLOTH_CARDFRONT = Sprite()
	ACID_OF_SLOTH_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.ACID_OF_SLOTH, "Acid of Sloth", 0, 9, 9, 0.5, 1.5, ACID_OF_SLOTH_CARDFRONT)

	local VOID_OF_GLUTTONY_CARDFRONT = Sprite()
	VOID_OF_GLUTTONY_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.VOID_OF_GLUTTONY, "Void of Gluttony", 0, 9, 9, 0.5, 1.5, VOID_OF_GLUTTONY_CARDFRONT)

	local APPLE_OF_PRIDE_CARDFRONT = Sprite()
	APPLE_OF_PRIDE_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.APPLE_OF_PRIDE, "Apple of Pride", 0, 9, 9, 0.5, 1.5, APPLE_OF_PRIDE_CARDFRONT)

	local CANINE_OF_WRATH_CARDFRONT = Sprite()
	CANINE_OF_WRATH_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.CANINE_OF_WRATH, "Canine of Wrath", 0, 9, 9, 0.5, 1.5, CANINE_OF_WRATH_CARDFRONT)

	local MASK_OF_ENVY_CARDFRONT = Sprite()
	MASK_OF_ENVY_CARDFRONT:Load("gfx/ui/eid_cardfronts.anm2", true)
	EID:addIcon("Card"..CustomConsumables.MASK_OF_ENVY, "Mask of Envy", 0, 9, 9, 0.5, 1.5, MASK_OF_ENVY_CARDFRONT)
end


-- adding metadata for Placebo, Blank Card and Clear Rune mimicking --
----------------------------------------------------------------------
if true then
	EID:addCardMetadata(CustomConsumables.RED_RUNE, 4, true)
	EID:addCardMetadata(CustomConsumables.QUASAR_SHARD, 6, true)
	EID:addCardMetadata(CustomConsumables.BUSINESS_CARD, 4, false)
	EID:addCardMetadata(CustomConsumables.FLY_PAPER, 12, false)
	EID:addCardMetadata(CustomConsumables.LIBRARY_CARD, 6, false)
	EID:addCardMetadata(CustomConsumables.ANTIMATERIAL_CARD, 12, false)
	EID:addCardMetadata(CustomConsumables.FUNERAL_SERVICES, 12, false)
	EID:addCardMetadata(CustomConsumables.MOMS_ID, 6, false)
	EID:addCardMetadata(CustomConsumables.FIEND_FIRE, 2, false)
	EID:addCardMetadata(CustomConsumables.DEMON_FORM, 12, false)
	EID:addCardMetadata(CustomConsumables.VALENTINES_CARD, 6, false)
	EID:addCardMetadata(CustomConsumables.CURSED_CARD, 2, false)

	EID:addCardMetadata(CustomConsumables.CANINE_OF_WRATH, 6, true)
	EID:addCardMetadata(CustomConsumables.MASK_OF_ENVY, 4, true)
	EID:addCardMetadata(CustomConsumables.CROWN_OF_GREED, 3, true)
	EID:addCardMetadata(CustomConsumables.VOID_OF_GLUTTONY, 12, true)
	EID:addCardMetadata(CustomConsumables.APPLE_OF_PRIDE, 3, true)
	EID:addCardMetadata(CustomConsumables.FLOWER_OF_LUST, 6, true)
	EID:addCardMetadata(CustomConsumables.ACID_OF_SLOTH, 3, true)

	EID:addCardMetadata(CustomConsumables.SPIRITUAL_RESERVES, 12, false)
	EID:addCardMetadata(CustomConsumables.MIRRORED_LANDSCAPE, 2, false)
	EID:addCardMetadata(CustomConsumables.JOKER_Q, 1, false)
	EID:addCardMetadata(CustomConsumables.UNO_REVERSE_CARD, 4, false)
	EID:addCardMetadata(CustomConsumables.KING_OF_SPADES, 6, false)
	EID:addCardMetadata(CustomConsumables.KING_OF_CLUBS, 6, false)
	EID:addCardMetadata(CustomConsumables.KING_OF_DIAMONDS, 6, false)
	EID:addCardMetadata(CustomConsumables.QUEEN_OF_DIAMONDS, 12, false)
	EID:addCardMetadata(CustomConsumables.QUEEN_OF_CLUBS, 12, false)
	EID:addCardMetadata(CustomConsumables.BEDSIDE_QUEEN, 12, false)
	EID:addCardMetadata(CustomConsumables.JACK_OF_DIAMONDS, 2, false)
	EID:addCardMetadata(CustomConsumables.JACK_OF_CLUBS, 2, false)
	EID:addCardMetadata(CustomConsumables.JACK_OF_HEARTS, 2, false)
	EID:addCardMetadata(CustomConsumables.JACK_OF_SPADES, 2, false)

	EID:addPillMetadata(CustomPills.ESTROGEN, 4, "2")
	EID:addPillMetadata(CustomPills.LAXATIVE, 2, "1+")
	EID:addPillMetadata(CustomPills.PHANTOM_PAINS, 4, "2")
	EID:addPillMetadata(CustomPills.YUM, 12, "3+")
	EID:addPillMetadata(CustomPills.YUCK, 6, "2+")
end


	----------------------------------------
	-- THE ACTUAL DESCRIPTIONS START HERE --
	----------------------------------------
 -- big shoutout to contributors once again! --

-- Enlish EID (by Mr. SeemsGood)
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}} Tears up #{{TreasureRoom}} Spawns an additional Mom and Dad related item in Treasure rooms alongside the presented items; only one item can be taken")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "{{Heart}} Gives you one heart container and one broken heart #{{Heart}} Heals you for 2 full red hearts")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "{{BlackHeart}} +2 black hearts #{{ArrowUp}} Damage +2 then x1.5 #{{ArrowUp}} Grants +2 range and -0.2 shotspeed #Grants spectral and piercing tears")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "After each use, has a 5% (100% on 20-th use) chance to be 'solved', removed from the player and be replaced with a Magic Cube item")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "Rerolls item pedestals #{{Collectible402}} Rerolled items can be drawn from any item pool")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "Double tap shooting button to spew a line of {{ColorRainbow}}rainbow{{CR}} creep in the direction you're firing #Random status effect is applied to enemies walking over that creep #{{Collectible66}} Has 4 seconds cooldown")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "Grants you Enoch familiar #On death, if you have any item familiars besides Enoch, revive you and remove them instead; Enoch familiar becomes more powerful; grants you invincibility frames and keeps all your heart containers #{{Warning}} Works only once")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "25% chance to enter Berserk state when taking damage #While in this state, every enemy damaged has a 5% chance to be erased for the rest of the run")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "A familiar that creates blue flies upon clearing a room #Blocks enemy projectiles, but has a chance to break and drop Breakfast or Nightsoil trinket #Spawns more flies the more floors it doesn't break")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "{{Collectible331}} A familiar that shoots Godhead tears that deal 5 damage")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "Killing an enemy has a 20% chance to drop cherry familiar on the ground #Those cherries emit a charming fart when an enemy walks over them, and drop half red heart when clearing a room")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "Upon entering a new room, all enemies will be grouped into pairs randomly. Dealing damage to an enemy will deal 60% of that damage to another enemy in the pair")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "Upon dying you turn into invincible ghost and a bird flies out of room center in a random direction. Catching the bird in 5 seconds will save you and get you back to your death spot, otherwise you will die #{{Warning}} Every time you die, the bird will fly faster and faster, making it harder to catch her")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "Double tap shooting button to launch a ghost familiar in the direction you are firing #The ghost will latch onto the first enemy it collides with, dealing damage over time for 7 seconds or until that enemy is killed #{{Collectible66}} Has a 7 seconds cooldown")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "When shooting, 7% chance to launch a piercing dagger that does no damage, but inflicts bleed on enemies #{{BleedingOut}} All enemies that die while bleeding will drop Sacrificial Blood Consumable that gives you temporary DMG up")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "{{Collectible712}} Grants you two Lemegeton wisps at the beginning of each floor and when sleeping in bed")
	EID:addCollectible(CustomCollectibles.QUASAR, "{{Collectible712}} Consumes all item pedestals in the room and gives you 3 Lemegeton wisps for each item consumed")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "{{Coin}} Every third shop item on the current floor will cost 1 penny")
	EID:addCollectible(CustomCollectibles.RED_MAP, "{{UltraSecretRoom}} Reveals location of Ultra Secret Room #{{Card78}} Any trinket left in a boss or treasure room will turn into Cracked Key, unless this is your first visit in such room")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "{{ArrowUp}} Removes one red heart container and gives you x" .. tostring(CustomStatups.Damage.CHEESE_GRATER_MUL) .. " damage increase and 3 Minisaacs")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "{{Pill}} Pills now have additional effects based on their color")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "Destroys all obstacles in the current room and applies confusion to enemies in small radius around you #Also blows the doors open and opens secret room entrances")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "Prevents curses from appearing for the rest of the run #{{ArrowUp}} Preventing a curse grants you x" .. tostring(CustomStatups.Damage.BLESS_OF_THE_DEAD_MUL) .. " damage increase")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "Spawns 2 Toy Tanks that roam around the room and attack enemies that are in their line of sight #Green tank: rapidly shoots bullets at enemies from a further distance and moves more quickly #Red tank: shoots rockets at enemies at a close range, moves slower")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "{{ArrowUp}} Killing enemies grants you tears and speed up #The bonus is reset when entering a new room")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "{{Bomb}} +5 bombs #Grants explosion immunity #Allows you to throw your bombs instead of placing them on the ground")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "Grants you stat boosts for each familiar you own #Some familiars grant greater stat boosts, and some do not grant them at all (e.g. blue flies, dips or Isaac's body parts)")
	EID:addCollectible(CustomCollectibles.CAT_IN_A_BOX, "Enemies outside your line of sight are paralyzed, cannot attack you in any way and cannot be damaged #{{Confusion}} Periodically applies confusion to bosses and minibosses")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "Removes a random item and spawns 3 items of the same quality #Only one item can be taken")
	EID:addCollectible(CustomCollectibles.SCALPEL, "{{Heart}} Consumes one red heart but permanently makes Isaac shoot more tears in random directions #These tears deal 65% of your damage and have all your tear flags")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "Spawns a golden penny upon entering a new floor #{{Shop}} Shops will now sell 1-4 additional items that are drawn from shop, treasure or boss itempools #If the shop is a Greed fight, it instead spawns 3-4 items when the miniboss dies")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "Double tap to trigger a nerve pinch #{{ArrowDown}} You take fake damage and gain a permanent " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " speed down when that happens #{{ArrowUp}} However, there is an 80% chance to activate your active item for free, even if it's uncharged")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "Taking damage doesn't actually hurt the player, instead filling the blood vessel #This can be repeated 6 times until the vessel is full #Once it's full, using it or taking damage will empty it and deal 3 and 3.5 hearts of damage to the player, respectively #{{Warning}} The Vessel cannot be easily swapped if it's not empty!")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "Orbital that switches between 2 different states every 15 seconds: #Two orbitals that quickly rotate around Isaac #One orbital that rotates slower and closer to Isaac, and periodically shoots teeth in random directions and spawns blood creep underneath it #All orbitals block enemy shots and do contact damage")
	EID:addCollectible(CustomCollectibles.RED_KING, "After defeating a boss, red crawlspace will appear in a middle of a room #{{BossRoom}} Entering the crawlspace brings you to another bossfight of high difficulty #Victory rewards you two items from Ultra secret room pool to choose from")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "Summons the Stargazer beggar #{{SoulHeart}} Can only be charged with soul hearts, similarly to {{Collectible585}} #Can only be used once per floor")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "Upon use, gain invincibility, hold up the bag and suck up all nearby projectiles for 4 seconds #Hold shooting button to release sucked projecties as homing tears in a matching direction")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "Enemies that come close to you become crippled; your tears can also cripple them #Crippled enemies lose their speed overtime, and die afer 12 seconds of losing it #When crippled enemies die, they release a fountain of slowing black tears")
	EID:addCollectible(CustomCollectibles.REJECTION, "On use, consume all your follower familiars and throw them as big piercing poisonous gut ball in your firing direction #Damage formula: your dmg * 4 * number of consumed familiars #Passively grants a familiar that doesn't shoot tears, but deals 2.5 contact damage to enemies")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "Spawns an item from the room's pool for sale #Its price will change rougly 5 times a second #The price is random, but generally increases over time until it reaches {{Coin}}99 #If you leave and re-enter the room, the item disappears")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "Chain yourself to a random enemy with an astral chain and freeze them #The chain deals heavy contact damage to enemies #{{Warning}} Going too far away from chained enemy will break the chain #{{SoulHeart}} Chained enemies have a 33% chance to drop a soul heart when killed #Can chain bosses too for 5 seconds")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}} +0.3 Shot Speed up #Your tears are replaced with piercing feathers that deal more damage the more they travel #Double tap to perform one of Dogma related attacks #{{Collectible66}} Has a 6 seconds cooldown")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "{{ArrowUp}} +0.2 Speed up #After your run ends, 3 random items from your inventory are spawned on the floor where it ended. They can be collected on the next run by getting to the same floor")
	EID:addCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, "#{{Key}} +2 keys on pickup #Requires a key to 'unlock' and use it #Upon use, cripples all enemies in the room #Crippled enemies lose their speed overtime, and die afer 12 seconds of losing it #Has special synergies with key trinkets")
	EID:addCollectible(CustomCollectibles.FRIENDLY_SACK, "After each 3rd completed room, spawns a random weak familiar (such as Dip, Blood clot, fly etc.) #If boss room is a room where Friendly Sack would pay out, it spawns a random charmed monster instead")	
	EID:addCollectible(CustomCollectibles.MAGIC_MARKER, "{{Card}} Drops a random tarot card when picked up #{{Card}} On use, transform held tarot card by increasing its number by 1 (or reducing for reversed tarots)")
	EID:addCollectible(CustomCollectibles.ULTRA_FLESH_KID, "Familiar that chases enemies and deals contact damage #Has 3 stages, collects red hearts to evolve #{{HalfHeart}} A total of 15 hearts needs to be collected to evolve")
	EID:addCollectible(CustomCollectibles.VAULT_OF_HAVOC, "Passively stores killed enemies; can be used as soon as 12 enemies are stored #{{MiniBoss}} Upon use, brings you into a special room with 12 most recently killed enemies; clearing the room spawns a reward based on total HP of spawned enemies")
	EID:addCollectible(CustomCollectibles.PURE_SOUL, "{{MiniBoss}} All sin minibosses have a 100% chance to drop their respective {{ColorRed}}Sin's Jewel{{CR}} #A ghost can spawn in {{SecretRoom}}Secret or {{SuperSecretRoom}}Super Secret room that will disappear and spawn a random sin miniboss when approached #The ghost will also spawn in the doorway that leads to a miniboss room, alarming you of what miniboss is inside")
	EID:addCollectible(CustomCollectibles.HANDICAPPED_PLACARD, "Places a handicapped placard on the ground #{{Weakness}} Every enemy inside the placard's area of effect is weakened and spawns bone spurs on death")
	EID:addCollectible(CustomCollectibles.BOOK_OF_JUDGES, "While in active room, beams of light will strike at random positions marked by crosshairs #Beams hurt enemies and inflict burn on them, but they hurt players too #On use, cancels the effect for the current room")
	EID:addCollectible(CustomCollectibles.BIRTH_CERTIFICATE, "{{Warning}} ONE-TIME USE #Consumes all your currently held trinkets #Teleports you into a special area that contains many trinkets, along with some other pickups #You can choose as many trinkets as you can hold #Teleports you out of the area afterwards")
	EID:addCollectible(CustomCollectibles.BROKEN_TV, "???")

	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "{{DirtyChest}} While held, every Golden Chest has a 25% chance to turn into Old Chest")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "While held, every enemy has a chance to drop Flesh Chest on death")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "{{Bait}} Enemies touching you become feared and targeted by other enemies (effect similar to Rotten Tomato)")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "{{LuckSmall}} Using coin, bomb or key on slots and beggars has a 17% chance to not subtract it from your inventory count")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "{{Coin}} Upon spawning, every coin has a 20% chance to be upgraded to a higher value")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "{{EmptyCoinHeart}} Gives you one empty coin heart #It is depleted before any of your normal hearts and can only be refilled by directly picking up money")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "{{TreasureRoom}} All new treasure rooms will have an angel item for sale instead of a normal item")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "{{ArrowUp}} x2 DMG up while held #{{ArrowDown}} Breaks when you take damage #Having Duct Tape prevents it from breaking")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "Does nothing, it's broken")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "Upon taking damage, one of your items rerolls into another random item #Doesn't take away nor give you story items")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "When entering uncleared room, you will leave a trail of powder #Enemies walking on the powder will be significantly slowed down #The powder lasts for 10 seconds")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "22% chance to revive you as Eve when you die")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "75% chance to prevent a curse when entering a new floor")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "At the beginning of every new floor, grants: #{{ArrowUp}} +10% DMG up #{{ArrowUp}} Size increase #Both damage and size up stay if you drop the trinket")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "{{Library}} Amplifies or changes books' activation effects")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "{{Library}} Books now activate another random active item on use #Doesn't proc items that reroll, hurt or kill you")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "Reduces the size of all enemies (even bosses) by 10% #This affects both sprite and hitbox")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "{{Collectible705}} 8% chance to activate Dark Arts effect when taking damage")
	EID:addTrinket(CustomTrinkets.SHATTERED_STONE, "Chance to spawn random locust when collecting coins, bombs or keys #Chance increases with pickup's rarity")

	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "{{Collectible723}} Invokes the effect of Spindown Dice")
	EID:addCard(CustomConsumables.RED_RUNE, "{{Collectible706}} Damages all enemies in a room, turns item pedestals into red locusts and turns pickups into random locusts with a 50% chance")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "{{BrokenHeart}} If you have any broken hearts, removes one and replaces it with a heart container")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "{{Coin}} Spawns 1-12 random coins #These can be nickels or dimes")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "Lose all your keys and spawn a proportional number of pickups #Can spawn a trinket or an item with a certain chance that grows with the amount of keys and reaches 100% at 9 and 21 keys, respectively #{{GoldenKey}} Removes Golden key as well")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "Lose all your bombs and spawn a proportional number of pickups #Can spawn a trinket or an item with a certain chance that grows with the amount of bombs and reaches 100% at 9 and 21 bombs, respectively #{{GoldenBomb}} Removes Golden bomb as well")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "Lose all your coins and spawn a proportional number of pickups #Can spawn a trinket or an item with a certain chance that grows with the amount of coins and reaches 100% at 18 and 42 coins, respectively")
	EID:addCard(CustomConsumables.BAG_TISSUE, "All pickups in a room are destroyed, and 8 most valuables pickups form an item quality based on their total weight; the item of such quality is then spawned #The most valuable pickups are the rarest ones, e.g. {{EthernalHeart}}Eternal hearts or {{Battery}}Mega batteries")
	EID:addCard(CustomConsumables.JOKER_Q, "{{SuperSecretRoom}} Teleports Isaac to a Black Market")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "{{Collectible422}} Invokes the effect of Glowing Hourglass")
	EID:addCard(CustomConsumables.LOADED_DICE, "{{Luck}} Grants +10 Luck for the current room")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "{{Key}} Spawns 1-12 random keys #There is a small chance to spawn a charged key")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "{{Bomb}} Spawns 1-12 random bombs #There is a chance to spawn a double-pack bomb")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "Bombs will drop more often after clearing rooms for the current floor, and the average quality of bombs is increased")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "Coins will drop more often after clearing rooms the for current floor, and the average quality of coins is increased")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "Keys will drop more often after clearing rooms for the current floor, and the average quality of keys is increased")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "Hearts will drop more often after clearing rooms for the current floor, and the average quality of hearts is increased")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "Damages all enemies in a room and turns every item pedestal into 3 Lemegeton wisps")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "{{Collectible687}} Summons a random friendly controllable monster")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "{{ArrowUp}} Gives +1.25 DMG up that depletes over the span of 25 seconds #{{Collectible216}} Heals you for one heart if you have Ceremonial Robes")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "{{Library}} Activates a random book effect")
	EID:addCard(CustomConsumables.FLY_PAPER, "{{Collectible693}} Spawns 8 fly orbitals")
	EID:addCard(CustomConsumables.MOMS_ID, "Drops knives from above on all enemies, dealing 2x your damage")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES, "{{DirtyChest}} Spawns an Old Chest")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD, "Can be thrown similarly to Chaos Card #If the card touches an enemy, that enemy is erased for the rest of the run")
	EID:addCard(CustomConsumables.FIEND_FIRE, "Sacrifice your consumables for mass room destruction #3-20 total: enemies take 15 damage and burn for 4 seconds #20-40 total: the initital damage, the burning damage and burning duration are doubled; destroys obstacles around you #40+ total: the burning damage and burning duration are quadrupled; produces a Mama Mega explosion")
	EID:addCard(CustomConsumables.DEMON_FORM, "{{Damage}} +0.2 damage for every new uncleared room you enter #+1 damage for entering a boss room #The boost disappears when entering a new floor")
	EID:addCard(CustomConsumables.VALENTINES_CARD, "Can be thrown similarly to Chaos Card #Permanently charms all enemies that it passes through and drops a red heart on use")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "Spawns two ghostly orbital familiars that block enemy shots and shoot spectral tears #{{HalfSoulHeart}} After blocking 3 shots, each ghost dies and drops half a soul heart")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "Your active item moves to the pocket slot #If you've already had pocket active, it drops on a pedestal")
	EID:addCard(CustomConsumables.CURSED_CARD, "For the current room, every hit you would take is negated #{{BrokenHeart}} Instead, it gives you a broken heart and a permanent tears boost")
	--
	EID:addCard(CustomConsumables.CROWN_OF_GREED , "{{Luck}} Spawns 1-2 golden pennies and grants -1 luck for each penny spawned")
	EID:addCard(CustomConsumables.FLOWER_OF_LUST, "Allows you to restart the room and guarantees a better room clear reward")
	EID:addCard(CustomConsumables.ACID_OF_SLOTH, "Slows down all enemies by 50% and makes them leave poisonous gas clouds behind")
	EID:addCard(CustomConsumables.VOID_OF_GLUTTONY, "{{HalfHeart}} For 7 seconds, if you lack red health, you will regenerate it, while also gaining -0.01 speed #The duration is extended by 2 seconds each time you kill an enemy")
	EID:addCard(CustomConsumables.APPLE_OF_PRIDE, "Grants you a moderate boost to all stats until you get hit")
	EID:addCard(CustomConsumables.CANINE_OF_WRATH, "Every enemy in a room explodes, taking 15 damage #{{Warning}} The explosion can hurt you too #Every enemy that dies from the explosion will give you a temporary damage boost")
	EID:addCard(CustomConsumables.MASK_OF_ENVY, "{{RottenBoneHeart}} Turns all your heart containers into bone hearts filled with rotten hearts")

	EID:addPill(CustomPills.ESTROGEN, "{{Trinket176}} Turns all your red health into blood clots #Leaves you at one red heart, other hearts are unaffected")
	EID:addPill(CustomPills.LAXATIVE, "Isaac shoots out corn tears from behind for 3 seconds")
	EID:addPill(CustomPills.PHANTOM_PAINS, "Isaac takes fake damage on pill use, then 15 and 30 seconds after")
	EID:addPill(CustomPills.YUCK, "{{RottenHeart}} Spawns a rotten heart #For 30 seconds, every red heart will spawn blue flies when picked up")
	EID:addPill(CustomPills.YUM, "{{HalfHeart}} Spawns 2-5 half red hearts #{{ArrowUp}} For 30 seconds, every red heart will grant you small permanent stat upgrades when picked up")

	EID:addEntity(5, 10, 84, "Broken Heart", "Gives one full heart container and a broken heart")
	EID:addEntity(5, 10, 85, "Dauntless Heart", "If your total number of red and soul hearts is odd, enemies have a chance to drop half red or soul heart on death #Dropped hearts disappear quickly")
	EID:addEntity(5, 10, 86, "Hoarder Heart", "Heals 4 full red hearts")
	EID:addEntity(5, 10, 87, "Deceiver Heart", "???")
	EID:addEntity(5, 10, 88, "Soiled Heart", "Spawns 0-2 friendly dips upon clearing a room")
	EID:addEntity(5, 10, 89, "Curdled Heart", "Heals full red heart and spawns a blood clot on pickup")
	EID:addEntity(5, 10, 90, "Savage Heart", "Heals full red heart and grants +1.25 damage boost that depletes over the span of 25 seconds #If picked up at full health, grants an additional boost")
	EID:addEntity(5, 10, 91, "Benighted Heart", "Gives full black heart and a permanent +0.16 DMG Up")
	EID:addEntity(5, 10, 92, "Enigma Heart", "Stored in a separate slot #Player can revive if they have at least 1 Enigma heart #Any heart after the first will heal 2 full red hearts after revival")
	EID:addEntity(5, 10, 93, "Capricious Heart", "Splits into 1-3 random hearts upon pickup")
	EID:addEntity(5, 10, 94, "Baleful Heart", "While held, will summon ghosts to attack enemies that get close to you #Each heart increases their damage and allows them to attack from further away")
	EID:addEntity(5, 10, 95, "Harlot Heart", "Heals full red heart and spawns a Leprosy orbital on pickup")
	EID:addEntity(5, 10, 96, "Miser Heart", "When depleted, rerolls all items/pickups in the room #Passively grants discounts in shops while held")
	EID:addEntity(5, 10, 97, "Empty Heart", "{{Collectible706}} Grants you one Abyss locust when entering a new floor")
	EID:addEntity(5, 10, 98, "Fettered Heart", "{{Key}} Requires a key to pick up #Grants a soul heart and a special ghost familiar")
	EID:addEntity(5, 10, 99, "Zealot Heart", "{{Collectible712}} Grants you one Lemegeton wisp when entering a new floor")
	EID:addEntity(5, 10, 100, "Deserter Heart", "Acts as a black heart version of a blended heart")

	EID:assignTransformation("collectible", CustomCollectibles.MARK_OF_CAIN, "9")
	EID:assignTransformation("collectible", CustomCollectibles.CHERUBIM, "4,10")
	EID:assignTransformation("collectible", CustomCollectibles.BOOK_OF_GENESIS, "12")
	EID:assignTransformation("collectible", CustomCollectibles.CROSS_OF_CHAOS, "9")
	EID:assignTransformation("collectible", CustomCollectibles.BOOK_OF_LEVIATHAN, "9, 12")
	EID:assignTransformation("collectible", CustomCollectibles.BOOK_OF_JUDGES, "12")
end

-- EID Spanish (by Kotry)
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}}{{Tears}}Más lágrimas #Genera un objeto relacionado a Mamá o Papá en la {{TreasureRoom}}Sala del tesoro junto al objeto regular; sólo puedes tomar uno", "Vida ordinaria", "spa")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "Te otorga un {{Heart}}un contenedor de corazón y un corazón roto#{{Warning}}¡Tener 12 corazones te matará!", "Cortador de Galletas", "spa")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "{{ArrowUp}}+2 de daño, multiplicador de daño x1.5#{{ArrowDown}}baja la velocidad de tiro#lágrimas teledirigidas", "Corazón de los Pecadores", "spa")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "Tras cada uso, hay un 5% (100% en el uso 20) de probabilidad de 'resolverlo', cuando esto ocurre, se le remueve al jugador y es reemplazado con un Cubo Mágico", "Cubo de Rubik", "spa")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "{{DiceRoom}}Rerolea los pedestales de objetos #Los items reroleados se toman de cualquier pool", "Cubo Mágico", "spa")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "Las lágrimas dejan {{ColorRainbow}}{{CR}}creep arcoíris bajo ellas #Efectos de estado permantenes se aplican a los enemigos que caminen por el creep", "Pluma Mágica", "spa")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "Te otorgará un Bebé Enoch#Si mueres, y tienes más familiares a parte de Enoch, estos serán removidos a cambio de revivir; el bebé Enoch será más poderoso; otorga frames de invencibilidad y conservarás tus corazones #{{Warning}}Sólo funciona una vez", "La Marca de Caín", "spa")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "Al recibir daño, Hay un 25% de probabiliad de entrar al modo Berserk #Mientras el modo esté activo, Cada enemigo dañado tiene un 10% de ser eliminado de la partida", "Temper Tantrum", "spa")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "Un familiar que genera moscas azules al limpiar una habitación #Puede bloquear disparos, al recibir un golpe tiene la posibilidad de romperse y otorgar {{Collectible25}}Desayuno o el trinket La Tierra de la Noch #Mientras más pisos pases sin romperlo, más moscas generará", "Bolsa de Basura", "spa")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "Un familiar que lanza lágrimas de {{Collectible331}}Cabeza de Dios a una cadencia de tiro alta", "Bebé Zen", "spa")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "Matar a un enemigo otorga un 20% de posibilidad de soltar un familiar cereza en el suelo #Estas cerezas emiten un pedo con efecto encantador cuando un enemigo camina sobre ellos, sueltan medio corazón al limpiar la habitación", "Amigos de Cereza", "spa")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "Al entrar en una nueva habitación, Los enemigos serán divididos en pares. Dañar a un enemigo de un par, provocará la mitad del daño hecho en la otra mitad del par", "Muñeco Negro", "spa")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "Al morir, revivirás como un fantasma invencible y un pájaro azul saldrá del centro de la habitación a una dirección aleatoria. Atrapar al pájaro en menos de 5 segundos te salvará y regreserás al punto donde moriste, de otra forma, morirás #{{Warning}}Cada vez que mueres, el pájaro volará con mayor velocidad, volviéndolo más difícil de atrapar", "Un Pájaro de la Esperanza", "spa")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "Presionar dos veces el botón de disparo hará que lances un fantasma en esa dirección#El fantasma se pegará con el primer enemigo con el que choque, dañándolo por 7 segundos o hasta que el enemigo muera #El fantasma también afecta a los jefes #{{Warning}}Tiene un cooldown de 7 segundos", "Alma Iracunda", "spa")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "{{ArrowDown}}Multiplicador de daño de x0.85 #Al disparar, hay un 5% de probabilidad de lanzar una daga que no hiere a los enemigos, pero los hace sangrar#Todo enemigo que muera desangrado soltará el consumible Sangre de Sacrificio, el cual otorgará un {{ArrowUp}}aumento de daño", "Daga Ceremonial", "spa")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "Otorga dos flamas de {{Collectible712}}Lemegeton por cada piso avanzado y cama a la que se va a dormir", "Móvil de estrellas", "spa")
	EID:addCollectible(CustomCollectibles.QUASAR, "Consume todos los objetos en pedestal y otorga 3 flamas de {{Collectible712}}Lemegeton", "Quasar", "spa")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "Cada tercer objeto comprado en la tienda del piso actual costará 1 {{Coin}}penny #Comprar 2 objetos con corazones en una habitación hará que los demás se vuelvan gratuitos", "2+1", "spa")
	EID:addCollectible(CustomCollectibles.RED_MAP, "Revela la ubicación de la Sala Ultra Secreta en los siguientes pisos#Cualquier trinket que se deje en una {{TreasureRoom}}sala del tesoro o {{BossRoom}}sala del jefe dejará una Cracked Key", "Mapa Rojo", "spa")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "Remueve un contenedor de corazón rojo y otorga {{ArrowUp}}+0.5 de daño y 2 mini Isaacs", "Rayador de Queso", "spa")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "Ahora las píldoras reciben efectos adicionales en base a su color", "Redactor de ADN", "spa")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "Destruye los obstáculos de la habitación y aplica confusión a los enemigos cercanos #Destroza las puertas y abre la entrada a Salas Secretas", "La Torre de Babel", "spa")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "Previene las maldiciones durante toda la partida #Si se previene una maldición recibes {{ArrowUp}}+0.5 de daño", "Bendición de los muertos", "spa")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "Genera 2 tanques de juguete que rondan por la habitación y atacan a los enemigos dentro de su linea de visión #Tanque verde: Dispara balas rápidamente a los enemigos a gran distancia y es de movimiento rápido #Tanque rojo: Dispara cohetes a corto rango, de movimiento lento", "Tanquesitos", "spa")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "Matar a los enemigos te da {{ArrowUp}}más lágrimas y velocidad #Se resetea al entrar a una nueva habitación", "Sangre Tempestuosa", "spa")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "+5 bombas #Ganas inmunidad a explosiones #Ahora puedes arrojar las bombas en vez de simplemente ponerlas en el suelo", "Bombardero Rojo", "spa")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "Otorga aumentos de estadísticas en base a tus familiares#Algunos darán buenos aumentos, y otros no los darán del todo (p.e. Moscas azules, dips o partes del cuerpo de Isaac)", "Amor Maternal", "spa")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "Retira un objeto aleatorio y genera 3 objetos de la misma calidad#Sólo puedes tomar uno#No remueve o genera objetos relacionados a la historia", "Libro del Génesis", "spa")
	EID:addCollectible(CustomCollectibles.SCALPEL, "Ahora disparas en la dirección opuesta#De lado frontal, dispararás rápidamente unas lágrimas sangrientas que hacen tu daño x0.66#Otro tipo de ataques serán disparados regularmente", "Un bisturí", "spa")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "Genera una moneda dorada al entrar a un nuevo piso#Las tiendas ahora venden 1-4 objetos adicionales tomados de la tienda, sala del tesoro o sala del jefe", "El centavo de Keeper", "spa")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "Disparar o moverse en una dirección durante 5 segundos generará un pincho nervioso#{{ArrowDown}}Tomas daño falso y recibes " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " de velocidad permanente cuando ocurre#{{ArrowUp}}Sin embatgo, hay un 75% de posibilidad de usar tu activo gratis, Incluso si no está cargado#Objetos de un solo uso y de cargas infinitas no pueden usarse de esta forma", "Pincho nervioso", "spa")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "Tomar daño no herirá al jugador, en vez de eso se llenará un contenedor de sangre#Puede ser repeetido hasta 6 veces, cuando este se llenará#Cuando esté lleno, usarlo o recibir daño lo vaciará y se provocará 3 corazones de daño al jugador", "Contenedor de sangre", "spa")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "Un orbital que cambia en 2 distintos estados cada 15 segundos:#Dos orbitales que giran rápidamente alrededor de Isaac #Un orbital que gira más lento y cerca de Isaac, dispara dientes y suelta creep rojo bajo el #{{Warning}}Ambas fases bloquean proyectiles y hacen daño por contacto", "Rivalidad entre hermanos", "spa")
	EID:addCollectible(CustomCollectibles.RED_KING, "Después de derrotar al jefe, aparecerá un pasadizo rojo#Entrar a este pasadizo rojo iniciará otra batalla de jefe con alta dificultad#Si ganas, recibirás un objeto rojo (de la pool de la Sala Ultra Secreta)", "Rey Rojo", "spa")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "Invoca al mendigo observador estelar#{{SoulHeart}}Sólo puede ser recargado con corazones de alma#Se necesita 2 corazones de alma para cargarlo completamente", "Sombrero del observador estelar", "spa")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "Tras usarlo, Sostendrás la bolsa en el aire#Durante 4 segundos, todos los proyectiles cercanos serán succionados por la bolsa#Mantener pulsado el botón de disparo los lanzará como disparos teledirigidos en la dirección apuntadadespués de 4 segundos", "Bolso sin fondo", "spa")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "Los enemigos que se te acerquen serán lisiados; tus lágrimas poseen el mismo efecto#Los enemigos lisiados perderán su velocidad progesivamente, acabarán muriendo 16 segundos después de perderla#Cuando un enemigo lisiado muere, Lanzarán una fuente de lágrimas negras ralentizadoras", "Cruz del Cáos", "spa")
	EID:addCollectible(CustomCollectibles.REJECTION, "Al usarlo, consumirá a todos tus familiares y los lanzará en una gran bola de tripas disparada hacia donde apuntes#Formula de daño: {{Damage}}Daño * 4 * Número de familiares consumidos#A cambio, otorga un familiar que no puede disparar, pero provoca 2.5 puntos de daño por contacto a los enemigos", "Rechazo", "spa")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "Generará un objeto de la pool en la que estés disponible para la venta#Su precio cambiará cerca de 5 veces por segundo#El precio es aleatorio, pero generalmente aumentará hasta llegar a $99 #Si sales y entras de la habitación, el objeto desaparecerá", "Mazo de subastas", "spa")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "Usando una cadena astral, serás encadenado a un enemigo y este se congelará#La cadena hace demasiado daño por contaco a los enemigos#Alejarse demasiado de un enemigo encadenado romperá la cadena#{{SoulHeart}}Los enemigos encadenados tienen un 33% de posibilidad de soltar un corazón de alma al morir", "Lazo del alma", "spa")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}}{{Shotspeed}}Vel. de tiro +0.3#Tus lágrimas serán reemplazadas por plumas penetrantes, harán más daño mientras más viajenthat deal more damage#Presionar el botón de disparo 2 veces realizará un ataque similar al de Dogma#Tiene un tiempo de recarga de 6 segundos", "Alas de Ángel", "spa")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "{{ArrowUp}}{{Speed}}Velocidad +0.2#Al terminar la partida, 3 objetos aleatorios del inventario serán generados en el piso donde terminó. Podrán ser tomados en la siguiente partida yendo hacia ese mismo piso", "Herencia", "spa")
	EID:addCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, "Al usarlo, todos los enemigos serán lisiados#Los enemigos lisiados perderán su velocidad progesivamente, acabarán muriendo 12 segundos después de perderla#Necesita una llave para 'desbloquearlo' y usarlo, no hace nada sin llaves#Posee sinergias especiales con trinkets relativos a llaver", "El libro de Leviatán", "spa")
	EID:addCollectible(CustomCollectibles.FRIENDLY_SACK, "Después de cada 3 habitaciones completadas, se generará un familiar debil (como un Dip, Blood clot, moscas, etc.)#Si esl efecto del Saco amistoso se activa en una {{BossRoom}}sala del jefe, aparecerá un monstruo encantado en su lugar", "Saco amistoso", "spa")
	EID:addCollectible(CustomCollectibles.MAGIC_MARKER, "{{Card}}Se genera una carta del tarot#Tras usarlo, cambiará tu carta sumándole un 1 a su número (Restará 1 para las cartas reversas)", "Plumón Mágico", "spa")
    EID:addCollectible(CustomCollectibles.ULTRA_FLESH_KID, "Familiar que persigue y ataca a los enemigos#Posee 3 fases, conseguir {{Heart}}corazones rojos hará que evolucione#{{Heart}}Se necesitan 15 corazones en total para hacerlo evolucionar", "Chico Ultra-carnoso", "spa")
	EID:addCollectible(CustomCollectibles.VAULT_OF_HAVOC, "Almacenará de forma pasiva a los enemigos asesinados; se podrá usar cuando guardes hasta 12#Al usarlo, te llevará a una habitación especial con esos 12 enemigos; limpiar la sala generará una recompensa basada en el HP de los enemigos", "Bóveda de Havoc", "spa")
	EID:addCollectible(CustomCollectibles.PURE_SOUL, "Todos los jefes de pecado tienen un 100% de posibilidad de soltar su respectiva {{ColorRed}}Gema del pecado{{CR}} #Un fantasma podrá aparecer en la {{SecretRoom}} Sala secreta o la {{SuperSecretRoom}} sala súper secreta, el cual generará un minijefe del pecado si lo alcanzas #{{MiniBoss}} Este familiar se posicionará en las entradas de las salas de minijefe", "Alma Pura", "spa")
	EID:addCollectible(CustomCollectibles.HANDICAPPED_PLACARD, "Coloca una placa de discapacitados en el suelo#Cada enemigo dentro del área de la placa será debilitado y generarán Espuelas de huesos al morir#El área se volverá más grande al recibir daño", "Placa de discapacitados", "spa")
	EID:addCollectible(CustomCollectibles.BOOK_OF_JUDGES, "Se generarán punteros al entrar a una sala con enemigos#Cada 3 segundos, caerán rayos de luz sobre estos punteros#{{Burning}} Los rayos dañan y queman a los enemigos, pero también te pueden dañar, but they hurt you too#Usar el libro anulará el efecto durante la sala", "Book of Judges", "spa")
	EID:addCollectible(CustomCollectibles.BIRTH_CERTIFICATE, "{{Warning}} DE UN SOLO USO#Consumirá todos los trinkets que poseas#Te teletransportarás a una sala especial con demasiados trinkets, junto a otros recolectables#Sólo podrás tomar unp; después de esto, serás transportado a la sala donde estabas antes", "Birth Certificate", "spa")

	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "{{ChestRoom}}Al tenerlo, cada Cofre Dorado tiene un 25% de probabilidad de convertirse en un Cofre Viejo", "Llave del Sótano", "spa")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "Al tenerlo, cada enemigo tiene una posibilidad de soltar un Cofre Escarlata al morir#Los Cofres Escarlata contienen: 1-4 {{Heart}}corazones/{{Pill}}píldoras O un objeto aleatorio relativo al cuerpo", "Llave al Corazón", "spa")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "Los enemigos que te toquen serán marcados y atacados por otros enemigos (Efecto similar al de {{Collectible618}}Tomate Podrido", "Beso de Judas", "spa")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "Usar una moneda, llave o bomba en una máquina, un mendigo o un cofre cerrado tendrá un 17% de probabilidad de no restarlo de tu ivnentario", "Moneda Truculenta", "spa")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "Al momento de generarse, cada moneda tiene un 20% de posibilidad de recibir una mejora: #penny -> penny doble -> nickel pegajoso -> nickel -> décimo -> penny de la suerte -> penny dorado", "Juego de Manos", "spa")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "Te otorga una Moneda corazón vacía #Esta se vacía antes que tus corazones regulares, se rellena consiguiendo dinero", "Corazón de la Codicia", "spa")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "Toda nueva sala del ángel tendrá un objeto de la pool del ángel a la venta en vez de un objeto de la pool del tesoro#Los ángeles de las estatuas no generarán {{Collectible238}}{{Collectible239}}Piezas de Llave", "Corona de Ángel", "spa")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "{{ArrowUp}}x2 de daño al sostenerlo#Se rompe al recibir daño#{{ArrowUp}}Tener Cinta Adhesiva evitará que se rompa", "Espada Mágica", "spa")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "No hace nada, está rota", "Espera... ¡NO!", "spa")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "Al recibir daño, uno de tus objetos será reroleado a otro objeto aleatorio #No quita ni otorga objetos relativos a la historia", "Mechón de Eden", "spa")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "Al entrar a una sala nueva, dejarás un rastro de talco bajo tuyo durante 5 segundos#Los enemigos que intenten caminar por el rastro serán repelidos", "Pedazo de Tiza", "spa")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "Revives como Eve al morir", "Costilla de Adan", "spa")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "40% de posibilidad de prevenir una maldición al pasar a un nuevo piso", "La Tierra de la Noche", "spa")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "{{ArrowUp}}Aumenta el daño y el tamaño por piso al tener la baratija", "Harina de huesos", "spa")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "Los libros tienen efectos adicionales al usarlos", "Pagina destrozada", "spa")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "Los libros activan un efecto aleatorio al usarlo #No funciona con How to Jump# no activa efectos de dado u objetos que te dañen #{{ArrowUp}}33% de posibilidad de aparecer en bibliotecas", "Página vacía", "spa")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "{{ArrowDown}}-20% al tamaño de los enemigos#Afecta también a los jefes#{{Warning}}Se reduce tanto el tamaño como la hitbox", "Zapatitos de bebé", "spa")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "5% de posibilidad de activar el efecto de {{Collectible705}}Artes Oscuras al recibir daño Dark Arts#Aumenta la posibilidad de aparición de cofres negros en las {{DevilRoom}}Salas del diablo", "Llave cuchillo", "spa")
    EID:addTrinket(CustomTrinkets.SHATTERED_STONE, "Posibilidad de generar una langosta al tomar {{Coin}}monedas, {{Key}}llaves o {{Bomb}}Bombas #La posibilidad aumenta con la rareza del recolectable", "Piedra fragmentada", "spa")

	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "Efecto de {{Collectible723}}Spindown Dice de un solo uso", "Fragmento de Spindown Dice", "spa")
	EID:addCard(CustomConsumables.RED_RUNE, "Daña a todos los enemigos de una habitación, los objetos en pedestales se convierten en langostas rojas y los consumibles tienen 50% de probabilidad de convertirse en una langosta roja", "Runa Roja", "spa")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "Remueve un Corazón Roto y otorga un {{Heart}}Contenedor de Corazón", "Aguja e Hilo", "spa")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "Genera 1-12 {{Coin}}monedas aleatorias (pueden ser tanto nickels como décimos)", "Reina de Diamantes", "spa")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "Pierdes todas tus llaves y se genera un número proporcional a la cantidad perdida en recolectables #Se necesitan al menos 12 {{Key}}llaves para generar un trinket y al menos 28 para un objeto#Si Isaac tiene una {{GoldenKey}}Llave Dorada, Será removida y aumentará el valor de la recompensa significativamente", "Rey de Espadas", "spa")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "Pierdes todas tus bombas y se genera un número proporcional a la cantidad perdida en recolectables#Se necesitan al menos 12 {{Bomb}}bombas para generar un trinket y al menos 28 para un objeto#Si Isaac tiene una {{GoldenBomb}}Bomba Dorada, Será removida y aumentará el valor de la recompensa significativamente", "Rey de Tréboles", "spa")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "Pierdes todas tus monedas y se genera un número proporcional a la cantidad perdida en recolectables#Se necesitan al menos 12 {{Coin}}monedas para generar un trinket y al menos 28 para un objeto", "Rey de Diamantes", "spa")
	EID:addCard(CustomConsumables.BAG_TISSUE, "Destruye todos los recolectables, y los ocho recolectables de mayor valor generarán un objeto con una calidad basada en el valor de los recolectables#Los recolectables con mayor valor son los más raros, por ejemplo:{{EthernalHeart}}Corazones Eternos o {{Battery}}Mega Baterías#{{Warning}}Si se usa en una habitación sin recolectables, no generará nada", "Bolsa de tela", "spa")
	EID:addCard(CustomConsumables.JOKER_Q, "Teletransporta a Isaac a un {{SuperSecretRoom}}Mercado Negro", "Joker?", "spa")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "Activa el efecto de {{Collectible422}}Reloj de arena brillante", "¿Comodín?", "spa")
	EID:addCard(CustomConsumables.LOADED_DICE, "{{ArrowUp}}+10 de suerte durante una habitación", "Dado Cargado", "spa")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "Genera 1-12 {{Key}}llaves#Hay una posibilidad de generar una Llave Cargada", "Reina de Espadas", "spa")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "Genera 1-12 {{Bomb}}bombas#Hay una posibilidad de generar una bomba doble", "Reina de Tréboles", "spa")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "Se generarán más bombas al limpiar habitaciones, la calidad general de las bombas aumenta", "Jota de Tréboles", "spa")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "Se generarán más monedas al limpiar habitaciones, la calidad general de las monedas aumenta", "Jota de Diamantes", "spa")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "Se generarán más llaves al limpiar habitaciones, la calidad general de las llaves aumenta", "Jota de Espadas", "spa")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "Se generarán más corazones al limpiar habitaciones, la calidad general de los corazones aumenta", "Jota de Corazones", "spa")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "Dañaa todos los enemigos de la habitación, convierte cada pedestal de objeto en 3 flamas de {{Collectible712}}Lemegeton", "Fragmento de Quasar", "spa")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "Invoca un enemigo aliado aleatorio, al igual que {{Collectible687}}Buscador de Amigos", "Carta de Negocios", "spa")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "{{ArrowUp}}+1 de daño que decrementa tras 25 segundos#Acumulable#{{ArrowUp}}Cura un corazón rojo si tienes {{Collectible216}}Batas Ceremoniales#{{Warning}}El daño disminuirá más rápido mientras más sangre uses", "Sangre de Sacrificio", "spa")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "Activa un efecto aleatorio de un Libro", "Carta de Biblioteca", "spa")
	EID:addCard(CustomConsumables.FLY_PAPER, "Genera 8 moscas de {{Collectible693}}El Enjambre", "Trampa para Moscas", "spa")
	EID:addCard(CustomConsumables.MOMS_ID, "Encanta a todos los enemigos de la habitación", "Identificación de Mamá", "spa")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES, "Genera un Cofre Viejo", "Servicios de Funeraria", "spa")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD, "Se lanza igual que una Carta del caos#Si la carta toca a un enemigo, este es eliminado por el resto de la partida", "Carta Antimaterial", "spa")
	EID:addCard(CustomConsumables.FIEND_FIRE, "Elimina tus recolectables para provocar daño en masa #10-50 en total: Los enemigos toman 15 de daño y se queman por 4 segundos#51-125 total: El daño inicial, el daño de quemadura y duración de la misma se duplican; Destruye obstáculos cerca tuyo#126-150 total: El daño y duración de quemaduras se cuadriplica; produce una explosión de Mamá Mega", "Fuego del demonio", "spa")
	EID:addCard(CustomConsumables.DEMON_FORM, "{{ArrowUp}}+0.15 de daño por cada sala nueva a la que entres#El efecto desaparece al entrar a un nuevo piso", "Forma demoniaca", "spa")
	EID:addCard(CustomConsumables.VALENTINES_CARD , "Se lanza de forma parecida a una Carta del Cáos#Si la carta golpea a un enemigo, este se volverá amigable y se generará un corazón rojo en el piso", "Carta de San Valentín", "spa")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "Genera 2 familiares orbitales fantasma que bloquean disparos enemigos y disparan lágrimas espectrales#{{HalfSoulHeart}}Tras bloquear 3 disparos, los fantasmas soltarán medio corazón de alma", "Reserva Espiritual", "spa")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "Tu objeto activo será movido hacia los activos de bolsillo#En caso de que ya tengas un activo de bolsillo, lo soltarás en un pedestal", "Paisaje Reflejado", "spa")
	EID:addCard(CustomConsumables.CURSED_CARD, "Durante la sala, todo daño recibido será negado#A cambio, recibes: #{{BrokenHeart}} Un corazón roto#{{ArrowUp}} {{Tears}} Un aumento de lágrimas permanente", "Carta Maldita", "spa")

	-- Gemas del pecado
	EID:addCard(CustomConsumables.CROWN_OF_GREED , "{{Penny}} Genera 1-2 monedas doradas#{{ArrowDown}} {{Luck}} Suerte -1 por cada moneda generada", "Corona de la Codicia", "spa")
	EID:addCard(CustomConsumables.FLOWER_OF_LUST, "Te permite resetear la sala, asegurando recibir una recompensa mejor", "Flor de la Lujuria", "spa")
	EID:addCard(CustomConsumables.ACID_OF_SLOTH, "{{Slow}} Ralentiza a los enemigos reduciendo a su velocidad a la mitad#{{Poison}} Dejarán gas venenoso detrás suyo", "Ácido de la pereza", "spa")
	EID:addCard(CustomConsumables.VOID_OF_GLUTTONY, "{{HalfHeart}} Durante 7 segundos, Si no tienes salud roja, la recuperarás#{{ArrowDown}} {{Speed}} Perderás -0.01 de velovidad #Su duración se extiende 2 segundos al matar a un enemigo", "Vacío de la Gula", "spa")
	EID:addCard(CustomConsumables.APPLE_OF_PRIDE, "{{ArrowUp}} Recibes un aumento de stats moderado hasta recibir daño", "Manzana del Orgullo", "spa")
	EID:addCard(CustomConsumables.CANINE_OF_WRATH, "Every enemy in a room explodes, taking 15 damage #{{Warning}}The explosion can hurt you too #Every enemy that dies from the explosion will give you a temporary damage boost", "Colmillo de la Ira", "spa")
	EID:addCard(CustomConsumables.MASK_OF_ENVY, "{{RottenBoneHeart}} Convierte todos tus contenedores de corazón en corazones de hueso rellenos con corazones podridos", "Máscara de la Envídia", "spa")

	EID:addPill(CustomPills.ESTROGEN, "Convierte todos tus {{Heart}}corazones en Coágulos#Te deja con al menos un corazón rojo, No afecta Corazones de Alma/Corazones Negros", "Estrógeno", "spa")
	EID:addPill(CustomPills.LAXATIVE, "Hace que dispares los maíces de {{Collectible680}}Venganza de Montezuma durante 3 segundos", "Laxante", "spa")
	EID:addPill(CustomPills.PHANTOM_PAINS, "Provoca que Isaac reciba daño falso al usarse, luego a los 20 y 40 segundos de haberla consumido", "Fantasma", "spa")
	EID:addPill(CustomPills.YUCK, "Genera un corazón podrido #Por 30 segundos, cada corazón rojo tomado generará moscas azules", "Puaj", "spa")
	EID:addPill(CustomPills.YUM, "Genera un corazón rojo #Por, cada corazón rojo que consigas te dará un pequeño aumento permantente de estadísticas, Igual al efecto de {{Collectible671}}Corazón de Caramelo", "Mmm~", "spa")
end

-- EID Russian (by Laraz and Mr. SeemsGood)
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}}Повышает скорострельность #Создает дополнительный предмет, связанный с матерью/отцом, в сокровищницах; можно взять только один предмет", "Обычная Жизнь", "ru")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "При использовании дает один {{Heart}}контейнер сердца и одно сломанное сердце #{{Warning}}При 12 сломанных сердец вы умрете!", "Формочка для Печенья", "ru")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "+2 черных сердца #{{ArrowUp}}Дает +2 к урону и умножает на 1.5 #{{ArrowUp}}Дает +2 к дальности и -0.2 к скорости слезы #Дает спектральные и пронзающие слезы", "Сердце Грешника", "ru")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "После каждого использования, имеет 5%(100% на 20-ом использовании) шанс собраться, забирает у игрока этот предмет и заменяет его Магическим Кубом", "Кубик Рубика", "ru")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "{{DiceRoom}}Меняет предметы в комнате #Замененные предметы могут быть из любого пула предметов", "Магический Куб", "ru")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "При двойном нажатие кнопки стрельбы создает на полу полосу {{ColorRainbow}}радужной{{CR}}лужи в направлении стрельбы #Лужа накладывает случайные статусные эффекты врагам при соприкосновении#{{Warning}}Имеет 4 секунды перезарядки", "Магическая Ручка", "ru")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "Дарует вам спутника Еноха #Когда вы умираете, если у вас есть какие-либо спутники, кроме Еноха, воскрешает вас и уничтожает их вместо этого; Енох становится сильнее; дает вам кадры неуязвимости и сохраняет все ваши красные контейнеры #{{Warning}}Работает только один раз", "Метка Каина", "ru")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "При получении урона, есть 25% шанс войти в режим Берсерка #В этом состоянии, любой пораженный враг имеет 5% шанс стать стертым до конца забега", "Приступ Ярости", "ru")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "Спутник призывающий мух при зачистке комнат #Блокирует вражеские выстрелы, при блокировании имеет небольшой шанс быть уничтоженным и создать предмет Завтрак или брелок Ночное Золото #Чем больше этажей этот спутник выживает, тем больше мух он призывает", "Мешок для Мусора", "ru")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "Спутник, стреляющий слезами с аурой {{Collectible331}}Головы Бога", "Херувим", "ru")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "При убийстве врага есть 20% шанс призвать на его месте спутника вишенку #Вишенки испускают очаровывающий пук при соприкосновении с врагами, и создает половинку красного сердца после зачистки комнаты", "Друзья вишенки", "ru")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "При посещении комнаты, все враги будут разделены на пары. Нанося урон врагу, также наносит 60% урона другому врагу в этой паре", "Черная Кукла", "ru")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "При смерти персонаж превращается в неуязвимого призрака, и птица вылетает из центра комнаты в случайном направление. При поимке птицы вы воскрешаетесь и возвращаетесь на место своей смерти, если вы не успеваете поймать птицу вы умираете. Ужасной смертью #{{Warning}}За каждую вашу смерть, птица становится быстрее, затрудняя ее поймать", "Птичка Надежды", "ru")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "При двойном нажатии кнопки стрельбы запускает призрака в направление стрельбы #Призрак прилипнет ко врагу нанося урон на протяжении 7 секунд или до тех пор пока этот враг умрет#Призрак наносит 7 урона и повышается каждый этаж #Также Призрак может прилипать к боссам #{{Warning}}Призрак имеет 7 секунд перезарядки", "Разъяренная Душа", "ru")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "При стрельбе есть 7% шанс запустить кинжал, который не наносит урона, но накладывает кровотечение на врагов #Враги которые умерли пока кровоточили оставят за собой Жертвенную Кровь, которая дает временную прибавку к урону", "Церемониальный Кинжал", "ru")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "Дает 2 огонька {{Collectible712}}Лемегетона в начале каждого этажа и когда вы спите в кровати ", "Потолок со Звездами", "ru")
	EID:addCollectible(CustomCollectibles.QUASAR, "Поглощает все предметы на пьедесталах в комнате и дает 3 огонька {{Collectible712}}Лемегетона за каждый поглощенный предмет", "Квазар", "ru")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "Каждый третий купленный предмет будет стоить 1 {{Coin}}монету", "2+1", "ru")
	EID:addCollectible(CustomCollectibles.RED_MAP, "Показывает местоположение Ультра Секретной Комнаты на последующих этажах #Любой брелок оставленный в комнате босса или сокровищнице превратиться в Треснутый Ключ", "Красная Карта", "ru")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "Забирает один контейнер сердца и дает {{ArrowUp}}+0.5 к урону и создает 3 мини Айзека", "Терка для Сыра", "ru")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "Пилюли дают дополнительный эффект в зависимости от их цвета", "Редактор ДНК", "ru")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "Уничтожает все препятствия в этой комнате и накладывает на врагов в маленьком радиусе замешательство #Также подрывает двери и проход в секретную комнату", "Вавилонская Башня", "ru")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "Предотвращает проклятья до конца забега #Предотвращение проклятья дает вам {{ArrowUp}}*" .. tostring(CustomStatups.Damage.BLESS_OF_THE_DEAD_MUL) .. " множитель к урону", "Благословение Мертвых", "ru")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "Призывает двух спутников Танкистов, которые катаются по комнате и атакуют врагов находящиеся в их поле зрения #Зеленый танк: быстро стреляет по врагам на далекой дистанции и двигается быстро #Красный танк: стреляет ракетами по врагам на маленькой дистанции и двигается медленно", "Танкисты", "ru")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "Убийство врагов дает {{ArrowUp}}повышение к скорострельности и к скорости #Бонус пропадает при выходе из комнаты", "Бурная Кровь", "ru")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "+5 бомб #Дает иммунитет к взрывам #Позволяет вам бросать бомбы, а не оставлять их на земле", "Красный Подрывник", "ru")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "Дает повышение к случайной характеристике за каждого спутника", "Мамина Любовь", "ru")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "Удаляет ваш случайный предмет и создает три предмета того же качества #Только один предмет можно взять", "Книга Бытия", "ru")
	EID:addCollectible(CustomCollectibles.SCALPEL, "Убавляет одно красное сердце, или синее сердце, если красных нет #Игрок будет стрелять кровавыми слезами ещё в одном случайном направлении #Эти слёзы наносят 75% вашего урона", "Скальпель", "ru")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "Создает золотую монетку при переходе на новый этаж #Магазины теперь будут продавать 1-4 дополнительных предмета, взятых из пула магазина, сокровищницы или комнаты босса #Если в магазине будет битва с Алчностью, создает 3-4 предмета, когда мини-босс умирает", "Монетка Хранителя", "ru")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "При стрельбе или ходьбе в течение 8 секунд  #{{ArrowDown}}Вы получаете фальшивый урон и " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " к скорости #{{ArrowUp}}C 80% шансом активирует ваш активный предмет, даже если он не заряжен", "Защемление Нерва", "ru")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "Получение урона не причиняет вреда игроку, вместо этого заполняет сосуд #Это можно повторить 6 раз, пока сосуд не заполнится #Как только он заполнится, его использование или получение урона опустошит его и нанесет игроку 3 и 3,5 сердца урона соответственно.", "Кровавый Сосуд", "ru")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "Орбитал который переключается между двумя состояниями: #Два орбитала которые кружатся около игрока #Орбитал который кружится медленее, и случайно стреляет зубами в случайных направлениях и создает кровавые лужи под ними #{{Warning}}Все орбиталы блокируют снаряды и наносят контактный урон", "Соперничество", "ru")
	EID:addCollectible(CustomCollectibles.RED_KING, "После победы над боссом в середине комнаты появится красный люк #Люк приведет вас к другому бою с боссом высокой сложности #Победа вознаграждает вас двумя красными предметами на выбор", "Красный Король", "ru")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "Создает попрошайку Астронома #Предмет заряжается только синими сердцами #1 сердце для полного заряда", "Шапка Астронома", "ru")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "В течение 4 секунд все ближайшие снаряды всасываются в мешок #Удерживайте кнопку стрельбы, чтобы выпустить все всосанные снаряды в соответствующем направлении #Снаряды становятся самонаводящимися", "Бездонный Мешок", "ru")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "Враги, которые приближаются к вам, становятся ослабленными; ваши слезы также могут ослабить их #Ослабленные враги теряют свою скорость со временем и умирают через 16 секунд после ее потери #Когда ослабленные враги умирают, они выпускают фонтан замедляющихся черных слез", "Крест Хаоса", "ru")
	EID:addCollectible(CustomCollectibles.REJECTION, "При использовании уничтожает всех спутников на одну комнату и бросает их в виде большого пронзающего ядовитого шара в направлении вашей стрельбы #Формула урона: ваш урон * 4 *количество спутников #Пассивно дает фамильяра, который не стреляет слезами, но наносит 2,5 контактного урона врагам.", "Отторжение", "ru")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "Создает предмет из пула комнаты который можно купить #Его цена будет меняться случайно 5 раз в секунду #Цена меняется случайно, но в целом увеличивается, пока не достигнет 99 монет #Если вы выйдете из комнаты, предмет исчезнет", "Молоток для Аукциона", "ru")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "Приковывайте себя к случайному врагу астральной цепью и замораживайте их # Цепь наносит сильный контактный урон врагам # Если вы отойдете слишком далеко от прикованного врага, цепь разорвется #Прикованные враги имеют 33% шанс уронить синее сердце при смерти", "Связь Душ", "ru")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}}+0,3 к скорости выстрела  #Ваши слезы заменяются пронзающими перьями, которые наносят больше урона, чем больше они пролетают #Двойное нажатие на кнопку выстрела, чтобы использовать одну из атак Догмы #Имеет 6 секунд перезарядки", "Ангельские Крылья", "ru")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "{{ArrowUp}}+0.2 к скорости #После того, как ваш забег закончится, 3 случайных предмета из вашего инвентаря появятся на этаже, где он закончился. Их можно собрать на следующем забеге, добравшись до того же этажа", "Подержанные Вещи", "ru")
	EID:addCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, "+2 ключа #При использовании ослабляет всех врагов в комнате #Ослабленные враги теряют свою скорость со временем и умирают через 12 секунд после ее потери #Нужен ключ для использования", "Книга Левиафана", "ru")
	EID:addCollectible(CustomCollectibles.FRIENDLY_SACK, "После каждой 3-й пройденной комнаты появляется случайный слабый спутник (дип, блебик, синии мухи и т.д.). #Если комната босса - это комната, где Дружеский мешок спавнит спутника, вместо этого появляется случайный зачарованный монстр", "Мешок с Друзьями", "ru")	
	EID:addCollectible(CustomCollectibles.MAGIC_MARKER, "Создает случайную карту таро #При использовании, превращает вашу карту, увеличивая ее номер на 1(или уменьшая на 1 для перевернутых карт)", "Магический Маркер", "ru")
	EID:addCollectible(CustomCollectibles.ULTRA_FLESH_KID, "Спутник который гонится за врагами и наносит им контактный урон #Имеет три стадии, собирает красные сердца чтобы улучшаться #Нужно 15 красных сердец для улучшения", "Ультра Телесный Ребенок", "ru")
	EID:addCollectible(CustomCollectibles.VAULT_OF_HAVOC, "Пассивно хранит убитых врагов; Можно использовать только если сохранено 12 врагов #При использовании, отправляет вас в специальную комнату с сохраненными врагами; При зачистке комнаты, вы получаете награду основанную на общем количестве HP врагов", "Хранилище Хаоса", "ru")
	EID:addCollectible(CustomCollectibles.PURE_SOUL, "Все грехи оставляют соответствующий {{ColorRed}}Драгоценный Камень Греха{{CR}} после смерти #Призрак может появится в {{SecretRoom}}Секретных или {{SuperSecretRoom}}Супер Секретных комнатах который исчезнет и призовет случайный Грех при приближении #Этот призрак также может появиться возле двери, ведущей в комнату с Грехом, показывая, какой Грех там находится", "Чистая Душа", "ru")
	EID:addCollectible(CustomCollectibles.HANDICAPPED_PLACARD, "Помещает Плакат для Инвалидов на землю #Враги в зоне действия плаката ослабляется и порождает кости при смерти #Площадь становится больше, чем больше урона вы получаете в комнате", "Плакат для Инвалидов", "ru")
	EID:addCollectible(CustomCollectibles.BOOK_OF_JUDGES, "Пассивно создает мишени на полу при входе в новую комнату #Каждые 3 секунды лучи света будут поражать мишени #Лучи наносят урон врагам и накладывает горение, но {{Warning}}они также наносят урон игроку #Использование книги отменяет вызов лучей для текущей комнаты", "Книга Судей", "ru")
	EID:addCollectible(CustomCollectibles.BIRTH_CERTIFICATE, "{{Warning}} Одноразовый! #При использовании, поглощает все удерживаемые брелки и телепортирует вас в комнату, в которой находится 188 брелоков, и несколько других расходников #Только один брелок может быть взять; вскоре после этого, вас телепортирует обратно в стартовую комнату текущего этажа", "Сертификат о рождении", "ru")
	
	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "{{ChestRoom}}Золотые Сундуки имеют 25% шанс стать Старым Сундуком", "Ключ от Подвала", "ru")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "У каждого врага есть шанс создать Кожанный Сундук после смерти #Кожанные Сундуки могут содержать 1-4 {{Heart}}сердца/{{Pill}}таблетки или случайный предмет, связанный с телом", "Ключ к Сердцу", "ru")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "Враги, прикасающиеся к вам, будут атакованы другими врагами (похожий на эффект {{Collectible618}}Тухлого Помидора)", "Поцелуй Иуды", "ru")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "Трата монет, бомб или ключей на автоматы, попрошаек или запертые сундуки имеет 17 % шанс не вычесть их из вашего инвентаря", "Трюк с Монеткой", "ru")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "После появления каждая монета имеет 20% шанс быть повышена до более высокой стоимости: #пенни->двойной пенни->липкий никель->никель-> десятник->счастливый пенни->золотой пенни", "Ловкость Рук", "ru")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "Дает вам один пустой контейнер монет #Оно тратится раньше, чем обычные сердца, и может быть пополнено только путем прямого подбирания монеток", "Сердце Жадности", "ru")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "Во всех новых Сокровищницах будет продаваться предмет ангела вместо обычного предмета #Ангелы не оставят части ключа при битве!", "Ангельская Корона", "ru")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "{{ArrowUp}}Удваивает ваш урон #Ломается, когда вы получаете урон #{{ArrowUp}}Наличие Клейкой Ленты предотвращает поломку", "Магический Меч", "ru")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "Ничего не делает", "О Нет!", "ru")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "При получении урона один из ваших предметов меняется на другой случайный предмет", "Локон Эдема", "ru")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "При входе в комнату вы оставляете под собой след из порошка в течение 5 секунд #Враги, проходящие по порошку, будут отброшены назад", "Кусок Мела", "ru")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "При смерти, воскрешает вас за Еву", "Ребро Адама", "ru")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "75% шанс предотвратить проклятия при входе на новый этаж", "Ночное Золото", "ru")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "В начале каждого этажа дает: #{{ArrowUp}}+10% Урона #{{ArrowUp}}Увеличение размера игрока #Урон и размер сохраняются если вы выбросите этот брелок", "Костная Мука", "ru")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "Усиливает эффекты книг #Этот брелок может появится в библиотеках с шансом 33%", "Порванная Страница", "ru")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "Книги активируют случайный активный предмет при использовании  #Этот брелок может появится в библиотеках с шансом 33%", "Пустая Страница", "ru")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "Уменьшает врагов на 20% #Также работает на боссах", "Детские Ботиночки", "ru")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "С шансом 5% активирует Темные Искусства когда вы получаете урон #Увеличивает шанс пояяления Черных Сундуков", "Нож Ключ", "ru")
	EID:addTrinket(CustomTrinkets.SHATTERED_STONE, "Шанс призвать случайную саранчу при подбирании монет, бомб или ключей", "Расколотый Камень", "ru")
	
	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "Активирует эффект {{Collectible723}}Кубика с Вычетом", "Осколок Кубика с Вычетом", "ru")
	EID:addCard(CustomConsumables.RED_RUNE, "Наносит урон всем врагам в комнате, превращает все пьедесталы с предметами в красную саранчу и превращает пикапы в случайную саранчу с вероятностью 50%", "Красная Руна", "ru")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "Убирает одно Сломанное Сердце и дает один {{Heart}}Контейнер Сердца", "Игла и Нитка", "ru")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "Создает 1-12 {{Coin}}случайных монет", "Дама Бубен", "ru")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "Вы теряете все свои ключи и создаете количество пикапов, пропорциональное количеству потерянных ключей #Для брелка требуется не менее 9 {{Key}}ключей и не менее 21 для предмета #Если у вас есть {{GoldenKey}}Золотой Ключ, он тоже удаляется и значительно увеличивает количество пикапов", "Король Пик", "ru")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "Вы теряете все свои бомбы и создаете количество пикапов, пропорциональное количеству потерянных бомб #Для брелка требуется не менее 9 {{Bomb}}бомб и не менее 21 для предмета #Если у вас есть {{GoldenBomb}}Золотая Бомба, он тоже удаляется и значительно увеличивает количество пикапов", "Король Треф", "ru")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "Вы теряете все свои монеты и создаете количество пикапов, пропорциональное количеству потерянных монет #Для брелка требуется не менее 21 {{Coin}}монет и не менее 54 для предмета", "Король Бубен", "ru")
	EID:addCard(CustomConsumables.BAG_TISSUE, "Все пикапы в комнате уничтожаются, и 8 самых ценных пикапов формируют качество предмета на основе их общей ценности; затем появляется предмет такого качества #Самые ценные пикапы - самые редкие, например {{EternalHeart}}Вечные сердца или {{Battery}}Мега Батареи #{{Warning}}При использовании в комнате с менее чем 8 пикапами предмет не появится!", "Ткань", "ru")
	EID:addCard(CustomConsumables.JOKER_Q, "Телепортирует вас в {{SuperSecretRoom}}Черный Рынок", "Джокер?", "ru")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "Активирует эффект {{Collectible422}}Светящихся Песочных Часов", "Обратная Карта", "ru")
	EID:addCard(CustomConsumables.LOADED_DICE, "{{ArrowUp}}+10 к удаче на одну комнату", "Шулерские Кости", "ru")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "Создает 1-12 {{Key}}случайных ключей", "Дама Пик", "ru")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "Создает 1-12 {{Bomb}}случайных бомб", "Дама Треф", "ru")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "Бомбы будут чаще падать после прохождение комнат на этом этажа, и качество бомб увеличится", "Валет Треф", "ru")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "Монеты будут чаще падать после прохождение комнат на этом этажа, и качество монет увеличится", "Валет Бубен", "ru")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "Ключи будут чаще падать после прохождение комнат на этом этажа, и качество ключей увеличится", "Валет Пик", "ru")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "Сердца будут чаще падать после прохождение комнат на этом этажа, и качество сердец увеличится", "Валет Червей", "ru")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "Поглощает все предметы на пьедесталах в комнате и дает 3 огонька {{Collectible712}}Лемегетона за каждый поглощенный предмет", "Осколок Квазара", "ru")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "Активирует эффект {{Collectible687}}Искателя Друзей", "Визитная Карточка", "ru")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "{{ArrowUp}}Дает +1,25 урона, который истощается в течение 20 секунд #{{ArrowUp}}Исцеляет вас на одно Красное Сердце, если у вас есть Церемониальные Роба #{{Warning}}Чем больше крови вы использовали впоследствии, тем быстрее понижается урон", "Жертвенная Кровь", "ru")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "Активирует эффект случайной книги", "Читательский Билет", "ru")
	EID:addCard(CustomConsumables.FLY_PAPER, "Создает 8 мух схожие с предметом {{Collectible693}}Рой", "Липучка", "ru")
	EID:addCard(CustomConsumables.MOMS_ID , "На всех врагов падает нож, который наносит двойной ваш урон", "Мамино Удостоверение", "ru")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES , "Создает Старый Сундук", "Похоронное Бюро", "ru")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD , "Можно кинуть как Карту Хаоса #При попадании стирает врага до конца забега", "Антиматериальная Карта", "ru")
	EID:addCard(CustomConsumables.FIEND_FIRE, "Пожертвуйте своими расходниками для массового уничтожения комнаты #3-20 итого: враги получают 15 урона и горят в течение 4 секунд #20-40 итого: начальный урон, урон от горения и продолжительность горения удваиваются; уничтожает препятствия вокруг вас #41+ итого: урон от горения и продолжительность горения увеличиваются в четыре раза; Дает эффект предмета Мама Мега на одну комнаты", "Дьявольский Огонь", "ru")
	EID:addCard(CustomConsumables.DEMON_FORM, "{{ArrowUp}}Дает 0.2 урона когда вы входите в незачищенную комнату #Бонус исчезает при переходе на следующий этаж", "Демоническая Форма", "ru")
	EID:addCard(CustomConsumables.VALENTINES_CARD , "Можно кинуть как Хаос Карту #Если карта попадает во врага, он становится дружелюбным и создает красное сердце", "Валентинка", "ru")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "Создает двух призрачных орбитальных спутников, которые блокируют вражеские выстрелы и стреляют призрачными слезами #После блокирования трех выстрелов призрак умирает и оставляет за собой половину сердца души", "Духовные Резервы", "ru")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "Ваш активный предмет перемещается в карманный слот #Если у вас уже есть предмет в карманном слоте, создает его копию на пьедестле", "Зеркальный Ландшафт", "ru")
	EID:addCard(CustomConsumables.CURSED_CARD, "Каждый урон, который вы получите в этой комнате, будет отменен; вместо этого вы получаете сломанное сердце и перманентное повышение скорострельности", "Проклятая Карта", "ru")
	
	EID:addCard(CustomConsumables.CROWN_OF_GREED , "Призывает 1-2 золотых пенни и дает {{ArrowDown}}-1 к удаче за каждый призванный пенни", "Корона Алчности", "ru")
	EID:addCard(CustomConsumables.FLOWER_OF_LUST, "Перезапускает комнату и вы получаете улучшенную награду после ее прохождения", "Цветок Похоти", "ru")
	EID:addCard(CustomConsumables.ACID_OF_SLOTH, "Замедляет всех врагов на 50% и заставляет их оставлять после себя облака ядовитого газа", "Кислота Лени", "ru")
	EID:addCard(CustomConsumables.VOID_OF_GLUTTONY, "На 7 секунд, если у вас не хватает красных сердец, восстанавливает 1{{HalfHeart}} в секунду, также получая {{ArrowDown}}-0.01 к скорости #Длительность эффекта увеличивается на 2 секунды после убийства врага", "Пустота Чревоугодия", "ru")
	EID:addCard(CustomConsumables.APPLE_OF_PRIDE, "Дает большую прибавку ко всем статам пока вы не получите урон", "Яблоко Гордыни", "ru")
	EID:addCard(CustomConsumables.CANINE_OF_WRATH, "Все враги в комнате взрывается нанося 15 урона #{{Warning}}Взрывы наносят урон игроку #Если враг умирает от взрыва вы получаете временную прибавку к урону", "Клык Гнева", "ru")
	EID:addCard(CustomConsumables.MASK_OF_ENVY, "Превращает все ваши контейнеры сердца в костянные сердца наполненные гнилыми сердцами", "Маска Зависти", "ru")
	
	EID:addPill(CustomPills.ESTROGEN, "Превращает все ваши {{Heart}}сердца в блебиков #Оставляет вас по крайней мере с одним красным сердцем, не убирает сердца души/черные сердца", "Эстроген", "ru")
	EID:addPill(CustomPills.LAXATIVE, "Заставляет вас стрелять кукурузой сзади в течение 3 секунд", "Слабительное", "ru")
	EID:addPill(CustomPills.PHANTOM_PAINS, "Вы получаете фальшивый урон и получаете его снова через 15 и 30 секунд", "Фантомная Боль", "ru")
	EID:addPill(CustomPills.YUCK, "Создает гнилое сердце #В течение 30 секунд, каждое взятое красное сердце будет создавать синих мух", "Фу!", "ru")
	EID:addPill(CustomPills.YUM, "Создает красное сердце #В течение 30 секунд, каждое взятое красное сердце даст вам небольшое постоянное увеличение случайной характеристики, похожий на эффект {{Collectible671}}Карамельного Сердца", "Ням!", "ru")

	EID:addEntity(5, 10, 84, "Сломанное Сердце", "Дает полный красный контейнер и сломанное сердце", "ru")
	EID:addEntity(5, 10, 85, "Бесстрашное Сердце", "Если ваше общее количество красных и синих сердец нечетное, у врагов есть шанс призвать половину красного или синего сердца при смерти #Выпавшие сердца быстро исчезают", "ru")
	EID:addEntity(5, 10, 86, "Сердце Накопителя", "Восстанавливает 4 красных контейнера здоровья", "ru")
	EID:addEntity(5, 10, 87, "Сердце Обманщика", "Разделяется на половину красного сердца и случайный расходник", "ru")
	EID:addEntity(5, 10, 88, "Грязное Сердце", "Призывает 0-2 дипов после зачистки комнаты", "ru")
	EID:addEntity(5, 10, 89, "Свернувшееся Сердце", "Восстанавливает один красный контейнер здоровья и призывает блебика", "ru")
	EID:addEntity(5, 10, 90, "Беспощадное Сердце", "Восстанавливает один красный контейнер и увеличивает урон на +1.25, который истощается в течение 25 секунд", "ru")
	EID:addEntity(5, 10, 91, "Темное Сердце", "Дает черное сердце и перманентный +0.1 к урону", "ru")
	EID:addEntity(5, 10, 92, "Загадочное Сердце", "Игрок может воскреснуть после смерти, если у него есть хотя бы одно Загадочное Сердце #Любое сердце будет восстанавливать 2 красных сердца после воскрешения", "ru")
	EID:addEntity(5, 10, 93, "Капризное Сердце", "Разбивается на 1-3 случайных сердца при подборе", "ru")
	EID:addEntity(5, 10, 94, "Зловещее Сердце", "Призывает атакующих призраков, если вы стоите близко к врагам", "ru")
	EID:addEntity(5, 10, 95, "Сердце Блудницы", "Восстанавливает один красный контейнер здоровья и призывает орбиталь {{Collectible525}}Проказы", "ru")
	EID:addEntity(5, 10, 96, "Сердце Торговца", "При потери этого сердца меняет все предметы и расходники в комнате #Пассивно даёт скидки в магазине", "ru")
	EID:addEntity(5, 10, 97, "Пустое Сердце", "За каждое пустое сердце, вы получаете одну саранчу Бездны {{Collectible706}}при переходе на новый этаж", "ru")
	EID:addEntity(5, 10, 98, "Скованное Сердце", "Требует ключа, чтобы подобрать #Дает сердце души и призывает призрачного орбитального спутника", "ru")
	EID:addEntity(5, 10, 99, "Фанатичное Сердце", "За каждое фанатичное сердце, вы получаете один огонек Лемегетона {{Collectible712}}при переходе на новый этаж", "ru")
	EID:addEntity(5, 10, 100, "Сердце Дезертира", "Восстанавливает один красный контейнер здоровья, но будет действовать как Черное сердце, если все красные контейнеры здоровья заполнены", "ru")
end

-- Korean EID (by 미카)
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "↑ {{TearsSmall}}눈물 딜레이 x0.8 #{{TreasureRoom}} 보물방에 엄마/아빠 관련 아이템이 한개 더 추가되며 하나를 선택하면 나머지는 사라집니다.", "평범한 삶", "ko_kr")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "#사용 시 {{Heart}}최대 체력 +1, {{Heart}}빨간하트 +2, {{BrokenHeart}}부서진하트 +1 #{{Warning}} 모든 체력이 부서진하트로 채워지면 사망합니다.", "쿠키 커터", "ko_kr")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "↑ {{BlackHeart}}블랙하트 +2 #↑ {{DamageSmall}}공격력 +2 #↑ {{DamageSmall}}공격력 배율 x1.5 #↑ {{RangeSmall}}사거리 +2 #↓ {{ShotspeedSmall}}탄속 -0.2 #눈물이 적과 지형을 관통합니다.", "죄인의 심장", "ko_kr")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "사용시 5% (20회 사용시 100%)의 확률로 퍼즐을 풀고 {{Collectible"..CustomCollectibles.MAGIC_CUBE.."}}Magic Cube 아이템으로 교체됩니다.", "루빅큐브", "ko_kr")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "방 안의 모든 아이템을 다른 아이템으로 바꿉니다.#{{Collectible402}} 바뀐 아이템의 배열은 랜덤으로 결정됩니다.", "매직큐브", "ko_kr")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "{{Throwable}} 눈물 발사키를 두번 연속 누르면 그 방향으로 {{ColorRainbow}}무지개{{CR}} 장판을 뿌립니다.#무지개 장판을 지나는 적들에게 랜덤 상태이상을 부여합니다#{{TimerSmall}} (쿨타임 4초)", "마법의 펜", "ko_kr")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "에녹 패밀리어를 소환합니다. #사망시, 에녹을 제외한 다른 패밀리어 아이템이 있다면 모두 제거한 후 그 방에서 체력이 꽉 찬 상태로 부활합니다.#부활 이후 에녹 패밀리어는 알트 에녹으로 강화되며 캐릭터는 잠시동안 무적시간을 얻습니다. #{{Warning}} 단 한번만 발동됨", "카인의 표식", "ko_kr")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "피격시 25%의 확률로 {{Collectible704}}폭주 상태로 돌입합니다.#폭주 상태에서 적에게 피해를 줄 경우 5%의 확률로 해당 게임에서 제거합니다.", "울화통", "ko_kr")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "방 클리어시 파란 아군 파리를 생성하는 패밀리어를 소환합니다. #적 탄환을 막을 수 있으며 탄환을 막을 때마다 1.25%의 확률로 파리가 사라지면서 Breakfast 혹은 Nightsoil 장신구를 드랍합니다. #파리를 유지한 스테이지당 파란 아군 파리 생성량이 늘어납니다.", "쓰레기 봉지", "ko_kr")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "{{Collectible331}} 공격하는 방향으로 주변에 오라를 둘러싼 공격력 5의 눈물을 발사합니다.", "케루빔", "ko_kr")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "적 처치시 20%의 확률로 체리 패밀리어를 드랍합니다. #적이 체리 패밀리어 위를 지나가면 매혹시키는 방귀를 뀝니다.#{{HalfHeart}} 방 클리어시 체리 패밀리어당 33%의 확률로 빨간하트 반칸을 드랍합니다.", "체리 친구들", "ko_kr")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "새로운 방 진입시, 모든 적들이 붙어다닙니다. 한 쪽이 피격되면 다른 한쪽도 60%의 피해를 받습니다.", "흑색인형", "ko_kr")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "사망시 잠시동안 무적 유령으로 변신하며 방 중앙에서 새 한마리가 랜덤한 방향을 이동하며 소환됩니다.#5초 이내로 새를 잡으면 부활합니다.#{{Warning}} 사망 횟수에 비례하여 새의 비행속도가 빨라집니다.", "희망의 파랑새", "ko_kr")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "{{Throwable}} 눈물 발사키를 두번 연속 누르면 그 방향으로 적과 보스에게 달라붙는 유령을 발사합니다. #유령은 7초동안 피해를 입힌 후 사라집니다.#유령의 공격력은 7이며 스테이지 진행도에 비례하여 추가로 증가합니다.#{{TimerSmall}} (쿨타임 7초)", "분노의 영혼", "ko_kr")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "{{BleedingOut}} 7%의 확률로 피해를 입히지 않으나 출혈을 일으키는 단검을 발사합니다.#출혈 상태의 적이 죽으면 일정 시간동안 공격력이 상승하는 {{Card"..CustomConsumables.SACRIFICIAL_BLOOD.."}}Sacrificial Blood를 드랍합니다.", "의례용 단검", "ko_kr")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "스테이지 시작시, 혹은 침대에서 자면 {{Collectible712}}레메게톤 불꽃을 두마리 소환합니다.", "별무늬 천장 장식", "ko_kr")
	EID:addCollectible(CustomCollectibles.QUASAR, "현재 방의 모든 적에게 피해를 입히며 현재 방의 아이템당 각각 {{Collectible712}}레메게톤 불꽃 3개씩으로 바꿉니다.", "퀘이사", "ko_kr")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "현재 층에서 3번째마다 구입하는 아이템의 가격이 1코인으로 바뀝니다.", "2+1", "ko_kr")
	EID:addCollectible(CustomCollectibles.RED_MAP, "{{UltraSecretRoom}}특급 비밀방의 위치를 보여줍니다. #이미 방문한 {{BossRoom}}보스방과 {{TreasureRoom}}보물방에서 버린 장신구를 전부 {{Card78}}깨진 열쇠로 바꿉니다.", "빨간 지도", "ko_kr")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "사용 시 최대 체력 1개를 소모하여 이하 효과 발동: #↑ {{DamageSmall}}공격력 +" .. tostring(CustomStatups.Damage.CHEESE_GRATER_MUL) .. " #작은 아이작 패밀리어를 3마리 소환합니다.", "치즈 강판", "ko_kr")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "알약 사용 시 사용한 알약의 색상에 따라 추가 효과를 발동합니다.", "DNA 변형", "ko_kr")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "{{Confusion}} 방 안의 모든 장애물을 파괴하며 캐릭터 주변 적들에게 혼란을 겁니다. #닫힌 문과 비밀방을 강제로 열 수 있습니다.", "바벨탑 모형", "ko_kr")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "현재 게임에서 더 이상 저주가 걸리지 않습니다.#↑ 걸렸어야 할 저주를 방어할 때마다 {{DamageSmall}}공격력 +" .. tostring(CustomStatups.Damage.BLESS_OF_THE_DEAD_MUL) .. "", "사자의 가호", "ko_kr")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "방 안을 돌아다니며 앞에 보이는 적을 향해 공격하는 장난감 탱크를 2대 소환합니다.#{{ColorGreen}}녹색{{CR}}: 총알을 빠르게 발사하며 빠르게 움직입니다. #{{ColorRed}}적색{{CR}}: 적을 향해 사거리가 짧은 로켓을 발사하며 느리게 움직입니다.", "탱크보이", "ko_kr")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "적 처치 시 그 방에서: #↑ {{TearsSmall}}연사 +0.16 #↑ {{SpeedSmall}}이동속도 +0.07#{{Blank}} (최대 10회)", "돌풍의 피", "ko_kr")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "↑ {{Bomb}}폭탄 +5 #폭발 공격에 피해를 입지 않습니다.#폭탄을 설치하는 대신 직접 던질 수 있습니다.", "레드 봄버맨", "ko_kr")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "↑ 현재 데리고 있는 패밀리어 당 능력치 증가#패밀리어의 등급에 따라 증가폭이 다르거나 적용되지 않습니다.", "엄마의 사랑", "ko_kr")
	EID:addCollectible(CustomCollectibles.CAT_IN_A_BOX, "{{Confusion}} 캐릭터의 공격방향 범위 밖에 있는 적은 움직일 수 없으나 어떠한 피해도 받지 않습니다.", "상자 안 고양이", "ko_kr")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "소지한 랜덤 아이템 하나를 제거한 후 해당 아이템과 같은 등급의 아이템 3개를 소환합니다.#3개의 아이템 중 하나를 획득할 수 있습니다.#{{Blank}} (루트 진행 아이템은 영향을 받지 않음)", "창세기의 책", "ko_kr")
	EID:addCollectible(CustomCollectibles.SCALPEL, "사용 시 최대 체력 1칸을 제거하고 발사하는 눈물의 갯수를 하나씩 추가합니다. #추가 눈물은 랜덤 방향으로 발사되며 캐릭터 공격력의 x0.65의 핏방울을 발사합니다. #{{Blank}} (눈물 이외의 무기는 영향을 받지 않음)", "외과용 메스", "ko_kr")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "스테이지 진입 시 황금동전을 소환합니다. #상점에서 상점, 보물방, 보스방 배열의 추가 아이템을 1~4개 판매합니다. #Greed 미니보스 처치 시, 처치한 시점에서 추가 아이템이 3~4개 생성됩니다.", "키퍼의 페니", "ko_kr")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "공격키를 두번 누르면 {{Collectible486}}피해를 입지 않고 피격 시 발동 효과를 발동하며 80%의 확률로 현재 소지한 액티브 아이템을 충전량 소모 없이 발동하며:#↓ 추가로 {{SpeedSmall}}이동속도가 " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " 감소합니다.#{{TimerSmall}} (쿨타임 3초)#{{Blank}} (일회용 및 쿨타임이 없는 아이템의 경우 발동 안됨)", "신경통", "ko_kr")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "피격시 피해를 입는 대신 피통에 피가 채워집니다. #6회까지 채울 수 있으며 전부 채워진 후 사용하거나, 피격시 각각 세칸, 세칸 반의 피해를 받습니다.", "피통", "ko_kr")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "두 패밀리어가 캐릭터의 주변을 돌며 15초마다 상태가 바뀝니다: #두 패밀리어가 캐릭터 주변을 빠르게 돕니다. #패밀리어 하나가 캐릭터에게 더 가깝고 느리게 돌며 피장판을 뿌리는 이빨을 주기적으로 발사합니다.#{{Warning}} 두 패밀리어 모두 적의 탄환을 막아주며 접촉 피해를 입힙니다.", "투닥투닥 형제들", "ko_kr")
	EID:addCollectible(CustomCollectibles.RED_KING, "보스방 클리어시, 빨간 트랩도어가 생성됩니다. #빨간 트랩도어 진입시, 더 어려운 보스전으로 진입합니다. #빨간 보스 처치 시 특급비밀방 배열의 아이템을 드랍합니다.", "적색황제", "ko_kr")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "망원경 거지를 소환합니다. #{{SoulHeart}} 소울하트/블랙하트 획득 시 체력으로 획득되지 않는 대신 하트 0.5개당 한칸씩 충전됩니다. (소울하트 2개로 최대 충전)#망원경 거지는 동전 5개를 지불하여 100%의 확률로 룬(83%), 혹은 우주 타입의 아이템(17%)을 드랍합니다.", "천문학자의 모자", "ko_kr")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "사용시 가방을 머리 위에 들며: #4초동안 캐릭터 주변의 모든 탄환을 흡수합니다. #흡수한 탄환 수에 비례하여 공격 발사키를 누르고 있으면 4초동안 그 방향으로 탄환을 발사합니다.", "무한가방", "ko_kr")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "캐릭터 주변의 적을 무력화시킵니다.#2%의 확률로 적을 무력화시키는 눈물을 발사합니다. #무력화된 적은 이동속도가 매우 느려지며 12초 이후 처치됩니다. #무력화된 적이 처치될 시, 주변에 적을 느리게 하는 검은 핏방울을 분출합니다.", "혼돈의 십자가", "ko_kr")
	EID:addCollectible(CustomCollectibles.REJECTION, "소지하는 동안, 눈물을 쏘지 않으며 접촉시 2.5의 피해를 주는 패밀리어를 소환합니다.#사용시 캐릭터를 따라다니는 패밀리어를 전부 소모하여 공격하는 방향으로 적을 관통하는 매우 거대한 독성 내장공을 던집니다. #!!! 내장공 공격력: 캐릭터의 공격력 * 4 * 희생한 패밀리어 수", "폐기", "ko_kr")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "현재 방 배열의 판매 아이템을 소환합니다. #아이템의 가격은 0.2초마다 랜덤으로 바뀌며 서서히 증가합니다. #방을 나가면 아이템이 사라집니다.", "경매 망치", "ko_kr")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "주변의 적 하나와 캐릭터를 체인으로 서로 묶은 후 얼립니다. #체인에 닿은 적은 매우 큰 피해를 입습니다. #!!! 묶인 적과 캐릭터의 간격이 너무 멀면 체인이 부서집니다. #묶인 적 처치 시 33%의 확률로 소울하트를 드랍합니다.#!!! 보스는 5초 후에 체인이 풀립니다.", "영혼의 끈", "ko_kr")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "↑ {{ShotspeedSmall}}탄속 +0.3 #눈물 대신 멀어질수록 공격력이 증가하며 적을 관통하는 깃털을 발사합니다. #{{Throwable}} 눈물 발사키를 두번 연속 누르면 Dogma 보스 관련 공격 하나를 랜덤으로 전개합니다.#{{TimerSmall}} (쿨타임 6초)", "천사의 날개", "ko_kr")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "↑ {{SpeedSmall}}이동속도 +0.2 #게임오버 시 캐릭터가 소지한 아이템 중 3개를 해당 스테이지에 드랍합니다.#다음 게임에서 해당 스테이지 진입시, 전 게임에서 드랍한 아이템을 획득할 수 있습니다.", "물려받은 물건", "ko_kr")
	EID:addCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, "↑ {{Key}}열쇠 +2#!!! 아이템 사용에 열쇠 필요:#사용 시 방 안의 모든 적을 무력화시킵니다.#무력화된 적은 이동속도가 매우 느려지며 12초 이후 처치됩니다. #열쇠 관련 장신구와의 시너지가 있습니다.", "레비아탄의 책", "ko_kr")
	EID:addCollectible(CustomCollectibles.FRIENDLY_SACK, "방을 3개 클리어할 때마다 약한 패밀리어를 소환합니다(Dip, Blood clot, fly 등) #3번쨰 방이 보스방인 경우 아군 적을 대신 소환합니다.", "친구 자루", "ko_kr")	
	EID:addCollectible(CustomCollectibles.MAGIC_MARKER, "{{Card}} 획득 시 타로 카드를 하나 드랍합니다.#사용시, 현재 들고 있는 타로 타입의 카드 번호를 1씩 증가합니다.#{{Blank}} (역방향의 경우 1씩 감소)", "마법의 마커", "ko_kr")
	EID:addCollectible(CustomCollectibles.ULTRA_FLESH_KID, "적을 따라다니며 접촉한 적에게 피해를 줍니다.#빨간 하트를 일정량 모을 시 최대 3단계까지 진화할 수 있습니다.#최대 진화까지 총 하트 15개가 필요합니다.", "살코기 아이", "ko_kr")
	EID:addCollectible(CustomCollectibles.VAULT_OF_HAVOC, "적 처치 시 금고에 적이 저장됩니다(최대 12)#사용 시, 최근에 처치한 적 12마리와 특수한 미니보스방에서 전투를 합니다.#해당 미니보스방 클리어 시 해당 방에서 전투한 적들의 총합 최대 체력에 비례한 보상을 받습니다.", "파괴의 금고", "ko_kr")
	EID:addCollectible(CustomCollectibles.PURE_SOUL, "7대죄악 미니보스 처치 시 100%의 확률로 각 죄에 대응되는 {{ColorRed}}죄악의 보석{{CR}}을 드랍합니다. #{{SecretRoom}}{{SuperSecretRoom}}비밀방/일급비밀방 진입 시 일정 확률로 유령이 나타나며 유령에 접촉 시 미니보스를 소환합니다.#미니보스방의 문 입구에 유령이 나타나 어느 미니보스가 나올 것인지 알려줍니다.", "순결한 영혼", "ko_kr")
	EID:addCollectible(CustomCollectibles.HANDICAPPED_PLACARD, "사용 시 캐릭터의 위치에 플래카드를 설치합니다.#{{Weakness}} 플래카드의 범위 안에 있는 적들을 약화시키며 처치 시 뼛조각을 생성합니다. #비어 있는 최대 체력에 비례하여 플래카드의 크기가 커집니다.#!!! 적이 없는 방에서 사용 불가", "장애인 플래카드", "ko_kr")
	EID:addCollectible(CustomCollectibles.BOOK_OF_JUDGES, "소지 시, 적이 있는 방에서 파란 타겟 여러개가 생성됩니다.#3초마다 빛줄기가 떨어지며 빛줄기는 캐릭터에게 피해를, 적에게 화상 피해를 줍니다.#사용 시 현재 방에서 빛줄기가 떨어지지 않습니다.", "심판의 책", "ko_kr")
	EID:addCollectible(CustomCollectibles.BIRTH_CERTIFICATE, "!!! 일회용 #사용 시 현재 들고 있는 장신구를 흡수하고 아이작의 모든 장신구가 있는 방으로 이동합니다.#장신구 한개 획득 시 원래 있던 장소로 돌아갑니다.", "출생 증명서", "ko_kr")

	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "{{DirtyChest}} 황금상자를 25%의 확률로 낡은 상자로 대체합니다.", "지하실 열쇠", "ko_kr")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "적 처치 시 5%의 확률로 생체상자를 드랍합니다.#생체상자에서는 하트류 픽업, 알약이나 몸체 관련 아이템 및 장신구를 드랍합니다.", "심장열쇠", "ko_kr")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "{{Bait}} 적과 접촉 시 해당 적에게 표식을 부여합니다. ({{Collectible618}}Rotten Tomato와 비슷한 효과)", "유다의 키스", "ko_kr")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "↑ 도박기계, 거지류에서 동전/폭탄/열쇠 사용 시 17%의 확률로 소모되지 않습니다.", "속임수 동전", "ko_kr")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "17%의 확률로 한 단계 더 높은 동전이 소환됩니다: #페니 -> 1+1 페니 -> 끈적이는 니켈 -> 니켈 -> 다임 -> 럭키 페니 -> 황금 페니", "교묘한 손기술", "ko_kr")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "↑ {{EmptyCoinHeart}}빈 코인하트 +1 #모든 하트 중에서 가장 먼저 소모되며 동전으로만 회복할 수 있습니다.", "탐욕의 심장", "ko_kr")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "{{TreasureRoom}}보물방이 코인을 요구하는 천사 상점으로 바뀝니다. #보물방에서의 천사 보스는 열쇠 조각을 드랍하지 않습니다!", "천사의 왕관", "ko_kr")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "↑ {{DamageSmall}}공격력 배율 x2 #Duct Tape를 소지하지 않은 경우 패널티 피격 시 부러집니다.", "완드", "ko_kr")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "무효과: 이미 부러진 완드입니다.", "안돼에에에", "ko_kr")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "피격 시 소지한 아이템 중 하나가 다른 아이템으로 바뀝니다.#루트 진행 아이템은 이 장신구의 효과를 받지 않습니다.", "에덴의 자물쇠", "ko_kr")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "클리어하지 않은 방에 진입 시 밟은 적들을 매우 느려지게 하는 분필가루를 뿌립니다. #분필가루는 10초동안 지속됩니다.", "분필 조각", "ko_kr")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "사망 시, 22%의 확률로 Eve 캐릭터로 부활합니다.", "아담의 갈비뼈", "ko_kr")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "스테이지 진입 시 저주가 걸릴 확률이 75% 감소합니다.", "분뇨", "ko_kr")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "스테이지 진입 시 효과 발동:#↑ {{DamageSmall}}공격력 배율 x1.1 #↑ 캐릭터의 크기가 커집니다. #이 효과는 영구적으로 적용됩니다.", "뼛가루", "ko_kr")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "{{Library}} 책 종류의 아이템이 증폭되거나 전혀 새로운 효과를 발동하며 충전 속도가 빨라집니다.", "찢어진 페이지", "ko_kr")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "{{Library}} 책 종류의 아이템 사용시 일정 확률로 랜덤 액티브 아이템 하나를 추가로 발동합니다.#{{Blank}} (확률은 액티브 충전 칸 수에 비례)#아이템을 돌리는 효과, 캐릭터를 사망시키거나 자해하는 아이템은 발동되지 않습니다.", "빈 페이지", "ko_kr")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "적과 보스의 크기 및 피격 판정 범위를 10% 감소시킵니다.", "꼬까신", "ko_kr")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "피격시 8%의 확률로 {{Collectible705}}Dark Arts 효과 발동", "열쇠칼", "ko_kr")
	EID:addTrinket(CustomTrinkets.SHATTERED_STONE, "열쇠 혹은 폭탄을 주울 시 일정 확률로 랜덤 자폭 파리를 생성합니다. #생성 확률은 주운 픽업의 레어도에 비례합니다.", "조각난 석상", "ko_kr")
	
	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "{{Collectible723}} Spindown Dice 효과 발동:#사용 시 방 안의 모든 아이템을 코드 뒷번호의 아이템으로 바꿉니다.#해금하지 않은 아이템은 등장하지 않습니다.", "스핀다운 주사위 파편", "ko_kr")
	EID:addCard(CustomConsumables.RED_RUNE, "방 안의 적 전체에게 대미지를 줍니다.#50%의 확률로 방 안의 아이템을 심연의 파리로, 픽업 아이템을 랜덤 자폭 파리로 바꿉니다.", "레드 룬", "ko_kr")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "부서진 하트 하나를 {{Heart}}최대 체력으로 바꿉니다.", "바느질", "ko_kr")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "{{Coin}}랜덤 동전을 1~12개 드랍합니다.", "다이아 Q", "ko_kr")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "열쇠와 황금열쇠를 모두 소모하여 그에 비례한 수의 픽업 아이템을 소환합니다. #장신구는 최소 9개, 아이템은 최소 21개의 열쇠가 필요합니다.", "스페이드 K", "ko_kr")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "폭탄과 황금폭탄을 모두 소모하여 그에 비례한 수의 픽업 아이템을 소환합니다. #장신구는 최소 9개, 아이템은 최소 21개의 폭탄이 필요합니다.", "클럽 K", "ko_kr")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "동전을 모두 소모하여 그에 비례한 수의 픽업 아이템을 소환합니다. #장신구는 최소 21개, 아이템은 최소 54개의 동전이 필요합니다.", "다이아 K", "ko_kr")
	EID:addCard(CustomConsumables.BAG_TISSUE, "방 안의 모든 픽업을 소모하여 그 중 가장 품질이 좋은 8개의 픽업을 기반으로 아이템을 하나 소환합니다.#픽업이 희귀할수록 (예시:{{EthernalHeart}}이터널하트, {{Battery}}메가배터리) 소환되는 아이템의 퀄리티가 높아집니다.#방 안의 픽업이 8개 미만인 경우에는 낮은 퀄리티의 아이템이 소환될 확률이 높아집니다.", "여행용 티슈", "ko_kr")
	EID:addCard(CustomConsumables.JOKER_Q, "블랙마켓으로 텔레포트합니다.", "조커?", "ko_kr")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "{{Collectible422}} Glowing Hour Glass 효과 발동:#사용 시 이전 방의 시점으로 시간을 되돌립니다.", "되돌리기 카드", "ko_kr")
	EID:addCard(CustomConsumables.LOADED_DICE, "↑ 현재 방에서 {{LuckSmall}}행운 +10", "속임수 주사위", "ko_kr")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "{{Key}}열쇠를 1~12개 드랍합니다.#낮은 확률로 충전된 열쇠를 드랍합니다.", "머리맡 Q", "ko_kr")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "{{Bomb}}폭탄을 1~12개 드랍합니다.#낮은 확률로 1+1 폭탄을 드랍합니다.", "클럽 Q", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "현재 층에서 폭탄이 드랍할 확률과 폭탄이 특수 폭탄으로 대체될 확률을 60% 증가시킵니다.", "클럽 J", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "현재 층에서 동전이 드랍할 확률과 동전이 특수 동전으로 대체될 확률을 60% 증가시킵니다.", "다이아 J", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "현재 층에서 열쇠가 드랍할 확률과 열쇠가 특수 열쇠로 대체될 확률을 60% 증가시킵니다.", "스페이드 J", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "현재 층에서 하트가 드랍할 확률과 하트가 특수 하트로 대체될 확률을 60% 증가시킵니다.", "하트 J", "ko_kr")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "현재 방의 모든 적에게 피해를 입히며 현재 방의 아이템당 각각 {{Collectible712}}레메게톤 불꽃 3개씩으로 바꿉니다.", "퀘이사 파편", "ko_kr")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "사용 시 캐릭터가 움직이는 방향으로 움직이며 공격하는 방향으로 공격하는 아군 적을 소환합니다.", "사업 카드", "ko_kr")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "↑ {{DamageSmall}}공격력 +1.25(중첩 가능)#공격력 증가 효과는 20초동안 서서히 사라집니다 #↑ {{Collectible216}}Ceremonial Robes 소지시 빨간하트 +1 #{{Warning}} 연속적으로 사용시 공격력 감소 속도가 빨라집니다.", "희생의 제물", "ko_kr")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "랜덤 책 효과를 발동합니다.", "도서관 카드", "ko_kr")
	EID:addCard(CustomConsumables.FLY_PAPER, "{{Collectible693}}The Swarm 아이템의 파리 8마리를 소환합니다.", "파리잡이 끈끈이", "ko_kr")
	EID:addCard(CustomConsumables.MOMS_ID , "방 안의 적들 위에 캐릭터의 공격력 x2의 피해를 주는 엄마의 식칼을 투척시킵니다.", "엄마의 신분증", "ko_kr")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES , "낡은 상자를 소환합니다.", "장례식", "ko_kr")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD , "Chaos Card처럼 던질 수 있음 #카드와 접촉한 적을 해당 게임에서 제거합니다.", "반물질 카드", "ko_kr")
	EID:addCard(CustomConsumables.FIEND_FIRE, "동전, 열쇠, 폭탄을 전부 소모하여 방 전체에 커다란 대미지를 줍니다.#합계 7-40: 15의 피해를 입으며 4초동안 불에 붙습니다. #합계 41-80: 적들이 30의 피해를 입으며 8초동안 불에 붙습니다.; 캐릭터 주변의 장애물을 파괴합니다. #함계 81+: 적들이 60의 피해를 입으며 16초동안 불에 붙습니다.; Mama Mega 폭발이 발생합니다.", "불장난", "ko_kr")
	EID:addCard(CustomConsumables.DEMON_FORM, "↑ 클리어하지 않은 방에 들어갈 때마다 {{DamageSmall}}공격력 +0.2#다음 스테이지 진입 시 효과가 사라집니다.", "악마화", "ko_kr")
	EID:addCard(CustomConsumables.VALENTINES_CARD, "Chaos Card처럼 던질 수 있음 #카드와 접촉한 적을 아군으로 만들며 빨간하트 하나를 드랍합니다.", "발렌타인 카드", "ko_kr")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "캐릭터의 주변을 돌고 적의 탄환을 막아주며 지형을 관통하는 눈물을 발사하는 유령 패밀리어를 2마리 소환합니다.#3회 피격시 사라지며 소울하트 반칸을 드랍합니다.", "영혼의 보호", "ko_kr")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "현재 소지한 액티브 아이템을 픽업 슬롯으로 이동시킵니다.#이미 픽업 슬롯에 액티브 아이템이 있을 경우 액티브 아이템을 내려놓습니다.", "거울세계의 풍경", "ko_kr")
	EID:addCard(CustomConsumables.CURSED_CARD, "현재 방에서 피격 시 체력이 감소하지 않으나, 소지 불가능 체력이 하나 추가되며 연사가 영구적으로 증가합니다.", "저주받은 카드", "ko_kr")
	--
	EID:addCard(CustomConsumables.CROWN_OF_GREED , "{{Coin}} 황금 동전을 1~2개 드랍합니다.#↓ 드랍한 황금 동전 개수 당 {{LuckSmall}}운 -1", "탐욕의 왕관", "ko_kr")
	EID:addCard(CustomConsumables.FLOWER_OF_LUST, "현재 방을 다시 시작하며 방 클리어 시 더 좋은 보상을 드랍합니다.", "색욕의 꽃", "ko_kr")
	EID:addCard(CustomConsumables.ACID_OF_SLOTH, "방 안의 모든 적들을 50% 느리게 하며 처치 시 독가스를 생성합니다.", "나태의 독", "ko_kr")
	EID:addCard(CustomConsumables.VOID_OF_GLUTTONY, "방 안의 모든 적들을 흡수합니다. #흡수한 적들의 최대 체력에 따라 캐릭터의 최대 체력 +1, 혹은 Cyst 적을 뱉습니다.#시간이 지날수록 체력을 서서히 회복하나 {{SpeedSmall}}이동속도가 감소합니다.", "식탐의 공허", "ko_kr")
	EID:addCard(CustomConsumables.APPLE_OF_PRIDE, "↑ 모든 능력치 증가#!!! 피격 시 해제됩니다.", "교만의 사과", "ko_kr")
	EID:addCard(CustomConsumables.CANINE_OF_WRATH, "방 안의 모든 적들이 15의 폭발 피해를 받습니다. #{{Warning}} 캐릭터도 폭발 피해를 받을 수 있음 #{{DamageSmall}} 적이 폭발로 처치될 때마다 서서히 감소하는 공격력이 증가합니다.", "분노의 송곳니", "ko_kr")
	EID:addCard(CustomConsumables.MASK_OF_ENVY, "모든 최대 체력을 {{BoneHeart}}뼈하트+{{RottenHeart}}썩은하트로 바꿉니다.", "질투의 가면", "ko_kr")

	EID:addPill(CustomPills.ESTROGEN, "빨간하트가 한칸이 되며 나머지 빨간하트를 전부 꼬마 클롯으로 바꿉니다.", "에스트로겐", "ko_kr")
	EID:addPill(CustomPills.LAXATIVE, "3초동안 캐릭터의 뒤로 옥수수 탄환을 발사합니다.", "설사약", "ko_kr")
	EID:addPill(CustomPills.PHANTOM_PAINS, "사용 시 피해를 입지 않고 피격 시 발동 효과를 발동합니다.#15초, 30초 이후에 각각 한번씩 더 발동합니다.", "헛통증", "ko_kr")
	EID:addPill(CustomPills.YUCK, "썩은하트를 하나 드랍합니다.#30초동안 빨간하트를 주울 때마다 파란 아군 파리를 소환합니다.", "우웩", "ko_kr")
	EID:addPill(CustomPills.YUM, "빨간하트를 하나 드랍합니다.#30초동안 빨간하트를 주울 때마다 능력치가 소량 증가합니다.", "냠", "ko_kr")

	EID:addEntity(5, 10, 84, "부서진 하트", "습득 시 최대체력 +1, 소지 불가능 체력 +1", "ko_kr")
	EID:addEntity(5, 10, 85, "기죽지 않는 하트", "현재 빨간하트+소울하트의 갯수가 홀수라면 소지한 상태에서 적 처치 시 확률적으로 1.5초 후 사라지는 하트를 드랍합니다.", "ko_kr")
	EID:addEntity(5, 10, 86, "모아진 하트", "습득 시 빨간하트 +4", "ko_kr")
	EID:addEntity(5, 10, 87, "배신의 하트", "???", "ko_kr")
	EID:addEntity(5, 10, 88, "더러운 하트", "방 클리어시 Dip 패밀리어 0~2마리를 소환합니다.", "ko_kr")
	EID:addEntity(5, 10, 89, "멍울진 하트", "습득 시 빨간하트와 더불어 꼬마 클롯 패밀리어 소환", "ko_kr")
	EID:addEntity(5, 10, 90, "사나운 하트", "{{DamageSmall}} 습득 시 빨간하트와 더불어 25초동안 서서히 감소하는 공격력 +1.25", "ko_kr")
	EID:addEntity(5, 10, 91, "우매한 하트", "{{DamageSmall}} 습득 시 블랙하트와 더불어 영구적 공격력 +0.1", "ko_kr")
	EID:addEntity(5, 10, 92, "수수께끼 하트", "{{EmptyHeart}} 빈 최대 체력 +1", "ko_kr")
	EID:addEntity(5, 10, 93, "뒤섞인 하트", "습득 시 다른 랜덤 하트 픽업 3개로 분해됩니다.", "ko_kr")
	EID:addEntity(5, 10, 94, "사악한 하트", "소지하고 있는 동안 캐릭터 주변에 적이 있으면 연옥의 유령을 소환합니다. #소지하고 있는 사악한 하트의 갯수만큼 유령의 공격력이 증가합니다.", "ko_kr")
	EID:addEntity(5, 10, 95, "매춘 하트", "습득 시 빨간하트와 더불어 Leprosy 배리어 소환", "ko_kr")
	EID:addEntity(5, 10, 96, "구두쇠 하트", "사라지면 판매 아이템을 소환하며 현재 방의 아이템과 픽업 아이템을 바꿉니다.", "ko_kr")
	EID:addEntity(5, 10, 97, "공허 하트", "{{Collectible706}} 소지한 상태에서 스테이지 진입 시 심연의 파리를 획득합니다.", "ko_kr")
	EID:addEntity(5, 10, 98, "굳은 하트", "열쇠 1개를 소모하여 소울하트 1.5칸을 획득합니다.", "ko_kr")
	EID:addEntity(5, 10, 99, "광신도 하트", "{{Collectible712}} 소지한 상태에서 스테이지 진입 시 레메게톤 불꽃을 소환합니다.", "ko_kr")
	EID:addEntity(5, 10, 100, "방랑자 하트", "습득 시 빨간하트를, 빨간하트를 주울 수 없으면 블랙하트를 획득합니다.", "ko_kr")
end

-- Chinese EID (by ReLU丶 and Saurtya)
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE,"{{ArrowUp}} 射速上升 #在宝箱房额外生成一个与妈妈/爸爸相关的道具,但只能拿走其中一个","平凡的生活","zh_cn")
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER,"使用后，获得一个{{Heart}} 心之容器和一颗碎心 #{{Warning}} 碎心达到12个时角色死亡","曲奇模具","zh_cn")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART,"{{BlackHeart}} +2黑心 #{{ArrowUp}} (伤害+2)×1.5 #{{ArrowUp}} +2射程 #{{ArrowDown}} -0.2弹速 #幽灵和穿透眼泪","罪人之心","zh_cn")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE,"每次使用后，增加 {{ArrowUp}} 5%完成概率(第20次必定完成),并获得完成后的魔方 #魔方完成后，每次使用会重置底座道具，道具来源于任意道具池","待完成的魔方","zh_cn")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE,"{{DiceRoom}} 重置底座道具 #{{Collectible402}} 重置后的道具来自任意道具池","魔方","zh_cn")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN,"双击射击键向你所在方向发射一条{{ColorRainbow}} 彩虹{{CR}} 渐变色痕迹 #踩在上面的敌人获得随机状态 {{Blank}}{{Collectible66}} 需要4秒冷却时间","魔法钢笔","zh_cn")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN,"给予你一个跟班以诺 #死亡后，如果你有以诺以外的其他跟班，则献祭它们并复活你，同时以诺会变得更强 #复活后，获得短暂无敌时间，保留原有的{{Heart}} 心之容器 #{{Warning}} 一次性","该隐的印记","zh_cn")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM,"受到伤害时，有25%的几率进入狂暴状态 #在此状态下，每一个受到伤害的敌人都有5%的几率被移除出本局游戏","盛怒","zh_cn")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH,"清理房间后会产生蓝苍蝇的跟班 #阻挡敌人的弹幕，阻挡过程有几率被摧毁并生成早餐或者粪便饰品 #保留的层数越多，产生的蓝苍蝇越多","垃圾袋","zh_cn")
	EID:addCollectible(CustomCollectibles.CHERUBIM,"{{Collectible331}} 发射神性眼泪的跟班","基路伯","zh_cn")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS,"杀死敌人后有20%概率在地上生成一个樱桃宝宝 #在敌人经过时，樱桃宝宝会产生魅惑气体 #清理房间后每个樱桃宝宝会转化为半颗心","樱桃朋友","zh_cn")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL,"进入新房间后，所有敌人将被分成两队 #对一队中的一个敌人造成伤害将对另一队中对应的另一个敌人造成60%的伤害","黑布玩偶","zh_cn")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE,"死亡后变成无敌的游魂，一只蓝雀会从房间中心向随机方向飞出。 在5秒内抓住蓝雀会将你复活并回到死亡地点，否则你将死亡 #{{Warning}} 死亡次数越多，蓝雀会飞得越快，你会更难抓到它","祈望蓝雀","zh_cn")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL,"双击射击按钮会向你射击的方向发射一个亡魂 #亡魂会锁定它碰撞的第一个敌人，持续7秒造成伤害或者直到该敌人被杀死 #亡魂不再锁定较小的敌人(<= 10 HP)，而是直接刺穿并立即杀死它们 #亡魂每次的攻击伤害从7开始，逐层递增 #亡魂可以锁定Boss {{Blank}}{{Collectible66}} 亡魂生成有7秒的冷却时间","愤怒亡魂","zh_cn")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE,"#射击时，有7%几率发射一把穿透匕首，匕首不造成伤害，但会对敌人造成流血效果 #{{BleedingOut}} 所有带有流血效果死亡的敌人都会掉落\"仪式用血\"，仪式用血使用后获得暂时的攻击加成","仪式匕首","zh_cn")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS,"在每层开始或者在床上睡觉后给予你两个{{Collectible712}} 被动道具火焰跟班（所罗门魔典）","天花板上的星星","zh_cn")
	EID:addCollectible(CustomCollectibles.QUASAR,"使用后，摧毁所有底座道具 #每摧毁一个底座道具生成三个{{Collectible712}} 被动道具火焰跟班（所罗门魔典）","类星体","zh_cn")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE,"{{Coin}} 当前楼层每购买两个商品，第三个商品将只需要1块钱 #{{Heart}} 在同一个房间进行两次心交易，会使得其他道具免费","2+1","zh_cn")
	EID:addCollectible(CustomCollectibles.RED_MAP,"在所有后续楼层显示{{UltraSecretRoom}} 红隐藏房间的位置 #将饰品留在宝箱房或Boss房进出房间后饰品会转化为{{Card78}} 红钥匙碎片","红地图","zh_cn")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER,"使用后，移除一个{{Heart}} 心之容器，{{ArrowUp}} +" .. tostring(CustomStatups.Damage.CHEESE_GRATER_MUL) .. "攻击力并获得3个小以撒 #允许你移除所有心之容器并且没有其他心，但是离开房间后角色会死亡","奶酪刨丝器","zh_cn")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR,"{{Pill}} 药丸基于不同的颜色具有额外效果","DNA解码器","zh_cn")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL,"使用后摧毁当前房间内的所有障碍物并对你周围小范围内的敌人施加混乱效果 #同时摧毁普通房间门并打开隐藏房入口","巴别塔","zh_cn")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD,"防止接下来的楼层遇到诅咒 #每避免一次诅咒，{{ArrowUp}} +" .. tostring(CustomStatups.Damage.BLESS_OF_THE_DEAD_MUL) .. "攻击力","亡者祝福","zh_cn")
	EID:addCollectible(CustomCollectibles.TANK_BOYS,"生成两个坦克跟班,它们会在房间内漫游并攻击视线内的敌人 #绿坦克：远距离向敌人快速射击，移速较快 #红坦克:近距离向敌人发射火箭，移速较慢","坦克男孩","zh_cn")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD,"杀死敌人在当前房间获得{{ArrowUp}} 射速和移速加成","血雨腥风","zh_cn")
	EID:addCollectible(CustomCollectibles.RED_BOMBER,"{{Bomb}} +5炸弹 #免疫爆炸 #允许你投掷炸弹而不是直接在地板上放置炸弹","红炸弹","zh_cn")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE,"{{ArrowUp}} 提升你拥有的所有跟班的属性 #一些跟班提供更大属性提升,而有些跟班则没有效果(如蓝苍蝇,小屎,以撒的身体部位)","妈妈的爱","zh_cn")
	EID:addCollectible(CustomCollectibles.CAT_IN_A_BOX,"视线之外的敌人（由射击方向决定）会瘫痪，不会以任何方式攻击你，同时它们也不会受到伤害 #{{Confusion}} 也会对Boss和小Boss生效","薛定谔的猫","zh_cn")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS,"使用后随机移除一个已有的道具,并生成三个与该道具相同品质的道具 #只能拿取三个道具中其中一个 #不会移除或生成任务物品(如天使钥匙，爸爸的便条)","《创世记》","zh_cn")
	EID:addCollectible(CustomCollectibles.SCALPEL,"消耗一个{{Heart}} 心之容器，若没有，则消耗两颗{{SoulHeart}} 魂心/{{BlackHeart}} 黑心，让你永久地向随机方向发射眼泪 #这些眼泪造成65%的伤害，并拥有你的眼泪特效","解剖刀","zh_cn")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY,"进入新一层会生成一个金金币 #{{Shop}} 商店现在会额外出售1-4个额外道具,道具来源商店、宝箱房、Boss房道具池 #如果商店生成贪婪，则会在贪婪死后产生3-4个道具出售","店长的硬币","zh_cn")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH,"双击射击键以触发神经压迫 #{{ArrowDown}} 你会受到一次假伤害（钝刀片效果）并永久降低" .. tostring(CustomStatups.Speed.NERVE_PINCH) .. "速度 #有80%的几率免费触发一次主动道具 #{{Collectible66}} 3秒冷却时间 #{{Warning}} 6充能或12充能的道具触发时，给予两倍的速度惩罚 #一次性和无限使用的主动道具不会触发","神经箍缩","zh_cn")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1],"受到伤害后会填充血皿,并免疫本次伤害 #血皿一共可以填充6次 #血皿填满之后,使用它或下次受到伤害会清空血皿并分别对玩家造成3或3.5颗心的伤害 #{{Warning}} 如果血皿不是空的，就不能轻易被更换！","血皿","zh_cn")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY,"每15秒在两种不同状态之间切换的轨道 #两个轨道围绕玩家快速旋转 #一个轨道旋转得更慢,更靠近玩家,定时向随机方向发射牙齿并在其下方产生血蠕虫 #{{Warning}} 轨道可以阻挡怪物的射击并可以对怪物造成接触伤害","同室操戈","zh_cn")
	EID:addCollectible(CustomCollectibles.RED_KING, "击败Boss后，房间中间会出现一个特殊地下室 #{{BossRoom}} 进入后将会进行另一场更高难度的Boss战 #胜利后奖励红隐藏道具池道具二选一", "红王", "zh_cn")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "生成一个观星乞丐，每次喂7块钱，会给予星象房道具 #只能用魂心充能 #充满能需要1个{{SoulHeart}} 魂心 #{{Warning}} 每层只能使用一次", "观星帽", "zh_cn")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "使用后，将袋子悬空 #4秒内，玩家进入无敌状态且无法射击，并将周围所有敌方眼泪吸入袋中 #4秒后，将所有吸入的眼泪射出并追踪攻击敌人", "无底袋", "zh_cn")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "靠近你的敌人会变瘫痪，你的眼泪也可以使它们瘫痪（运气0时为2%，运气10时几率最高，为7%） #瘫痪的敌人会逐渐失去速度，12秒后死亡 #瘫痪的敌人死亡后，会释放大量黑色眼泪", "混沌十字", "zh_cn")
	EID:addCollectible(CustomCollectibles.REJECTION, "拾取后获得一个不射击但造成2.5接触伤害的宝宝跟班 #使用时，消耗你所有的跟班，并将它们以一个带穿透的大肉球扔向射击方向 #伤害公式：你的面板伤害×4×消耗的跟班数量 #出房间后消耗的宝宝还原", "流产", "zh_cn")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "从当前房间道具池生成一个拍卖道具 #其价格每秒变化5次 #价格是随机的，且通常会随着时间的推移而上涨，直到{{Coin}} 99元 #离开房间后，拍卖的物品消失", "拍卖槌", "zh_cn")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "用星界锁链将自己锁在随机敌人身上并将其禁锢 #锁链会对敌人造成接触伤害 #{{Warning}} 离被锁链锁住的敌人太远会导致锁链断掉 #被锁链锁住的敌人击杀后有33%的几率掉落{{SoulHeart}} 魂心", "灵魂锁链", "zh_cn")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}} +0.3弹速 #角色的眼泪被穿透羽毛取代，距离越远，造成的伤害越高 #双击会发射类似教条的攻击方式之一（循环触发） {{Blank}}{{Collectible66}} 6秒冷却时间", "天使之翼", "zh_cn")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "{{ArrowUp}} +0.2移速 #当目前该局游戏结束时（死亡或胜利），你拥有的3个随机道具（包括主动）会在结束的地上生成 #它们可以在下一局时通过到达同一楼层来获取", "递给我", "zh_cn")
	EID:addCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, "{{Key}} +2 钥匙 #需要一个钥匙来“解锁”和使用它 #使用后，使房间内的所有敌人瘫痪 #瘫痪的敌人会失去速度，并在失去速度12秒后死亡 #每次使用消耗一把钥匙，如果没有钥匙则没有效果 #与钥匙相关的饰品有特殊的协同作用", "《利维坦》", "zh_cn")
	EID:addCollectible(CustomCollectibles.FRIENDLY_SACK, "每清理三个房间，生成一个弱跟班（如：蓝苍蝇，小屎等） #如果三个房间中包含Boss房，则会生成一个较强的跟班", "友好的麻袋", "zh_cn")	
	EID:addCollectible(CustomCollectibles.MAGIC_MARKER, "拾取后掉落一张{{Card}} 卡牌 #使用后，变换当前卡牌（正位牌为卡牌编号+1，逆位牌为卡牌编号-1）", "魔法标记", "zh_cn")
	EID:addCollectible(CustomCollectibles.ULTRA_FLESH_KID, "追击敌人并造成接触伤害的跟班，类似于水蛭 #有3个阶段，每收集7.5颗{{Heart}} 红心进化一次", "究极食肉小子！", "zh_cn")
	EID:addCollectible(CustomCollectibles.VAULT_OF_HAVOC, "被动存储12个击杀后的敌人，存储12个敌人后可以使用 #{{MiniBoss}} 使用后，传送到特殊房间，里面有你最近杀死的12个敌人，击杀它们会基于所有敌人的总生命值给予奖励", "浩劫穹顶", "zh_cn")
	EID:addCollectible(CustomCollectibles.PURE_SOUL, "{{MiniBoss}} 所有七宗罪Boss必定掉落各自的{{ColorRed}} 罪恶道具{{CR}} #这个灵魂可以在{{SecretRoom}} 隐藏房或者{{SuperSecretRoom}} 超级隐藏房发现，靠近会消失并随机生成一个七宗罪Boss #这个灵魂也会在通往七宗罪Boss房间的门口生成，以提醒你里面是哪个七宗罪Boss", "纯净灵魂", "zh_cn")
	EID:addCollectible(CustomCollectibles.HANDICAPPED_PLACARD, "在地上放置一个残疾人标语牌 #标语牌作用范围内的每个敌人都会被{{Weakness}} 虚弱（卡牌力量?效果）并在死亡时产生骨刺 #你在放置标语牌时拥有的空的心之容器越多，标语牌的范围越大", "残疾人标语牌", "zh_cn")
	EID:addCollectible(CustomCollectibles.BOOK_OF_JUDGES, "#【被动效果】进入未清理的房间时，在地上持续周期性（每3秒）生成圣光攻击目标 {{Blank}}光束会伤害敌人并灼烧它们，但同时也会伤害到你并造成1颗心伤害 #【主动效果】取消当前房间的圣光召唤", "《士师记》", "zh_cn")
	EID:addCollectible(CustomCollectibles.BIRTH_CERTIFICATE,"{{Warning}} 一次性 #如同死亡证明的效果 #{{Warning}} 会消耗掉当前身上所携带的所有饰品 #使用后传送到一个特殊房间，其房间内容为游戏内包含mod的所有饰品和若干基础掉落，拾取一个饰品后传送回该层初始房间 #若房间内无法放下所有的饰品，则生成第二个房间 # 进入第二个房间后无法回到第一个房间","出生证明","zh_cn")
                 
	EID:addTrinket(CustomTrinkets.BASEMENT_KEY,"{{DirtyChest}} 持有时，每个金宝箱都有 25% 的几率被旧宝箱取代","地下室钥匙","zh_cn")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART,"持有时，每个生命值超过10的敌人在死亡后都有几率掉落猩红宝箱 #猩红宝箱可能包含1-4{{Heart}} 心 / {{Pill}} 药丸或者跟身体有关的道具","心之钥","zh_cn")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS,"{{Bait}} 接触到你的敌人会成为其他敌人的攻击目标（类似烂番茄效果）","犹大之吻","zh_cn")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY,"{{LuckSmall}} 消耗硬币，炸弹或者钥匙进行开锁，给乞丐捐钱或者开箱子时有 17 %概率不消耗","厚硬币","zh_cn")	
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND,"{{Coin}} 生成硬币时，每个硬币都有20%概率进行升级 #普通硬币->双倍硬币->粘币->五块钱硬币->十块钱硬币->幸运币->金金币","出千妙手","zh_cn")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART,"给予你一个{{EmptyCoinHeart}} 空的硬币心 #通过拾取硬币补充，优先其他心消耗","贪婪之心","zh_cn")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN,"{{TreasureRoom}} 宝箱房将出售天使房道具 #从雕像中复活的天使不再掉落钥匙碎片","天使之冠","zh_cn")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD,"{{ArrowUp}} 持有时，伤害×2 #{{ArrowDown}} 受到伤害后会断掉 #持有饰品：胶带可以避免其断掉","魔法树枝","zh_cn")
	EID:addTrinket(CustomTrinkets.WAIT_NO,"无作用，它已经断掉了","等等，不！","zh_cn")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK,"受伤后，将你身上随机一个道具转化为另一个随机道具","伊甸的头发","zh_cn")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK,"进入未清理房间时，会在下方留下5秒的粉末痕迹 #走过粉末痕迹的敌人将被显着减慢","一块粉笔","zh_cn")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB,"死亡后，有22%的几率复活成为夏娃","亚当的肋骨","zh_cn")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL,"进入新的一层有75%的概率免疫诅咒","粪便","zh_cn")
	EID:addTrinket(CustomTrinkets.BONE_MEAL,"在每个新楼层开始时,给予: #{{ArrowUp}} +10% 伤害 #{{ArrowUp}} 眼泪尺寸增加 #加成效果是永久性的，即使失去该饰品，伤害和眼泪尺寸也会保持","骨粉","zh_cn")
	EID:addTrinket(CustomTrinkets.TORN_PAGE,"{{Library}} 加强或改变书的主动效果,或者使书的充能更快 #除了正常生成外，该饰品有33%概率在书房生成","撕裂的书页","zh_cn")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE,"{{Library}} 在使用书时额外激活一个随机主动道具 #除了正常生成外，该饰品有33%概率在书房生成","空白的书页","zh_cn")
	EID:addTrinket(CustomTrinkets.BABY_SHOES,"将所有敌人的尺寸缩小10% #这会影响动画和碰撞体积 #对Boss也有效","童鞋","zh_cn")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "受到攻击时有8%的几率激活 {{Collectible705}} 黑魔法物品效果", "钥匙刀", "zh_cn")
	EID:addTrinket(CustomTrinkets.SHATTERED_STONE, "拾取基础掉落有概率生成随机蝗虫 #基础掉落的质量越高，生成概率越高", "碎石", "zh_cn")
                 
	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD,"{{Collectible723}} 触发D-1骰子效果", "D-1碎片", "zh_cn")
	EID:addCard(CustomConsumables.RED_RUNE, "{{Collectible706}} 对房间内的所有敌人造成伤害，50%几率将道具底座转化为红色蝗虫，将掉落物转化为随机蝗虫", "红色符文", "zh_cn")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD,"移除一颗{{BrokenHeart}} 碎心并给予一个{{Heart}} 心之容器", "针线包", "zh_cn")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS,"生成1-12个随机{{Coin}} 硬币", "方片Q", "zh_cn")
	EID:addCard(CustomConsumables.KING_OF_SPADES,"失去所有钥匙（但不超过33个）并生成与失去钥匙数量成比例概率的掉落物 #可生成饰品或道具，分别在第9和21个钥匙时达到100% #如果角色有{{GoldenKey}} 金钥匙，也会被移除并显著提高失去钥匙的数量", "梅花K", "zh_cn")
	EID:addCard(CustomConsumables.KING_OF_CLUBS,"失去所有炸弹（但不超过33个）并生成与失去炸弹数量成比例概率的掉落物 #可生成饰品或道具，分别在第9和21颗炸弹时达到100% #如果角色有{{GoldenBomb}} 金炸弹，也会被移除并显著提高失去炸弹的数量", "黑桃K", "zh_cn")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS,"失去所有硬币（但不超过66个）并生成与失去硬币数量成比例概率的掉落物 #可生成饰品或道具，分别在第18和42枚硬币时达到100%", "方片K", "zh_cn")
	EID:addCard(CustomConsumables.BAG_TISSUE,"移除当前房间所有掉落物，并选取其中8个最有价值的掉落物参与道具合成 #道具合成等同于里该隐合成袋", "合成袋碎布", "zh_cn")
	EID:addCard(CustomConsumables.JOKER_Q,"传送到 {{SuperSecretRoom}} 黑市", "恶魔？", "zh_cn")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD,"一次性{{Collectible422}} 发光沙漏效果", "uno？", "zh_cn")
	EID:addCard(CustomConsumables.LOADED_DICE,"当前房间{{ArrowUp}} +10{{Luck}} 幸运", "灌铅骰子", "zh_cn")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN,"生成1-12个随机{{Key}} 钥匙 #小概率生成双倍钥匙或充能钥匙", "梅花Q", "zh_cn")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS,"生成1-12个随机{{Bomb}} 炸弹 #小概率生成双倍炸弹", "黑桃Q", "zh_cn")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS,"当前层{{Bomb}} 炸弹的掉落频率增加，并且炸弹的掉落质量提高", "黑桃J", "zh_cn")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS,"当前层{{Coin}} 硬币的掉落频率增加，并且硬币的掉落质量提高", "方片J", "zh_cn")
	EID:addCard(CustomConsumables.JACK_OF_SPADES,"当前层{{Key}} 钥匙的掉落频率增加，并且钥匙的掉落质量提高", "梅花J", "zh_cn")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS,"当前层{{Heart}} 心的掉落频率增加，并且心的掉落质量提高", "红桃J", "zh_cn")
	EID:addCard(CustomConsumables.QUASAR_SHARD,"对房间内所有敌人造成伤害，每个道具底座生成3个被动道具火焰跟班（所罗门魔典）", "类星体碎片", "zh_cn")
	EID:addCard(CustomConsumables.BUSINESS_CARD,"{{Collectible687}} 生成一个随机怪物为你作战", "名片", "zh_cn")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD,"{{ArrowUp}} +1.25攻击力，并在25秒内持续衰减 #如果你有{{Collectible216}} 仪式法袍，则治疗一颗红心 #{{Warning}} 使用该物品越多，伤害衰减得越快", "仪式用血", "zh_cn")
	EID:addCard(CustomConsumables.LIBRARY_CARD,"{{Library}} 随机给予一本书的效果", "借书证", "zh_cn")
	EID:addCard(CustomConsumables.FLY_PAPER,"{{Collectible693}} 生成8只环绕苍蝇 #苍蝇被弹幕打到会转化为蓝苍蝇", "粘蝇板", "zh_cn")
	EID:addCard(CustomConsumables.MOMS_ID,"向房间内的所有敌人投掷匕首，造成双倍伤害", "妈妈的身份证", "zh_cn")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES,"生成一个{{DirtyChest}} 旧箱子", "殡仪服务", "zh_cn")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD,"可投掷 #被此卡接触到的敌人会在本局被移除", "反物质卡", "zh_cn")
	EID:addCard(CustomConsumables.FIEND_FIRE,"消耗你的基础物品进行大规模的破坏 #3-20：敌人受到15点伤害并燃烧4秒 #21-40：初始伤害、燃烧伤害和燃烧持续时间加倍，摧毁你周围的障碍 #41+：燃烧伤害和燃烧持续时间增加4倍,产生妈妈炸弹的爆炸", "恶魔之火", "zh_cn")
	EID:addCard(CustomConsumables.DEMON_FORM,"每进入一个新的未清理的房间,你的{{Damage}} 伤害就会增加{{ArrowUp}} 0.2 #进入Boss房间时伤害增加{{ArrowUp}} 1 #进入新的楼层后增益消失", "恶魔形态", "zh_cn")
	EID:addCard(CustomConsumables.VALENTINES_CARD, "可投掷 #永久魅惑穿过的所有敌人，并且在使用时掉落一颗红心", "情人节贺卡", "zh_cn")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "生成两个幽灵环绕跟班 #跟班会阻挡弹幕并发射幽灵眼泪 #阻挡三次后跟班会死亡并掉落{{HalfSoulHeart}} 半颗魂心", "精神卡", "zh_cn")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "将主动道具移动到第二主动栏（右下角），如果你已经拥有第二主动道具，则会生成在道具底座上", "镜像卡", "zh_cn")
	EID:addCard(CustomConsumables.CURSED_CARD, "使用后，当前房间原本应该受到的伤害都会转换为获得一颗{{BrokenHeart}} 碎心和永久的射速提升{{ArrowUp}} ", "诅咒卡", "zh_cn")
                 
	EID:addCard(CustomConsumables.CROWN_OF_GREED , "{{Luck}} 使用后在当前房间生成1-2个金金币，但是每拾取一次金币幸运{{ArrowDown}} -1", "贪婪之冠", "zh_cn")
	EID:addCard(CustomConsumables.FLOWER_OF_LUST, "使用后可以重新清理房间，并获得更好的奖励", "欲望之花", "zh_cn")
	EID:addCard(CustomConsumables.ACID_OF_SLOTH, "使用后，房间中的每个敌人都会永久减速50%，但每2秒会留下毒气云，持续4秒", "懒惰之酸", "zh_cn")
	EID:addCard(CustomConsumables.VOID_OF_GLUTTONY, "{{HalfHeart}} 在7秒内，如果你的红心不足，你会以每秒1.5红心的速度快速恢复它，同时每次恢复速度都会降低{{ArrowUp}} -0.01 #杀死敌人会使该效果的持续时间延长2秒", "暴食之虚", "zh_cn")
	EID:addCard(CustomConsumables.APPLE_OF_PRIDE, "获得大量属性提升{{ArrowUp}} #受到伤害后效果消失", "傲慢之果", "zh_cn")
	EID:addCard(CustomConsumables.CANINE_OF_WRATH, "房间里每个敌人都会爆炸，造成15点伤害 #{{Warning}} 角色会受到敌人爆炸伤害 #每个死于爆炸的敌人都会给予角色短暂的{{ArrowUp}} +1.25伤害提升", "愤怒之犬", "zh_cn")
	EID:addCard(CustomConsumables.MASK_OF_ENVY, "将所有心之容器转化为{{RottenBoneHeart}} 充满腐心的骨心", "嫉妒面具", "zh_cn")
	
	EID:addPill(CustomPills.ESTROGEN,"{{Trinket176}} 只保留1颗红心，将其余红心扣除，不影响魂心/黑心", "雌激素上升", "zh_cn")
	EID:addPill(CustomPills.LAXATIVE,"让你从背后射出玉米眼泪，持续3秒", "泻药", "zh_cn")
	EID:addPill(CustomPills.PHANTOM_PAINS,"使用后造成一次假受伤（钝刀片效果） #每过15-30秒就会再受到一次假伤害", "幻痛", "zh_cn")
	EID:addPill(CustomPills.YUCK,"生成1个{{RottenHeart}} 腐心 #30秒内每捡起一颗红心都会产生蓝苍蝇", "呸！", "zh_cn")
	EID:addPill(CustomPills.YUM,"生成2-5个{{HalfHeart}} 半红心 #30秒内每捡起一颗红心都会给予永久属性上升{{ArrowUp}} ", "嗯！", "zh_cn")	
                
	EID:addEntity(5, 10, 84, "神伤者的心", "拾取后，给予角色1个{{Heart}} 心之容器和1个碎心", "zh_cn")
	EID:addEntity(5, 10, 85, "无畏者之心", "拾取后，最末尾的心会被银边环绕 #如果被银边环绕的心只有半颗，则角色杀死敌人时有20%的概率掉率迅速消失的半颗心", "zh_cn")
	EID:addEntity(5, 10, 86, "囤积者之心", "拾取后，恢复4颗红心", "zh_cn")
	EID:addEntity(5, 10, 87, "背叛者之心", "接近时分裂成半个红心和1个随机拾取物（炸弹、钥匙或镍币）", "zh_cn")
	EID:addEntity(5, 10, 88, "污秽者之心", "拾取后，最末尾的心会被大便覆盖 #角色每有1颗心被大便覆盖，则清理完房间后会生成0-2个随机友方蘸酱", "zh_cn")
	EID:addEntity(5, 10, 89, "血凝者之心", "拾取后，回复1颗红心并在拾取后生成1个血凝块跟班 #如果角色只能获得魂心，则只会生成1个魂心血凝块跟班", "zh_cn")
	EID:addEntity(5, 10, 90, "残暴者之心", "拾取后，回复1颗红心并增加{{ArrowUp}} +1.25伤害，持续25秒 #满红心时也能拾取并获得双倍伤害提升", "zh_cn")
	EID:addEntity(5, 10, 91, "堕落者之心", "拾取后，获得1颗黑心并永久提升{{ArrowUp}} +0.16伤害", "zh_cn")
	EID:addEntity(5, 10, 92, "迷离者之心", "拾取后，出现在最末尾 #角色获得1次额外的生命，在死亡时，角色会以半颗红心的生命值于当前房间复活（魂心类角色为半颗魂心） #额外的每颗迷离者之心会使角色在复活时回复2颗红心（魂心类角色不会获得额外魂心）", "zh_cn")
	EID:addEntity(5, 10, 93, "无常者之心", "拾取时随机分成3颗心", "zh_cn")
	EID:addEntity(5, 10, 94, "受难者之心", "拾取后，最末尾的心会被幽灵覆盖 #覆盖时，每2秒召唤幽灵跟踪敌人，爆炸并瞬间造成3次每次200%角色伤害 #如果有多颗心被幽灵覆盖，则提升幽灵的接触伤害和生成范围", "zh_cn")
	EID:addEntity(5, 10, 95, "浪荡者之心", "如果角色有空的心之容器，则会自动吸附 #拾取后，回复1颗红心并生成1个麻风病环绕物 #环绕物会造成接触伤害并阻挡敌人眼泪，阻挡3次后消失", "zh_cn")
	EID:addEntity(5, 10, 96, "吝财者之心", "拾取后，最末尾的心会被金币覆盖 #当角色失去被金币覆盖的心时，生成1-2个物品交易,并重置房间内所有道具和掉落物", "zh_cn")
	EID:addEntity(5, 10, 97, "空虚者之心", "拾取后，最末尾的心会被蝗虫覆盖 #角色进入新楼层时，每有1颗心被蝗虫覆盖，永久获得1只深渊{{Collectibles 706}} 产生的蝗虫", "zh_cn")
	EID:addEntity(5, 10, 98, "受缚者之心", "消耗1把{{Key}} 钥匙（或拥有金钥匙）才能拾取 #拾取后，获得1颗蓝心并生成1个鬼魂 #鬼魂会与角色一同发射眼泪并阻挡敌人的眼泪 #鬼魂会在受到3次伤害后消失,同时掉落半颗魂心", "zh_cn")
	EID:addEntity(5, 10, 99, "狂信者之心", "拾取后，最末尾的心会被紫边覆盖 #角色进入新楼层时，每有1颗心被紫边覆盖，获得1个{{Collectible712}} 随机被动道具火焰跟班（所罗门魔典）", "zh_cn")
	EID:addEntity(5, 10, 100, "流亡者之心", "作为混合心的黑心版本 #拾取后，优先治疗红心，溢出的部分转化为黑心", "zh_cn")
end
