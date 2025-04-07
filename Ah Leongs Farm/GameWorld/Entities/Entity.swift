//
//  Entity.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 8/4/25.
//

import GameplayKit

typealias EntityID = ObjectIdentifier

protocol Entity: AnyObject, Hashable {
    var id: EntityID { get }
    func addComponent(_ component: Component)
    func removeComponent(ofType type: Component.Type)
    func component<T: Component>(ofType type: T.Type) -> T?
    var allComponents: [Component] { get }
}

extension GKEntity: Entity {

    var id: EntityID {
        ObjectIdentifier(self)
    }

    func addComponent(_ component: Component) {
        if let gkComponent = component as? GKComponent {
            self.addComponent(gkComponent)
        }
    }
    
    func removeComponent(ofType type: Component.Type) {
        if let gkType = type as? GKComponent.Type {
            self.removeComponent(ofType: type)
        }
    }
    
    func component<T: Component>(ofType type: T.Type) -> T? {
        guard let gkType = type as? GKComponent.Type else {
            return nil
        }
        return self.component(ofType: type)
    }
    
    var allComponents: [any Component] {
        self.components
    }
}
