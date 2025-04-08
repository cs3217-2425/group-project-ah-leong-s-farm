//
//  Entity.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 8/4/25.
//

import GameplayKit

typealias EntityID = ObjectIdentifier

protocol Entity: AnyObject {
    var id: EntityID { get }
    func addComponent(_ component: Component)
    func removeComponentByType(ofType type: Component.Type)
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

    func removeComponentByType(ofType componentType: Component.Type) {
        guard let gkType = componentType as? GKComponent.Type else {
            return
        }
        self.removeComponent(ofType: gkType)
    }

    func component<T: Component>(ofType componentType: T.Type) -> T? {
        let filteredComponent = allComponents.first {
            type(of: $0) == componentType
        }

        return filteredComponent as? T
    }

    var allComponents: [any Component] {
        self.components
    }
}
