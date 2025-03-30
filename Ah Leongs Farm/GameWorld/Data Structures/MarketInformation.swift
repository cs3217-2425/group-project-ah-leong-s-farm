//
//  MarketConfig.swift
//  Ah Leongs Farm
//
//  Created by proglab on 30/3/25.
//

class MarketInformation {
    static let initialItemPrices: [ItemType: Price] = [
        .bokChoySeed: Price(buyPrice: [.coin: 5.0], sellPrice: [.coin: 3.0]),
        .appleSeed: Price(buyPrice: [.coin: 10.0], sellPrice: [.coin: 6.0]),
        .bokChoyHarvested: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0])
    ]

    static let initialItemStocks: [ItemType: Int] = [
        .bokChoySeed: Int.max,
        .appleSeed: 20,
        .bokChoyHarvested: Int.max
    ]

    static let sellableItems: Set<ItemType> = [
        .bokChoySeed,
        .appleSeed,
        .bokChoyHarvested
    ]
}
