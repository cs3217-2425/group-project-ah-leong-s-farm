import Foundation
import GameplayKit

class LevelSystem: GKComponentSystem<LevelComponent> {

    override init() {
        super.init()
    }

    func addXP(_ amount: Float) {
        guard let levelComponent = components.first else {
            return
        }
        levelComponent.addXP(amount)
    }

    func getCurrentLevel() -> Int {
        guard let levelComponent = components.first else {
            return 0
        }
        return levelComponent.level
    }

    func getCurrentXP() -> Float {
        guard let levelComponent = components.first else {
            return 0
        }
        return levelComponent.currentXP
    }

    func getXPForNextLevel() -> Float {
        guard let levelComponent = components.first else {
            return 0
        }
        return LevelComponent.calculateXPThreshold(for: levelComponent.level + 1)
    }

    func getXPProgress() -> Double {
        guard let levelComponent = components.first else {
            return 0
        }
        return levelComponent.getXPProgress()
    }
}
