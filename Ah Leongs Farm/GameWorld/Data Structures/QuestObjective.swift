import Foundation

struct QuestObjective {
    let description: String
    let criteria: QuestCriteria
    let target: Float
    var progress: Float

    init(description: String, criteria: QuestCriteria, target: Float) {
        self.description = description
        self.criteria = criteria
        self.target = target
        self.progress = 0
    }

    var isCompleted: Bool {
        progress >= target
    }
}
