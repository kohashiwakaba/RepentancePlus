local ItemsWiki = {
	[CustomCollectibles.ORDINARY_LIFE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Grants its own tears up and makes all tears up items more effective"},
			{str = "Spawns an additional Mom and Dad related item in Treasure rooms alongside the presented items. Only one item can be taken"},
		},
	},
	[CustomCollectibles.COOKIE_CUTTER] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Gives you one heart container and one broken heart. Heals you for 2 full red hearts"},
			{str = "Having 12 broken hearts kills you!"},
		},
	},
	[CustomCollectibles.SINNERS_HEART] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "+2 black hearts "},
			{str = "Damage +2 then x1.5"},
			{str = "Grants +2 range and -0.2 shotspeed "},
			{str = "Grants spectral and piercing tears"},
		},
	},
	[CustomCollectibles.RUBIKS_CUBE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "After each use, has a 5% (100% on 20-th use) chance to be 'solved', removed from the player and be replaced with a Magic Cube item"},
		},
	},
	[CustomCollectibles.MAGIC_CUBE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Rerolls item pedestals "},
			{str = "Rerolled items can be drawn from any item pool"},
		},
	},
	[CustomCollectibles.MAGIC_PEN] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Double tap shooting button to spew a line of  creep in the direction you're firing "},
			{str = "Random status effect is applied to enemies walking over that creep "},
			{str = "Has a 4 seconds cooldown"},
		},
	},
	[CustomCollectibles.MARK_OF_CAIN] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Grants you Enoch follower familiar"},
			{str = "On death, if you have any familiars (granted by items, not in other ways) besides Enoch, revive you and remove them instead. Enoch familiar becomes more powerful. Grants you invincibility frames and keeps all your heart containers"},
			{str = "Base Enoch (before revival): shoots tears that home in on enemies Brain Worm-style and deal 3.5 base damage"},
			{str = "Tainted Enoch (after revival): shoots rock tears (purely visual) that also home in on enemies, have increased damage of 4.375 and have a 7% chance to spawn Ocular Rift on impact. Also shoots 3 bloody tears upwards that deal 1.25 damage each"},
			{str = "Works only once!"},
		},
	},
	[CustomCollectibles.TEMPER_TANTRUM] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "25% chance to enter Berserk state when taking damage "},
			{str = "While in this state, every enemy damaged has a 5% chance to be erased for the rest of the run"},
		},
	},
	[CustomCollectibles.BAG_O_TRASH] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "A familiar that creates blue flies upon clearing a room "},
			{str = "Blocks enemy projectiles, and after blocking it has a 1.25% chance to be destroyed and drop Breakfast or Nightsoil trinket"},
			{str = "The more floors it is not destroyed, the more flies it spawns"},
		},
	},
	[CustomCollectibles.CHERUBIM] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "A familiar that shoots tears with Godhead aura that deal 5 damage"},
		},
	},
	[CustomCollectibles.CHERRY_FRIENDS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Killing an enemy has a 20% chance to drop cherry familiar on the ground"},
			{str = "Those cherries emit a charming fart when an enemy walks over them, and drop half a heart when a room is cleared"},
		},
	},
	[CustomCollectibles.BLACK_DOLL] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Upon entering a new room, all enemies will be grouped into pairs randomly. Dealing damage to an enemy will deal 60% of that damage to another enemy in the pair"},
		},
	},
	[CustomCollectibles.BIRD_OF_HOPE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Upon dying you turn into invincible ghost and a bird flies out of room center in a random direction. Catching the bird in 5 seconds will save you and get you back to your death spot, otherwise you will die "},
			{str = "Every time you die, the bird will fly faster and faster, making it harder to catch her"},
		},
	},
	[CustomCollectibles.ENRAGED_SOUL] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Double tap shooting button to launch a ghost familiar in the direction you are firing "},
			{str = "The ghost will latch onto the first enemy it collides with, dealing damage over time for 7 seconds or until that enemy is killed "},
			{str = "The ghost's damage per hit starts at 7 and increases each floor "},
			{str = "The ghost can latch onto bosses aswell "},
			{str = "Has a 7 seconds cooldown"},
		},
	},
	[CustomCollectibles.CEREMONIAL_BLADE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "When shooting, 7% chance to launch a piercing dagger that does no damage, but inflicts bleed on enemies"},
			{str = "All enemies that die while bleeding will drop Sacrificial Blood consumable that gives you temporary DMG up"},
		},
	},
	[CustomCollectibles.CEILING_WITH_THE_STARS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Grants you two Lemegeton wisps at the beginning of each floor and when sleeping in bed"},
			{str = "Gives you only one wisp when entering the starting room on each floor while doing Ascent path"}
		},
	},
	[CustomCollectibles.QUASAR] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Consumes all item pedestals in the room and gives you 3 Lemegeton wisps for each item consumed"},
			{str = "Can also consume items that you are currently holding above your head, similarly to Void and Abyss"}
		},
	},
	[CustomCollectibles.TWO_PLUS_ONE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Every third shop item on the current floor will cost 1 penny"},
		},
	},
	[CustomCollectibles.RED_MAP] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Reveals location of Ultra Secret Room"},
			{str = "Any trinket left in a boss or treasure room will turn into Cracked Key, unless this is your first visit in such room"},
		},
	},
	[CustomCollectibles.CHEESE_GRATER] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Removes one red heart container and gives you  x" .. tostring(CustomStatups.Damage.CHEESE_GRATER_MUL) .. " damage increase and 3 Minisaacs"},
		},
	},
	[CustomCollectibles.DNA_REDACTOR] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Pills now have additional effects based on their color"},
			{str = "Some effects are different for normal and horse pills"},
			{str = "Helper icons are displayed near pills to give some clue as to what the additional effect is"}
		},
	},
	[CustomCollectibles.TOWER_OF_BABEL] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Destroys all obstacles in the current room and applies confusion to enemies in small radius around you "},
			{str = "Also blows the doors open and opens secret room entrances"},
		},
	},
	[CustomCollectibles.BLESS_OF_THE_DEAD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Prevents curses from appearing for the rest of the run"},
			{str = "Preventing a curse grants you x" .. tostring(CustomStatups.Damage.BLESS_OF_THE_DEAD_MUL) .. " damage multiplier"},
		},
	},
	[CustomCollectibles.TANK_BOYS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns 2 Toy Tanks familiars that roam around the room and attack enemies that are in their line of sight "},
			{str = "Green tank: rapidly shoots bullets at enemies from a further distance and moves more quickly "},
			{str = "Red tank: shoots rockets at enemies at a close range, moves slower"},
		},
	},
	[CustomCollectibles.GUSTY_BLOOD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Killing enemies grants you temporary tears and speed bonus"},
			{str = "The bonus is reset when entering a new room"},
		},
	},
	[CustomCollectibles.RED_BOMBER] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "+5 bombs "},
			{str = "Grants explosion immunity"},
			{str = "Allows you to throw your bombs instead of placing them on the ground"},
		},
	},
	[CustomCollectibles.MOTHERS_LOVE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Grants you stat boosts for each familiar you own"},
			{str = "Some familiars grant greater stat boosts, and some do not grant them at all (e.g. blue flies, dips or Isaac's body parts)"},
		},
	},
	[CustomCollectibles.CAT_IN_A_BOX] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Enemies outside your line of sight (defined by your firing direction) are paralyzed, cannot attack you in any way and cannot be damaged"},
        },
	},
	[CustomCollectibles.BOOK_OF_GENESIS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Removes a random item and spawns 3 items of the same quality "},
			{str = "Only one item can be taken"},
			{str = "Can't remove or spawn quest items"},
		},
	},
	[CustomCollectibles.SCALPEL] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Consumes a heart container. If you have no heart containers or bone hearts, consumes 2 soul heart"},
			{str = "Permanently makes Isaac fire tears in one more random direction, similarly to Eye Sore"},
			{str = "These tears deal 75% of your damage, are shot with approximately the same rate of fire and retain all your tear modifiers"},
		},
	},
	[CustomCollectibles.KEEPERS_PENNY] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns a golden penny upon entering a new floor"},
			{str = "Shops will now sell 1-4 additional items that are drawn from shop, treasure or boss item pools"},
			{str = "If the shop is a Greed fight, 3-4 items spawn instead after it is defeated"}
		},
	},
	[CustomCollectibles.NERVE_PINCH] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Double tap shooting button to trigger a nerve pinch. You take fake damage and gain a permanent " .. tostring(CustomStatups.Speed.NERVE_PINCH) .. " speed down when that happens"},
			{str = "However, there is an 80% chance to activate your active item for free, even if it's uncharged"},
			{str = "One-time use and infinite use actives cannot be used that way"},
			{str = "Gives twice as much speed penalty if the player tries to use 6 or 12 room recharge active item"}
		},
	},
	[CustomCollectibles.BLOOD_VESSELS[1]] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Taking damage doesn't actually hurt the player, instead filling the blood vessel"},
			{str = "This can be repeated 6 times until the vessel is full"},
			{str = "Once it's full, using it or taking damage will empty it and deal 3 and 3.5 hearts of damage to the player, respectively"},
			{str = "Any non-empty Blood Vessels cannot be switched for another active item to prevent taking damage. When any is detected, it will instantly be destroyed, damaging all players in proportion to how full it was"}
		},
	},
	[CustomCollectibles.SIBLING_RIVALRY] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Grants an orbital that switches between 2 different states every 15 seconds:"},
			{str = "- Two orbitals that quickly rotate around Isaac"},
			{str = "- One orbital that rotates slower and closer to Isaac, and periodically shoots teeth in random directions and spawns blood creep underneath it"},
			{str = "All orbitals block enemy shots and do contact damage"},
		},
	},
	[CustomCollectibles.RED_KING] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "After defeating a boss, red crawlspace will appear in a middle of a room"},
			{str = "Entering the crawlspace brings you to another bossfight of high difficulty. Victory rewards you two items from Ultra secret room pool to choose from"},
			{str = "The crawlspace can be entered only once, but you can enter it whenever you want, not necessarily after defeating the main floor boss"},
		},
	},
	[CustomCollectibles.STARGAZERS_HAT] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Summons the Stargazer beggar"},
			{str = "Can only be charged with soul hearts, similarly to Alabaster Box. 1 soul heart needed for full charge"},
			{str = "Can only be used (and hence, charged) once per floor"},
		},
	},
	[CustomCollectibles.BOTTOMLESS_BAG] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Upon use, holds the bag in the air"},
			{str = "For 4 seconds, all nearby projectiles are sucked into the bag"},
			{str = "Hold the shooting button to release all sucked projecties as homing tears in the matching direction after 4 seconds"},
			{str = "Tears released by the bag inherit all your tear effects (e.g. they are explosive if you have Ipecac)"},
			{str = "If the player doesn't hold a shooting button, the reflected tears are shot downwards"},
		},
	},
	[CustomCollectibles.CROSS_OF_CHAOS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Enemies that come close to you become crippled"},
			{str = "Crippled enemies lose their speed overtime, and die afer 12 seconds of losing it"},
			{str = "When crippled enemies die, they release a fountain of slowing black tears"},
			{str = "Your tears also have a chance to cripple enemies. Base chance is 2% and it maxes out at 7% at 10 luck"},
		},
	},
	[CustomCollectibles.REJECTION] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "On use, consume all your follower familiars and throw them as big piercing poisonous gut ball in your firing direction"},
			{str = "Damage formula: your damage x 4 x number of consumed familiars"},
			{str = "Consumed familiars respawn in the next room"},
			{str = "Passively grants a familiar that doesn't shoot tears, but deals 2.5 contact damage to enemies"},
		},
	},
	[CustomCollectibles.AUCTION_GAVEL] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns an item from the room's pool for sale"},
			{str = "Its price starts at 22 cents and will change roughly 5 times a second"},
			{str = "The price is random, but generally increases over time until it reaches 99 coins"},
			{str = "If you leave and re-enter the room, the item disappears"},
			{str = "Having Steam Sale makes the prices start at only 11 cents and slows down the price increase"}
		},
	},
	[CustomCollectibles.SOUL_BOND] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Chain yourself to a random enemy in a close radius with an astral chain and freeze them "},
			{str = "The chain deals heavy contact damage to enemies"},
			{str = "Going too far away from chained enemy will break the chain "},
			{str = "Chained enemies have a 33% chance to drop a soul heart when killed"},
			{str = "Can chain bosses too. Chain-down lasts for 5 seconds"},
		},
	},
	[CustomCollectibles.ANGELS_WINGS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "+0.3 Shot Speed up "},
			{str = "Your tears are replaced with piercing feathers that deal more damage the more they travel "},
			{str = "Double tap to perform one of Dogma-related attacks (these attacks cycle between each other and are not chosen randomly):"},
			{str = "- Spawn a friendly Dogma Baby, that behaves much like Hungry Soul"},
			{str = "- Shoot 3 slow piercing tears with Godhead aura"},
			{str = "- Shoot a laser that deals 3.5 contact damage per hit to enemies"},
			{str = "Has a 6 seconds cooldown"},
		},
	},
	[CustomCollectibles.HAND_ME_DOWNS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "+0.2 Speed up "},
			{str = "After your run ends, 3 random items from your inventory are spawned on the floor where it ended. They can be collected on the next run by getting to the same floor"},
		},
	},
	[CustomCollectibles.BOOK_OF_LEVIATHAN] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Requires a key to 'unlock' and use it, does nothing if used without keys. Grants 2 keys on pickup"},
			{str = "Upon use, cripples all enemies in the room"},
			{str = "Crippled enemies lose their speed overtime, and die afer 12 seconds of losing it "},
			{str = "Has special synergies with key-related trinkets:"},
			{str = "- Store Key: Crippled enemies have a 75% chance to drop random pickup on death"},
			{str = "- Rusted Key: Applies confusion to crippled enemies"},
			{str = "- Crystal Key: Can randomly make enemies frozen on death"},
			{str = "- Blue Key: Crippled enemies can drop half soul heart on death"},
			{str = "- Strange Key: Applies random status effect to enemies with 75% chance"},
			{str = "- Gilded Key: Can randomly Midas freeze enemies on use"},
			{str = "- Basement Key: Crippled enemies can spawn bone orbitals on death"},
			{str = "- Key to the Heart: Crippled enemies can drop half red heart on death"},
			{str = "- Key Knife: Applies bleed to crippled enemies"},
        },
	},
	[CustomCollectibles.FRIENDLY_SACK] = {
			{
				{str = "Effects", fsize = 2, clr = 3, halign = 0},
				{str = "After each 3rd completed room, spawns a random weak familiar. This includes blue flies, spiders, locusts, dips, mini isaacs, blood clots and wisps"},
				{str = "If boss room is a room where Friendly Sack would pay out, it spawns a random charmed monster instead"},
			},
	},
	[CustomCollectibles.MAGIC_MARKER] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Drops a random tarot card (normal or reversed) when picked up "},
			{str = "On use, transform held tarot card by increasing the number by 1 (or reducing by 1 for reversed tarots)"},
			{str = "Can roll into cards even if they haven't been unlocked yet"},
        },
	},
	[CustomCollectibles.ULTRA_FLESH_KID] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Familiar that chases enemies and deals contact damage, similar to Leech"},
			{str = "Has 3 stages, collects red hearts to evolve. A total of 15 hearts needs to be collected to evolve. Only collects hearts in cleared rooms and cannot fly through obstacles to collect them"},
			{str = "Stage 1: chases enemies, leaving creep"},
			{str = "Stage 2: contact damage increased, occasionally shoots 8 bloody tears in all directions"},
			{str = "Stage 3: contact damage increased, after 2 seconds of being in uncleared rooms, pops his head off and lets it bounce across the room"},
		},
	},
	[CustomCollectibles.VAULT_OF_HAVOC] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Passively stores killed enemies with more than 10 HP. Can be used as soon as 12 such enemies are stored"},
			{str = "Upon use, brings you into a special room with 12 most recently killed enemies. Clearing the room spawns a reward based on total HP of spawned enemies:"},
			{str = "- Low: soul, red and golden heart"},
			{str = "- Medium: brown chest, golden chest and a trinket"},
			{str = "- High: a random collectible item"},
		},
	},
	[CustomCollectibles.PURE_SOUL] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "All sin minibosses have a 100% chance to drop their respective Sin's Jewel"},
			{str = "A ghost can spawn in either Secret or Super Secret room that will disappear and spawn a random sin miniboss when approached"},
			{str = "This familiar will also spawn in the doorway leading to a miniboss room, alarming you of what miniboss is inside"},
			{str = "Sin's Jewels are a special set of consumables that drop when defeating a miniboss, each sin miniboss has a 7.5% default chance to drop its respective Jewel (15% for Super version)"}
        },
	},
	[CustomCollectibles.HANDICAPPED_PLACARD] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Places a handicapped placard on the ground"},
			{str = "Every enemy inside the placard's area of effect is weakened (The Strength? card effect) and spawns bone spurs on death"},
			{str = "The area becomes bigger the more damage you take in a room"},
			{str = "Works on bosses and minibosses too"}
        },
	},
	[CustomCollectibles.BOOK_OF_JUDGES] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Passively spawns targets on the floor when entering a new room with monsters"},
			{str = "Every 3 seconds, beams of light will strike at the targets' positions "},
			{str = "Beams hurt enemies and inflict burn on them, but they deal full heart of damage to you as well"},
			{str = "Using the book cancels the summoning of beams for the current room"},
        },
	},
	[CustomCollectibles.BIRTH_CERTIFICATE] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "ONE-TIME USE ITEM"},
			{str = "Consumes all your currently held trinkets and teleports you to a room containing 188 trinkets, as well as some other pickups"},
			{str = "Only one trinket can be chosen, and after choosing it, you will be teleported back to the starting room of the current floor"},
			{str = "If the total trinket pool is more than 230, there will be a secondary room adjusted to the main one which contains 52 more trinkets"},
			{str = "You will not be able to return to the main room once you enter the secondary room, so choose carefully!"}
        },
	},
}

