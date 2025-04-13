//
//  RewardXPComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

import Foundation

class RewardXPComponent: ComponentAdapter, RewardComponent {

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

extension RewardXPComponent {
    func accept(visitor: RewardDataRetrievalVisitor) -> [RewardViewModel] {
        visitor.retrieveData(component: self)
    }
}
