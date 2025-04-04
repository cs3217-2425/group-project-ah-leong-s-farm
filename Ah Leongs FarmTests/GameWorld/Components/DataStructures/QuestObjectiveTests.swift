//
//  QuestObjectiveTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

import XCTest
@testable import Ah_Leongs_Farm

final class QuestObjectiveTests: XCTestCase {

    struct MockQuestCriteria: QuestCriteria {
        let value: Float
        
        func calculateValue(from eventData: EventData) -> Float {
            return value
        }
    }

    func testQuestObjective_initialState() {
        let criteria = MockQuestCriteria(value: 5.0)
        let objective = QuestObjective(description: "Plant 5 crops", criteria: criteria, target: 10.0)

        XCTAssertEqual(objective.progress, 0.0)
        XCTAssertFalse(objective.isCompleted)
    }

    func testQuestObjective_progressUpdate_notCompleted() {
        var objective = QuestObjective(description: "Plant 5 crops", criteria: MockQuestCriteria(value: 5.0), target: 10.0)

        objective.progress += 5.0
        XCTAssertEqual(objective.progress, 5.0)
        XCTAssertFalse(objective.isCompleted)
    }

    func testQuestObjective_progressUpdate_completed() {
        var objective = QuestObjective(description: "Plant 10 crops", criteria: MockQuestCriteria(value: 10.0), target: 10.0)

        objective.progress += 10.0
        XCTAssertEqual(objective.progress, 10.0)
        XCTAssertTrue(objective.isCompleted)
    }
}
