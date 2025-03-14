import Foundation

class LevelSystem {
    private var levelComponent = LevelComponent()

    init(startLevel: Int = 1, startXP: Float = 0) {
        self.levelComponent = LevelComponent(level: startLevel, currentXP: startXP)
    }

    func addXP(_ amount: Float) {
        levelComponent.currentXP += amount

        while levelComponent.currentXP >= levelComponent.thresholdXP {
            levelComponent.currentXP -= levelComponent.thresholdXP
            levelComponent.level += 1
            levelComponent.updateThresholdXP()
        }
    }

    func getCurrentLevel() -> Int {
        return levelComponent.level
    }

    func getCurrentXP() -> Float {
        return levelComponent.currentXP
    }

    func getXPForNextLevel() -> Float {
        return levelComponent.thresholdXP
    }

    func getXPProgress() -> Double {
        return Double(levelComponent.currentXP) / Double(levelComponent.thresholdXP)
    }
}
