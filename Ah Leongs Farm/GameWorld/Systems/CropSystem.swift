import GameplayKit

class CropSystem: ISystem {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }
}
