//
//  EventAmountCalculatorTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class EventAmountCalculatorTests: XCTestCase {

    func testCalculateProgress_withIntValue() {

        var eventData = EventData(eventType: .harvestCrop)
        eventData.addData(type: .cropType, value: 100)

        let calculator = EventAmountCalculator(dataType: .cropType)

        let progress = calculator.calculateProgress(from: eventData)

        XCTAssertEqual(progress, 100.0)
    }

    func testCalculateProgress_withFloatValue() {

        var eventData = EventData(eventType: .harvestCrop)
        eventData.addData(type: .cropType, value: Float(75.5))

        let calculator = EventAmountCalculator(dataType: .cropType)

        let progress = calculator.calculateProgress(from: eventData)

        XCTAssertEqual(progress, 75.5)
    }

    func testCalculateProgress_withDoubleValue() {

        var eventData = EventData(eventType: .harvestCrop)
        eventData.addData(type: .cropType, value: Double(200.5))

        let calculator = EventAmountCalculator(dataType: .cropType)

        let progress = calculator.calculateProgress(from: eventData)

        XCTAssertEqual(progress, 200.5)
    }

    func testCalculateProgress_withInvalidValue() {

        var eventData = EventData(eventType: .harvestCrop)
        eventData.addData(type: .cropType, value: "invalid")

        let calculator = EventAmountCalculator(dataType: .cropType)

        let progress = calculator.calculateProgress(from: eventData)

        XCTAssertEqual(progress, 0.0)
    }
}
