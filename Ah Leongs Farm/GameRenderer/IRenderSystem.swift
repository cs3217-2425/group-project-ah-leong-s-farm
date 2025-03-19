import GameplayKit

protocol IRenderSystem {
    typealias EntityType = GKEntity

    func createNode(of entity: EntityType) -> IRenderNode?
}
