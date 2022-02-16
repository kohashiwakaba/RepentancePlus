# EID to Wiki description

EID = """EID:addCollectible(CustomCollectibles.MAGIC_MARKER, "Drops a random tarot card when picked up #On use, transform held tarot card by adding 1 to its number (or deducing 1 for reversed tarots)")
	EID:addCollectible(CustomCollectibles.ULTRA_FLESH_KID, "Familiar that chases enemies and deals contact damage, similar to Leech #Has 3 stages, collects red hearts to evolve #A total of 15 hearts needs to be collected to evolve")"""

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


