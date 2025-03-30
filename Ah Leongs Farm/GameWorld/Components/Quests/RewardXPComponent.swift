//
//  RewardXPComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

import GameplayKit

class RewardXPComponent: GKComponent, RewardComponent {

    let amount: Float

    init(amount: Float) {
        self.amount = amount
        super.init()
    }

    func processReward(with queuer: RewardEventQueuer) {
        queuer.queueRewardEvent(component: self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
