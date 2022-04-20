# EID to Wiki description

EID = """EID:addCard(CustomConsumables.CROWN_OF_GREED , "Spawns 1-2 golden pennies and grants {{ArrowDown}}-1 luck for each penny spawned")
	EID:addCard(CustomConsumables.FLOWER_OF_LUST, "Allows you to restart the room and grants a better room reward for clearing it")
	EID:addCard(CustomConsumables.ACID_OF_SLOTH, "Slows down all enemies by 40% and makes them leave poisonous creep behind")
	EID:addCard(CustomConsumables.VOID_OF_GLUTTONY, "Consumes all enemies in a room #Depending on their total health, either grants you a heart containter or makes you spit them back as a Cyst enemy")
	EID:addCard(CustomConsumables.APPLE_OF_PRIDE, "Grants you a massive boost to all stats until you get hit")
	EID:addCard(CustomConsumables.CANINE_OF_WRATH, "Every enemy in a room explodes, taking 15 damage #{{Warning}}The explosion can hurt you too #Every enemy that dies from the explosion will give you a temporary damage boost")
	EID:addCard(CustomConsumables.MASK_OF_ENVY, "#{{ArrowUp}}Tears up #Turns all your heart containers into bone hearts filled with rotten heart and moves them to after soul hearts")"""

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
    print('\t\t{str = "Jewels have a 7.5\% chance to be dropped when killing a sin miniboss (15\% for Super version)"}')
    print('\t},')
    print('},')

# Item pools to Wiki item pools

for description in EID.split('\n'):
    itemID = description[description.find('(') + 1:description.find(',')]
    
    print('[' + itemID + '] = {Encyclopedia.ItemPools.},')


