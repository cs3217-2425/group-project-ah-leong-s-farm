import Foundation

protocol ISystem: AnyObject {
    var manager: EntityManager? { get set }

    init(for manager: EntityManager)
    func update(deltaTime: CGFloat)
}

extension ISystem {
    func update(deltaTime: CGFloat) { }
}
