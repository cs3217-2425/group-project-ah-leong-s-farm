class LevelSystem {

    private var levelComponent: LevelComponent

    init(startLevel: Int = 1, startXP: Float = 0) {
        self.levelComponent = LevelComponent(level: startLevel, currentXP: startXP)
    }

    func addXP(_ amount: Float) {
        levelComponent.addXP(amount)
    }

    func getCurrentLevel() -> Int {
        return levelComponent.level
    }

    func getCurrentXP() -> Float {
        return levelComponent.currentXP
    }

    func getXPForNextLevel() -> Float {
        return LevelComponent.calculateXPThreshold(for: levelComponent.level + 1)
    }

    func getXPProgress() -> Double {
        return levelComponent.getXPProgress()
    }
}
