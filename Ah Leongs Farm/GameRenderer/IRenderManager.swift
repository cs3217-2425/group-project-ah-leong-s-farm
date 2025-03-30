import GameplayKit

protocol IRenderManager: AnyObject {
    func createNode(for entity: EntityType, in renderer: GameRenderer)

    func transformNode(_ node: IRenderNode, for entity: EntityType, in renderer: GameRenderer)
}

extension IRenderManager {
    func createNode(for entity: EntityType, in renderer: GameRenderer) {
    }

    func transformNode(_ node: IRenderNode, for entity: EntityType, in renderer: GameRenderer) {
    }
}
