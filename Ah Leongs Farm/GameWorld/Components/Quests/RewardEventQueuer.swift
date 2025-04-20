//
//  RewardEventQueuer.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

protocol RewardEventQueuer {
    func queueRewardEvent(component: RewardXPComponent)
    func queueRewardEvent(component: RewardCurrencyComponent)
    func queueRewardEvent(component: RewardItemComponent)
    func queueRewardEvent(component: RewardPointsComponent)
}
