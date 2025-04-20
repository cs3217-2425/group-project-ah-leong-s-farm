//
//  QuestComponentTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class QuestComponentTests: XCTestCase {

    struct MockQuestCriteria: QuestCriteria {
        let value: Float

        func calculateValue(from eventData: EventData) -> Float {
            value
        }
    }

    func testQuestComponent_initialState() {
        let objective = QuestObjective(description: "Plant 5 crops",
                                       criteria: MockQuestCriteria(value: 5.0), target: 10.0)
        let prerequisites: [QuestID] = []
        let quest = QuestComponent(title: "Farming Quest", objectives: [objective],
                                  prerequisites: prerequisites, order: 1)

        XCTAssertEqual(quest.title, "Farming Quest")
        XCTAssertEqual(quest.status, .inactive)
        XCTAssertEqual(quest.objectives.count, 1)
        XCTAssertEqual(quest.prerequisites.count, 0)
        XCTAssertFalse(quest.isCompleted)
    }

    func testQuestComponent_isCompleted_false() {
        var objective = QuestObjective(description: "Plant 5 crops",
                                       criteria: MockQuestCriteria(value: 5.0),
                                       target: 10.0)
        objective.progress += 5.0
        let prerequisites: [QuestID] = []

        let quest = QuestComponent(title: "Farming Quest", objectives: [objective],
                                  prerequisites: prerequisites, order: 1)
        XCTAssertFalse(quest.isCompleted)
    }

    func testQuestComponent_isCompleted_true() {
        var objective1 = QuestObjective(description: "Plant 5 crops",
                                        criteria: MockQuestCriteria(value: 5.0), target: 5.0)
        var objective2 = QuestObjective(description: "Harvest 3 crops",
                                        criteria: MockQuestCriteria(value: 3.0),
                                        target: 3.0)

        objective1.progress = 5.0
        objective2.progress = 3.0
        let prerequisites: [QuestID] = []

        let quest = QuestComponent(title: "Farming Quest", objectives: [objective1, objective2],
                                  prerequisites: prerequisites, order: 1)
        XCTAssertTrue(quest.isCompleted)
    }

    func testQuestComponent_withPrerequisites() {
        let objective = QuestObjective(description: "Plant 5 crops",
                                       criteria: MockQuestCriteria(value: 5.0), target: 10.0)
        let prerequisiteId = UUID()
        let prerequisites: [QuestID] = [prerequisiteId]

        let quest = QuestComponent(title: "Farming Quest", objectives: [objective],
                                  prerequisites: prerequisites, order: 1)

        XCTAssertEqual(quest.prerequisites.count, 1)
        XCTAssertEqual(quest.prerequisites.first, prerequisiteId)
    }

    func testQuestComponent_withCustomId() {
        let objective = QuestObjective(description: "Plant 5 crops",
                                      criteria: MockQuestCriteria(value: 5.0), target: 10.0)
        let prerequisites: [QuestID] = []
        let customId = UUID()

        let quest = QuestComponent(title: "Farming Quest", objectives: [objective],
                                  prerequisites: prerequisites, order: 1, id: customId)

        XCTAssertEqual(quest.id, customId)
    }
}