local TrinketsWiki = {
	[CustomTrinkets.BASEMENT_KEY] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "While held, every Golden Chest has a 15% chance to be replaced with Old Chest"},
		},
	},
	[CustomTrinkets.KEY_TO_THE_HEART] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "While held, every enemy with more than 10 HP has a chance to drop Flesh Chest upon death"},
			{str = "Flesh Chests hurt the player for half a heart multiple times before opening up. This prioritizes red hearts"},
			{str = "Flesh Chests contain red hearts, pills, or random body-related items and trinkets"},
		},
	},
	[CustomTrinkets.JUDAS_KISS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Enemies touching you become feared and targeted by other enemies (bait effect of Rotten Tomato item)"},
			{str = "Fear effect lasts for 1.5 seconds, bait effect is permanent"},
		},
	},
	[CustomTrinkets.TRICK_PENNY] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Using coin, bomb or key on slots, beggars or locked chests has a 17% chance to not subtract it from your inventory count"},
		},
	},
	[CustomTrinkets.SLEIGHT_OF_HAND] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Upon spawning, every coin has a 20% chance to be upgraded to a higher value"},
			{str = "The upgrade is as follows: penny - doublepack pennies - sticky nickel - nickel - dime - lucky penny - golden penny"},
		},
	},
	[CustomTrinkets.GREEDS_HEART] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Gives you one empty coin heart"},
			{str = "It is depleted before any of your normal hearts and can only be refilled by directly picking up money"},
		},
	},
	[CustomTrinkets.ANGELS_CROWN] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "All newly visited treasure rooms will have an angel item for sale instead of a normal item, similarly to Stairway shops"},
		},
	},
	[CustomTrinkets.MAGIC_SWORD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "x2 DMG up while held "},
			{str = "Breaks when you take damage. Having Duct Tape prevents it from breaking"},
		},
	},
	[CustomTrinkets.WAIT_NO] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Does nothing, it's broken"},
		},
	},
	[CustomTrinkets.EDENS_LOCK] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Upon taking damage, one of your items rerolls into another random item"},
			{str = "Doesn't take away nor give you story items"},
		},
	},
	[CustomTrinkets.PIECE_OF_CHALK] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "When entering uncleared room, you will leave a trail of powder underneath for 5 seconds"},
			{str = "Enemies walking over the powder will be significantly slowed down"},
			{str = "The powder lasts for 10 seconds"},
		},
	},
	[CustomTrinkets.ADAMS_RIB] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "22% chance to revive you as Eve when you die"},
			{str = "The Eve character retains all standard stats, health, and passive items"}
		},
	},
	[CustomTrinkets.NIGHT_SOIL] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "75% chance to prevent a curse when entering a new floor"},
		},
	},
	[CustomTrinkets.BONE_MEAL] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "At the beginning of every new floor, grants:"},
			{str = "- +10% DMG up"},
			{str = "- Size increase"},
			{str = "Both damage and size up stay if you drop the trinket"},
		},
	},
	[CustomTrinkets.TORN_PAGE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Amplifies or changes book's activation effects:"},
			{str = "- Book of Virtues: summoned wisps are stronger"},
			{str = "- Book of Revelations: prevents Harbingers from replacing floor bosses"},
			{str = "- Book of the Dead: grants you a bone heart"},
			{str = "- Book of Belial: grants Eye of Belial effect"},
			{str = "- Book of Sin: has a 3% chance to spawn an item, a normal or golden chest instead of a pickup"},
			{str = "- Book of Shadows: the shield has extended durability"},
			{str = "- Anarchist Cookbook: spawns a golden troll bomb instead"},
			{str = "- Bible: removes a broken heart"},
			{str = "- Satanic Bible: grants you a choice of 2 (3 if you have There's Options) devil deal items after defeating a boss"},
			{str = "- Telepathy for Dummies: grants Dunce Cap effect"},
			{str = "- Necronomicon: summons 3 locusts of death on use"},
			{str = "- How to Jump: when landing, shoot tears in a + or X pattern"},
			{str = "- Lemegeton: Can be used at partial charge to gain remaining charges at the cost of player's red health (similarly to how Sharp Plus works)"},
			{str = "- Monster Manual and Book of Secrets: gain 2 charges back when used"},
			{str = "- Book of Genesis: increases the number of options to 4"},
			{str = "- Book of Leviathan: Doesn't require keys to be used"},
		},
	},
	[CustomTrinkets.EMPTY_PAGE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Books now activate another random active item on use"},
			{str = "Doesn't proc dice (except for D20) and items that hurt or kill you"},
		},
	},
	[CustomTrinkets.BABY_SHOES] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Reduces the size of all enemies by 10%"},
			{str = "This affects both sprite and hitbox"},
			{str = "Affects bosses too"},
		},
	},
	[CustomTrinkets.KEY_KNIFE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "8% chance to activate Dark Arts effect when taking damage"},
		},
	},
	[CustomTrinkets.SHATTERED_STONE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Chance to spawn random locust when picking up bombs, coing or keys"},
			{str = "Chance increases with pickup's quality"},
		},
	},
}

