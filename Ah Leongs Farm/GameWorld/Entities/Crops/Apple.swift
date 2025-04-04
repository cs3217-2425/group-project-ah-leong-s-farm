//
//  Apple.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import Foundation
import GameplayKit

class Apple: GKEntity, Crop {
    var seedItemType: ItemType = .appleSeed
    var harvestedItemType: ItemType = .appleHarvested

    override init() {
        super.init()
        setUpComponents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setUpComponents() {
        let cropComponent = CropComponent(cropType: .apple)
        addComponent(cropComponent)

        let healthComponent = HealthComponent()
        addComponent(healthComponent)
    }

    static func createSeed() -> GKEntity {
        let apple = Apple()
        apple.addComponent(SeedComponent())
        return apple
    }
}
