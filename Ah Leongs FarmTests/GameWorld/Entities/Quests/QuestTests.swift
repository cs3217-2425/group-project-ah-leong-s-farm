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
            let questComponent = QuestComponent(title: "Test Quest", objectives: [], order: 1)
            let rewardComponent = MockRewardComponent()

            let quest = Quest(questComponent: questComponent, rewardComponents: [rewardComponent])

            XCTAssertNotNil(quest.component(ofType: QuestComponent.self))
            XCTAssertNotNil(quest.component(ofType: MockRewardComponent.self))
    }
}

class MockRewardComponent: ComponentAdapter, RewardComponent {
    func processReward(with queuer: any Ah_Leongs_Farm.RewardEventQueuer) {
    }

    func accept(visitor: any Ah_Leongs_Farm.RewardDataRetrievalVisitor) -> [any Ah_Leongs_Farm.RewardViewModel] {
        []
    }
}
