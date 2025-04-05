//
//  WalletComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class WalletComponentTests: XCTestCase {
    func testInit_createsWalletComponent() {
        let walletComponent = WalletComponent()

        XCTAssertNotNil(walletComponent)
    }

    func testGetAmount_returnsCorrectAmount() {
        let walletComponent = WalletComponent()

        XCTAssertEqual(walletComponent.getAmount(of: .coin), 100.0)
    }

    func testGetAmountInBaseCurrency_returnsCorrectAmount() {
        let walletComponent = WalletComponent()

        XCTAssertEqual(walletComponent.getAmountInBaseCurrency(of: .coin), 100.0)
    }
}
