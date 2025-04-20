//
//  RewardPointsComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/4/25.
//
import Foundation

class RewardPointsComponent: ComponentAdapter, RewardComponent {
    let amount: Int

    init(amount: Int) {
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

extension RewardPointsComponent {
    func accept(visitor: RewardDataRetrievalVisitor) -> [RewardViewModel] {
        visitor.retrieveData(component: self)
    }
}
