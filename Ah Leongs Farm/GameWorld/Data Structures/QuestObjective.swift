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

    func setProgress(by amount: Float) -> Bool {
        progress = amount
        return progress >= target
    }
    
    func isCompleted() -> Bool {
        return progress >= target
    }
}

