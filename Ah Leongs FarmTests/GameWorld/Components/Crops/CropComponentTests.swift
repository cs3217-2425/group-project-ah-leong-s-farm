//
//  CropComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 3/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class CropComponentTests: XCTestCase {
    func testInit() {
        let cropComponent = CropComponent()

        XCTAssertNotNil(cropComponent)
    }
}
