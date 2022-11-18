# Small script I used for rendering card icons in EID.
# table taken from Encyclopedia, since I needed to use it to match cards to their cardfront sprites there too.

pickups = '''[CustomConsumables.FUNERAL_SERVICES_Q] = "Funeral Services?",
[CustomConsumables.DARK_REMNANTS] = "Dark Remnants"'''

for line in pickups.split('\n'):
    entry = line[line.find('[') + len('[CustomConsumables.'):line.find(']')]
    cardfront = line[line.find('\"') + 1:line.find('\",')]
    #print(entry, cardfront)
    name = entry + "_CARDFRONT"

    print(f"local {name} = Sprite()")
    print(f"{name}:Load(\"gfx/ui/eid_cardfronts.anm2\", true)")
    print("EID:addIcon(\"Card\"..mod.CustomConsumables." + entry + ", \"" + cardfront + "\", 0, 9, 9, 0.5, 1.5, " + name + ")")
    print()