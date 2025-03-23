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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(maxTurns: Int) {
        self.currentTurn = 1
        self.maxTurns = maxTurns
        super.init()
    }

}
