//
//  EntityManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 25/3/25.
//

/// EntityManager is responsible for managing all entities and their components.
/// It provides an interface for systems to query entities with specific components.
class EntityManager {
    private var entities: [EntityID: Entity] = [:]
    private var componentsByType: [String: [EntityID: Component]] = [:]

    func addEntity(_ entity: Entity) {
        let entityID = entity.id
        entities[entityID] = entity

        for component in entity.allComponents {
            registerComponent(component, for: entity)
        }
    }

    func addEntities(_ entities: [Entity]) {
        for entity in entities {
            addEntity(entity)
        }
    }

    func removeEntity(_ entity: Entity) {
        let entityID = entity.id
        entities.removeValue(forKey: entityID)

        for (key, _) in componentsByType {
            componentsByType[key]?.removeValue(forKey: entityID)

            if componentsByType[key]?.isEmpty == true {
                componentsByType.removeValue(forKey: key)
            }
        }
    }

    func addComponent(_ component: Component, to entity: Entity) {
        entity.attachComponent(component)
        registerComponent(component, for: entity)
    }

    func removeComponent<T: Component>(ofType type: T.Type, from entity: Entity) {
        if let component = entity.getComponentByType(ofType: type) {
            unregisterComponent(component, for: entity)
        }
        entity.detachComponent(ofType: type)
    }

    func getAllComponents<T: Component>(ofType type: T.Type) -> [T] {
        let componentTypeName = String(describing: type)
        guard let componentsDict = componentsByType[componentTypeName] else {
            return []
        }

        return componentsDict.values.compactMap { $0 as? T }
    }

    func getSingletonComponent<T: Component>(ofType type: T.Type) -> T? {
        let componentTypeName = String(describing: type)
        guard let componentsDict = componentsByType[componentTypeName] else {
            return nil
        }
        if componentsDict.values.count > 1 {
            fatalError("More than one component of \(componentTypeName) has been created!")
        }
        return componentsDict.values.first as? T
    }

    func getEntities<T: Component>(withComponentType type: T.Type) -> [Entity] {
        let componentTypeName = String(describing: type)
        guard let componentsDict = componentsByType[componentTypeName] else {
            return []
        }

        return Array(componentsDict.keys.compactMap {
            entities[$0]
        })
    }

    func getEntities(withComponentTypes types: [Component.Type]) -> [Entity] {
        guard !types.isEmpty else {
            return Array(entities.values)
        }

        var result: [Entity] = []

        for i in 0..<types.count {
            let currentType = types[i]
            let entitiesWithCurrentType = getEntities(withComponentType: currentType)
            result += entitiesWithCurrentType
        }

        return result
    }

    func getAllEntities() -> [Entity] {
        Array(entities.values)
    }

    func getEntitiesByType(_ type: EntityType) -> [Entity] {
        entities.values.filter {
            $0.type == type
        }
    }

    // MARK: - Private Helper Methods

    private func registerComponent(_ component: Component, for entity: Entity) {
        let componentType = type(of: component)
        let componentTypeName = String(describing: componentType)
        let entityID = entity.id

        if componentsByType[componentTypeName] == nil {
            componentsByType[componentTypeName] = [:]
        }

        componentsByType[componentTypeName]?[entityID] = component
    }

    private func unregisterComponent(_ component: Component, for entity: Entity) {
        let componentType = type(of: component)
        let componentTypeName = String(describing: componentType)
        let entityID = entity.id

        componentsByType[componentTypeName]?[entityID] = nil
    }
}
