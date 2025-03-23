//
//  QuestObjectiveTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

class QuestObjectiveTests: XCTestCase {

    func testInitialization() {
        let criteria = QuestCriteria(eventType: .endTurn, progressCalculator: FixedProgressCalculator(amount: 2.0))
        let questObjective = QuestObjective(description: "Survive 10 turns", criteria: criteria, target: 10.0)

        XCTAssertEqual(questObjective.description, "Survive 10 turns", "Description should be correctly assigned")
        XCTAssertEqual(questObjective.target, 10.0, "Target should be correctly assigned")
        XCTAssertEqual(questObjective.progress, 0.0, "Initial progress should be 0")
        XCTAssertFalse(questObjective.isCompleted, "Objective should not be completed at start")
    }

    func testProgressUpdate() {
        let criteria = QuestCriteria(eventType: .endTurn, progressCalculator: FixedProgressCalculator(amount: 2.0))
        var questObjective = QuestObjective(description: "Survive 5 turns",
                                            criteria: criteria,
                                            target: 5.0)

        questObjective.progress = 3.0

        XCTAssertEqual(questObjective.progress, 3.0)
        XCTAssertFalse(questObjective.isCompleted)
    }

    func testIsCompleted_whenProgressMeetsTarget() {
        let criteria = QuestCriteria(eventType: .harvestCrop, progressCalculator: FixedProgressCalculator(amount: 2.0))
        var questObjective = QuestObjective(description: "Harvest 20 crops",
                                            criteria: criteria,
                                            target: 20.0)

        questObjective.progress = 20.0

        XCTAssertTrue(questObjective.isCompleted)
    }

    func testIsCompleted_whenProgressExceedsTarget() {

        let criteria = QuestCriteria(eventType: .sellCrop, progressCalculator: FixedProgressCalculator(amount: 2.0))
        var questObjective = QuestObjective(description: "Sell 50 crops",
                                            criteria: criteria,
                                            target: 50.0)

        questObjective.progress = 60.0

        XCTAssertTrue(questObjective.isCompleted)
    }

    func testQuestObjectiveProgressWithEventAmountCalculator() {
        let eventType = EventType.harvestCrop
        let eventDataType = EventDataType.cropType
        let eventCalculator = EventAmountCalculator(dataType: eventDataType)

        var eventData = EventData(eventType: eventType)
        eventData.addData(type: eventDataType, value: 10)

        let questCriteria = QuestCriteria(eventType: eventType, progressCalculator: eventCalculator)
        var questObjective = QuestObjective(description: "Harvest 10 crops", criteria: questCriteria, target: 50.0)

        let progressGained = eventCalculator.calculateProgress(from: eventData)
        questObjective.progress += progressGained

        XCTAssertEqual(questObjective.progress, 10.0, "Progress should be updated to 10.0")
        XCTAssertFalse(questObjective.isCompleted, "Quest should not be completed yet")

        eventData.addData(type: eventDataType, value: 40)
        let additionalProgress = eventCalculator.calculateProgress(from: eventData)
        questObjective.progress += additionalProgress

        XCTAssertTrue(questObjective.isCompleted)
    }
}
