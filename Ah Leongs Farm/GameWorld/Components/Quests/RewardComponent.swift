//
//  RewardComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

protocol RewardComponent where Self: ComponentAdapter {
    func processReward(with queuer: RewardEventQueuer)
    func accept(visitor: RewardDataRetrievalVisitor) -> [RewardViewModel]
}
