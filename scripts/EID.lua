-- making a Spindown Dice Shard roll helper --
----------------------------------------------
local function SpindownDiceCallback(descObj)
	EID:appendToDescription(descObj, "#{{Collectible723}} :")
	local refID = descObj.ObjSubType
	local hasCarBattery = EID.player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)
	
	for i = 1,EID.Config["SpindownDiceResults"] do
		local spinnedID = EID:getSpindownResult(refID)
		if hasCarBattery then
			refID = spinnedID
			spinnedID = EID:getSpindownResult(refID)
		end
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
	
	if hasCarBattery then
		EID:appendToDescription(descObj, " (Results with {{Collectible356}})")
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
	EID:appendToDescription(descObj, "#{{Trinket" .. tostring(CustomTrinkets.TORN_PAGE) .. "}}: ")
	local refID = descObj.ObjSubType
	
	if refID == CustomCollectibles.BOOK_OF_GENESIS then
		EID:appendToDescription(descObj, "Gives you 4 options to choose from instead of 3")
	elseif refID == CollectibleType.COLLECTIBLE_NECRONOMICON then
		EID:appendToDescription(descObj, "Spawns 3 locusts of death on use")
	elseif refID == CollectibleType.COLLECTIBLE_BIBLE then
		EID:appendToDescription(descObj, "Removes a broken heart")
	elseif refID == CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS then
		EID:appendToDescription(descObj, "Prevents Harbingers from spawning in boss rooms")
	elseif refID == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL then
		EID:appendToDescription(descObj, "Also grants Eye of Belial effect for the room")
	elseif refID == CollectibleType.COLLECTIBLE_BOOK_OF_SIN then
		EID:appendToDescription(descObj, "Has a 3% chance to spawn a pedestal item, normal chest or a golden chest")
	elseif refID == CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS then
		EID:appendToDescription(descObj, "The shield has extended durability")
	elseif refID == CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD then
		EID:appendToDescription(descObj, "Grants a bone heart on use")
	elseif refID == CollectibleType.COLLECTIBLE_HOW_TO_JUMP then
		EID:appendToDescription(descObj, "When landing, shoot tears in X or + pattern")
	elseif refID == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
		EID:appendToDescription(descObj, "All wisps have 1.5x more health")
	elseif refID == CollectibleType.COLLECTIBLE_SATANIC_BIBLE then
		EID:appendToDescription(descObj, "Grants you a choice of 2 devil deal items after defeating a boss")
	elseif refID == CollectibleType.COLLECTIBLE_TELEPATHY_BOOK then
		EID:appendToDescription(descObj, "Grants the Wiz (Dunce Cap) effect on use")
	elseif refID == CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK then
		EID:appendToDescription(descObj, "Spawns a golden troll bomb instead")
	elseif refID == CustomCollectibles.BOOK_OF_LEVIATHAN then
		EID:appendToDescription(descObj, "Doesn't require keys to be used")
	elseif refID == CollectibleType.COLLECTIBLE_LEMEGETON then
		EID:appendToDescription(descObj, "Can be used at partial charge to gain remaining charges at the cost of player's red health (as if you have {{Collectible205}})")
	elseif refID == CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS or refID == CollectibleType.COLLECTIBLE_MONSTER_MANUAL then
		EID:appendToDescription(descObj, "Gains 2 charges back when used")	
	else
		EID:appendToDescription(descObj, "<No effect (probably because the book is modded)>")
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
	EID:appendToDescription(descObj, "#{{Collectible" .. tostring(CustomCollectibles.BOOK_OF_LEVIATHAN) .. "}}: ")
	local refID = descObj.ObjSubType % 32768
	
	if refID == TrinketType.TRINKET_STORE_KEY then
		EID:appendToDescription(descObj, "Crippled enemies can drop random pickup on death")
	elseif refID == TrinketType.TRINKET_RUSTED_KEY then
		EID:appendToDescription(descObj, "Applies confusion to crippled enemies")
	elseif refID == TrinketType.TRINKET_CRYSTAL_KEY then
		EID:appendToDescription(descObj, "Can randomly freeze enemies on death")
	elseif refID == TrinketType.TRINKET_BLUE_KEY then
		EID:appendToDescription(descObj, "Crippled enemies can drop half soul heart on death")
	elseif refID == TrinketType.TRINKET_STRANGE_KEY then
		EID:appendToDescription(descObj, "Applies random status effect to enemies")
	elseif refID == TrinketType.TRINKET_GILDED_KEY then
		EID:appendToDescription(descObj, "Can randomly Midas freeze enemies on use")
	elseif refID == CustomTrinkets.BASEMENT_KEY then
		EID:appendToDescription(descObj, "Crippled enemies can spawn bone orbitals on death")
	elseif refID == CustomTrinkets.KEY_TO_THE_HEART then
		EID:appendToDescription(descObj, "Crippled enemies can drop half red heart on death")
	elseif refID == CustomTrinkets.KEY_KNIFE then
		EID:appendToDescription(descObj, "Applies bleed to crippled enemies")
	end
	
	return descObj
end

local function isKeyTrinket(t)
	t = t % 32768	-- golden trinkets
	return (t == TrinketType.TRINKET_STORE_KEY or t == TrinketType.TRINKET_RUSTED_KEY
	or t == TrinketType.TRINKET_CRYSTAL_KEY or t == TrinketType.TRINKET_BLUE_KEY 
	or t == TrinketType.TRINKET_STRANGE_KEY or t == TrinketType.TRINKET_GILDED_KEY 
	or t == CustomTrinkets.BASEMENT_KEY or t == CustomTrinkets.KEY_TO_THE_HEART or t == CustomTrinkets.KEY_KNIFE)
end

local function KeyTrinketsCondition(descObj)
	if descObj.ObjType ~= 5 or descObj.ObjVariant ~= PickupVariant.PICKUP_TRINKET 
	or not isKeyTrinket(descObj.ObjSubType) then
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


		----------------------------------------
		-- THE ACTUAL DESCRIPTIONS START HERE --
		----------------------------------------


