//
//  QuestTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

final class QuestTests: XCTestCase {

    func testQuestInitialization() {

        let reward = Reward(rewards: [])
        let objective = QuestObjective(
            description: "Test Objective",
            criteria: QuestCriteria(eventType: .plantCrop, progressCalculator: FixedProgressCalculator(amount: 1)),
            target: 10
        )
        let questComponent = QuestComponent(title: "Test Quest", objectives: [objective], reward: reward)

        let quest = Quest(questComponent: questComponent)

        XCTAssertEqual(quest.questComponent.title, "Test Quest")
        XCTAssertEqual(quest.questComponent.objectives.count, 1)

        let retrievedComponent = quest.component(ofType: QuestComponent.self)
        XCTAssertNotNil(retrievedComponent)
        XCTAssertTrue(retrievedComponent === questComponent)
    }
}
