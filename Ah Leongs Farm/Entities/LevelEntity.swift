import Foundation
import GameplayKit

class LevelEntity: GKEntity {
    var levelComponent: LevelComponent

    init(level: Int = 1, currentXP: Float = 0) {
        self.levelComponent = LevelComponent(level: level, currentXP: currentXP)
        super.init()

        self.addComponent(levelComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

