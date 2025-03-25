//
//  BokChoy.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation
import GameplayKit

class BokChoy: GKEntity {
    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let cropComponent = CropComponent(cropType: .bokChoy)
        addComponent(cropComponent)

        let healthComponent = HealthComponent()
        addComponent(healthComponent)
    }
}
