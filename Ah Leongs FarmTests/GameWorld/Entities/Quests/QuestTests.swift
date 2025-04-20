//
//  QuestTests.swift
//  Ah Leongs Farm
//
//  Created by proglab on 23/3/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class QuestTests: XCTestCase {

    func testQuestInitialization() {
        let questComponent = QuestComponent(
            title: "Test Quest",
            objectives: [],
            prerequisites: [],
            order: 1
        )
        let rewardComponent = MockRewardComponent()

        let quest = Quest(questComponent: questComponent, rewardComponents: [rewardComponent])

        XCTAssertNotNil(quest.component(ofType: QuestComponent.self))
        XCTAssertNotNil(quest.component(ofType: MockRewardComponent.self))
    }
}

class MockRewardComponent: ComponentAdapter, RewardComponent {
    func processReward(with queuer: RewardEventQueuer) {
        // Mock implementation
    }

    func accept(visitor: RewardDataRetrievalVisitor) -> [RewardViewModel] {
        return []
    }
}