-- Enlish EID
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}} Tears up #Spawns an additional Mom and Dad related item in Treasure rooms alongside the presented items; only one item can be taken")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "Gives you one {{Heart}} heart container and one broken heart #{{Warning}} Having 12 broken hearts kills you!")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "+2 black hearts #{{ArrowUp}} Damage +2 then x1.5 #{{ArrowUp}} Grants +2 range and -0.2 shotspeed #Grants spectral and piercing tears")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "After each use, has a 5% (100% on 20-th use) chance to be 'solved', removed from the player and be replaced with a Magic Cube item")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "Rerolls item pedestals #Rerolled items can be drawn from any item pool")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "Double tap shooting button to spew a line of {{ColorRainbow}}rainbow{{CR}} creep in the direction you're firing #Random permanent status effects is applied to enemies walking over that creep #Has a 4 seconds cooldown")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "Grants you Enoch familiar #On death, if you have any item familiars besides Enoch, revive you and remove them instead; Enoch familiar becomes more powerful; grants you invincibility frames and keeps all your heart containers #{{Warning}} Works only once")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "25% chance to enter Berserk state when taking damage #While in this state, every enemy damaged has a 10% chance to be erased for the rest of the run")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "A familiar that creates blue flies upon clearing a room #Blocks enemy projectiles, and after blocking it has a chance to be destroyed and drop Breakfast or Nightsoil trinket #The more floors it is not destroyed, the more flies it spawns")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "A familiar that rapidly shoots tears with Godhead aura")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "Killing an enemy has a 20% chance to drop cherry familiar on the ground #Those cherries emit a charming fart when an enemy walks over them, and drop half a heart when a room is cleared")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "Upon entering a new room, all enemies will be split in pairs. Dealing damage to one enemy in each pair will deal 60% of that damage to another enemy in that pair")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "Upon dying you turn into invincible ghost and a bird flies out of room center in a random direction. Catching the bird in 5 seconds will save you and get you back to your death spot, otherwise you will die #{{Warning}} Every time you die, the bird will fly faster and faster, making it harder to catch her")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "Double tap shooting button to launch a ghost familiar in the direction you are firing #The ghost will latch onto the first enemy it collides with, dealing damage over time for 7 seconds or until that enemy is killed #The ghost's damage per hit starts at 7 and increases each floor #The ghost can latch onto bosses aswell #{{Warning}} Has a 7 seconds cooldown")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "When shooting, 7% chance to launch a piercing dagger that does no damage, but inflicts bleed on enemies #All enemies that die while bleeding will drop Sacrificial Blood Consumable that gives you temporary DMG up")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "Grants you two Lemegeton wisps at the beginning of each floor and when sleeping in bed")
	EID:addCollectible(CustomCollectibles.QUASAR, "Consumes all item pedestals in the room and gives you 3 Lemegeton wisps for each item consumed")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "Every third shop item on the current floor will cost 1 {{Coin}} penny #Buying two items with hearts in one room makes all other items free")
	EID:addCollectible(CustomCollectibles.RED_MAP, "Reveals location of Ultra Secret Room #Any trinket left in a boss or treasure room will turn into Cracked Key, unless this is your first visit in such room")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "Removes one red heart container and gives you {{ArrowUp}} +" .. tostring(CustomStatups.Damage.CHEESE_GRATER) .. " Damage up and 3 Minisaacs")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "Pills now have additional effects based on their color")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "Destroys all obstacles in the current room and applies confusion to enemies in small radius around you #Also blows the doors open and opens secret room entrances")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "Prevents curses from appearing for the rest of the run #Preventing a curse grants you {{ArrowUp}} +" .. tostring(CustomStatups.Damage.BLESS_OF_THE_DEAD) .. " damage up")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "Spawns 2 Toy Tanks that roam around the room and attack enemies that are in their line of sight #Green tank: rapidly shoots bullets at enemies from a further distance and moves more quickly #Red tank: shoots rockets at enemies at a close range, moves slower")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "Killing enemies grants you {{ArrowUp}} tears and speed up #The bonus is reset when entering a new room")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "+5 bombs #Grants explosion immunity #Allows you to throw your bombs instead of placing them on the ground")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "Grants you stat boosts for each familiar you own #Some familiars grant greater stat boosts, and some do not grant them at all (e.g. blue flies, dips or Isaac's body parts)")
	EID:addCollectible(CustomCollectibles.CAT_IN_A_BOX, "Enemies outside your line of sight (defined by your firing direction) are paralyzed, cannot attack you in any way and cannot be damaged")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "Removes a random item and spawns 3 items of the same quality #Only one item can be taken #Can't remove or spawn quest items")
	EID:addCollectible(CustomCollectibles.SCALPEL, "Makes you shoot tears in the opposite direction #From the front, you will frequently shoot bloody tears that deal x0.66 of your damage #All other weapon types will still be fired from the front as well")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "Spawns a golden penny upon entering a new floor #Shops will now sell 1-4 additional items that are drawn from shop, treasure or boss itempools #If the shop is a Greed fight, it instead spawns 3-4 items when the miniboss dies")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "Shooting or moving for 8 seconds will trigger a nerve pinch #{{ArrowDown}} You take fake damage and gain a permanent " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " speed down when that happens #{{ArrowUp}} However, there is a 75% chance to activate your active item for free, even if it's uncharged #One-time use and infinite use actives cannot be used that way")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "Taking damage doesn't actually hurt the player, instead filling the blood vessel #This can be repeated 6 times until the vessel is full #Once it's full, using it or taking damage will empty it and deal 3 and 3.5 hearts of damage to the player, respectively")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "Orbital that switches between 2 different states every 15 seconds: #Two orbitals that quickly rotate around Isaac #One orbital that rotates slower and closer to Isaac, and periodically shoots teeth in random directions and spawns blood creep underneath it #{{Warning}} All orbitals block enemy shots and do contact damage")
	EID:addCollectible(CustomCollectibles.RED_KING, "After defeating a boss, red crawlspace will appear in a middle of a room #Entering the crawlspace brings you to another bossfight of high difficulty #Victory rewards you two items from Ultra secret room pool to choose from")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "Summons the Stargazer beggar #Can only be charged with soul hearts, similar to Alabaster Box #2 soul hearts needed for full charge")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "Upon use, holds the bag in the air #For 4 seconds, all nearby projectiles are sucked into the bag #Hold the shooting button to release all sucked projecties as homing tears in the matching direction after 4 seconds")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "Enemies that come close to you become crippled; your tears can also cripple them #Crippled enemies lose their speed overtime, and die afer 12 seconds of losing it #When crippled enemies die, they release a fountain of slowing black tears")
	EID:addCollectible(CustomCollectibles.REJECTION, "On use, consume all your follower familiars and throw them as big piercing poisonous gut ball in your firing direction #Damage formula: your dmg * 4 * number of consumed familiars #Passively grants a familiar that doesn't shoot tears, but deals 2.5 contact damage to enemies")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "Spawns an item from the room's pool for sale #Its price will change rougly 5 times a second #The price is random, but generally increases over time until it reaches $99 #If you leave and re-enter the room, the item disappears")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "Chain yourself to a random enemy with an astral chain and freeze them #The chain deals heavy contact damage to enemies #Going too far away from chained enemy will break the chain #Chained enemies have a 33% chance to drop a soul heart when killed #Can chain bosses too for 5 seconds")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}} +0.3 Shot Speed up #Your tears are replaced with piercing feathers that deal more damage the more they travel #Double tap to perform one of Dogma related attacks #Has a 6 seconds cooldown")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "{{ArrowUp}} +0.2 Speed up #After your run ends, 3 random items from your inventory are spawned on the floor where it ended. They can be collected on the next run by getting to the same floor")
	EID:addCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, "Upon use, cripples all enemies in the room #Crippled enemies lose their speed overtime, and die afer 12 seconds of losing it #Requires a key to 'unlock' and use it, does nothing if used without keys #Has special synergies with key-related trinkets")
	EID:addCollectible(CustomCollectibles.FRIENDLY_SACK, "After each 3rd completed room, spawns a random weak familiar (such as Dip, Blood clot, fly etc.) #If boss room is a room where Friendly Sack would pay out, it spawns a random charmed monster instead")	
	EID:addCollectible(CustomCollectibles.MAGIC_MARKER, "Drops a random tarot card when picked up #On use, transform held tarot card by adding 1 to its number (or deducing 1 for reversed tarots)")
	EID:addCollectible(CustomCollectibles.ULTRA_FLESH_KID, "Familiar that chases enemies and deals contact damage, similar to Leech #Has 3 stages, collects red hearts to evolve #A total of 15 hearts needs to be collected to evolve")

	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "While held, every Golden Chest has a 15% chance to be replaced with Old Chest")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "While held, every enemy has a chance to drop Flesh Chest upon death #Flesh Chests contain hearts, pills and body-related items and trinkets")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "Enemies touching you become feared and targeted by other enemies (effect similar to Rotten Tomato)")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "Using coin, bomb or key on slots, beggars or locked chests has a 17% chance to not subtract it from your inventory count")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "Upon spawning, every coin has a 20% chance to be upgraded to a higher value: #penny -> doublepack pennies -> sticky nickel -> nickel -> dime -> lucky penny -> golden penny")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "Gives you one empty coin heart #It is depleted before any of your normal hearts and can only be refilled by directly picking up money")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "All new treasure rooms will have an angel item for sale instead of a normal item #Angels spawned from statues will not drop Key Pieces!")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "{{ArrowUp}} x2 DMG up while held #Breaks when you take damage #{{ArrowUp}} Having Duct Tape prevents it from breaking")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "Does nothing, it's broken")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "Upon taking damage, one of your items rerolls into another random item #Doesn't take away nor give you story items")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "When entering uncleared room, you will leave a trail of powder #Enemies walking on the powder will be significantly slowed down #The powder lasts for 10 seconds")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "Revives you as Eve when you die")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "75% chance to prevent a curse when entering a new floor")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "At the beginning of every new floor, grants:#{{ArrowUp}} +10% DMG up #{{ArrowUp}} Size increase #Both damage and size up stay if you drop the trinket")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "Amplifies or changes book's activation effects")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "Books now activate a random active item on use #Doesn't proc items that reroll, hurt or kill you")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "Reduces the size of all enemies by 10% #This affects both sprite and hitbox #Affects bosses too")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "8% chance to activate Dark Arts effect when taking damage")
	EID:addTrinket(CustomTrinkets.SHATTERED_STONE, "Chance to spawn random locust when collecting coins, bombs or keys #Chance increases with pickup's rarity")

	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "Invokes the effect of Spindown Dice")
	EID:addCard(CustomConsumables.RED_RUNE, "Damages all enemies in a room, turns item pedestals into red locusts and turns pickups into random locusts with a 50% chance")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "Removes one broken heart and grants one {{Heart}} heart container")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "Spawns 1-12 random {{Coin}} coins (those can be nickels or dimes as well)")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "Lose all your keys and spawn a proportional number of pickups #Can spawn an item or trinket with a certain chance that grows with the amount of keys and reaches 100% at 9 and 21 keys, respectively #Removes {{GoldenKey}}Golden key as well")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "Lose all your bombs and spawn a proportional number of pickups #Can spawn an item or trinket with a certain chance that grows with the amount of bombs and reaches 100% at 9 and 21 bombs, respectively #Removes {{GoldenBomb}}Golden bomb as well")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "Lose all your coins and spawn a proportional number of pickups #Can spawn an item or trinket with a certain chance that grows with the amount of bombs and reaches 100% at 18 and 42 bombs, respectively")
	EID:addCard(CustomConsumables.BAG_TISSUE, "All pickups in a room are destroyed, and 8 most valuables pickups form an item quality based on their total weight; the item of such quality is then spawned #The most valuable pickups are the rarest ones, e.g. {{EthernalHeart}}Eternal hearts or {{Battery}}Mega batteries #{{Warning}} If used in a room with less then 8 pickups, no item will spawn!")
	EID:addCard(CustomConsumables.JOKER_Q, "Teleports Isaac to a Black Market")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "Invokes the effect of Glowing Hourglass")
	EID:addCard(CustomConsumables.LOADED_DICE, "{{ArrowUp}} Grants +10 Luck for the current room")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "Spawns 1-12 random {{Key}} keys #There is a small chance to spawn a charged key")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "Spawns 1-12 random {{Bomb}} bombs #There is a chance to spawn a double-pack bomb")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "Bombs will drop more often after clearing rooms for the current floor, and the average quality of bombs is increased")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "Coins will drop more often after clearing rooms the for current floor, and the average quality of coins is increased")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "Keys will drop more often after clearing rooms for the current floor, and the average quality of keys is increased")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "Hearts will drop more often after clearing rooms for the current floor, and the average quality of hearts is increased")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "Damages all enemies in a room and turns every item pedestal into 3 Lemegeton wisps")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "Summons a friendly monster, like ones from Friend Finder")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "{{ArrowUp}} Gives +1.25 DMG up that depletes over the span of 20 seconds #Stackable #{{ArrowUp}} Heals you for one red heart if you have Ceremonial Robes #{{Warning}} Damage depletes quicker the more Blood you used subsequently")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "Activates a random book effect")
	EID:addCard(CustomConsumables.FLY_PAPER, "Grants 8 fly orbitals, similar to the Swarm item")
	EID:addCard(CustomConsumables.MOMS_ID , "Drops knives from above on all enemies, dealing 2x your damage")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES , "Spawns an Old Chest")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD , "Can be thrown similarly to Chaos Card #If the card touches an enemy, that enemy is erased for the rest of the run")
	EID:addCard(CustomConsumables.FIEND_FIRE, "Sacrifice your consumables for mass room destruction #3-20 total: enemies take 15 damage and burn for 4 seconds #20-40 total: the initital damage, the burning damage and burning duration are doubled; destroys obstacles around you #40+ total: the burning damage and burning duration are quadrupled; produces a Mama Mega explosion")
	EID:addCard(CustomConsumables.DEMON_FORM, "{{ArrowUp}} +0.2 damage for every new uncleared room you enter #+1 damage for entering a boss room #The boost disappears when entering a new floor")
	EID:addCard(CustomConsumables.VALENTINES_CARD, "Can be thrown similarly to Chaos Card #Permanently charms all enemies that it passes through and drops a full red heart on use")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "Spawns two ghostly orbital familiars that block enemy shots and shoot spectral tears #After blocking 3 shots, each ghost dies and drops half a soul heart")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "Your active item moves to the pocket slot #If you've already had pocket active, it drops on a pedestal")

	EID:addPill(CustomPills.ESTROGEN, "Turns all your red health into blood clots #Leaves you at one red heart other types of hearts are unaffected")
	EID:addPill(CustomPills.LAXATIVE, "Makes you shoot out corn tears from behind for 3 seconds")
	EID:addPill(CustomPills.PHANTOM_PAINS, "Makes Isaac take fake damage on pill use, then 15 and 30 seconds after")
	EID:addPill(CustomPills.YUCK, "Spawns a rotten heart #For 30 seconds, every red heart will spawn blue flies when picked up")
	EID:addPill(CustomPills.YUM, "Spawns 2-5 half red hearts #For 30 seconds, every red heart will grant you small permanent stat upgrades when picked up")

	EID:assignTransformation("collectible", CustomCollectibles.MARK_OF_CAIN, "9")
	EID:assignTransformation("collectible", CustomCollectibles.CHERUBIM, "4,10")
	EID:assignTransformation("collectible", CustomCollectibles.BOOK_OF_GENESIS, "12")
	EID:assignTransformation("collectible", CustomCollectibles.CROSS_OF_CHAOS, "9")
	EID:assignTransformation("collectible", CustomCollectibles.BOOK_OF_LEVIATHAN, "9, 12")
end

