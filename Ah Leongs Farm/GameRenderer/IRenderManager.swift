protocol IRenderManager: AnyObject {
    func createNode(for entity: Entity, in renderer: GameRenderer)

    func transformNode(_ node: IRenderNode, for entity: Entity, in renderer: GameRenderer)
}

extension IRenderManager {
    func createNode(for entity: Entity, in renderer: GameRenderer) {
    }

    func transformNode(_ node: IRenderNode, for entity: Entity, in renderer: GameRenderer) {
    }
}
