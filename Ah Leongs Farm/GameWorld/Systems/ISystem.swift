import GameplayKit

protocol ISystem: AnyObject {
    var manager: EntityManager? { get set }
    // TODO: For systems to be able to queue events.
    // var eventQueueable: EventQueueable? { get set }

    init(for manager: EntityManager)
    func update(deltaTime: CGFloat)
}

extension ISystem {
    func update(deltaTime: CGFloat) { }
}
