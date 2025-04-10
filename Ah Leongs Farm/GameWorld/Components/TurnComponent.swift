//
//  EnergyComponent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 19/3/25.
//

import GameplayKit

class TurnComponent: GKComponent {
    private var _currentTurn: Int
    private var _maxTurns: Int

    var currentTurn: Int {
        get {
            _currentTurn
        }
        set {
            _currentTurn = max(1, newValue)
        }
    }

    var maxTurns: Int {
        get {
            _maxTurns
        }
        set {
            _maxTurns = max(1, newValue)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init(maxTurns: Int) {
        self._maxTurns = max(1, maxTurns)
        self._currentTurn = 1
        super.init()
    }
}
