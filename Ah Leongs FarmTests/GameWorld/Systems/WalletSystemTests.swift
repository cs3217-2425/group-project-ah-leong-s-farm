//
//  WalletSystemTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class WalletSystemTests: XCTestCase {

    var walletSystem: WalletSystem?
    var manager: EntityManager?

    override func setUp() {
        super.setUp()
        manager = EntityManager()
        walletSystem = WalletSystem(for: manager!)
        manager?.addEntity(GameState(maxTurns: 30))
    }

    override func tearDown() {
        walletSystem = nil
        manager = nil
        super.tearDown()
    }

    private func validateSetup() -> WalletSystem? {
        guard let system = walletSystem else {
            XCTFail("Test setup failed: Missing walletSystem")
            return nil
        }
        return system
    }

    func testInit_createsWalletSystem() {
        let system = WalletSystem(for: EntityManager())
        XCTAssertNotNil(system)
    }

    func testAddCurrencyToAll_positiveValue_addsCurrencyToAllWallets() {
        walletSystem?.addCurrencyToAll(.coin, amount: 200.0)

        guard let component = manager?.getSingletonComponent(ofType: WalletComponent.self) else {
            XCTFail("WalletComponent not found")
            return
        }

        XCTAssertEqual(component.getAmount(of: .coin), 300.0)
    }

    func testAddCurrencyToAll_zeroValue_addsNothingToAllWallets() {
        walletSystem?.addCurrencyToAll(.coin, amount: 0)

        guard let component = manager?.getSingletonComponent(ofType: WalletComponent.self) else {
            XCTFail("WalletComponent not found")
            return
        }

        XCTAssertEqual(component.getAmount(of: .coin), 100.0)
    }

    func testAddCurrencyToAll_negativeValue_addsNothingToAllWallets() {
        walletSystem?.addCurrencyToAll(.coin, amount: -0.5)

        guard let component = manager?.getSingletonComponent(ofType: WalletComponent.self) else {
            XCTFail("WalletComponent not found")
            return
        }

        XCTAssertEqual(component.getAmount(of: .coin), 100.0)

    }

    func testRemovesCurrencyToAll_sufficientCurrency_removesCurrencyFromAllWallets() {
        walletSystem?.removeCurrencyFromAll(.coin, amount: 50.0)

        guard let component = manager?.getSingletonComponent(ofType: WalletComponent.self) else {
            XCTFail("WalletComponent not found")
            return
        }

        XCTAssertEqual(component.getAmount(of: .coin), 50.0)
    }

    func testRemovesCurrencyToAll_zeroCurrency_removesCurrencyFromAllWallets() {
        walletSystem?.removeCurrencyFromAll(.coin, amount: 0)

        guard let component = manager?.getSingletonComponent(ofType: WalletComponent.self) else {
            XCTFail("WalletComponent not found")
            return
        }

        XCTAssertEqual(component.getAmount(of: .coin), 100.0)
    }

    func testRemovesCurrencyToAll_insufficientCurrency_removesNothingFromAllWallets() {
        walletSystem?.removeCurrencyFromAll(.coin, amount: 150.0)

        guard let component = manager?.getSingletonComponent(ofType: WalletComponent.self) else {
            XCTFail("WalletComponent not found")
            return
        }

        XCTAssertEqual(component.getAmount(of: .coin), 100.0)
    }

    func testRemovesCurrencyToAll_negativeCurrency_removesNothingFromAllWallets() {
        walletSystem?.removeCurrencyFromAll(.coin, amount: -10.0)

        guard let component = manager?.getSingletonComponent(ofType: WalletComponent.self) else {
            XCTFail("WalletComponent not found")
            return
        }

        XCTAssertEqual(component.getAmount(of: .coin), 100.0)
    }
}
