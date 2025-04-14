//
//  ItemToViewDataMap.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 13/4/25.
//

struct ItemToViewDataMap {
    static let itemTypeToImage: [EntityType: String] = [
        BokChoySeed.type: "bokchoy_seed",
        BokChoy.type: "bokchoy_harvested",
        AppleSeed.type: "apple_seed",
        Apple.type: "apple_harvested",
        PotatoSeed.type: "potato_seed",
        Potato.type: "potato_harvested",
        Fertiliser.type: "fertiliser",
        PremiumFertiliser.type: "premium_fertiliser"
    ]

    static let itemTypeToDisplayName: [EntityType: String] = [
        BokChoySeed.type: "Bokchoy seed",
        BokChoy.type: "Bokchoy",
        AppleSeed.type: "Apple seed",
        Apple.type: "Apple",
        PotatoSeed.type: "Potato seed",
        Potato.type: "Potato",
        Fertiliser.type: "Fertiliser",
        PremiumFertiliser.type: "Premium fertiliser"
    ]

}
