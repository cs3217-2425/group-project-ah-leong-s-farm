import GameplayKit

protocol ISystem: AnyObject {
    var componentClass: AnyClass { get }

    func addComponent(foundIn entity: GKEntity)

    func removeComponent(foundIn entity: GKEntity)

    func update(deltaTime seconds: TimeInterval)
}
