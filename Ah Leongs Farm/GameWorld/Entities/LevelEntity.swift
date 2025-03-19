import Foundation
import GameplayKit

class LevelEntity: GKEntity {

    init(level: Int = 1, currentXP: Float = 0) {
        super.init()

        self.addComponent(LevelComponent(level: level, currentXP: currentXP))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
