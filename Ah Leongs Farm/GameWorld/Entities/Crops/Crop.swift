//
//  Crop.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 27/3/25.
//

import Foundation
import GameplayKit

protocol Crop {
    var seedItemType: ItemType { get }
    var harvestedItemType: ItemType { get }
    var components: [GKComponent] { get }
    func update(deltaTime seconds: TimeInterval)
    func addComponent(_ component: GKComponent)
    func component<ComponentType>(ofType componentClass: ComponentType.Type) -> ComponentType?
        where ComponentType: GKComponent
    func removeComponent<ComponentType>(ofType componentClass: ComponentType.Type) where ComponentType: GKComponent
}