local PillsWiki = {
	[CustomPills.ESTROGEN] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Turns all your red health into blood clots "},
			{str = "Leaves you at one red heart, doesn't affect soul/black hearts"},
			{str = "HORSE: no difference"},
		},
	},
	[CustomPills.LAXATIVE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Makes you shoot out corn tears from behind for 3 seconds"},
			{str = "HORSE: the effect lasts for 12 seconds"},
		},
	},
	[CustomPills.PHANTOM_PAINS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Makes Isaac take fake damage on pill use, then 15 and 30 seconds after"},
			{str = "HORSE: when fake damage ticks, 8 bone tears are shot in a star pattern around Isaac"},
		},
	},
	[CustomPills.YUCK] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns a rotten heart "},
			{str = "For 30 seconds, every picked up red heart will spawn blue flies"},
			{str = "HORSE: lasts for 60 seconds"},
		},
	},
	[CustomPills.YUM] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns 2-5 half red hearts"},
			{str = "For 30 seconds, every picked up red heart will grant you small permanent stat upgrades, similar to Candy Heart effect"},
			{str = "HORSE: lasts for 60 seconds"},
		},
	},
}

local PillsColors = {
	[CustomPills.ESTROGEN] = 9,
	[CustomPills.LAXATIVE] = 10,
	[CustomPills.PHANTOM_PAINS] = 10,
	[CustomPills.YUCK] = 9,
	[CustomPills.YUM] = 9
}

