//
//  MarketConfig.swift
//  Ah Leongs Farm
//
//  Created by proglab on 30/3/25.
//

class MarketInformation {
    static let initialItemPrices: [ItemTypeNew: Price] = [
        .bokChoySeed: Price(buyPrice: [.coin: 5.0], sellPrice: [.coin: 3.0]),
        .appleSeed: Price(buyPrice: [.coin: 10.0], sellPrice: [.coin: 6.0]),
        .appleHarvested: Price(buyPrice: [.coin: 5.0], sellPrice: [.coin: 3.0]),
        .bokChoyHarvested: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0]),
        .potatoSeed: Price(buyPrice: [.coin: 15.0], sellPrice: [.coin: 10.0]),
        .potatoHarvested: Price(buyPrice: [.coin: 20.0], sellPrice: [.coin: 15.0])
    ]

    static let initialItemStocks: [ItemTypeNew: Int] = [
        .bokChoySeed: Int.max,
        .appleSeed: Int.max,
        .bokChoyHarvested: Int.max,
        .appleHarvested: Int.max,
        .potatoSeed: Int.max,
        .potatoHarvested: Int.max
    ]

    static let sellableItems: Set<ItemTypeNew> = [
        .bokChoySeed,
        .appleSeed,
        .bokChoyHarvested,
        .potatoSeed,
        .appleHarvested,
        .potatoHarvested
    ]
}
