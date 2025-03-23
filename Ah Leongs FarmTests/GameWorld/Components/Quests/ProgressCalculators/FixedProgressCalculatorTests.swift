//
//  FixedProgressCalculatorTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class FixedProgressCalculatorTests: XCTestCase {

    func testCalculateProgress_withDefaultAmount() {

        let calculator = FixedProgressCalculator()
        let eventData = EventData(eventType: .endTurn)

        let progress = calculator.calculateProgress(from: eventData)

        XCTAssertEqual(progress, 1.0)
    }

    func testCalculateProgress_withCustomAmount() {

        let calculator = FixedProgressCalculator(amount: 5.5)
        let eventData = EventData(eventType: .endTurn)

        let progress = calculator.calculateProgress(from: eventData)

        XCTAssertEqual(progress, 5.5)
    }
}
