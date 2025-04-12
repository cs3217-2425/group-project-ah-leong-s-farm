//
//  ItemToViewDataMap.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 13/4/25.
//

struct ItemToViewDataMap {
    static let itemTypeToImage: [ItemType: String] = [
        .bokChoySeed: "bokchoy_seed",
        .bokChoyHarvested: "bokchoy_harvested",
        .appleSeed: "apple_seed",
        .appleHarvested: "apple_harvested",
        .potatoSeed: "potato_seed",
        .potatoHarvested: "potato_harvested",
        .fertiliser: "fertiliser",
        .premiumFertiliser: "premium_fertiliser"
    ]

    static let itemTypeToDisplayName: [ItemType: String] = [
        .bokChoySeed: "Bokchoy seed",
        .bokChoyHarvested: "Bokchoy",
        .appleSeed: "Apple seed",
        .appleHarvested: "Apple",
        .potatoSeed: "Potato seed",
        .potatoHarvested: "Potato",
        .fertiliser: "Fertiliser",
        .premiumFertiliser: "Premium fertiliser"
    ]

}
