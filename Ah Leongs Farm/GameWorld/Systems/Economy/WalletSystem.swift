//
//  WalletSystem.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 19/3/25.
//

import Foundation

class WalletSystem: ISystem {
    unowned var manager: EntityManager?

    private var walletComponent: WalletComponent? {
        manager?.getSingletonComponent(ofType: WalletComponent.self)
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func addCurrencyToAll(_ currency: CurrencyType, amount: Double) {
        guard let walletComponent = walletComponent else {
            return
        }
        addCurrencyToWallet(walletComponent, of: currency, amount: amount)
    }

    func removeCurrencyFromAll(_ currency: CurrencyType, amount: Double) {
        guard let walletComponent = walletComponent else {
            return
        }
        removeCurrencyFromWallet(walletComponent, of: currency, amount: amount)
    }

    func getTotalAmount(of currency: CurrencyType) -> Double {
        guard let walletComponent = walletComponent else {
            return 0.0
        }
        var total: Double = 0.0
        if let amount = walletComponent.getAmount(of: currency) {
                total += amount
        }

        return total
    }

    /// Adds a specific type of currency if and only if the currency type exists.
    /// - Parameter walletComponent: The wallet to add to.
    /// - Parameter currency: The type of currency to add.
    /// - Parameter amount: The amount to add, must be a non-negative value.
    private func addCurrencyToWallet(_ walletComponent: WalletComponent, of currency: CurrencyType,
                                     amount: Double) {
        guard let currentAmount = walletComponent.wallet[currency] else {
            return
        }

        guard amount >= 0 else {
            return
        }

        let newAmount = currentAmount + amount
        walletComponent.wallet[currency] = newAmount
    }

    /// Removes a specific type of currency if and only if the currency type exists, and the specified
    /// amount is less than or equal to the amount of the currency type available.
    /// - Parameter walletComponent: The wallet to remove from.
    /// - Parameter currency: The type of currency to update.
    /// - Parameter amount: The amount to remove, must be a non-negative value.
    private func removeCurrencyFromWallet(_ walletComponent: WalletComponent, of currency: CurrencyType,
                                          amount: Double) {
        guard let currentAmount = walletComponent.wallet[currency] else {
            return
        }

        guard amount >= 0 else {
            return
        }

        guard currentAmount >= amount else {
            return
        }

        let newAmount = currentAmount - amount
        walletComponent.wallet[currency] = newAmount
    }
}