local itemPools = {
	[CustomCollectibles.ORDINARY_LIFE] = {Encyclopedia.ItemPools.POOL_SECRET, Encyclopedia.ItemPools.POOL_OLD_CHEST},
	[CustomCollectibles.COOKIE_CUTTER] = {Encyclopedia.ItemPools.POOL_DEMON_BEGGAR, Encyclopedia.ItemPools.POOL_CURSE},
	[CustomCollectibles.RUBIKS_CUBE] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_CRANE_GAME},
	[CustomCollectibles.MAGIC_PEN] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_CRANE_GAME},
	[CustomCollectibles.MARK_OF_CAIN] = {Encyclopedia.ItemPools.POOL_CURSE, Encyclopedia.ItemPools.POOL_DEVIL, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.TEMPER_TANTRUM] = {Encyclopedia.ItemPools.POOL_SECRET, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.BAG_O_TRASH] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_BEGGAR, Encyclopedia.ItemPools.POOL_BABY_SHOP},
	[CustomCollectibles.CHERUBIM] = {Encyclopedia.ItemPools.POOL_ANGEL, Encyclopedia.ItemPools.POOL_BABY_SHOP},
	[CustomCollectibles.CHERRY_FRIENDS] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.BLACK_DOLL] = {Encyclopedia.ItemPools.POOL_CURSE, Encyclopedia.ItemPools.POOL_RED_CHEST},
	[CustomCollectibles.BIRD_OF_HOPE] = {Encyclopedia.ItemPools.POOL_ANGEL},
	[CustomCollectibles.ENRAGED_SOUL] = {Encyclopedia.ItemPools.POOL_DEVIL},
	[CustomCollectibles.CEREMONIAL_BLADE] = {Encyclopedia.ItemPools.POOL_DEVIL},
	[CustomCollectibles.CEILING_WITH_THE_STARS] = {Encyclopedia.ItemPools.POOL_SHOP},
	[CustomCollectibles.QUASAR] = {Encyclopedia.ItemPools.POOL_DEVIL, Encyclopedia.ItemPools.POOL_ANGEL, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.TWO_PLUS_ONE] = {Encyclopedia.ItemPools.POOL_SHOP},
	[CustomCollectibles.RED_MAP] = {Encyclopedia.ItemPools.POOL_SECRET, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.SINNERS_HEART] = {Encyclopedia.ItemPools.POOL_DEVIL},
	[CustomCollectibles.CHEESE_GRATER] = {Encyclopedia.ItemPools.POOL_SHOP},
	[CustomCollectibles.DNA_REDACTOR] = {Encyclopedia.ItemPools.POOL_SECRET},
	[CustomCollectibles.TOWER_OF_BABEL] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_CRANE_GAME},
	[CustomCollectibles.BLESS_OF_THE_DEAD] = {Encyclopedia.ItemPools.POOL_SECRET},
	[CustomCollectibles.TANK_BOYS] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_BABY_SHOP},
	[CustomCollectibles.GUSTY_BLOOD] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_DEVIL, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.RED_BOMBER] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_BOMB_BUM, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.MOTHERS_LOVE] = {Encyclopedia.ItemPools.POOL_SHOP, Encyclopedia.ItemPools.POOL_BEGGAR, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.CAT_IN_A_BOX] = {Encyclopedia.ItemPools.POOL_TREASURE},
	[CustomCollectibles.BOOK_OF_GENESIS] = {Encyclopedia.ItemPools.POOL_ANGEL, Encyclopedia.ItemPools.POOL_LIBRARY},
	[CustomCollectibles.SCALPEL] = {Encyclopedia.ItemPools.POOL_DEMON_BEGGAR, Encyclopedia.ItemPools.POOL_RED_CHEST},
	[CustomCollectibles.KEEPERS_PENNY] = {Encyclopedia.ItemPools.POOL_SHOP, Encyclopedia.ItemPools.POOL_SECRET},
	[CustomCollectibles.NERVE_PINCH] = {Encyclopedia.ItemPools.POOL_TREASURE},
	[CustomCollectibles.BLOOD_VESSELS[1]] = {Encyclopedia.ItemPools.POOL_CURSE},
	[CustomCollectibles.SIBLING_RIVALRY] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_BABY_SHOP},
	[CustomCollectibles.RED_KING] = {Encyclopedia.ItemPools.POOL_DEVIL, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.STARGAZERS_HAT] = {Encyclopedia.ItemPools.POOL_TREASURE},
	[CustomCollectibles.BOTTOMLESS_BAG] = {Encyclopedia.ItemPools.POOL_SECRET, Encyclopedia.ItemPools.POOL_TREASURE},
	[CustomCollectibles.CROSS_OF_CHAOS] = {Encyclopedia.ItemPools.POOL_DEVIL, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.REJECTION] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_ROTTEN_BEGGAR},
	[CustomCollectibles.AUCTION_GAVEL] = {Encyclopedia.ItemPools.POOL_SHOP, Encyclopedia.ItemPools.POOL_CRANE_GAME, Encyclopedia.ItemPools.POOL_WOODEN_CHEST},
	[CustomCollectibles.SOUL_BOND] = {Encyclopedia.ItemPools.POOL_ANGEL},
	[CustomCollectibles.ANGELS_WINGS] = {Encyclopedia.ItemPools.POOL_ANGEL},
	[CustomCollectibles.HAND_ME_DOWNS] = {Encyclopedia.ItemPools.POOL_SHOP, Encyclopedia.ItemPools.POOL_BEGGAR},
	[CustomCollectibles.BOOK_OF_LEVIATHAN] = {Encyclopedia.ItemPools.POOL_LIBRARY},
	[CustomCollectibles.FRIENDLY_SACK] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_BABY_SHOP, Encyclopedia.ItemPools.POOL_BEGGAR},
	[CustomCollectibles.ULTRA_FLESH_KID] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_BABY_SHOP, Encyclopedia.ItemPools.POOL_ULTRA_SECRET},
	[CustomCollectibles.MAGIC_MARKER] = {Encyclopedia.ItemPools.POOL_SHOP, Encyclopedia.ItemPools.POOL_CRANE_GAME},
	[CustomCollectibles.VAULT_OF_HAVOC] = {Encyclopedia.ItemPools.POOL_TREASURE, Encyclopedia.ItemPools.POOL_ULTRA_SECRET, Encyclopedia.ItemPools.POOL_CURSE},
	[CustomCollectibles.PURE_SOUL] = {Encyclopedia.ItemPools.POOL_ANGEL},
	[CustomCollectibles.HANDICAPPED_PLACARD] = {Encyclopedia.ItemPools.POOL_SHOP},
	[CustomCollectibles.BOOK_OF_JUDGES] = {Encyclopedia.ItemPools.POOL_LIBRARY, Encyclopedia.ItemPools.POOL_ANGEL},
	[CustomCollectibles.BIRTH_CERTIFICATE] = {Encyclopedia.ItemPools.POOL_SHOP, Encyclopedia.ItemPools.POOL_SECRET}
}

