import Foundation

class QuestObjective {
    var progress: Float
    var target: Float
    var description: String

    init(description: String, progress: Float, target: Float) {
        self.description = description
        self.progress = progress
        self.target = target
    }

    @discardableResult
    func setProgress(by amount: Float) -> Bool {
        progress = amount
        return progress >= target
    }
    
    var isCompleted: Bool {
        return progress >= target
    }
}

