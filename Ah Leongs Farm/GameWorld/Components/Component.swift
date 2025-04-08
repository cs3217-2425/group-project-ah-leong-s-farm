//
//  Component.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 8/4/25.
//

import GameplayKit

protocol Component: AnyObject {
    var ownerEntity: (Entity)? { get }
}

extension GKComponent: Component {
    var ownerEntity: (Entity)? {
        self.entity
    }
}
