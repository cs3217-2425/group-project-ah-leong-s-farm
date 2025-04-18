//
//  HealthComponent.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class HealthComponent: ComponentAdapter {
    var health: Double

    init(health: Double) {
        self.health = health
        super.init()
    }

    override convenience init() {
        self.init(health: 1.0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
