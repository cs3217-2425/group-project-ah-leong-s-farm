//
//  WalletComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 19/3/25.
//

import Foundation

class WalletComponent: ComponentAdapter {
    static let exchangeRate: [CurrencyType: Double] = [
        .coin: 1.0
    ]

    var wallet: [CurrencyType: Double]

    override init() {
        self.wallet = [
            .coin: 100.0
        ]

        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    func getAmount(of currency: CurrencyType) -> Double? {
        wallet[currency]
    }

    func getAmountInBaseCurrency(of currency: CurrencyType) -> Double? {
        guard let exchangeRate = WalletComponent.exchangeRate[currency] else {
            return nil
        }

        guard let amount = wallet[currency] else {
            return nil
        }

        return amount * exchangeRate
    }
}

enum CurrencyType {
    case coin
}
