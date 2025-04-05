//
//  SellComponentTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 6/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class SellComponentTests: XCTestCase {

    func testInitialization() {
        let itemType: ItemType = .bokChoySeed
        let sellComponent = SellComponent(itemType: itemType)
        
        XCTAssertEqual(sellComponent.itemType, itemType)
        XCTAssertNotNil(sellComponent)
    }
}
