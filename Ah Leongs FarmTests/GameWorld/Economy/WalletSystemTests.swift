//
//  WalletSystemTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class WalletSystemTests: XCTestCase {
    var walletSystem = WalletSystem()
    var walletComponents: [WalletComponent] = []

    override func setUpWithError() throws {
        walletSystem = WalletSystem()
        walletComponents.append(WalletComponent())
        walletComponents.append(WalletComponent())

        for component in walletComponents {
            walletSystem.addComponent(component)
        }
    }

    override func tearDownWithError() throws {
        walletComponents = []
    }

    func testInit_createsWalletSystem() {
        let walletSystem = WalletSystem()

        XCTAssertNotNil(walletSystem)
    }

    func testAddCurrencyToAll_positiveValue_addsCurrencyToAllWallets() {
        walletSystem.addCurrencyToAll(.coin, amount: 200.0)

        for component in walletComponents {
            XCTAssertEqual(component.getAmount(of: .coin), 300.0)
        }
    }

    func testAddCurrencyToAll_zeroValue_addsNothingToAllWallets() {
        walletSystem.addCurrencyToAll(.coin, amount: 0)

        for component in walletComponents {
            XCTAssertEqual(component.getAmount(of: .coin), 100.0)
        }
    }

    func testAddCurrencyToAll_negativeValue_addsNothingToAllWallets() {
        walletSystem.addCurrencyToAll(.coin, amount: -0.5)

        for component in walletComponents {
            XCTAssertEqual(component.getAmount(of: .coin), 100.0)
        }
    }

    func testRemovesCurrencyToAll_sufficientCurrency_removesCurrencyFromAllWallets() {
        walletSystem.removeCurrencyFromAll(.coin, amount: 50.0)

        for component in walletComponents {
            XCTAssertEqual(component.getAmount(of: .coin), 50.0)
        }
    }

    func testRemovesCurrencyToAll_zeroCurrency_removesCurrencyFromAllWallets() {
        walletSystem.removeCurrencyFromAll(.coin, amount: 0)

        for component in walletComponents {
            XCTAssertEqual(component.getAmount(of: .coin), 100.0)
        }
    }

    func testRemovesCurrencyToAll_insufficientCurrency_removesNothingFromAllWallets() {
        walletSystem.removeCurrencyFromAll(.coin, amount: 150.0)

        for component in walletComponents {
            XCTAssertEqual(component.getAmount(of: .coin), 100.0)
        }
    }

    func testRemovesCurrencyToAll_negativeCurrency_removesNothingFromAllWallets() {
        walletSystem.removeCurrencyFromAll(.coin, amount: -10.0)

        for component in walletComponents {
            XCTAssertEqual(component.getAmount(of: .coin), 100.0)
        }
    }
}
