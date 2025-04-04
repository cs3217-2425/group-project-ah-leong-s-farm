//
//  EventData.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

protocol EventData {
}

struct EndTurnEventData: EventData {
    var endTurnCount: Int = 1
}

struct GameOverEventData: EventData {
    var score: Int
    var coins: Double
}

struct HarvestCropEventData: EventData {
    var type: CropType
    var quantity: Int
}

struct SellCropEventData: EventData {
    var type: CropType
    var quantity: Int
}

struct XPGrantEventData: EventData {
    var xpGrantAmount: Float = 0
}

struct CurrencyGrantEventData: EventData {
    var currencyGrants: [CurrencyType: Double] = [:]
}

struct ItemGrantEventData: EventData {
    var itemGrants: [ItemType: Int] = [:]
}

struct BuyItemEventData: EventData {
    var itemType: ItemType
    var quantity: Int
}

struct SellItemEventData: EventData {
    var itemType: ItemType
    var quantity: Int
}

struct PlantCropEventData: EventData {
    var cropType: CropType
    var isSuccessfullyPlanted: Bool
}
