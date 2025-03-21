//
//  WalletTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 21/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class WalletTests: XCTestCase {
    func testInit_createsWalletWithComponent() {
        let wallet = Wallet()

        XCTAssertNotNil(wallet)
        XCTAssertEqual(wallet.components.count, 1)
        XCTAssertNotNil(wallet.component(ofType: WalletComponent.self))
    }
}
