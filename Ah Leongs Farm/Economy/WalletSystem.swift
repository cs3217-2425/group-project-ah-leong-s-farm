//
//  WalletSystem.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 19/3/25.
//

import Foundation
import GameplayKit

class WalletSystem: GKComponentSystem<WalletComponent> {
    override init() {
        super.init(componentClass: WalletComponent.self)
    }

    func addCurrencyToAll(_ currency: CurrencyType, amount: Double) {
        for component in components {
            component.addCurrency(currency, amount: amount)
        }
    }

    func removeCurrencyFromAll(_ currency: CurrencyType, amount: Double) {
        for component in components {
            component.removeCurrency(currency, amount: amount)
        }
    }

    func getTotalAmount(of currency: CurrencyType) -> Double {
        var total: Double = 0.0

        for component in components {
            if let amount = component.getAmount(of: currency) {
                total += amount
            }
        }

        return total
    }
}
