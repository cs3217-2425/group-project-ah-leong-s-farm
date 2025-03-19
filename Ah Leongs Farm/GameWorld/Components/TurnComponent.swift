//
//  EnergyComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import GameplayKit

class TurnComponent: GKComponent {
    var currentTurn: Int
    var maxTurns: Int

    required init?(coder: NSCoder) {
        currentTurn = 1
        maxTurns = 30
        super.init(coder: coder)
    }

    init(maxTurns: Int) {
        self.currentTurn = 1
        self.maxTurns = maxTurns
        super.init()
    }

}
