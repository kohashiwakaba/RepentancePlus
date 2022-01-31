# EID to Wiki description

EID = """EID:addCollectible(CustomCollectibles.ORDINARY_LIFE, "{{ArrowUp}} Tears up #Spawns an additional Mom and Dad related item in Treasure rooms alongside the presented items; only one item can be taken")	
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
"""

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
    
    print('[' + itemID + '] = {Encyclopedia.ItemPools.},')