--EID Spanish
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}} {{Tears}} Más lágrimas #Genera un objeto relacionado a Mamá o Papá en la {{TreasureRoom}} Sala del tesoro junto al objeto regular; sólo puedes tomar uno", "Vida ordinaria", "spa")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "Te otorga un {{Heart}} un contenedor de corazón y un corazón roto#{{Warning}} ¡Tener 12 corazones te matará!", "Cortador de Galletas", "spa")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "{{ArrowUp}} +2 de daño, multiplicador de daño x1.5#{{ArrowDown}} baja la velocidad de tiro#lágrimas teledirigidas", "Corazón de los Pecadores", "spa")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "Tras cada uso, hay un 5% (100% en el uso 20) de probabilidad de 'resolverlo', cuando esto ocurre, se le remueve al jugador y es reemplazado con un Cubo Mágico", "Cubo de Rubik", "spa")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "{{DiceRoom}} Rerolea los pedestales de objetos #Los items reroleados se toman de cualquier pool", "Cubo Mágico", "spa")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "Las lágrimas dejan {{ColorRainbow}}{{CR}} creep arcoíris bajo ellas #Efectos de estado permantenes se aplican a los enemigos que caminen por el creep", "Pluma Mágica", "spa")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "Te otorgará un Bebé Enoch#Si mueres, y tienes más familiares a parte de Enoch, estos serán removidos a cambio de revivir; el bebé Enoch será más poderoso; otorga frames de invencibilidad y conservarás tus corazones #{{Warning}} Sólo funciona una vez", "La Marca de Caín", "spa")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "Al recibir daño, Hay un 25% de probabiliad de entrar al modo Berserk #Mientras el modo esté activo, Cada enemigo dañado tiene un 10% de ser eliminado de la partida", "Temper Tantrum", "spa")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "Un familiar que genera moscas azules al limpiar una habitación #Puede bloquear disparos, al recibir un golpe tiene la posibilidad de romperse y otorgar {{Collectible25}}Desayuno o el trinket La Tierra de la Noch #Mientras más pisos pases sin romperlo, más moscas generará", "Bolsa de Basura", "spa")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "Un familiar que lanza lágrimas de {{Collectible331}} Cabeza de Dios a una cadencia de tiro alta", "Bebé Zen", "spa")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "Matar a un enemigo otorga un 20% de posibilidad de soltar un familiar cereza en el suelo #Estas cerezas emiten un pedo con efecto encantador cuando un enemigo camina sobre ellos, sueltan medio corazón al limpiar la habitación", "Amigos de Cereza", "spa")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "Al entrar en una nueva habitación, Los enemigos serán divididos en pares. Dañar a un enemigo de un par, provocará la mitad del daño hecho en la otra mitad del par", "Muñeco Negro", "spa")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "Al morir, revivirás como un fantasma invencible y un pájaro azul saldrá del centro de la habitación a una dirección aleatoria. Atrapar al pájaro en menos de 5 segundos te salvará y regreserás al punto donde moriste, de otra forma, morirás #{{Warning}} Cada vez que mueres, el pájaro volará con mayor velocidad, volviéndolo más difícil de atrapar", "Un Pájaro de la Esperanza", "spa")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "Presionar dos veces el botón de disparo hará que lances un fantasma en esa dirección#El fantasma se pegará con el primer enemigo con el que choque, dañándolo por 7 segundos o hasta que el enemigo muera #El fantasma también afecta a los jefes #{{Warning}}Tiene un cooldown de 7 segundos", "Alma Iracunda", "spa")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "{{ArrowDown}}Multiplicador de daño de x0.85 #Al disparar, hay un 5% de probabilidad de lanzar una daga que no hiere a los enemigos, pero los hace sangrar#Todo enemigo que muera desangrado soltará el consumible Sangre de Sacrificio, el cual otorgará un {{ArrowUp}}aumento de daño", "Daga Ceremonial", "spa")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "Otorga dos flamas de {{Collectible712}} Lemegeton por cada piso avanzado y cama a la que se va a dormir", "Móvil de estrellas", "spa")
	EID:addCollectible(CustomCollectibles.QUASAR, "Consume todos los objetos en pedestal y otorga 3 flamas de {{Collectible712}}Lemegeton", "Quasar", "spa")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "Cada tercer objeto comprado en la tienda del piso actual costará 1 {{Coin}} penny #Comprar 2 objetos con corazones en una habitación hará que los demás se vuelvan gratuitos", "2+1", "spa")
	EID:addCollectible(CustomCollectibles.RED_MAP, "Revela la ubicación de la Sala Ultra Secreta en los siguientes pisos#Cualquier trinket que se deje en una {{TreasureRoom}}sala del tesoro o {{BossRoom}}sala del jefe dejará una Cracked Key", "Mapa Rojo", "spa")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "Remueve un contenedor de corazón rojo y otorga {{ArrowUp}} +0.5 de daño y 2 mini Isaacs", "Rayador de Queso", "spa")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "Ahora las píldoras reciben efectos adicionales en base a su color", "Redactor de ADN", "spa")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "Destruye los obstáculos de la habitación y aplica confusión a los enemigos cercanos #Destroza las puertas y abre la entrada a Salas Secretas", "La Torre de Babel", "spa")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "Previene las maldiciones durante toda la partida #Si se previene una maldición recibes {{ArrowUp}} +0.5 de daño", "Bendición de los muertos", "spa")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "Genera 2 tanques de juguete que rondan por la habitación y atacan a los enemigos dentro de su linea de visión #Tanque verde: Dispara balas rápidamente a los enemigos a gran distancia y es de movimiento rápido #Tanque rojo: Dispara cohetes a corto rango, de movimiento lento", "Tanquesitos", "spa")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "Matar a los enemigos te da {{ArrowUp}} más lágrimas y velocidad #Se resetea al entrar a una nueva habitación", "Sangre Tempestuosa", "spa")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "+5 bombas #Ganas inmunidad a explosiones #Ahora puedes arrojar las bombas en vez de simplemente ponerlas en el suelo", "Bombardero Rojo", "spa")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "Otorga aumentos de estadísticas en base a tus familiares#Algunos darán buenos aumentos, y otros no los darán del todo (p.e. Moscas azules, dips o partes del cuerpo de Isaac)", "Amor Maternal", "spa")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "Retira un objeto aleatorio y genera 3 objetos de la misma calidad#Sólo puedes tomar uno#No remueve o genera objetos relacionados a la historia", "Libro del Génesis", "spa")
	EID:addCollectible(CustomCollectibles.SCALPEL, "Ahora disparas en la dirección opuesta#De lado frontal, dispararás rápidamente unas lágrimas sangrientas que hacen tu daño x0.66#Otro tipo de ataques serán disparados regularmente", "Un bisturí", "spa")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "Genera una moneda dorada al entrar a un nuevo piso#Las tiendas ahora venden 1-4 objetos adicionales tomados de la tienda, sala del tesoro o sala del jefe", "El centavo de Keeper", "spa")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "Disparar o moverse en una dirección durante 5 segundos generará un pincho nervioso#{{ArrowDown}} Tomas daño falso y recibes " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " de velocidad permanente cuando ocurre#{{ArrowUp}} Sin embatgo, hay un 75% de posibilidad de usar tu activo gratis, Incluso si no está cargado#Objetos de un solo uso y de cargas infinitas no pueden usarse de esta forma", "Pincho nervioso", "spa")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "Tomar daño no herirá al jugador, en vez de eso se llenará un contenedor de sangre#Puede ser repeetido hasta 6 veces, cuando este se llenará#Cuando esté lleno, usarlo o recibir daño lo vaciará y se provocará 3 corazones de daño al jugador", "Contenedor de sangre", "spa")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "Un orbital que cambia en 2 distintos estados cada 15 segundos:#Dos orbitales que giran rápidamente alrededor de Isaac #Un orbital que gira más lento y cerca de Isaac, dispara dientes y suelta creep rojo bajo el #{{Warning}} Ambas fases bloquean proyectiles y hacen daño por contacto", "Rivalidad entre hermanos", "spa")
	EID:addCollectible(CustomCollectibles.RED_KING, "Después de derrotar al jefe, aparecerá un pasadizo rojo#Entrar a este pasadizo rojo iniciará otra batalla de jefe con alta dificultad#Si ganas, recibirás un objeto rojo (de la pool de la Sala Ultra Secreta)", "Rey Rojo", "spa")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "Invoca al mendigo observador estelar#{{SoulHeart}} Sólo puede ser recargado con corazones de alma#Se necesita 2 corazones de alma para cargarlo completamente", "Sombrero del observador estelar", "spa")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "Tras usarlo, Sostendrás la bolsa en el aire#Durante 4 segundos, todos los proyectiles cercanos serán succionados por la bolsa#Mantener pulsado el botón de disparo los lanzará como disparos teledirigidos en la dirección apuntadadespués de 4 segundos", "Bolso sin fondo", "spa")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "Los enemigos que se te acerquen serán lisiados; tus lágrimas poseen el mismo efecto#Los enemigos lisiados perderán su velocidad progesivamente, acabarán muriendo 16 segundos después de perderla#Cuando un enemigo lisiado muere, Lanzarán una fuente de lágrimas negras ralentizadoras", "Cruz del Cáos", "spa")
	EID:addCollectible(CustomCollectibles.REJECTION, "Al usarlo, consumirá a todos tus familiares y los lanzará en una gran bola de tripas disparada hacia donde apuntes#Formula de daño: {{Damage}} Daño * 4 * Número de familiares consumidos#A cambio, otorga un familiar que no puede disparar, pero provoca 2.5 puntos de daño por contacto a los enemigos", "Rechazo", "spa")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "Generará un objeto de la pool en la que estés disponible para la venta#Su precio cambiará cerca de 5 veces por segundo#El precio es aleatorio, pero generalmente aumentará hasta llegar a $99 #Si sales y entras de la habitación, el objeto desaparecerá", "Mazo de subastas", "spa")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "Usando una cadena astral, serás encadenado a un enemigo y este se congelará#La cadena hace demasiado daño por contaco a los enemigos#Alejarse demasiado de un enemigo encadenado romperá la cadena#{{SoulHeart}} Los enemigos encadenados tienen un 33% de posibilidad de soltar un corazón de alma al morir", "Lazo del alma", "spa")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}} {{Shotspeed}} Vel. de tiro +0.3#Tus lágrimas serán reemplazadas por plumas penetrantes, harán más daño mientras más viajenthat deal more damage#Presionar el botón de disparo 2 veces realizará un ataque similar al de Dogma#Tiene un tiempo de recarga de 6 segundos", "Alas de Ángel", "spa")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "{{ArrowUp}} {{Speed}} Velocidad +0.2#Al terminar la partida, 3 objetos aleatorios del inventario serán generados en el piso donde terminó. Podrán ser tomados en la siguiente partida yendo hacia ese mismo piso", "Herencia", "spa")
	EID:addCollectible(CustomCollectibles.BOOK_OF_LEVIATHAN, "Al usarlo, todos los enemigos serán lisiados#Los enemigos lisiados perderán su velocidad progesivamente, acabarán muriendo 12 segundos después de perderla#Necesita una llave para 'desbloquearlo' y usarlo, no hace nada sin llaves#Posee sinergias especiales con trinkets relativos a llaver", "El libro de Leviatán", "spa")
	EID:addCollectible(CustomCollectibles.FRIENDLY_SACK, "Después de cada 3 habitaciones completadas, se generará un familiar debil (como un Dip, Blood clot, moscas, etc.)#Si esl efecto del Saco amistoso se activa en una {{BossRoom}} sala del jefe, aparecerá un monstruo encantado en su lugar", "Saco amistoso", "spa")

	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "{{ChestRoom}} Al tenerlo, cada Cofre Dorado tiene un 15% de probabilidad de convertirse en un Cofre Viejo", "Llave del Sótano", "spa")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "Al tenerlo, cada enemigo tiene una posibilidad de soltar un Cofre Escarlata al morir#Los Cofres Escarlata contienen: 1-4 {{Heart}} corazones/{{Pill}} píldoras O un objeto aleatorio relativo al cuerpo", "Llave al Corazón", "spa")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "Los enemigos que te toquen serán marcados y atacados por otros enemigos (Efecto similar al de {{Collectible618}} Tomate Podrido", "Beso de Judas", "spa")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "Usar una moneda, llave o bomba en una máquina, un mendigo o un cofre cerrado tendrá un 17% de probabilidad de no restarlo de tu ivnentario", "Moneda Truculenta", "spa")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "Al momento de generarse, cada moneda tiene un 20% de posibilidad de recibir una mejora: #penny -> penny doble -> nickel pegajoso -> nickel -> décimo -> penny de la suerte -> penny dorado", "Juego de Manos", "spa")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "Te otorga una Moneda corazón vacía #Esta se vacía antes que tus corazones regulares, se rellena consiguiendo dinero", "Corazón de la Codicia", "spa")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "Toda nueva sala del ángel tendrá un objeto de la pool del ángel a la venta en vez de un objeto de la pool del tesoro#Los ángeles de las estatuas no generarán {{Collectible238}}{{Collectible239}}Piezas de Llave", "Corona de Ángel", "spa")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "{{ArrowUp}} x2 de daño al sostenerlo#Se rompe al recibir daño#{{ArrowUp}}Tener Cinta Adhesiva evitará que se rompa", "Espada Mágica", "spa")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "No hace nada, está rota", "Espera... ¡NO!", "spa")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "Al recibir daño, uno de tus objetos será reroleado a otro objeto aleatorio #No quita ni otorga objetos relativos a la historia", "Mechón de Eden", "spa")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "Al entrar a una sala nueva, dejarás un rastro de talco bajo tuyo durante 5 segundos#Los enemigos que intenten caminar por el rastro serán repelidos", "Pedazo de Tiza", "spa")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "Revives como Eve al morir", "Costilla de Adan", "spa")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "40% de posibilidad de prevenir una maldición al pasar a un nuevo piso", "La Tierra de la Noche", "spa")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "{{ArrowUp}} Aumenta el daño y el tamaño por piso al tener la baratija", "Harina de huesos", "spa")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "Los libros tienen efectos adicionales al usarlos", "Pagina destrozada", "spa")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "Los libros activan un efecto aleatorio al usarlo #No funciona con How to Jump# no activa efectos de dado u objetos que te dañen #{{ArrowUp}} 33% de posibilidad de aparecer en bibliotecas", "Página vacía", "spa")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "{{ArrowDown}} -20% al tamaño de los enemigos#Afecta también a los jefes#{{Warning}} Se reduce tanto el tamaño como la hitbox", "Zapatitos de bebé", "spa")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "5% de posibilidad de activar el efecto de {{Collectible705}} Artes Oscuras al recibir daño Dark Arts#Aumenta la posibilidad de aparición de cofres negros en las {{DevilRoom}} Salas del diablo", "Llave cuchillo", "spa")

	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "Efecto de {{Collectible723}} Spindown Dice de un solo uso", "Fragmento de Spindown Dice", "spa")
	EID:addCard(CustomConsumables.RED_RUNE, "Daña a todos los enemigos de una habitación, los objetos en pedestales se convierten en langostas rojas y los consumibles tienen 50% de probabilidad de convertirse en una langosta roja", "Runa Roja", "spa")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "Remueve un Corazón Roto y otorga un {{Heart}} Contenedor de Corazón", "Aguja e Hilo", "spa")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "Genera 1-12 {{Coin}} monedas aleatorias (pueden ser tanto nickels como décimos)", "Reina de Diamantes", "spa")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "Pierdes todas tus llaves y se genera un número proporcional a la cantidad perdida en recolectables #Se necesitan al menos 12 {{Key}} llaves para generar un trinket y al menos 28 para un objeto#Si Isaac tiene una {{GoldenKey}} Llave Dorada, Será removida y aumentará el valor de la recompensa significativamente", "Rey de Espadas", "spa")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "Pierdes todas tus bombas y se genera un número proporcional a la cantidad perdida en recolectables#Se necesitan al menos 12 {{Bomb}} bombas para generar un trinket y al menos 28 para un objeto#Si Isaac tiene una {{GoldenBomb}} Bomba Dorada, Será removida y aumentará el valor de la recompensa significativamente", "Rey de Tréboles", "spa")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "Pierdes todas tus monedas y se genera un número proporcional a la cantidad perdida en recolectables#Se necesitan al menos 12 {{Coin}} monedas para generar un trinket y al menos 28 para un objeto", "Rey de Diamantes", "spa")
	EID:addCard(CustomConsumables.BAG_TISSUE, "Destruye todos los recolectables, y los ocho recolectables de mayor valor generarán un objeto con una calidad basada en el valor de los recolectables#Los recolectables con mayor valor son los más raros, por ejemplo:{{EthernalHeart}} Corazones Eternos o {{Battery}} Mega Baterías#{{Warning}} Si se usa en una habitación sin recolectables, no generará nada", "Bolsa de tela", "spa")
	EID:addCard(CustomConsumables.JOKER_Q, "Teletransporta a Isaac a un {{SuperSecretRoom}} Mercado Negro", "Joker?", "spa")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "Activa el efecto de {{Collectible422}} Reloj de arena brillante", "¿Comodín?", "spa")
	EID:addCard(CustomConsumables.LOADED_DICE, "{{ArrowUp}} +10 de suerte durante una habitación", "Dado Cargado", "spa")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "Genera 1-12 {{Key}} llaves#Hay una posibilidad de generar una Llave Cargada", "Reina de Espadas", "spa")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "Genera 1-12 {{Bomb}} bombas#Hay una posibilidad de generar una bomba doble", "Reina de Tréboles", "spa")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "Se generarán más bombas al limpiar habitaciones, la calidad general de las bombas aumenta", "Jota de Tréboles", "spa")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "Se generarán más monedas al limpiar habitaciones, la calidad general de las monedas aumenta", "Jota de Diamantes", "spa")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "Se generarán más llaves al limpiar habitaciones, la calidad general de las llaves aumenta", "Jota de Espadas", "spa")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "Se generarán más corazones al limpiar habitaciones, la calidad general de los corazones aumenta", "Jota de Corazones", "spa")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "Dañaa todos los enemigos de la habitación, convierte cada pedestal de objeto en 3 flamas de {{Collectible712}} Lemegeton", "Fragmento de Quasar", "spa")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "Invoca un enemigo aliado aleatorio, al igual que {{Collectible687}} Buscador de Amigos", "Carta de Negocios", "spa")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "{{ArrowUp}} +1 de daño que decrementa tras 25 segundos#Acumulable#{{ArrowUp}} Cura un corazón rojo si tienes {{Collectible216}} Batas Ceremoniales#{{Warning}} El daño disminuirá más rápido mientras más sangre uses", "Sangre de Sacrificio", "spa")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "Activa un efecto aleatorio de un Libro", "Carta de Biblioteca", "spa")
	EID:addCard(CustomConsumables.FLY_PAPER, "Genera 8 moscas de {{Collectible693}} El Enjambre", "Trampa para Moscas", "spa")
	EID:addCard(CustomConsumables.MOMS_ID, "Encanta a todos los enemigos de la habitación", "Identificación de Mamá", "spa")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES, "Genera un Cofre Viejo", "Servicios de Funeraria", "spa")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD, "Se lanza igual que una Carta del caos#Si la carta toca a un enemigo, este es eliminado por el resto de la partida", "Carta Antimaterial", "spa")
	EID:addCard(CustomConsumables.FIEND_FIRE, "Elimina tus recolectables para provocar daño en masa #10-50 en total: Los enemigos toman 15 de daño y se queman por 4 segundos#51-125 total: El daño inicial, el daño de quemadura y duración de la misma se duplican; Destruye obstáculos cerca tuyo#126-150 total: El daño y duración de quemaduras se cuadriplica; produce una explosión de Mamá Mega", "Fuego del demonio", "spa")
	EID:addCard(CustomConsumables.DEMON_FORM, "{{ArrowUp}} +0.15 de daño por cada sala nueva a la que entres#El efecto desaparece al entrar a un nuevo piso", "Forma demoniaca", "spa")
	EID:addCard(CustomConsumables.VALENTINES_CARD , "Se lanza de forma parecida a una Carta del Cáos#Si la carta golpea a un enemigo, este se volverá amigable y se generará un corazón rojo en el piso", "Carta de San Valentín", "spa")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "Genera 2 familiares orbitales fantasma que bloquean disparos enemigos y disparan lágrimas espectrales#{{HalfSoulHeart}} Tras bloquear 3 disparos, los fantasmas soltarán medio corazón de alma", "Reserva Espiritual", "spa")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "Tu objeto activo será movido hacia los activos de bolsillo#En caso de que ya tengas un activo de bolsillo, lo soltarás en un pedestal", "Paisaje Reflejado", "spa")

	EID:addPill(CustomPills.ESTROGEN, "Convierte todos tus {{Heart}}corazones en Coágulos#Te deja con al menos un corazón rojo, No afecta Corazones de Alma/Corazones Negros", "Estrógeno", "spa")
	EID:addPill(CustomPills.LAXATIVE, "Hace que dispares los maíces de {{Collectible680}}Venganza de Montezuma durante 3 segundos", "Laxante", "spa")
	EID:addPill(CustomPills.PHANTOM_PAINS, "Provoca que Isaac reciba daño falso al usarse, luego a los 20 y 40 segundos de haberla consumido", "Fantasma", "spa")
	EID:addPill(CustomPills.YUCK, "Genera un corazón podrido #Por 30 segundos, cada corazón rojo tomado generará moscas azules", "Puaj", "spa")
	EID:addPill(CustomPills.YUM, "Genera un corazón rojo #Por, cada corazón rojo que consigas te dará un pequeño aumento permantente de estadísticas, Igual al efecto de {{Collectible671}} Corazón de Caramelo", "Mmm~", "spa")
