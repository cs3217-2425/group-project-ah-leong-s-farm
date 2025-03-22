//
//  Seed+CropMap.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 21/3/25.
//

// Seed to Crop mapping
let seedToCrop: [ItemType: CropType] = [
    .appleSeed: .apple,
    .bokChoySeed: .bokChoy,
    .potatoSeed: .potato
]

// Crop to Harvested Plant mapping
let cropToHarvested: [CropType: ItemType] = [
    .apple: .appleHarvested,
    .bokChoy: .bokChoyHarvested,
    .potato: .potatoHarvested
]
