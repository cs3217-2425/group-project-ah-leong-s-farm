import GameplayKit

protocol IRenderManager {
    associatedtype T = IRenderNode
    typealias EntityType = GKEntity

    var entityNodeMap: [ObjectIdentifier: T] { get }

    func createNode(of entity: EntityType, in scene: SKScene)

    func removeNode(of entityIdentifier: ObjectIdentifier, in scene: SKScene)
}

extension IRenderManager {
    var renderNodeType: T.Type {
        T.self
    }

    func render(entities: Set<EntityType>, in scene: SKScene) {
        let entitiesToRender = getEntitiesToRender(entities: entities)
        let entityIdentifiersToRemove = getEntityIdentifiersToRemove(entities: entities)

        for entity in entitiesToRender {
            createNode(of: entity, in: scene)
        }

        for entityIdentifier in entityIdentifiersToRemove {
            removeNode(of: entityIdentifier, in: scene)
        }
    }

    func getEntitiesToRender(entities: Set<EntityType>) -> Set<EntityType> {
        entities.filter { entity in
            entityNodeMap[ObjectIdentifier(entity)] == nil
        }
    }

    func getEntityIdentifiersToRemove(entities: Set<EntityType>) -> Set<ObjectIdentifier> {
        let entityIdentifiers = entities.map( ObjectIdentifier.init )

        return Set(entityNodeMap.keys.filter { entityIdentifier in
            !entityIdentifiers.contains(entityIdentifier)
        })
    }
}
