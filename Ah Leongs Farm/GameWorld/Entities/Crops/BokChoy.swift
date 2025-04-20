//
//  BokChoy.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation

class BokChoy: EntityAdapter, Crop {
    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let cropComponent = CropComponent()
        attachComponent(cropComponent)

        let healthComponent = HealthComponent()
        attachComponent(healthComponent)

        let yieldComponent = YieldComponent(maxYield: 5)
        attachComponent(yieldComponent)
    }
}
