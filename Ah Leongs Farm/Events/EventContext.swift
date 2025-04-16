//
//  EventDispatcher.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/3/25.
//

protocol EventContext: AnyObject {
    func addEntity(_ entity: Entity)
    func addEntities(_ entities: [Entity])
    func removeEntity(_ entity: Entity)
    func getEntities(withComponentType type: Component.Type) -> [Entity]
    func getEntitiesOfType(_ type: EntityType) -> [Entity]
    func getSystem<T>(ofType: T.Type) -> T?
}
