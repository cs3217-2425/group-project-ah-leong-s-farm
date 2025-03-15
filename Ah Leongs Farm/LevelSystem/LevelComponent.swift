import Foundation

struct LevelComponent {
    private(set) var level: Int
    private(set) var currentXP: Float
    private(set) var thresholdXP: Float

    init(level: Int = 1, currentXP: Float = 0) {
        self.level = level
        self.currentXP = currentXP
        self.thresholdXP = LevelComponent.calculateXPThreshold(for: level)
    }

    static func calculateXPThreshold(for level: Int) -> Float {
        return Float(level * 100)
    }

    mutating func addXP(_ amount: Float) {
        currentXP += amount

        while currentXP >= thresholdXP {
            currentXP -= thresholdXP
            level += 1
            thresholdXP = LevelComponent.calculateXPThreshold(for: level)
        }
    }

    func getXPProgress() -> Double {
        return Double(currentXP) / Double(thresholdXP)
    }
}
