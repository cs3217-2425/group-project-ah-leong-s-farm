//
//  MarketConfig.swift
//  Ah Leongs Farm
//
//  Created by proglab on 30/3/25.
//

class MarketInformation {
    static let initialItemPrices: [EntityType: Price] = [
        BokChoySeed.type: Price(buyPrice: [.coin: 5.0], sellPrice: [.coin: 3.0]),
        AppleSeed.type: Price(buyPrice: [.coin: 10.0], sellPrice: [.coin: 6.0]),
        Apple.type: Price(buyPrice: [.coin: 5.0], sellPrice: [.coin: 3.0]),
        BokChoy.type: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0]),
        PotatoSeed.type: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0]),
        Potato.type: Price(buyPrice: [.coin: 20.0], sellPrice: [.coin: 15.0]),
        Fertiliser.type: Price(buyPrice: [.coin: 10.0], sellPrice: [.coin: 5.0]),
        PremiumFertiliser.type: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0]),
        SolarPanel.type: Price(buyPrice: [.coin: 35.0], sellPrice: [.coin: 30.0])
    ]

    static let initialItemStocks: [EntityType: Int] = [
        BokChoySeed.type: 999,
        AppleSeed.type: 999,
        BokChoy.type: 999,
        Apple.type: 999,
        PotatoSeed.type: 999,
        Potato.type: 999,
        Fertiliser.type: 999,
        PremiumFertiliser.type: 999,
        SolarPanel.type: 999
    ]

    static let sellableItems: Set<EntityType> = [
        BokChoySeed.type,
        AppleSeed.type,
        BokChoy.type,
        PotatoSeed.type,
        Apple.type,
        Potato.type,
        Fertiliser.type,
        PremiumFertiliser.type,
        SolarPanel.type
    ]
}
