//
//  EventData.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

protocol EventData {
    var eventType: EventType { get }
}

struct EndTurnEventData: EventData {
    var eventType: EventType = .endTurn
    var endTurnCount: Int = 1
}

struct HarvestCropEventData: EventData {
    var eventType: EventType = .harvestCrop
    var type: CropType
    var quantity: Int
}

struct SellCropEventData: EventData {
    var eventType: EventType = .sellCrop
    var type: CropType
    var quantity: Int
}

struct RewardGrantEventData: EventData {
    var eventType: EventType = .rewardGrant
    var xpGrantAmount: Int = 0
    var currencyGrants: [CurrencyType: Double] = [:]
    var itemGrants: [ItemType: Int] = [:]
}
