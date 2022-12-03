# EID to Wiki description

EID = """EID:addCollectible(mod.CustomCollectibles.WE_NEED_TO_GO_SIDEWAYS, "Passively spawns a special dirt patch in every secret room #{{Key}} If used elsewhere, bury all keys in a room #{{Card78}} If used on that dirt patch, dig up all buried keys as Cracked Keys")
	EID:addCollectible(mod.CustomCollectibles.DEAD_WEIGHT, "Throwable Forgotten's Body familiar #Shoots bones upwards if hits a wall #Blocks enemy projectiles")
	EID:addCollectible(mod.CustomCollectibles.KEEPERS_ANNOYING_FLY, "Orbital fly familiar #Block both enemy projectiles and Isaac's tears #Deals more contact damage to enemies the more tears it absorbs in a current room")"""

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


