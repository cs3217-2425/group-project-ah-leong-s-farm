//
//  QuestCriteriaTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class QuestCriteriaTests: XCTestCase {

    func testInitialization_withDefaultRequiredData() {

        let mockCalculator = FixedProgressCalculator(amount: 2.0)
        let eventType: EventType = .endTurn

        let criteria = QuestCriteria(eventType: eventType, progressCalculator: mockCalculator)

        XCTAssertEqual(criteria.eventType, eventType)
        XCTAssertTrue(criteria.requiredData.isEmpty)
        XCTAssertEqual(criteria.progressCalculator.calculateProgress(from: EventData(eventType: eventType)), 2.0)
    }

    func testInitialization_withRequiredData() {

        let mockCalculator = FixedProgressCalculator(amount: 3.5)
        let eventType: EventType = .endTurn
        let requiredData: [EventDataType: any Hashable] = [.cropAmount: 100, .cropType: 50]

        let criteria = QuestCriteria(eventType: eventType,
                                     progressCalculator: mockCalculator,
                                     requiredData: requiredData)

        XCTAssertEqual(criteria.eventType, eventType)
        XCTAssertEqual(criteria.requiredData.count, 2)
        XCTAssertEqual(criteria.requiredData[.cropAmount] as? Int, 100)
        XCTAssertEqual(criteria.requiredData[.cropType] as? Int, 50)
    }

    func testProgressCalculator_withEventData() {
        let mockCalculator = EventAmountCalculator(dataType: .xpGrantAmount)
        let eventType: EventType = .harvestCrop
        let criteria = QuestCriteria(eventType: eventType, progressCalculator: mockCalculator)

        var eventData = EventData(eventType: eventType)
        eventData.addData(type: .xpGrantAmount, value: 200)

        let progress = criteria.progressCalculator.calculateProgress(from: eventData)

        XCTAssertEqual(progress, 200.0)
    }
}
