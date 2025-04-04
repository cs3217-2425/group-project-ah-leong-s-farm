//
//  RewardCurrencyComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

import GameplayKit

class RewardCurrencyComponent: GKComponent, RewardComponent {

    let currencies: [CurrencyType: Double]

    init(currencies: [CurrencyType: Double]) {
        self.currencies = currencies
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

extension RewardCurrencyComponent {
    func accept(visitor: RewardDataRetrievalVisitor) -> [RewardViewModel] {
        return visitor.retrieveData(component: self)
    }
}
