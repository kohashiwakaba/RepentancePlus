# EID to Wiki description

EID = """EID:addCollectible(CustomCollectibles.VAULT_OF_HAVOC, "Passively stores killed enemies; can be used as soon as 12 enemies are stored #Upon use, brings you into a special room with 12 most recently killed enemies; clearing the room spawns a reward based on total HP of spawned enemies")"""

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


