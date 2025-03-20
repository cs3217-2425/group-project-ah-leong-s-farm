import Foundation
import GameplayKit

class LevelComponent: GKComponent {
    private(set) var level: Int
    private(set) var currentXP: Float
    private(set) var thresholdXP: Float

    init(level: Int = 1, currentXP: Float = 0) {
        self.level = level
        self.currentXP = currentXP
        self.thresholdXP = LevelComponent.calculateXPThreshold(for: level)
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func calculateXPThreshold(for level: Int) -> Float {
        Float(level * 100)
    }

    func setLevel(_ level: Int, xp: Float, threshold: Float) {
        self.level = level
        self.currentXP = xp
        self.thresholdXP = threshold
    }
}
