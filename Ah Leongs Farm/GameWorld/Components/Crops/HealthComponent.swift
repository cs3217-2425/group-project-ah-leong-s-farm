//
//  HealthComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class HealthComponent: ComponentAdapter {
    var health: Double
    let maxHealth: Double

    override init() {
        self.health = 1.0
        self.maxHealth = 1.0
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
