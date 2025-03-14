import Foundation

struct LevelComponent {
    var level: Int
    var currentXP: Float
    var thresholdXP: Float

    init(level: Int = 1, currentXP: Float = 0) {
        self.level = level
        self.currentXP = currentXP
        self.thresholdXP = 0
        
        thresholdXP = calculateXPThreshold(for: level)
    }

    private func calculateXPThreshold(for level: Int) -> Float {
        return Float(level * 100)
    }
    
    mutating func updateThresholdXP() {
        thresholdXP = calculateXPThreshold(for: level)
    }
}
