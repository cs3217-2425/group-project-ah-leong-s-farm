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

        var newXP = levelComponent.currentXP + amount
        var newLevel = levelComponent.level
        var newThreshold = LevelComponent.calculateXPThreshold(for: newLevel)

        while newXP >= newThreshold {
            newXP -= newThreshold
            newLevel += 1
            newThreshold = LevelComponent.calculateXPThreshold(for: newLevel)
        }

        levelComponent.setLevel(newLevel, xp: newXP, threshold: newThreshold)
    }

    func getCurrentLevel() -> Int {
        components.first?.level ?? 0
    }

    func getCurrentXP() -> Float {
        components.first?.currentXP ?? 0
    }

    func getXPForNextLevel() -> Float {
        components.first.map { LevelComponent.calculateXPThreshold(for: $0.level + 1) } ?? 0
    }

    func getXPProgress() -> Float {
        guard let component = components.first else {
            return 0
        }
        return component.currentXP / component.thresholdXP
    }
}