end

-- EID Russian
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}} Повышает скорострельность #Создает дополнительный предмет, связанный с матерью/отцом, в сокровищницах; можно взять только один предмет", "Обычная Жизнь", "ru")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "При использовании дает один {{Heart}} контейнер сердца и одно сломанное сердце #{{Warning}} При 12 сломанных сердец вы умрете!", "Формочка для Печенья", "ru")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "+2 черных сердца #{{ArrowUp}} Дает +2 к урону и умножает на 1.5 #{{ArrowUp}} Дает +2 к дальности и -0.2 к скорости слезы #Дает спектральные и пронзающие слезы", "Сердце Грешника", "ru")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "После каждого использования, имеет 5%(100% на 20-ом использовании) шанс стать 'собранным', забирает у игрока этот предмет и заменяет его Магическим Кубом", "Кубик Рубика", "ru")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "{{DiceRoom}} Меняет предметы в комнате #Замененные предметы могут быть из любого пула предметов", "Магический Куб", "ru")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "При двойном нажатие кнопки стрельбы создает на полу полосу {{ColorRainbow}}радужной{{CR}} лужи в направлении стрельбы #Лужа накладывает случайные статусные эффекты врагам при соприкосновении#{{Warning}} Имеет 4 секунды перезарядки", "Магическая Ручка", "ru")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "Дарует вам спутника Еноха #Когда вы умираете, если у вас есть какие-либо спутники, кроме Еноха, воскрешает вас и уничтожает их вместо этого; Енох становится сильнее; дает вам кадры неуязвимости и сохраняет все ваши красные контейнеры #{{Warning}} Работает только один раз", "Метка Каина", "ru")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "При получении урона, есть 25% шанс войти в режим Берсерка #В этом состоянии, любой пораженный враг имеет 10% шанс стать стертым до конца забега", "Приступ Ярости", "ru")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "Спутник призывающий мух при зачистке комнат #Блокирует вражеские выстрелы, при блокировании имеет небольшой шанс быть уничтоженным и создать предмет Завтрак или брелок Ночное Золото #Чем больше этажей этот спутник выживает, тем больше мух он призывает", "Мешок для Мусора", "ru")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "Спутник, быстро стреляющий слезами с аурой {{Collectible331}} Головы Бога", "Херувим", "ru")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "При убийстве врага есть 20% шанс призвать на его месте спутника вишенку #Вишенки испускают очаровывающий пук при соприкосновении с врагами, и создает половинку красного сердца после зачистки комнаты", "Вишенки", "ru")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "При посещении комнаты, все враги будут разделены на пары. Нанося урон врагу, также наносит половину урона другому врагу в этой паре", "Черная Кукла", "ru")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "При смерти персонаж превращается в неуязвимого призрака, и птица вылетает из центра комнаты в случайном направление. При поимке птицы вы воскрешаетесь и возвращаетесь на место своей смерти, если вы не успеваете поймать птицу вы умираете. Ужасной смертью #{{Warning}} За каждую вашу смерть, птица становится быстрее, затрудняя ее поймать", "Птичка Надежды", "ru")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "При двойном нажатии кнопки стрельбы запускает призрака в направление стрельбы #Призрак прилипнет ко врагу нанося урон на протяжении 7 секунд или до тех пор пока этот враг умрет#Призрак наносит 7 урона и повышается каждый этаж #Также Призрак может прилипать к боссам #{{Warning}} Призрак имеет 7 секунд перезарядки", "Разъяренная Душа", "ru")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "При стрельбе есть 7%  шанс запустить кинжал, который не наносит урона, но накладывает кровотечение на врагов #Враги которые умерли пока кровоточили оставят за собой Жертвенную Кровь, которая дает временную прибавку к урону", "Церемониальный Кинжал", "ru")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "Дает 2 огонька {{Collectible712}} Лемегетона в начале каждого этажа и когда вы спите в кровати ", "Потолок со Звездами", "ru")
	EID:addCollectible(CustomCollectibles.QUASAR, "Поглощает все предметы на пьедесталах в комнате и дает 3 огонька {{Collectible712}} Лемегетона за каждый поглощенный предмет", "Квазар", "ru")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "Каждый третий купленный предмет будет стоить 1 {{Coin}} пенни #Покупка двух предметов сердцами сделает все остальные предметы бесплатными", "2+1", "ru")
	EID:addCollectible(CustomCollectibles.RED_MAP, "Показывает местоположение Ультра Секретной Комнаты на последующих этажах #Любой брелок оставленный в комнате босса или сокровищнице превратиться в Треснутый Ключ", "Красная Карта", "ru")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "Забирает один контейнер сердца и дает {{ArrowUp}} +0.5 к урону и создает 3 мини Айзека", "Терка для Сыра", "ru")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "Пилюли дают дополнительный эффект в зависимости от их цвета", "Редактор ДНК", "ru")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "Уничтожает все препятствия в этой комнате и накладывает на врагов в маленьком радиусе замешательство #Также подрывает двери и проход в секретную комнату", "Вавилонская Башня", "ru")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "Предотвращает проклятья до конца забега #Предотвращение проклятья дает вам {{ArrowUp}} +" .. tostring(CustomStatups.Damage.BLESS_OF_THE_DEAD) .. " к урону", "Благословение Мертвых", "ru")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "Призывает двух спутников Танкистов, которые катаются по комнате и атакуют врагов находящиеся в их поле зрения #Зеленый танк: быстро стреляет по врагам на далекой дистанции и двигается быстро #Красный танк: стреляет ракетами по врагам на маленькой дистанции и двигается медленно", "Танкисты", "ru")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "Убийство врагов дает {{ArrowUp}} повышение к скорострельности и к скорости #Бонус пропадает при выходе из комнаты", "Бурная Кровь", "ru")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "+5 бомб #Дает иммунитет к взрывам #Позволяет вам бросать бомбы", "Красный Бомбардировщик", "ru")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "Дает повышение к случайной характеристике за каждого спутника", "Мамина Любовь", "ru")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "Удаляет ваш случайный предмет и создает три предмета того же качества #Только один предмет можно взять", "Книга Бытия", "ru")
	EID:addCollectible(CustomCollectibles.SCALPEL, "Вы будете стрелять слезами в противоположном направлении #Спереди вы быстро будете стрелять кровавыми слезами, которые наносят х0,66 вашего урона #Все остальные типы оружия также будут выпущены спереди", "Скальпель", "ru")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "Создает золотую монетку при переходе на новый этаж #Магазины теперь будут продавать 1-4 дополнительных предмета, взятых из пула магазина, сокровищницы или комнаты босса #Если в магазине будет битва с Алчностью, создает 3-4 предмета, когда мини-босс умирает", "Монетка Хранителя", "ru")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "При стрельбе или ходьбе в течение 8 секунд  #{{ArrowDown}} Вы получаете фальшивый урон и " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " к скорости #{{ArrowUp}} C 75% шансом активирует ваш активный предмет, даже если он не заряжен #Одноразовое", "Защемление Нерва", "ru")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "Получение урона не причиняет вреда игроку, вместо этого заполняет сосуд #Это можно повторить 6 раз, пока сосуд не заполнится #Как только он заполнится, его использование или получение урона опустошит его и нанесет игроку 3 и 3,5 сердца урона соответственно.", "Кровавый Сосуд", "ru")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "Орбитал который переключается между двумя состояниями: #Два орбитала которые кружатся около игрока #Орбитал который кружится медленее, и случайно стреляет зубами в случайных направлениях и создает кровавые лужи под ними #{{Warning}} Все орбиталы блокируют снаряды и наносят контактный урон", "Соперничество", "ru")
	EID:addCollectible(CustomCollectibles.RED_KING, "После победы над боссом в середине комнаты появится красный люк #Люк приведет вас к другому бою с боссом высокой сложности #Победа вознаграждает вас красным предметом", "Красный Король", "ru")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "Создает попрошайку Астронома #Предмет заряжается только синими сердцами #2 сердца нужна для полного заряда", "Шапка Астронома", "ru")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "В течение 4 секунд все ближащие снаряды всасываются в мешок #Удерживайте кнопку стрельбы, чтобы выпустить все всосанные снаряды в соответствующем направлении #Снаряды становятся самонаводящимися", "Бездонный Мешок", "ru")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "Враги, которые приближаются к вам, становятся ослабленными; ваши слезы также могут ослабить их #Ослабленные враги теряют свою скорость со временем и умирают через 16 секунд после ее потери #Когда ослабленные враги умирают, они выпускают фонтан замедляющихся черных слез", "Крест Хаоса", "ru")
	EID:addCollectible(CustomCollectibles.REJECTION, "При использовании уничтожает всех спутников на одну комнату и бросает их в виде большого пронзающего ядовитого шара в направлении вашей стрельбы #Формула урона: ваш урон * 4 *количество спутников #Пассивно дает фамильяра, который не стреляет слезами, но наносит 2,5 контактного урона врагам.", "Отторжение", "ru")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "Создает предмет из пула комнаты который можно купить # Его цена будет меняться случайно 5 раз в секунду #Цена меняется случайно, но в целом увеличивается, пока не достигнет 99 монет #Если вы выйдете из комнаты, предмет исчезнет", "Молоток для Аукциона", "ru")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "Приковывайте себя к случайному врагу астральной цепью и замораживайте их # Цепь наносит сильный контактный урон врагам # Если вы отойдете слишком далеко от прикованного врага, цепь разорвется #Прикованные враги имеют 33% шанс уронить синие сердце при смерти", "Связь Душ", "ru")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}} +0,3 к скорости выстрела  #Ваши слезы заменяются пронзающими перьями, которые наносят больше урона, чем больше они пролетают # Двойное нажатие на кнопку выстрела, чтобы использовать одну из атак Догмы #Имеет 6 секунд перезарядки", "Ангельские Крылья", "ru")

	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "{{ChestRoom}} Золотые Сундуки имеют 12.5% шанс стать Старым Сундуком", "Ключ от Подвала", "ru")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "У каждого врага есть шанс создать Кожанный Сундук после смерти #Кожанные Сундуки могут содержать 1-4 {{Heart}} сердца/{{Pill}} таблетки или случайный предмет, связанный с телом", "Ключ к Сердцу", "ru")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "Враги, прикасающиеся к вам, будут атакованы другими врагами (похожий на эффект {{Collectible618}} Тухлого Помидора)", "Поцелуй Иуды", "ru")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "Трата монет, бомб или ключей на автоматы, попрошаек или запертые сундуки имеет 17 % шанс не вычесть их из вашего инвентаря", "Трюк с Монеткой", "ru")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "После появления каждая монета имеет 20% шанс быть повышена до более высокой стоимости: #пенни->двойной пенни->липкий никель->никель-> десятник->счастливый пенни->золотой пенни", "Ловкость Рук", "ru")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "Дает вам один пустой контейнер монет #Оно тратится раньше, чем обычные сердца, и может быть пополнено только путем прямого подбирания монеток", "Сердце Жадности", "ru")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "Во всех новых Сокровищницах будет продаваться предмет ангела вместо обычного предмета #Ангелы не оставят части ключа при битве!", "Ангельская Корона", "ru")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "{{ArrowUp}} Удваивает ваш урон #Ломается, когда вы получаете урон #{{ArrowUp}} Наличие Клейкой Ленты предотвращает поломку", "Магический Меч", "ru")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "Ничего не делает", "О Нет!", "ru")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "При получении урона один из ваших предметов меняется на другой случайный предмет", "Локон Эдема", "ru")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "При входе в комнату вы оставляете под собой след из порошка в течение 5 секунд #Враги, проходящие по порошку, будут отброшены назад", "Кусок Мела", "ru")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "При смерти, воскрешает вас за Еву", "Ребро Адама", "ru")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "75% шанс предотвратить проклятия при входе на новый этаж", "Ночное Золото", "ru")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "В начале каждого этажа дает: #{{ArrowUp}} +10% Урона #{{ArrowUp}} Увеличение размера игрока #Урон и размер сохраняются если вы выбросите этот брелок", "Костная Мука", "ru")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "Усиливает эффекты книг #Этот брелок может появится в библиотеках с шансом 33%", "Порванная Страница", "ru")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "Книги активируют случайный активный предмет при использовании  #Этот брелок может появится в библиотеках с шансом 33%", "Пустая Страница", "ru")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "Уменьшает врагов на 20% #Также работает на боссах", "Детские Ботиночки", "ru")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "С шансом 5% активирует Темные Искусства когда вы получаете урон #Увеличивает шанс пояяления Черных Сундуков", "Нож Ключ", "ru")

	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "Активирует эффект {{Collectible723}} Кубика с Вычетом", "Осколок Кубика с Вычетом", "ru")
	EID:addCard(CustomConsumables.RED_RUNE, "Наносит урон всем врагам в комнате, превращает все пьедесталы с предметами в красную саранчу и превращает пикапы в случайную саранчу с вероятностью 50%", "Красная Руна", "ru")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "Убирает одно Сломанное Сердце и дает один {{Heart}} Контейнер Сердца", "Игла и Нитка", "ru")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "Создает 1-12 {{Coin}} случайных монет", "Дама Бубен", "ru")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "Вы теряете все свои ключи и создаете количество пикапов, пропорциональное количеству потерянных ключей #Для брелка требуется не менее 9 {{Key}} ключей и не менее 21 для предмета #Если у вас есть {{GoldenKey}} Золотой Ключ, он тоже удаляется и значительно увеличивает количество пикапов", "Король Пик", "ru")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "Вы теряете все свои бомбы и создаете количество пикапов, пропорциональное количеству потерянных бомб #Для брелка требуется не менее 9 {{Bomb}} бомб и не менее 21 для предмета #Если у вас есть {{GoldenBomb}} Золотая Бомба, он тоже удаляется и значительно увеличивает количество пикапов", "Король Треф", "ru")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "Вы теряете все свои монеты и создаете количество пикапов, пропорциональное количеству потерянных монет #Для брелка требуется не менее 21 {{Coin}} монет и не менее 54 для предмета", "Король Бубен", "ru")
	EID:addCard(CustomConsumables.BAG_TISSUE, "Все пикапы в комнате уничтожаются, и 8 самых ценных пикапов формируют качество предмета на основе их общей ценности; затем появляется предмет такого качества #Самые ценные пикапы - самые редкие, например {{EternalHeart}} Вечные сердца или {{Battery}} Мега Батареи #{{Warning}} При использовании в комнате с менее чем 8 пикапами предмет не появится!", "Ткань", "ru")
	EID:addCard(CustomConsumables.JOKER_Q, "Телепортирует вас в {{SuperSecretRoom}} Черный Рынок", "Джокер?", "ru")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "Активирует эффект {{Collectible422}} Светящихся Песочных Часов", "Обратная Карта", "ru")
	EID:addCard(CustomConsumables.LOADED_DICE, "{{ArrowUp}} +10 к удаче на одну комнату", "Шулерские Кости", "ru")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "Создает 1-12 {{Key}} случайных ключей", "Дама Пик", "ru")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "Создает 1-12 {{Bomb}} случайных бомб", "Дама Треф", "ru")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "Бомбы будут чаще падать после прохождение комнат на этом этажа, и качество бомб увеличится", "Валет Треф", "ru")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "Монеты будут чаще падать после прохождение комнат на этом этажа, и качество монет увеличится", "Валет Бубен", "ru")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "Ключи будут чаще падать после прохождение комнат на этом этажа, и качество ключей увеличится", "Валет Пик", "ru")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "Сердца будут чаще падать после прохождение комнат на этом этажа, и качество сердец увеличится", "Валет Червей", "ru")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "Поглощает все предметы на пьедесталах в комнате и дает 3 огонька {{Collectible712}} Лемегетона за каждый поглощенный предмет", "Осколок Квазара", "ru")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "Активирует эффект {{Collectible687}} Искателя Друзей", "Визитная Карточка", "ru")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "{{ArrowUp}} Дает +1,25 урона, который истощается в течение 20 секунд #{{ArrowUp}} Исцеляет вас на одно Красное Сердце, если у вас есть Церемониальные Роба #{{Warning}} Чем больше крови вы использовали впоследствии, тем быстрее понижается урон", "Жертвенная Кровь", "ru")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "Активирует эффект случайной книги", "Читательский Билет", "ru")
	EID:addCard(CustomConsumables.FLY_PAPER, "Создает 8 мух схожие с предметом {{Collectible693}} Рой", "Липучка", "ru")
	EID:addCard(CustomConsumables.MOMS_ID , "Очаровывает всех врагов в комнате", "Мамино Удостоверение", "ru")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES , "Создает Старый Сундук", "Похоронное Бюро", "ru")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD , "Можно кинуть как Карту Хаоса #При попадании стирает врага до конца забега", "Антиматериальная Карта", "ru")
	EID:addCard(CustomConsumables.FIEND_FIRE, "Пожертвуйте своими расходниками для массового уничтожения комнаты #7-40 итого: враги получают 15 урона и горят в течение 4 секунд #41-80 итого: начальный урон, урон от горения и продолжительность горения удваиваются; уничтожает препятствия вокруг вас #81+ итого: урон от горения и продолжительность горения увеличиваются в четыре раза; Дает эффект предмета Мама Мега на одну комнаты", "Дьявольский Огонь", "ru")
	EID:addCard(CustomConsumables.DEMON_FORM, "{{ArrowUp}} Дает 0.15 урона когда вы входите в незачищенную комнату #Бонус исчезает при переходе на следующий этаж", "Демоническая Форма", "ru")
	EID:addCard(CustomConsumables.VALENTINES_CARD , "Можно кинуть как Хаос Карту #Если карта попадает во врага, он становится дружелюбным и создает красное сердце", "Валентинка", "ru")

	EID:addPill(CustomPills.ESTROGEN, "Превращает все ваши {{Heart}} сердца в блебиков #Оставляет вас по крайней мере с одним красным сердцем, не убирает сердца души/черные сердца", "Эстроген", "ru")
	EID:addPill(CustomPills.LAXATIVE, "Заставляет вас стрелять кукурузой сзади в течение 3 секунд", "Слабительное", "ru")
	EID:addPill(CustomPills.PHANTOM_PAINS, "Вы получаете фальшивый урон и получаете его снова через 15 и 30 секунд", "Фантомная Боль", "ru")
	EID:addPill(CustomPills.YUCK, "Создает гнилое сердце #В течение 30 секунд, каждое взятое красное сердце будет создавать синих мух", "Фу!", "ru")
	EID:addPill(CustomPills.YUM, "Создает красное сердце #В течение 30 секунд, каждое взятое красное сердце даст вам небольшое постоянное увеличение случайной характеристики, похожий на эффект {{Collectible671}} Карамельного Сердца", "Ням!", "ru")
