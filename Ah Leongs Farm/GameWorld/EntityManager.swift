//
//  EntityManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 25/3/25.
//

import GameplayKit

/// EntityManager is responsible for managing all entities and their components.
/// It provides an interface for systems to query entities with specific components.
class EntityManager {
    private typealias EntityID = ObjectIdentifier
    private(set) var entities: Set<GKEntity> = []
    private var componentsByType: [String: [EntityID: GKComponent]] = [:]

    func addEntity(_ entity: GKEntity) {
        entities.insert(entity)

        for component in entity.components {
            registerComponent(component, for: entity)
        }
    }

    func removeEntity(_ entity: GKEntity) {
        entities.remove(entity)

        let entityID = ObjectIdentifier(entity)
        for (_, var componentsDict) in componentsByType {
            componentsDict.removeValue(forKey: entityID)
        }
    }

    func addComponent(_ component: GKComponent, to entity: GKEntity) {
        entity.addComponent(component)
        registerComponent(component, for: entity)
    }

    func removeComponent<T: GKComponent>(ofType type: T.Type, from entity: GKEntity) {
        if let component = entity.component(ofType: type) {
            unregisterComponent(component, for: entity)
        }
        entity.removeComponent(ofType: type)
    }

    func getAllComponents<T: GKComponent>(ofType type: T.Type) -> [T] {
        let componentTypeName = String(describing: type)
        guard let componentsDict = componentsByType[componentTypeName] else {
            return []
        }

        return componentsDict.values.compactMap { $0 as? T }
    }

    func getSingletonComponent<T: GKComponent>(ofType type: T.Type) -> T? {
        let componentTypeName = String(describing: type)
        guard let componentsDict = componentsByType[componentTypeName] else {
            return nil
        }
        if componentsDict.values.count > 1 {
            fatalError("More than one component of \(componentTypeName) has been created!")
        }
        return componentsDict.values.first as? T
    }

    func getEntities<T: GKComponent>(withComponentType type: T.Type) -> [GKEntity] {
        let componentTypeName = String(describing: type)
        guard let componentsDict = componentsByType[componentTypeName] else {
            return []
        }

        return Array(componentsDict.keys.compactMap { entityID in
            entities.first { ObjectIdentifier($0) == entityID }
        })
    }

    func getEntities(withComponentTypes types: [GKComponent.Type]) -> [GKEntity] {
        guard !types.isEmpty else {
            return Array(entities)
        }

        var result: [GKEntity] = []

        for i in 0..<types.count {
            let currentType = types[i]
            let entitiesWithCurrentType = getEntities(withComponentType: currentType)
            result += entitiesWithCurrentType
        }

        return result
    }

    func getAllEntities() -> [GKEntity] {
        Array(entities)
    }

    // MARK: - Private Helper Methods

    private func registerComponent(_ component: GKComponent, for entity: GKEntity) {
        let componentType = type(of: component)
        let componentTypeName = String(describing: componentType)
        let entityID = ObjectIdentifier(entity)

        if componentsByType[componentTypeName] == nil {
            componentsByType[componentTypeName] = [:]
        }

        componentsByType[componentTypeName]?[entityID] = component
    }

    private func unregisterComponent(_ component: GKComponent, for entity: GKEntity) {
        let componentType = type(of: component)
        let componentTypeName = String(describing: componentType)
        let entityID = ObjectIdentifier(entity)

        componentsByType[componentTypeName]?[entityID] = nil
    }
}
