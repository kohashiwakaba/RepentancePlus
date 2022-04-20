# Small script I used for rendering card icons in EID.
# table taken from Encyclopedia, since I needed to use it to match cards to their cardfront sprites there too.

pickups = '''[CustomConsumables.SPINDOWN_DICE_SHARD] = "Spindown Dice Shard",
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
[CustomConsumables.MASK_OF_ENVY] = "Mask of Envy",'''

for line in pickups.split('\n'):
    entry = line[line.find('[') + len('[CustomConsumables.'):line.find(']')]
    cardfront = line[line.find('\"') + 1:line.find('\",')]
    #print(entry, cardfront)
    name = entry + "_CARDFRONT"

    print(f"local {name} = Sprite()")
    print(f"{name}:Load(\"gfx/ui/eid_cardfronts.anm2\", true)")
    print("EID:addIcon(\"Card\"..CustomConsumables." + entry + ", \"" + cardfront + "\", 0, 9, 9, 0.5, 1.5, " + name + ")")
    print()