end

-- Korean EID
if true then
	EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}} {{Tears}}연사 증가 #{{TreasureRoom}}보물방에 엄마/아빠 관련 아이템이 한개 더 추가되며 하나를 선택하면 나머지는 사라집니다.", "평범한 삶", "ko_kr")	
	EID:addCollectible(CustomCollectibles.COOKIE_CUTTER, "#사용 시 {{Heart}}최대 체력 +1, {{BrokenHeart}}부서진 하트 +1 #{{Warning}} 모든 체력이 부서진 하트로 채워지면 사망합니다.", "쿠키 커터", "ko_kr")
	EID:addCollectible(CustomCollectibles.SINNERS_HEART, "블랙하트 +2 #{{ArrowUp}} {{Damage}}공격력 +2 #{{ArrowUp}} {{Damage}}공격력 배율 x1.5 #{{ArrowUp}} 사거리 +2 #{{ArrowDown}} 탄속 -0.2 #눈물이 적과 지형을 관통합니다.", "죄인의 심장", "ko_kr")
	EID:addCollectible(CustomCollectibles.RUBIKS_CUBE, "사용시 5% (20회 사용시 100%)의 확률로 퍼즐을 풀고 {{Collectible"..CustomCollectibles.MAGIC_CUBE.."}}Magic Cube 아이템으로 교체됩니다.", "루빅큐브", "ko_kr")
	EID:addCollectible(CustomCollectibles.MAGIC_CUBE, "방 안의 모든 아이템을 다른 아이템으로 바꿉니다.#바뀐 아이템의 배열은 랜덤으로 결정됩니다.", "매직큐브", "ko_kr")
	EID:addCollectible(CustomCollectibles.MAGIC_PEN, "눈물 발사키를 두번 연속 누르면 그 방향으로 {{ColorRainbow}}무지개{{CR}} 장판을 뿌립니다.#무지개 장판을 지나는 적들에게 랜덤 상태이상을 부여합니다#{{Blank}} (쿨타임 4초)", "마법의 펜", "ko_kr")
	EID:addCollectible(CustomCollectibles.MARK_OF_CAIN, "에녹 패밀리어를 소환합니다. #사망시, 에녹을 제외한 다른 패밀리어 아이템이 있다면 모두 제거한 후 그 방에서 체력이 꽉 찬 상태로 부활합니다.#부활 이후 에녹 패밀리어는 알트 에녹으로 강화되며 캐릭터는 잠시동안 무적시간을 얻습니다. #{{Warning}} 단 한번만 발동됨", "카인의 표식", "ko_kr")
	EID:addCollectible(CustomCollectibles.TEMPER_TANTRUM, "피격시 25%의 확률로 {{Collectible704}}폭주 상태로 돌입합니다.#폭주 상태에서 적에게 피해를 줄 경우 10%의 확률로 해당 게임에서 제거합니다.", "울화통", "ko_kr")
	EID:addCollectible(CustomCollectibles.BAG_O_TRASH, "방 클리어시 파란 아군 파리를 생성하는 패밀리어를 소환합니다. #적 탄환을 막을 수 있으며 탄환을 막을 때마다 일정 확률로 파리가 사라지면서 Breakfast 혹은 Nightsoil 장신구를 드랍합니다. #파리를 유지한 스테이지당 파란 아군 파리 생성량이 늘어납니다.", "쓰레기 봉지", "ko_kr")
	EID:addCollectible(CustomCollectibles.CHERUBIM, "공격하는 방향으로 주변에 오라를 둘러싼 눈물을 발사합니다.", "케루빔", "ko_kr")
	EID:addCollectible(CustomCollectibles.CHERRY_FRIENDS, "적 처치시 20%의 확률로 체리 패밀리어를 드랍합니다. #적이 체리 패밀리어 위를 지나가면 매혹시키는 방귀를 뀝니다.#방 클리어시 체리 패밀리어당 빨간하트 반칸을 드랍합니다.", "체리 친구들", "ko_kr")
	EID:addCollectible(CustomCollectibles.BLACK_DOLL, "새로운 방 진입시, 모든 적들이 둘로 분할됩니다. 한 쪽이 피격되면 다른 한쪽도 60%의 피해를 받습니다.", "흑색인형", "ko_kr")
	EID:addCollectible(CustomCollectibles.BIRD_OF_HOPE, "사망시 잠시동안 무적 유령으로 변신하며 방 중앙에서 새 한마리가 랜덤한 방향을 이동하며 소환됩니다.#5초 이내로 새를 잡으면 부활합니다.#{{Warning}} 사망 횟수에 비례하여 새의 비행속도가 빨라집니다.", "희망의 파랑새", "ko_kr")
	EID:addCollectible(CustomCollectibles.ENRAGED_SOUL, "눈물 발사키를 두번 연속 누르면 그 방향으로 적과 보스에게 달라붙는 유령을 발사합니다. #유령은 7초동안 피해를 입힌 후 사라집니다.#유령의 공격력은 7이며 스테이지 진행도에 비례하여 추가로 증가합니다.#{{Blank}} (쿨타임 7초)", "분노의 영혼", "ko_kr")
	EID:addCollectible(CustomCollectibles.CEREMONIAL_BLADE, "7%의 확률로 피해를 입히지 않으나 출혈을 일으키는 단검을 발사합니다.#출혈 상태의 적이 죽으면 일정시간동안 공격력이 상승하는 {{Card"..CustomConsumables.SACRIFICIAL_BLOOD.."}}Sacrificial Blood를 드랍합니다.", "의례용 단검", "ko_kr")
	EID:addCollectible(CustomCollectibles.CEILING_WITH_THE_STARS, "스테이지 시작시, 혹은 침대에서 자면 {{Collectible712}}레메게톤 불꽃을 두마리 소환합니다.", "별무늬 천장 장식", "ko_kr")
	EID:addCollectible(CustomCollectibles.QUASAR, "현재 방의 모든 적에게 피해를 입히며 현재 방의 아이템당 각각 {{Collectible712}}레메게톤 불꽃 3개씩으로 바꿉니다.", "퀘이사", "ko_kr")
	EID:addCollectible(CustomCollectibles.TWO_PLUS_ONE, "현재 층에서 3번째로 구입하는 아이템의 가격이 1코인으로 바뀝니다. #현재 방에서 체력 거래를 2번 하면 체력 거래 1회를 무료로 할 수 있습니다.", "2+1", "ko_kr")
	EID:addCollectible(CustomCollectibles.RED_MAP, "{{UltraSecretRoom}}특급비밀방의 위치를 보여줍니다. #이미 방문한 {{BossRoom}}보스방과 {{TreasureRoom}}보물방에서 버린 장신구를 전부 {{Card78}}깨진 열쇠로 바꿉니다.", "빨간 지도", "ko_kr")
	EID:addCollectible(CustomCollectibles.CHEESE_GRATER, "사용시 최대 체력 1개를 소모하여 이하 효과 발동: #{{ArrowUp}} {{Damage}}공격력 +" .. tostring(CustomStatups.GRATER_DMG) .. " 작은 아이작 패밀리어를 3마리 소환합니다.", "치즈 강판", "ko_kr")
	EID:addCollectible(CustomCollectibles.DNA_REDACTOR, "알약 사용시, 사용한 알약의 색상에 따라 추가 효과를 발동합니다.", "아이템이름", "ko_kr")
	EID:addCollectible(CustomCollectibles.TOWER_OF_BABEL, "방 안의 모든 장애물을 파괴하며 캐릭터 주변 적들에게 혼란을 갑니다. #닫힌 문과 비밀방을 강제로 열 수 있습니다.", "바벨탑", "ko_kr")
	EID:addCollectible(CustomCollectibles.BLESS_OF_THE_DEAD, "현재 게임에서 더 이상 저주가 걸리지 않습니다.{{ArrowUp}} 걸렸어야 할 저주를 방어할 때마다 {{Damage}}공격력 +" .. tostring(CustomStatups.BLESS_DMG) .. "", "사자의 가호", "ko_kr")
	EID:addCollectible(CustomCollectibles.TANK_BOYS, "방 안을 돌아다니며 앞에 보이는 적을 향해 공격하는 장난감 탱크를 2대 소환합니다.#{{ColorGreen}}녹색{{CR}}: 총알을 빠르게 발사하며 빠르게 움직입니다. #{{ColorRed}}적색{{CR}}: 적을 향해 사거리가 짧은 로켓을 발사하며 느리게 움직입니다.", "탱크보이", "ko_kr")
	EID:addCollectible(CustomCollectibles.GUSTY_BLOOD, "적 처치 시 그 방에서 {{Tears}}연사와 {{Speed}}이동속도가 증가합니다.", "돌풍의 피", "ko_kr")
	EID:addCollectible(CustomCollectibles.RED_BOMBER, "↑ 폭탄 +5 #폭발 공격에 피해를 입지 않습니다.#폭탄을 설치하는 대신 직접 던질 수 있습니다.", "레드 봄버맨", "ko_kr")
	EID:addCollectible(CustomCollectibles.MOTHERS_LOVE, "현재 데리고 있는 패밀리어 당 능력치 증가#패밀리어의 등급에 따라 증가폭이 다르거나 적용되지 않습니다.", "엄마의 사랑", "ko_kr")
	EID:addCollectible(CustomCollectibles.BOOK_OF_GENESIS, "소지한 랜덤 아이템 하나를 제거한 후 해당 아이템과 같은 등급의 아이템 3개 중 하나를 획득할 수 있습니다.#{{Blank}} (루트 진행 아이템은 영향을 받지 않음)", "창세기의 책", "ko_kr")
	EID:addCollectible(CustomCollectibles.SCALPEL, "눈물을 반대 방향으로 쏩니다. #원래 방향으로는 캐릭터 공격력의 x0.66의 핏방울을 발사합니다. #{{Blank}} (눈물 이외의 무기는 영향을 받지 않음)", "외과용 메스", "ko_kr")
	EID:addCollectible(CustomCollectibles.KEEPERS_PENNY, "스테이지 진입 시 황금동전을 소환합니다. #상점에서 상점, 보물방, 보스방 배열의 추가 아이템을 1~4개 판매합니다. #Greed 미니보스 처치 시, 처치한 시점에서 추가 아이템이 3~4개 생성됩니다.", "키퍼의 페니", "ko_kr")
	EID:addCollectible(CustomCollectibles.NERVE_PINCH, "8초동안 쉬지않고 눈물을 쏘거나 움직이면 쥐가 납니다. #{{ArrowDown}} 쥐가 나면 {{Collectible486}}피해를 입지 않고 피격 시 발동 효과를 발동하며 {{Speed}}이동속도가 " .. tostring(CustomStatups.NERVEPINCH_SPEED) .. " 감소합니다.#{{ArrowUp}} 쥐가 나면 80%의 확률로 현재 소지한 액티브 아이템을 충전량 소모 없이 발동합니다.#{{Blank}} (일회용 및 쿨타임이 없는 아이템 제외)", "신경통", "ko_kr")
	EID:addCollectible(CustomCollectibles.BLOOD_VESSELS[1], "피격시 피해를 입는 대신 피통에 피가 채워집니다. #6회까지 채울 수 있으며 전부 채워진 후 사용하거나, 피격시 각각 세칸, 세칸 반의 피해를 받습니다.", "피통", "ko_kr")
	EID:addCollectible(CustomCollectibles.SIBLING_RIVALRY, "두 패밀리어가 캐릭터의 주변을 돌며 15초마다 상태가 바뀝니다: #두 패밀리어가 캐릭터 주변을 빠르게 돕니다. #패밀리어 하나가 캐릭터에게 더 가깝고 느리게 돌며 피장판을 뿌리는 이빨을 주기적으로 발사합니다.#{{Warning}} 두 패밀리어 모두 적의 탄환을 막아주며 접촉 피해를 입힙니다.", "투닥투닥 형제들", "ko_kr")
	EID:addCollectible(CustomCollectibles.RED_KING, "보스방 클리어시, 빨간 트랩도어가 생성됩니다. #빨간 트랩도어 진입시, 더 어려운 보스전으로 진입합니다. #빨간 보스 처치 시 특급비밀방 배열의 아이템을 드랍합니다.", "적색황제", "ko_kr")
	EID:addCollectible(CustomCollectibles.STARGAZERS_HAT, "망원경 거지를 소환합니다. #소울하트/블랙하트 획득 시 체력으로 획득되지 않는 대신 하트 0.5개당 한칸씩 충전됩니다. (소울하트 2개로 최대 충전)#망원경 거지는 동전 5개를 지불하여 100%의 확률로 룬(83%), 혹은 우주 타입의 아이템(17%)을 드랍합니다.", "천문학자의 모자", "ko_kr")
	EID:addCollectible(CustomCollectibles.BOTTOMLESS_BAG, "사용시 가방을 머리 위에 들며: #4초동안 캐릭터 주변의 모든 탄환을 흡수합니다. #흡수한 탄환 수에 비례하여 공격 발사키를 누르고 있으면 4초동안 그 방향으로 탄환을 발사합니다.", "무한가방", "ko_kr")
	EID:addCollectible(CustomCollectibles.CROSS_OF_CHAOS, "캐릭터 주변의 적을 무력화시킵니다.#일정확률로 적을 무력화시키는 눈물을 발사합니다. #무력화된 적은 이동속도가 매우 느려지며 16초 이후 처치됩니다. #무력화된 적이 처치될 시, 주변에 적을 느리게 하는 검은 핏방울을 분출합니다.", "혼돈의 십자가", "ko_kr")
	EID:addCollectible(CustomCollectibles.REJECTION, "소지하는 동안, 눈물을 쏘지 않으며 접촉시 2.5의 피해를 주는 패밀리어를 소환합니다.#사용시 캐릭터를 따라다니는 패밀리어를 전부 소모하여 공격하는 방향으로 적을 관통하는 매우 거대한 독성 내장공을 던집니다. #!!! 내장공 공격력: 캐릭터의 공격력* 4 * 희생한 패밀리어 수", "폐기", "ko_kr")
	EID:addCollectible(CustomCollectibles.AUCTION_GAVEL, "현재 방 배열의 판매 아이템을 소환합니다. #아이템의 가격은 0.2초마다 랜덤으로 바뀌며 서서히 증가합니다. #방을 나가면 아이템이 사라집니다.", "경매 망치", "ko_kr")
	EID:addCollectible(CustomCollectibles.SOUL_BOND, "주변의 적 하나와 캐릭터를 체인으로 서로 묶은 후 얼립니다. #체인에 닿은 적은 매우 큰 피해를 입습니다. #묶인 적과 캐릭터의 간격이 너무 멀면 체인이 부서집니다. #묶인 적 처치 시 33%의 확률로 소울하트를 드랍합니다.", "영혼의 끈", "ko_kr")
	EID:addCollectible(CustomCollectibles.ANGELS_WINGS, "{{ArrowUp}} {{Shotspeed}}탄속 +0.3 #눈물 대신 멀어질수록 공격력이 증가하며 적을 관통하는 깃털을 발사합니다. #눈물 발사키를 두번 연속 누르면 Dogma 보스 관련 공격 하나를 랜덤으로 전개합니다.#{{Blank}} (쿨타임 6초)", "천사의 날개", "ko_kr")
	EID:addCollectible(CustomCollectibles.HAND_ME_DOWNS, "{{ArrowUp}} {{Speed}}이동속도 +0.2 #게임오버시 캐릭터가 소지한 아이템 중 3개를 해당 스테이지에 드랍합니다.#다음 게임에서 해당 스테이지 진입시, 전 게임에서 드랍한 아이템을 획득할 수 있습니다.", "물려받은 물건", "ko_kr")

	EID:addTrinket(CustomTrinkets.BASEMENT_KEY, "황금상자를 15%의 확률로 낡은 상자로 대체합니다.", "지하실 열쇠", "ko_kr")
	EID:addTrinket(CustomTrinkets.KEY_TO_THE_HEART, "적 처치 시 일정 확률로 고기상자를 드랍합니다.#고기상자에서는 하트류 픽업, 알약이나 몸체 관련 아이템 및 장신구를 드랍합니다.", "심장열쇠", "ko_kr")
	EID:addTrinket(CustomTrinkets.JUDAS_KISS, "적과 접촉 시 해당 적에게 표식을 부여합니다. ({{Collectible618}}Rotten Tomato와 비슷한 효과)", "유다의 키스", "ko_kr")
	EID:addTrinket(CustomTrinkets.TRICK_PENNY, "도박기계, 거지류, 잠긴 상자에서 동전/폭탄/열쇠 사용 시 17%의 확률로 소모되지 않습니다.", "속임수 동전", "ko_kr")
	EID:addTrinket(CustomTrinkets.SLEIGHT_OF_HAND, "20%의 확률로 한 단계 더 높은 동전이 소환됩니다: #페니 -> 1+1 페니 -> 끈적이는 니켈 -> 니켈 -> 다임 -> 럭키 페니 -> 황금 페니", "교묘한 손기술", "ko_kr")
	EID:addTrinket(CustomTrinkets.GREEDS_HEART, "{{ArrowUp}}빈 코인하트 +1 #모든 하트 중에서 가장 먼저 소모되며 동전으로만 회복할 수 있습니다.", "탐욕의 심장", "ko_kr")
	EID:addTrinket(CustomTrinkets.ANGELS_CROWN, "보물방이 코인을 요구하는 천사 상점으로 바뀝니다. #보물방에서의 천사 보스는 열쇠 조각을 드랍하지 않습니다!", "천사의 왕관", "ko_kr")
	EID:addTrinket(CustomTrinkets.MAGIC_SWORD, "{{ArrowUp}} {{Damage}}공격력 배율 x2 #Duct Tape를 소지하지 않은 경우 피격 시 부러집니다.", "완드", "ko_kr")
	EID:addTrinket(CustomTrinkets.WAIT_NO, "무효과: 이미 부러진 완드입니다.", "안돼에에에", "ko_kr")
	EID:addTrinket(CustomTrinkets.EDENS_LOCK, "피격 시 소지한 아이템 중 하나가 다른 아이템으로 바뀝니다.#루트 진행 아이템은 이 장신구의 효과를 받지 않습니다.", "에덴의 자물쇠", "ko_kr")
	EID:addTrinket(CustomTrinkets.PIECE_OF_CHALK, "클리어하지 않은 방에 진입 시 밟은 적들을 매우 느려지게 하는 분필가루를 뿌립니다. #분필가루는 10초동안 지속됩니다.", "분필 조각", "ko_kr")
	EID:addTrinket(CustomTrinkets.ADAMS_RIB, "사망 시, Eve 캐릭터로 부활합니다.", "아담의 갈비뼈", "ko_kr")
	EID:addTrinket(CustomTrinkets.NIGHT_SOIL, "스테이지 진입 시 저주가 걸릴 확률이 75% 감소합니다.", "분뇨", "ko_kr")
	EID:addTrinket(CustomTrinkets.BONE_MEAL, "스테이지 진입 시 효과 발동:#{{ArrowUp}} {{Damage}}공격력 배율 x1.1 #{{ArrowUp}} 캐릭터의 크기가 커집니다. #이 효과는 영구적으로 적용됩니다.", "뼛가루", "ko_kr")
	EID:addTrinket(CustomTrinkets.TORN_PAGE, "책 종류의 아이템이 증폭되거나 전혀 새로운 효과를 발동하며 충전 속도가 빨라집니다. #이 장신구는 책방에서도 33%의 확률로 등장합니다.", "찢어진 페이지", "ko_kr")
	EID:addTrinket(CustomTrinkets.EMPTY_PAGE, "책 종류의 아이템 사용시 랜덤 액티브 아이템 하나를 추가로 발동합니다. #아이템을 돌리는 효과, 캐릭터를 사망시키거나 자해하는 아이템은 발동되지 않습니다. #이 장신구는 책방에서도 33%의 확률로 등장합니다.", "빈 페이지", "ko_kr")
	EID:addTrinket(CustomTrinkets.BABY_SHOES, "적과 보스의 크기 및 피격 판정 범위를 20% 감소시킵니다.", "꼬까신", "ko_kr")
	EID:addTrinket(CustomTrinkets.KEY_KNIFE, "피격시 8%의 확률로 {{Collectible705}}Dark Arts 효과 발동.", "열쇠칼", "ko_kr")

	EID:addCard(CustomConsumables.SPINDOWN_DICE_SHARD, "{{Collectible723}} Spindown Dice 효과 발동:#사용 시 방 안의 모든 아이템을 코드 뒷번호의 아이템으로 바꿉니다.#해금하지 않은 아이템은 등장하지 않습니다.", "스핀다운 주사위 파편", "ko_kr")
	EID:addCard(CustomConsumables.RED_RUNE, "방 안의 적 전체에게 대미지를 줍니다.#50%의 확률로 방 안의 아이템을 심연의 파리로, 픽업 아이템을 랜덤 자폭 파리로 바꿉니다.", "레드 룬", "ko_kr")
	EID:addCard(CustomConsumables.NEEDLE_AND_THREAD, "부서진 하트 하나를 {{Heart}}최대 체력으로 바꿉니다.", "바느질", "ko_kr")
	EID:addCard(CustomConsumables.QUEEN_OF_DIAMONDS, "{{Coin}}랜덤 동전을 1~12개 드랍합니다.", "다이아 Q", "ko_kr")
	EID:addCard(CustomConsumables.KING_OF_SPADES, "열쇠와 황금열쇠를 모두 소모하여 그에 비례한 수의 픽업 아이템을 소환합니다. #장신구는 최소 9개, 아이템은 최소 21개의 열쇠가 필요합니다.", "스페이드 K", "ko_kr")
	EID:addCard(CustomConsumables.KING_OF_CLUBS, "폭탄과 황금폭탄을 모두 소모하여 그에 비례한 수의 픽업 아이템을 소환합니다. #장신구는 최소 9개, 아이템은 최소 21개의 폭탄이 필요합니다.", "클럽 K", "ko_kr")
	EID:addCard(CustomConsumables.KING_OF_DIAMONDS, "동전을 모두 소모하여 그에 비례한 수의 픽업 아이템을 소환합니다. #장신구는 최소 21개, 아이템은 최소 54개의 동전이 필요합니다.", "다이아 K", "ko_kr")
	EID:addCard(CustomConsumables.BAG_TISSUE, "방 안의 모든 픽업을 소모하여 그 중 가장 품질이 좋은 8개의 픽업을 기반으로 아이템을 하나 소환합니다.#픽업이 희귀할수록 (예시:{{EthernalHeart}}이터널하트, {{Battery}}메가배터리) #{{Warning}} 방 안의 픽업이 8개 미만일 경우 아이템이 소환되지 않습니다.", "여행용 티슈", "ko_kr")
	EID:addCard(CustomConsumables.JOKER_Q, "블랙마켓으로 텔레포트합니다.", "조커?", "ko_kr")
	EID:addCard(CustomConsumables.UNO_REVERSE_CARD, "{{Collectible422}} Glowing Hour Glass 효과 발동:#사용 시 이전 방의 시점으로 시간을 되돌립니다.", "되돌리기 카드", "ko_kr")
	EID:addCard(CustomConsumables.LOADED_DICE, "{{ArrowUp}} 현재 방에서 {{Luck}}행운 +10", "속임수 주사위", "ko_kr")
	EID:addCard(CustomConsumables.BEDSIDE_QUEEN, "{{Key}}열쇠를 1~12개 드랍합니다.#낮은 확률로 충전된 열쇠를 드랍합니다.", "머리맡 Q", "ko_kr")
	EID:addCard(CustomConsumables.QUEEN_OF_CLUBS, "{{Bomb}}폭탄을 1~12개 드랍합니다.#낮은 확률로 1+1 폭탄을 드랍합니다.", "클럽 Q", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_CLUBS, "현재 층에서 폭탄이 드랍할 확률과 폭탄이 특수 폭탄으로 대체될 확률을 증가시킵니다.", "클럽 J", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_DIAMONDS, "현재 층에서 동전이 드랍할 확률과 동전이 특수 동전으로 대체될 확률을 증가시킵니다.", "다이아 J", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_SPADES, "현재 층에서 열쇠가 드랍할 확률과 열쇠가 특수 열쇠로 대체될 확률을 증가시킵니다.", "스페이드 J", "ko_kr")
	EID:addCard(CustomConsumables.JACK_OF_HEARTS, "현재 층에서 하트가 드랍할 확률과 하트가 특수 하트로 대체될 확률을 증가시킵니다.", "하트 J", "ko_kr")
	EID:addCard(CustomConsumables.QUASAR_SHARD, "현재 방의 모든 적에게 피해를 입히며 현재 방의 아이템당 각각 {{Collectible712}}레메게톤 불꽃 3개씩으로 바꿉니다.", "퀘이사 파편", "ko_kr")
	EID:addCard(CustomConsumables.BUSINESS_CARD, "사용 시 캐릭터가 움직이는 방향으로 움직이며 공격하는 방향으로 공격하는 아군 적을 소환합니다.", "사업 카드", "ko_kr")
	EID:addCard(CustomConsumables.SACRIFICIAL_BLOOD, "{{ArrowUp}} {{Damage}}공격력 +1.25(중첩 가능)#공격력 증가 효과는 20초동안 서서히 사라집니다 #{{ArrowUp}} {{Collectible216}}Ceremonial Robes 소지시 빨간하트 +1 #{{Warning}} 연속적으로 사용시 공격력 감소 속도가 빨라집니다.", "희생의 제물", "ko_kr")
	EID:addCard(CustomConsumables.LIBRARY_CARD, "랜덤 책 효과를 발동합니다.", "도서관 카드", "ko_kr")
	EID:addCard(CustomConsumables.FLY_PAPER, "{{Collectible693}}The Swarm 아이템의 파리 8마리를 소환합니다.", "파리잡이 끈끈이", "ko_kr")
	EID:addCard(CustomConsumables.MOMS_ID , "방 안의 적들 위에 캐릭터의 공격력 x2의 피해를 주는 엄마의 식칼을 투척시킵니다.", "엄마의 신분증", "ko_kr")
	EID:addCard(CustomConsumables.FUNERAL_SERVICES , "낡은 상자를 소환합니다.", "장례식", "ko_kr")
	EID:addCard(CustomConsumables.ANTIMATERIAL_CARD , "Chaos Card처럼 던질 수 있음 #카드와 접촉한 적을 해당 게임에서 제거합니다.", "반물질 카드", "ko_kr")
	EID:addCard(CustomConsumables.FIEND_FIRE, "동전, 열쇠, 폭탄을 전부 소모하여 방 전체에 커다란 대미지를 줍니다.#합계 7-40: 15의 피해를 입으며 4초동안 불에 붙습니다. #합계 41-80: 적들이 30의 피해를 입으며 8초동안 불에 붙습니다.; 캐릭터 주변의 장애물을 파괴합니다. #함계 81+: 적들이 60의 피해를 입으며 16초동안 불에 붙습니다.; Mama Mega 폭발이 발생합니다.", "불장난", "ko_kr")
	EID:addCard(CustomConsumables.DEMON_FORM, "{{ArrowUp}} 클리어하지 않은 방에 들어갈 때마다 {{Damage}}공격력 +0.15#다음 스테이지 진입 시 효과가 사라집니다.", "악마화", "ko_kr")
	EID:addCard(CustomConsumables.VALENTINES_CARD, "Chaos Card처럼 던질 수 있음 #카드와 접촉한 적을 아군으로 만들며 빨간하트 하나를 드랍합니다.", "발렌타인 카드", "ko_kr")
	EID:addCard(CustomConsumables.SPIRITUAL_RESERVES, "캐릭터의 주변을 돌고 적의 탄환을 막아주며 지형을 관통하는 눈물을 발사하는 유령 패밀리어를 2마리 소환합니다.#3회 피격시 사라지며 소울하트 반칸을 드랍합니다.", "영혼의 보호", "ko_kr")
	EID:addCard(CustomConsumables.MIRRORED_LANDSCAPE, "현재 소지한 액티브 아이템을 픽업 슬롯으로 이동시킵니다.#이미 픽업 슬롯에 액티브 아이템이 있을 경우 액티브 아이템을 내려놓습니다.", "거울세계의 풍경", "ko_kr")

	EID:addPill(CustomPills.ESTROGEN, "빨간하트가 한칸이 되며 나머지 빨간하트를 전부 꼬마 클롯으로 바꿉니다.", "에스트로겐", "ko_kr")
	EID:addPill(CustomPills.LAXATIVE, "3초동안 캐릭터의 뒤로 옥수수 탄환을 발사합니다.", "설사약", "ko_kr")
	EID:addPill(CustomPills.PHANTOM_PAINS, "사용 시 피해를 입지 않고 피격 시 발동 효과를 발동합니다.#15초, 30초 이후에 각각 한번씩 더 발동합니다.", "헛통증", "ko_kr")
	EID:addPill(CustomPills.YUCK, "썩은하트를 하나 드랍합니다.#30초동안 빨간하트를 주울 때마다 파란 아군 파리를 소환합니다.", "우웩", "ko_kr")
	EID:addPill(CustomPills.YUM, "빨간하트를 하나 드랍합니다.#30초동안 빨간하트를 주울 때마다 능력치가 소량 증가합니다.", "냠", "ko_kr")
end









