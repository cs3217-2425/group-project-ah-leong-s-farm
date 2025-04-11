//
//  MarketConfig.swift
//  Ah Leongs Farm
//
//  Created by proglab on 30/3/25.
//

class MarketInformation {
    static let initialSeedPrices: [EntityType: Price] = [
        BokChoy.type: Price(buyPrice: [.coin: 5.0], sellPrice: [.coin: 3.0]),
        Apple.type: Price(buyPrice: [.coin: 5.0], sellPrice: [.coin: 3.0]),
        Potato.type: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0])
    ]

    static let initialHarvestedPrices: [EntityType: Price] = [
        BokChoy.type: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0]),
        Apple.type: Price(buyPrice: [.coin: 10.0], sellPrice: [.coin: 6.0]),
        Potato.type: Price(buyPrice: [.coin: 20.0], sellPrice: [.coin: 15.0])
    ]

    static let initialSeedStocks: [EntityType: Int] = [
        BokChoy.type: Int.max,
        Apple.type: Int.max,
        Potato.type: Int.max
    ]
    static let initialHarvestedStocks: [EntityType: Int] = [
        BokChoy.type: Int.max,
        Apple.type: Int.max,
        Potato.type: Int.max
    ]
}
