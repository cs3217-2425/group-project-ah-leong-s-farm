//
//  EventData.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

protocol EventData {
}

protocol ErrorEventData: EventData {
    var title: String { get }
    var message: String { get }
}

struct EndTurnEventData: EventData {
    var endTurnCount: Int = 1
}

struct GameOverEventData: EventData {
    var score: Int
    var coins: Double
}

struct HarvestCropEventData: EventData {
    var cropType: EntityType
    var quantity: Int
}

struct XPGrantEventData: EventData {
    var xpGrantAmount: Float = 0
}

struct CurrencyGrantEventData: EventData {
    var currencyGrants: [CurrencyType: Double] = [:]
}

struct ItemGrantEventData: EventData {
    var itemGrants: [EntityType: Int] = [:]
}

struct BuyItemEventData: EventData {
    var itemType: EntityType
    var quantity: Int
}

struct SellItemEventData: EventData {
    var itemType: EntityType
    var quantity: Int
}

struct PlantCropEventData: EventData {
    var row: Int
    var column: Int
    var cropType: EntityType
    var isSuccessfullyPlanted: Bool
}

struct WaterPlotEventData: EventData {
    var row: Int
    var column: Int
    var isSuccessfullyWatered: Bool
}

struct AddPlotEventData: EventData {
    var row: Int
    var column: Int
    var isSuccessfullyAdded: Bool
}

struct QuestCompletedEventData: EventData {
    let questTitle: String
}

struct RazePlotEventData: EventData {
    var row: Int
    var column: Int
    var isSuccessfullyRazed: Bool
}

struct RemoveCropEventData: EventData {
    var row: Int
    var column: Int
    var isSuccessfullyRemoved: Bool
}

struct UseFertiliserEventData: EventData {
    var row: Int
    var column: Int
    var fertiliserType: EntityType
    var isSuccessful: Bool
}

struct LevelUpEventData: EventData {
    var newLevel: Int
}

struct InsufficientEnergyErrorEventData: ErrorEventData {
    var title: String = "No Energy"
    var message: String
}

struct AddSolarPanelEventData: EventData {

}
