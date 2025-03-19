//
//  WalletComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 19/3/25.
//

import Foundation
import GameplayKit

class WalletComponent: GKComponent {
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    /// Adds a specific type of currency if and only if the currency type exists.
    /// - Parameter currency: The type of currency to add.
    /// - Parameter amount: The amount to add, must be a non-negative value.
    func addCurrency(_ currency: CurrencyType, amount: Double) {
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
    /// - Parameter currency: The type of currency to update
    /// - Parameter amount: The amount to remove, must be a non-negative value.
    func removeCurrency(_ currency: CurrencyType, amount: Double) {
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
