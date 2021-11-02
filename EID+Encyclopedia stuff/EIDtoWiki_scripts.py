# EID to Wiki description

EID = """EID:addCard(PocketItems.SDDSHARD, "Invokes the effect of Spindown Dice")
	EID:addCard(PocketItems.REDRUNE, "Damages all enemies in a room, turns item pedestals into red locusts and turns pickups into random locusts with a 50% chance")
	EID:addCard(PocketItems.NEEDLEANDTHREAD, "Removes one broken heart and grants one {{Heart}} heart container")
	EID:addCard(PocketItems.QUEENOFDIAMONDS, "Spawns  1-12 random {{Coin}} coins (those can be nickels or dimes as well)")
	EID:addCard(PocketItems.KINGOFSPADES, "Lose all your keys and spawn a number of pickups proportional to the amount of keys lost #At least 12 {{Key}} keys is needed for a trinket, and at least 28 for an item #If Isaac has {{GoldenKey}} Golden key, it is removed too and significantly increases total value")
	EID:addCard(PocketItems.KINGOFCLUBS, "Lose all your bombs and spawn a number of pickups proportional to the amount of bombs lost #At least 12 {{Bomb}} bombs is needed for a trinket, and at least 28 for an item #If Isaac has {{GoldenBomb}} Golden bomb, it is removed too and significantly increases total value")
	EID:addCard(PocketItems.KINGOFDIAMONDS, "Lose all your coins and spawn a number of pickups proportional to the amount of coins lost #At least 12 {{Coin}} coins is needed for a trinket, and at least 28 for an item")
	EID:addCard(PocketItems.BAGTISSUE, "All pickups in a room are destroyed, and 8 most valuables pickups form an item quality based on their total weight; the item of such quality is then spawned #The most valuable pickups are the rarest ones, e.g. {{EthernalHeart}} Eternal hearts or {{Battery}} Mega batteries #{{Warning}} If used in a room with less then 8 pickups, no item will spawn!")
	EID:addCard(PocketItems.RJOKER, "Teleports Isaac to a {{SuperSecretRoom}} Black Market")
	EID:addCard(PocketItems.REVERSECARD, "Invokes the effect of Glowing Hourglass")
	EID:addCard(PocketItems.LOADEDDICE, "{{ArrowUp}}  grants 10 Luck for the current room")
	EID:addCard(PocketItems.BEDSIDEQUEEN, "Spawns 1-12 random {{Key}} keys #There is a small chance to spawn a charged key")
	EID:addCard(PocketItems.QUEENOFCLUBS, "Spawns 1-12 random {{Bomb}} bombs #There is a small chance to spawn a double-pack bomb")
	EID:addCard(PocketItems.JACKOFCLUBS, "Bombs will drop more often from clearing rooms for current floor, and the average quality of bombs is increased")
	EID:addCard(PocketItems.JACKOFDIAMONDS, "Coins will drop more often from clearing rooms for current floor, and the average quality of coins is increased")
	EID:addCard(PocketItems.JACKOFSPADES, "Keys will drop more often from clearing rooms for current floor, and the average quality of keys is increased")
	EID:addCard(PocketItems.JACKOFHEARTS, "Hearts will drop more often from clearing rooms for current floor, and the average quality of hearts is increased")
	EID:addCard(PocketItems.QUASARSHARD, "Damages all enemies in a room and turns every item pedestal into 3 Lemegeton wisps")
	EID:addCard(PocketItems.BUSINESSCARD, "Summons a random monster, like ones from Friend Finder")
	EID:addCard(PocketItems.SACBLOOD, "{{ArrowUp}} Gives +1 DMG up that depletes over the span of 25 seconds #Stackable #{{ArrowUp}} Heals you for one red heart if you have Ceremonial Robes #{{Warning}} Damage depletes quicker the more Blood you used subsequently")
	EID:addCard(PocketItems.LIBRARYCARD, "Activates a random book effect")"""

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


