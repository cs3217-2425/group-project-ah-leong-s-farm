//
//  GameWorld.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class GameWorld {

    private(set) var entities: Set<GKEntity> = []
    private var systems: [any ISystem] = []

    func addEntity(_ entity: GKEntity) {
        entities.insert(entity)
        for system in systems {
            system.addComponent(foundIn: entity)
        }
    }

    func removeEntity(_ entity: GKEntity) {
        entities.remove(entity)
        for system in systems {
            system.removeComponent(foundIn: entity)
        }
    }

    func addSystem(_ system: ISystem) {
        systems.append(system)

        for entity in entities {
            system.addComponent(foundIn: entity)
        }
    }

    func removeSystem(_ system: ISystem) {
        systems.removeAll(where: { $0 === system })
    }

    func updateSystems(deltaTime: TimeInterval) {
        for system in systems {
            system.update(deltaTime: deltaTime)
        }
    }
}

extension GameWorld: EventContext {
    func getSystem<T>(ofType: T.Type) -> T? {
        return systems.first { $0 is T } as? T
    }
}
