import GameplayKit

protocol IRenderManager: AnyObject {
    associatedtype T: IRenderNode

    func createNode(of entity: EntityType) -> T?
}

extension IRenderManager {
    var renderNodeType: T.Type {
        T.self
    }
}