local CardsWiki = {
	[CustomConsumables.SPINDOWN_DICE_SHARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Invokes the effect of Spindown Dice"},
		},
	},
	[CustomConsumables.RED_RUNE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Damages all enemies in a room, turns item pedestals into red permanent locusts and turns pickups into random locusts with a 50% chance"},
		},
	},
	[CustomConsumables.NEEDLE_AND_THREAD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "If you have broken hearts, removes one and grants one full heart container instead"},
		},
	},
	[CustomConsumables.QUEEN_OF_DIAMONDS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns 1-12 random coins"},
			{str = "Coins could be nickels or dimes too"}
		},
	},
	[CustomConsumables.KING_OF_SPADES] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Lose all your keys (but no more than 33) and spawn a number of pickups proportional to the amount of keys lost"},
			{str = "Can spawn an item or trinket with a certain chance that grows with the amount of keys and reaches 100% at 9 or 21 keys, respectively"},
			{str = "If Isaac has Golden key, it is removed too and significantly increases total value"},
		},
	},
	[CustomConsumables.KING_OF_CLUBS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Lose all your bombs (but no more than 33) and spawn a number of pickups proportional to the amount of bombs lost"},
			{str = "Can spawn an item or trinket with a certain chance that grows with the amount of bombs and reaches 100% at 9 or 21 bombs, respectively"},
			{str = "If Isaac has Golden bomb, it is removed too and significantly increases total value"},
		},
	},
	[CustomConsumables.KING_OF_DIAMONDS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Lose all your coins (but no more than 66) and spawn a number of pickups proportional to the amount of coins lost"},
			{str = "Can spawn an item or trinket with a certain chance that grows with the amount of coins and reaches 100% at 18 or 42 coins, respectively"},
		},
	},
	[CustomConsumables.BAG_TISSUE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "All pickups in a room are destroyed, and 8 most valuables pickups form an item quality based on their total weight, the item of such quality is then spawned"},
			{str = "The most valuable pickups are the rarest ones, e.g. eternal hearts or mega batteries"},
			{str = "Can freely be used in rooms that contain less than 8 pickups at once"},
		},
	},
	[CustomConsumables.JOKER_Q] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Teleports Isaac to a Black Market"},
		},
	},
	[CustomConsumables.UNO_REVERSE_CARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Invokes the effect of Glowing Hourglass"},
		},
	},
	[CustomConsumables.LOADED_DICE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Grants +10 Luck for the current room"},
		},
	},
	[CustomConsumables.BEDSIDE_QUEEN] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns 1-12 random keys "},
			{str = "There is a small chance to spawn a charged key"},
		},
	},
	[CustomConsumables.QUEEN_OF_CLUBS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns 1-12 random bombs "},
			{str = "There is a chance to spawn a double-pack bomb"},
		},
	},
	[CustomConsumables.JACK_OF_CLUBS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Bombs will drop more often from clearing rooms for current floor, and the average quality of bombs is increased"},
		},
	},
	[CustomConsumables.JACK_OF_DIAMONDS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Coins will drop more often from clearing rooms for current floor, and the average quality of coins is increased"},
		},
	},
	[CustomConsumables.JACK_OF_SPADES] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Keys will drop more often from clearing rooms for current floor, and the average quality of keys is increased"},
		},
	},
	[CustomConsumables.JACK_OF_HEARTS] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Hearts will drop more often from clearing rooms for current floor, and the average quality of hearts is increased"},
		},
	},
	[CustomConsumables.QUASAR_SHARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Damages all enemies in a room and turns every item pedestal into 3 Lemegeton wisps"},
		},
	},
	[CustomConsumables.BUSINESS_CARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Summons a random monster, like ones from Friend Finder"},
		},
	},
	[CustomConsumables.SACRIFICIAL_BLOOD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Gives +1.25 DMG up that depletes over the span of 20 seconds"},
			{str = "Heals you for one red heart if you have Ceremonial Robes "},
			{str = "Stackable. Damage depletes quicker the more Blood you used subsequently"},
		},
	},
	[CustomConsumables.LIBRARY_CARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Activates a random book effect"},
		},
	},
	[CustomConsumables.MOMS_ID] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Drops knives from above on all enemies, dealing 2x your damage"},
		},
	},
	[CustomConsumables.FUNERAL_SERVICES ] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns an Old Chest"},
		},
	},
	[CustomConsumables.ANTIMATERIAL_CARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Can be thrown similarly to Chaos Card"},
			{str = "If the card touches an enemy, that enemy is erased for the rest of the run"},
		},
	},
	[CustomConsumables.FIEND_FIRE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Sacrifice your consumables for mass room destruction"},
			{str = "3-20 total: enemies take 15 damage and burn for 4 seconds"},
			{str = "20-40 total: the initital damage, the burning damage and burning duration are doubled, destroys obstacles around you"},
			{str = "40+ total: the burning damage and burning duration are quadrupled, produces a Mama Mega explosion"},
		},
	},
	[CustomConsumables.DEMON_FORM] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Increases your damage by 0.2 for every new uncleared room you enter"},
			{str = "Increases your damage by 1 when entering a boss room"},
			{str = "The boost disappears when entering a new floor"},
		},
	},
	[CustomConsumables.VALENTINES_CARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Can be thrown similarly to Chaos Card"},
			{str = "Permanently charms all enemies that it passes through and drops a full red heart on use"},
		},
	},
	[CustomConsumables.SPIRITUAL_RESERVES] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns two ghostly orbital familiars that block enemy shots and shoot spectral tears that deal 2 damage each"},
			{str = "After blocking 3 shots, each ghost dies and drops half a soul heart"},
		},
	},
	[CustomConsumables.MIRRORED_LANDSCAPE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Your active item moves to the pocket slot"},
			{str = "If you've already had pocket active, it drops on a pedestal"},
			{str = "Does nothing if you don't have active items. Doesn't work with certain active items that don't function correctly in pocket slot"},
		},
	},
	[CustomConsumables.CURSED_CARD] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "For the current room, every hit of damage you would take is negated"},
			{str = "Instead, it gives you a broken heart and a permanent tears boost"},
		},
	},
	[CustomConsumables.CROWN_OF_GREED] = {
        {
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Spawns 1-2 golden pennies and grants -1 luck for each penny spawned"},
			{str = "Jewels have a 7.5% chance to be dropped when killing a sin miniboss (15% for Super version)"}
        },
	},
	[CustomConsumables.FLOWER_OF_LUST] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Allows you to restart the room and grants a better room reward for clearing it"},
			{str = "Jewels have a 7.5% chance to be dropped when killing a sin miniboss (15% for Super version)"}
		},
	},
	[CustomConsumables.ACID_OF_SLOTH] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Slows down all enemies by 50% and makes them leave poisonous gas clouds behind"},
			{str = "Jewels have a 7.5% chance to be dropped when killing a sin miniboss (15% for Super version)"}
		},
	},
	[CustomConsumables.VOID_OF_GLUTTONY] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "For 7 seconds, if you lack red health, you will regenerate it at the rate of 1 half a red heart per second, while also gaining -0.01 speed"},
			{str = "The duration of this effect is extended by 2 seconds each time you kill an enemy. There is no limit to how many times it can be extended"},
			{str = "Your speed stat goes back to normal after the effect ends"},
			{str = "Jewels have a 7.5% chance to be dropped when killing a sin miniboss (15% for Super version)"}
		},
	},
	[CustomConsumables.APPLE_OF_PRIDE] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Grants you a massive boost to all stats until you get hit"},
			{str = "Jewels have a 7.5% chance to be dropped when killing a sin miniboss (15% for Super version)"}
		},
	},
	[CustomConsumables.CANINE_OF_WRATH] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Every enemy in a room explodes, taking 15 damage "},
			{str = "The explosion can hurt you too"},
			{str = "Every enemy that dies from the explosion will give you a temporary damage boost"},
			{str = "Jewels have a 7.5% chance to be dropped when killing a sin miniboss (15% for Super version)"}
		},
	},
	[CustomConsumables.MASK_OF_ENVY] = {
		{
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "Turns all your heart containers into bone hearts filled with rotten hearts"},                
			{str = "Jewels have a 7.5% chance to be dropped when killing a sin miniboss (15% for Super version)"}
		},
	},
}

