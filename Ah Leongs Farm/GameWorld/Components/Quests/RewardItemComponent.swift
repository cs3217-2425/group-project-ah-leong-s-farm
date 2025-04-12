//
//  RewardItemComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

import Foundation

class RewardItemComponent: ComponentAdapter, RewardComponent {

    let itemTypes: [ItemType: Int]

    init(itemTypes: [ItemType: Int]) {
        self.itemTypes = itemTypes
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

extension RewardItemComponent {
    func accept(visitor: RewardDataRetrievalVisitor) -> [RewardViewModel] {
        visitor.retrieveData(component: self)
    }
}
