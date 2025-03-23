//
//  QuestComponentTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class QuestComponentTests: XCTestCase {

    func testInitialization() {
        let reward = Reward(rewards: [])
        let objective = QuestObjective(
            description: "Plant 20 Crops",
            criteria: QuestCriteria(
                eventType: .plantCrop,
                progressCalculator: FixedProgressCalculator(amount: 1)
            ),
            target: 20
        )

        let quest = QuestComponent(title: "Crop Planting", objectives: [objective], reward: reward)

        XCTAssertEqual(quest.title, "Crop Planting")
        XCTAssertEqual(quest.status, .active)
        XCTAssertEqual(quest.objectives.count, 1)
        XCTAssertFalse(quest.isCompleted)
    }

    func testQuestCompletion_allObjectivesCompleted() {
        let reward = Reward(rewards: [])

        var objective1 = QuestObjective(
            description: "Plant 20 Crops",
            criteria: QuestCriteria(
                eventType: .plantCrop,
                progressCalculator: FixedProgressCalculator(amount: 1)
            ),
            target: 20
        )

        var objective2 = QuestObjective(
            description: "Survive 5 Days",
            criteria: QuestCriteria(
                eventType: .endTurn,
                progressCalculator: FixedProgressCalculator(amount: 1)
            ),
            target: 5
        )

        objective1.progress = 20
        objective2.progress = 5

        let quest = QuestComponent(title: "Survival Training", objectives: [objective1, objective2], reward: reward)

        XCTAssertTrue(quest.isCompleted, "Quest should be completed when all objectives are completed")
    }

    func testQuestCompletion_oneObjectiveIncomplete() {
        let reward = Reward(rewards: [])

        var objective1 = QuestObjective(
            description: "Plant 20 Crops",
            criteria: QuestCriteria(
                eventType: .plantCrop,
                progressCalculator: FixedProgressCalculator(amount: 1)
            ),
            target: 20
        )

        var objective2 = QuestObjective(
            description: "Survive 5 Days",
            criteria: QuestCriteria(
                eventType: .endTurn,
                progressCalculator: FixedProgressCalculator(amount: 1)
            ),
            target: 5
        )

        objective1.progress = 20
        objective2.progress = 4

        let quest = QuestComponent(title: "Survival Training", objectives: [objective1, objective2], reward: reward)

        XCTAssertFalse(quest.isCompleted)
    }

    func testQuestCompletion_withEventAmountCalculator() {
        let eventType = EventType.harvestCrop
        let eventDataType = EventDataType.cropType
        let eventCalculator = EventAmountCalculator(dataType: eventDataType)

        var eventData = EventData(eventType: eventType)
        eventData.addData(type: eventDataType, value: 20)

        let questCriteria = QuestCriteria(eventType: eventType, progressCalculator: eventCalculator)
        let objective = QuestObjective(description: "Harvest 20 Crops",
                                       criteria: questCriteria,
                                       target: 20.0)

        let quest = QuestComponent(title: "Crop Collection",
                                   objectives: [objective],
                                   reward: Reward(rewards: []))

        let progressGained = eventCalculator.calculateProgress(from: eventData)
        quest.objectives[0].progress += progressGained

        XCTAssertTrue(quest.isCompleted)
    }
}
