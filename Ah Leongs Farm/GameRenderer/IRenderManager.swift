import GameplayKit

<<<<<<< Updated upstream
protocol IRenderManager: AnyObject {
    func createNode(for entity: EntityType, in renderer: GameRenderer)

    func transformNode(_ node: IRenderNode, for entity: EntityType, in renderer: GameRenderer)
}

extension IRenderManager {
    func createNode(for entity: EntityType, in renderer: GameRenderer) {
    }

    func transformNode(_ node: IRenderNode, for entity: EntityType, in renderer: GameRenderer) {
    }
=======
protocol IRenderManager {
    typealias EntityType = GKEntity

    func createNode(of entity: EntityType) -> IRenderNode?

    func updateNode(for node: inout IRenderNode, using entity: EntityType)
>>>>>>> Stashed changes
}
