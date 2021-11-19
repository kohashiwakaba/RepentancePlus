# EID to Wiki description

EID = """EID:addCollectible(Collectibles.ORDLIFE, "{{ArrowUp}} Tears up #Spawns an additional Mom/Dad related item in Treasure rooms alongside the presented items; only one item can be taken")	
	EID:addCollectible(Collectibles.COOKIECUTTER, "Gives you one {{Heart}} heart container and one broken heart #{{Warning}} Having 12 broken hearts kills you!")
	EID:addCollectible(Collectibles.SINNERSHEART, "+2 black hearts #{{ArrowUp}} Damage +2 then x1.5 #{{ArrowUp}} Grants +2 range and -0.2 shotspeed #Grants spectral and piercing tears")
	EID:addCollectible(Collectibles.RUBIKSCUBE, "After each use, has a 5% (100% on 20-th use) chance to be 'solved', removed from the player and be replaced with a Magic Cube item")
	EID:addCollectible(Collectibles.MAGICCUBE, "Rerolls item pedestals #Rerolled items can be drawn from any item pool")
	EID:addCollectible(Collectibles.MAGICPEN, "Double tap shooting button to spew a line of {{ColorRainbow}}rainbow{{CR}} creep in the direction you're firing #Random permanent status effects is applied to enemies walking over that creep #{{Warning}} Has a 4 seconds cooldown")
	EID:addCollectible(Collectibles.MARKCAIN, "On death, if you have any familiars, removes them instead and revives you #On revival, you keep your heart containers, gain +" .. tostring(StatUps.MARKCAIN_DMG) .. " DMG for each consumed familiar and gain invincibility #{{Warning}} Works only once!")
	EID:addCollectible(Collectibles.TEMPERTANTRUM, "25% chance to enter Berserk state when taking damage #While in this state, every enemy damaged has a 10% chance to be erased for the rest of the run")
	EID:addCollectible(Collectibles.BAGOTRASH, "A familiar that creates blue flies upon clearing a room #Blocks enemy projectiles, and after blocking it has a chance to be destroyed and drop Breakfast or Nightsoil trinket #The more floors it is not destroyed, the more flies it spawns")
	EID:addCollectible(Collectibles.CHERUBIM, "A familiar that rapidly shoots tears with Godhead aura")
	EID:addCollectible(Collectibles.CHERRYFRIENDS, "Killing an enemy has a 20% chance to drop cherry familiar on the ground #Those cherries emit a charming fart when an enemy walks over them, and drop half a heart when a room is cleared")
	EID:addCollectible(Collectibles.BLACKDOLL, "Upon entering a new room, all enemies will be split in pairs. Dealing damage to one enemy in each pair will deal half of that damage to another enemy in that pair")
	EID:addCollectible(Collectibles.BIRDOFHOPE, "Upon dying you turn into invincible ghost and a bird flies out of room center in a random direction. Catching the bird in 5 seconds will save you and get you back to your death spot, otherwise you will die #{{Warning}} Every time you die, the bird will fly faster and faster, making it harder to catch her")
	EID:addCollectible(Collectibles.ENRAGEDSOUL, "Double tap shooting button to launch a ghost familiar in the direction you are firing #The ghost will latch onto the first enemy it collides with, dealing damage over time for 7 seconds or until that enemy is killed #The ghost's damage per hit starts at 7 and increases each floor #The ghost can latch onto bosses aswell #{{Warning}} Has a 7 seconds cooldown")
	EID:addCollectible(Collectibles.CEREMDAGGER, "{{ArrowDown}} Damage x" .. tostring(StatUps.CEREMDAGGER_DMG_MUL) .. "#When shooting, 7% chance to launch a dagger that does no damage, but inflicts bleed on enemies #All enemies that die while bleeding will drop Sacrificial Blood Consumable that gives you temporary DMG up")
	EID:addCollectible(Collectibles.CEILINGSTARS, "Grants you two Lemegeton wisps at the beginning of each floor and when sleeping in bed")
	EID:addCollectible(Collectibles.QUASAR, "Consumes all item pedestals in the room and gives you 3 Lemegeton wisps for each item consumed")
	EID:addCollectible(Collectibles.TWOPLUSONE, "Every third shop item on the current floor will cost 1 {{Coin}} penny #Buying two items with hearts in one room makes all other items free")
	EID:addCollectible(Collectibles.REDMAP, "Reveals location of Ultra Secret Room on all subsequent floors #Any trinket left in a boss or treasure room will turn into Cracked Key, unless this is your first visit in such room")
	EID:addCollectible(Collectibles.CHEESEGRATER, "Removes one red heart container and gives you {{ArrowUp}} +" .. tostring(StatUps.GRATER_DMG) .. " Damage up and 3 Minisaacs")
	EID:addCollectible(Collectibles.DNAREDACTOR, "Pills now have additional effects based on their color")
	EID:addCollectible(Collectibles.TOWEROFBABEL, "Destroys all obstacles in the current room and applies confusion to enemies in small radius around you #Also blows the doors open and opens secret room entrances")
	EID:addCollectible(Collectibles.BLESSOTDEAD, "Prevents curses from appearing for the rest of the run #Preventing a curse grants you {{ArrowUp}} +" .. tostring(StatUps.BLESS_DMG) .. " Damage up")
	EID:addCollectible(Collectibles.TOYTANKS, "Spawns 2 Toy Tanks familiars that roam around the room and attack enemies that are in their line of sight #Green tank: rapidly shoots bullets at enemies from a further distance and moves more quickly #Red tank: shoots rockets at enemies at a close range, moves slower")
	EID:addCollectible(Collectibles.GUSTYBLOOD, "Killing enemies grants you {{ArrowUp}} tears and speed up #The bonus is reset when entering a new room")
	EID:addCollectible(Collectibles.REDBOMBER, "+5 bombs #Grants explosion immunity #Allows you to throw your bombs instead of placing them on the ground")
	EID:addCollectible(Collectibles.MOTHERSLOVE, "Grants you stat upgrades for each familiar you own")
	EID:addCollectible(Collectibles.CATINBOX, "When entering a room with enemies, their health is halved for the first 3 seconds, and then restored back to full #Doesn't work on bosses or minibosses")
	EID:addCollectible(Collectibles.BOOKOFGENESIS, "Removes a random item and spawns 3 items of the same quality #Only one item can be taken #Can't remove or spawn quest items")
	EID:addCollectible(Collectibles.SCALPEL, "Makes you shoot tears in the opposite direction #From the front, you will frequently shoot bloody tears that deal x0.66 of your damage #All other weapon types will still be fired from the front as well")
	EID:addCollectible(Collectibles.KEEPERSPENNY, "Spawns a golden penny upon entering a new floor #Shops will now sell 1-4 additional items that are drawn from shop, treasure or boss itempools")
	EID:addCollectible(Collectibles.NERVEPINCH, "Shooting or moving in one direction for 5 seconds will trigger a nerve pinch #{{ArrowDown}} You take fake damage and gain a permanent " .. tostring(StatUps.NERVEPINCH_SPEED) .. " speed down when that happens #{{ArrowUp}} However, there is a 75% chance to activate your active item for free, even if it's uncharged #One-time use and infinite use actives cannot be used that way")
	EID:addCollectible(Collectibles.BLOODVESSELS[1], "Taking damage doesn't actually hurt the player, instead filling the blood vessel #This can be repeated 6 times until the vessel if full #Once it's full, using it or taking damage will empty it and deal 3 hearts of damage to the player")"""

for description in EID.split('\n'):
    itemID = description[description.find('(') + 1:description.find(',')]
    itemDesc = description[description.find('\"'):-2]

    itemDesc = itemDesc.replace('#', '\n')

    import re

    itemDesc = re.sub(r'\{\{.*\}\}', '', itemDesc)
    itemDesc = re.sub(r'\" *', '', itemDesc)

    print('[' + itemID + '] = {')
    print('\t{')
    print('\t\t{str = "Effects", fsize = 2, clr = 3, halign = 0},')
    for line in itemDesc.split('\n'):
        print('\t\t{str = \"' + line + '\"},')
    print('\t},')
    print('},')

# Item pools to Wiki item pools

for description in EID.split('\n'):
    itemID = description[description.find('(') + 1:description.find(',')]
    
    print('[' + itemID + '] = ,')