local spriteToCard = {
	[CustomConsumables.SPINDOWN_DICE_SHARD] = "Spindown Dice Shard",
	[CustomConsumables.RED_RUNE] = "Red Rune",
	[CustomConsumables.NEEDLE_AND_THREAD] = "Needle and Thread",
	[CustomConsumables.QUEEN_OF_DIAMONDS] = "Queen of Diamonds",
	[CustomConsumables.KING_OF_SPADES] = "King of Spades",
	[CustomConsumables.KING_OF_CLUBS] = "King of Clubs",
	[CustomConsumables.KING_OF_DIAMONDS] = "King of Diamonds",
	[CustomConsumables.BAG_TISSUE] = "Bag Tissue",
	[CustomConsumables.JOKER_Q] = "Joker?",
	[CustomConsumables.UNO_REVERSE_CARD] = "Reverse Card",
	[CustomConsumables.LOADED_DICE] = "Loaded Dice",
	[CustomConsumables.BEDSIDE_QUEEN] = "Bedside Queen",
	[CustomConsumables.QUEEN_OF_CLUBS] = "Queen of Clubs",
	[CustomConsumables.JACK_OF_CLUBS] = "Jack of Clubs",
	[CustomConsumables.JACK_OF_DIAMONDS] = "Jack of Diamonds",
	[CustomConsumables.JACK_OF_SPADES] = "Jack of Spades",
	[CustomConsumables.JACK_OF_HEARTS] = "Jack of Hearts",
	[CustomConsumables.QUASAR_SHARD] = "Quasar Shard",
	[CustomConsumables.BUSINESS_CARD] = "Business Card",
	[CustomConsumables.SACRIFICIAL_BLOOD] = "Sacrificial Blood",
	[CustomConsumables.LIBRARY_CARD] = "Library Card",
	[CustomConsumables.ANTIMATERIAL_CARD] = "Antimaterial Card",
	[CustomConsumables.FUNERAL_SERVICES] = "Funeral Services",
	[CustomConsumables.MOMS_ID] = "Mom's ID",
	[CustomConsumables.FIEND_FIRE] = "Fiend Fire",
	[CustomConsumables.DEMON_FORM] = "Demon Form",
	[CustomConsumables.VALENTINES_CARD] = "Valentine's Card",
	[CustomConsumables.SPIRITUAL_RESERVES] = "Spectral Reserves",
	[CustomConsumables.MIRRORED_LANDSCAPE] = "Mirrored Landscape",
	[CustomConsumables.CURSED_CARD] = "Cursed Card",
	[CustomConsumables.CROWN_OF_GREED ] = "Crown of Greed",
	[CustomConsumables.FLOWER_OF_LUST] = "Flower of Lust",
	[CustomConsumables.ACID_OF_SLOTH] = "Acid of Sloth",
	[CustomConsumables.VOID_OF_GLUTTONY] = "Void of Gluttony",
	[CustomConsumables.APPLE_OF_PRIDE] = "Apple of Pride",
	[CustomConsumables.CANINE_OF_WRATH] = "Canine of Wrath",
	[CustomConsumables.MASK_OF_ENVY] = "Mask of Envy"
}

