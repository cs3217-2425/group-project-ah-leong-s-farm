//
//  GameWorld.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 14/3/25.
//

import GameplayKit

class GameWorld {

    private let entityManager: EntityManager
    private var systems: [any ISystem] = []
    private var eventDispatcher: EventDispatcher?

    init() {
        self.entityManager = EntityManager()
        self.eventDispatcher = EventDispatcher(context: self, queueable: self)
        setUpSystems()
    }

    private func setUpSystems() {
        addSystem(EnergySystem(for: entityManager))
        addSystem(TurnSystem(for: entityManager))
        addSystem(WalletSystem(for: entityManager))
        addSystem(InventorySystem(for: entityManager))
        addSystem(LevelSystem(for: entityManager))
        addSystem(CropSystem(for: entityManager))
        addSystem(GridSystem(for: entityManager))
        addSystem(MarketSystem(for: entityManager))

        let questSystem = QuestSystem(for: entityManager, eventQueueable: self)
        addSystem(questSystem)
        registerEventObserver(questSystem)
    }

    func update(deltaTime: TimeInterval) {
        updateSystems(deltaTime: deltaTime)
        processEvents()
    }

    func addEntity(_ entity: GKEntity) {
        entityManager.addEntity(entity)
    }

    func removeEntity(_ entity: GKEntity) {
        entityManager.removeEntity(entity)
    }

    func getAllEntities() -> [GKEntity] {
        entityManager.getAllEntities()
    }

    func addSystem(_ system: ISystem) {
        systems.append(system)
    }

    func removeSystem(_ system: ISystem) {
        systems.removeAll(where: { $0 === system })
    }

    private func updateSystems(deltaTime: TimeInterval) {
        for system in systems {
            system.update(deltaTime: deltaTime)
        }
    }

    func registerEventObserver(_ observer: IEventObserver) {
        guard let eventDispatcher = eventDispatcher else {
            return
        }
        eventDispatcher.addEventObserver(observer)
    }

    private func processEvents() {
        guard let eventDispatcher = eventDispatcher else {
            return
        }
        eventDispatcher.processEvents()
    }
}

extension GameWorld: EventContext {
    func getSystem<T>(ofType: T.Type) -> T? {
        systems.first { $0 is T } as? T
    }
}

extension GameWorld: EventQueueable {
    func queueEvent(_ event: GameEvent) {
        guard let eventDispatcher = eventDispatcher else {
            return
        }
        eventDispatcher.queueEvent(event)
    }
}
