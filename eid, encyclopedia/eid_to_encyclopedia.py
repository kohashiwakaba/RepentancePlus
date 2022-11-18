# EID to Wiki description

EID = """EID:addTrinket(mod.CustomTrinkets.CRACKED_CROSS, "When entering a new room, one random enemy will be crippled")
	EID:addTrinket(mod.CustomTrinkets.MY_SOUL, "Spawns one permanent orbital ghost that shoot bullets and can block projectiles")
	EID:addTrinket(mod.CustomTrinkets.JEWEL_DIADEM, "Removes the negative effect of using a Sinful Jewel, if it has one")"""

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
'''
for description in EID.split('\n'):
    itemID = description[description.find('(') + 1:description.find(',')]
    
    print('[' + itemID + '] = {Encyclopedia.ItemPools.},')
'''


