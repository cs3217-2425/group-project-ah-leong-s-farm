//
//  RewardComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

import GameplayKit

protocol RewardComponent where Self: GKComponent {
    func processReward(with queuer: RewardEventQueuer)
}
