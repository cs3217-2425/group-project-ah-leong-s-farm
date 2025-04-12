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
    let itemType: ItemTypeNew
}

struct SellItemViewModel {
    let name: String
    let imageName: String
    let sellPrice: Double
    let quantity: Int
    let itemType: ItemTypeNew
}

protocol MarketDataHandler {
    func getBuyItemViewModels() -> [BuyItemViewModel]
    func getSellItemViewModels() -> [SellItemViewModel]
    func buyItem(itemType: ItemTypeNew, quantity: Int, currency: CurrencyType)
    func sellItem(itemType: ItemTypeNew, quantity: Int, currency: CurrencyType)
    func getAmountOfCurrencyForMarket(_ currency: CurrencyType) -> Double
}
