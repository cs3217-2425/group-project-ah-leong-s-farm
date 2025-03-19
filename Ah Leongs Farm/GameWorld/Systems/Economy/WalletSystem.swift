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
            addCurrencyToWallet(component, of: currency, amount: amount)
        }
    }

    func removeCurrencyFromAll(_ currency: CurrencyType, amount: Double) {
        for component in components {
            removeCurrencyFromWallet(component, of: currency, amount: amount)
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

    /// Adds a specific type of currency if and only if the currency type exists.
    /// - Parameter walletComponent: The wallet to add to.
    /// - Parameter currency: The type of currency to add.
    /// - Parameter amount: The amount to add, must be a non-negative value.
    private func addCurrencyToWallet(_ walletComponent: WalletComponent, of currency: CurrencyType,
                                     amount: Double) {
        var wallet = walletComponent.wallet
        guard let currentAmount = wallet[currency] else {
            return
        }

        guard amount >= 0 else {
            print("The amount to add must be positive.")
            return
        }

        let newAmount = currentAmount + amount
        wallet[currency] = newAmount
    }

    /// Removes a specific type of currency if and only if the currency type exists, and the specified
    /// amount is less than or equal to the amount of the currency type available.
    /// - Parameter walletComponent: The wallet to remove from.
    /// - Parameter currency: The type of currency to update.
    /// - Parameter amount: The amount to remove, must be a non-negative value.
    private func removeCurrencyFromWallet(_ walletComponent: WalletComponent, of currency: CurrencyType,
                                          amount: Double) {
        var wallet = walletComponent.wallet
        guard let currentAmount = wallet[currency] else {
            return
        }

        guard amount >= 0 else {
            print("The amount to remove must be positive.")
            return
        }

        guard currentAmount >= amount else {
            print("Insufficient currency.")
            return
        }

        let newAmount = currentAmount - amount
        wallet[currency] = newAmount
    }
}
