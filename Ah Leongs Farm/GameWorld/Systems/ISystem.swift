import GameplayKit

protocol ISystem: AnyObject {
    func addComponent(foundIn entity: GKEntity)

    func removeComponent(foundIn entity: GKEntity)

    func update(deltaTime seconds: TimeInterval)
}
