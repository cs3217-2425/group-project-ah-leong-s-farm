//
//  GameWorld.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class GameWorld {
    typealias Entity = GKEntity
    typealias System = GKComponentSystem<GKComponent>

    private var entities: Set<Entity> = []
    private var systems: Set<System> = []

    func addEntity(_ entity: Entity) {
        entities.insert(entity)
        for system in systems {
            system.addComponent(foundIn: entity)
        }
    }

    func removeEntity(_ entity: Entity) {
        entities.remove(entity)
        for system in systems {
            system.removeComponent(foundIn: entity)
        }
    }

    func addSystem(_ system: System) {
        systems.insert(system)
    }

    func removeSystem(_ system: System) {
        systems.remove(system)
    }

}
