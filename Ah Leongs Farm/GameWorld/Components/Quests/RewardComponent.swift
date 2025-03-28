//
//  RewardComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 29/3/25.
//

import GameplayKit

protocol RewardComponent {
    func processReward(with queuer: RewardEventQueuer)
}

extension RewardComponent where Self: GKComponent {
    
}
