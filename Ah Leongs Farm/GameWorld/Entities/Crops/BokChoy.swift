//
//  BokChoy.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 25/3/25.
//

import Foundation
import GameplayKit

class BokChoy: GKEntity, Crop {
    var seedItemType: ItemType = .bokChoySeed
    var harvestedItemType: ItemType = .bokChoyHarvested

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

        let persistenceComponent = PersistenceComponent(visitor: self)
        addComponent(persistenceComponent)
    }

    static func createSeed() -> GKEntity {
        let bokChoy = BokChoy()
        bokChoy.addComponent(SeedComponent())
        return bokChoy
    }
}

extension BokChoy: PersistenceVisitor {
    func visitPersistenceManager(manager: PersistenceManager) {
        manager.save(bokChoy: self)
    }
}
