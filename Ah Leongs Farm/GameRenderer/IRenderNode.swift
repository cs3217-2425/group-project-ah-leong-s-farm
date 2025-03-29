//
//  Renderable.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 18/3/25.
//

import GameplayKit

/// A protocol representing a box type for `SKNode`.
///
/// This protocol is needed to provide a generic way to manage different types of `SKNode`
/// instances. By using an associated type, we can define a common interface for nodes
/// while allowing flexibility in the specific type of node being used.
protocol IRenderNode {
    associatedtype NodeType: SKNode
    var skNode: NodeType { get }
}

extension IRenderNode {
    var managedSKNodeType: NodeType.Type {
        NodeType.self
    }
}
