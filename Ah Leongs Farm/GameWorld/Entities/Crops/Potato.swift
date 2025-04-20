//
//  Potato.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation

class Potato: EntityAdapter, Crop {
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
    }
}
