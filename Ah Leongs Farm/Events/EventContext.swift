//
//  EventDispatcher.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/3/25.
//

protocol EventContext: AnyObject {
    func getEntitiesOfType(_ type: EntityType) -> [Entity]
    func getSystem<T>(ofType: T.Type) -> T?
}
