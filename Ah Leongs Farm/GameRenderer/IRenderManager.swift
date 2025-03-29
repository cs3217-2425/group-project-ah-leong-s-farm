import GameplayKit

protocol IRenderManager: AnyObject {
    associatedtype T: IRenderNode

    func createNode(of entity: EntityType) -> T?

    func transformNode(_ node: T, for entity: EntityType)
}

extension IRenderManager {
    func createNode(of entity: EntityType) -> T? {
        nil
    }

    func transformNode(_ node: T, for entity: EntityType) {
    }
}
