//
//  BuyItemViewModel.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//

struct BuyItemViewModel {
    let name: String
    let imageName: String
    let buyPrice: Double
    let quantity: Int
    let itemType: ItemType
}

struct SellItemViewModel {
    let name: String
    let imageName: String
    let sellPrice: Double
    let quantity: Int
    let itemType: ItemType
}

protocol MarketDataHandler {
    func getBuyItemViewModels() -> [BuyItemViewModel]
    func getSellItemViewModels() -> [SellItemViewModel]
    func buyItem(itemType: ItemType, quantity: Int, currency: CurrencyType)
    func sellItem(itemType: ItemType, quantity: Int, currency: CurrencyType)
    func getAmountOfCurrencyForMarket(_ currency: CurrencyType) -> Double
}
