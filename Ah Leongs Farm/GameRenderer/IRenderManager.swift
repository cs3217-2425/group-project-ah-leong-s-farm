import GameplayKit

protocol IRenderManager {
    typealias EntityType = GKEntity

    func createNode(of entity: EntityType) -> IRenderNode?

    func updateNode(for node: inout IRenderNode, using entity: EntityType)
}
