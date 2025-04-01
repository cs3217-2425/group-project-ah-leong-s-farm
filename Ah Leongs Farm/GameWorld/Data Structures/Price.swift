//
//  Price.swift
//  Ah Leongs Farm
//
//  Created by proglab on 30/3/25.
//

struct Price {
    var buyPrice: [CurrencyType: Double]
    var sellPrice: [CurrencyType: Double]

    func buyPriceInCurrency(for currency: CurrencyType) -> Double? {
        buyPrice[currency]
    }

    func sellPriceInCurrency(for currency: CurrencyType) -> Double? {
        sellPrice[currency]
    }
}
