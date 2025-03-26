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

struct HarvestCropEventData: EventData {
    var type: CropType
    var quantity: Int
}

struct SellCropEventData: EventData {
    var type: CropType
    var quantity: Int
}

struct RewardGrantEventData: EventData {
    var xpGrantAmount: Int = 0
    var currencyGrants: [CurrencyType: Double] = [:]
    var itemGrants: [ItemType: Int] = [:]
}