-- DO NOT touch that! 
-- Just fill in the Wiki and itemPools tables with the desired item's entry, and it will show up in the Encyclopedia
for i = CustomCollectibles.ORDINARY_LIFE, CustomCollectibles.SIBLING_RIVALRY do
	Encyclopedia.AddItem({Class = "Repentance Plus", ID = i, WikiDesc = ItemsWiki[i], Pools = itemPools[i]})
	--Isaac.DebugString('Item ' .. tostring(i) .. 's entry succesfully loaded into the encyclopedia')
end

for i = CustomTrinkets.BASEMENT_KEY, CustomTrinkets.EMPTY_PAGE do
	Encyclopedia.AddTrinket({Class = "Repentance Plus", ID = i, WikiDesc = TrinketsWiki[i]})
end

for i = CustomPills.ESTROGEN, CustomPills.YUCK do
	Encyclopedia.AddPill({Class = "Repentance Plus", ID = i, WikiDesc = PillsWiki[i], Color = PillsColors[i]})
end

for i = CustomConsumables.RED_RUNE, CustomConsumables.JACK_OF_HEARTS do
	Encyclopedia.AddCard({Class = "Repentance Plus", ID = i, WikiDesc = CardsWiki[i], 
	Sprite = Encyclopedia.RegisterSprite("content/gfx/ui_cardfronts.anm2", tostring(spriteToCard[i]))})
end