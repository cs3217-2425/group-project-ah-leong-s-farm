import Foundation
import GameplayKit

class QuestComponent: GKComponent {
    let title: String
    var status: QuestStatus
    var objectives: [QuestObjective]
    let completionReward: Reward

    init(title: String, objectives: [QuestObjective], reward: Reward) {
        self.title = title
        self.status = .active
        self.objectives = objectives
        self.completionReward = reward
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isCompleted: Bool {
        objectives.allSatisfy { $0.isCompleted }
    }
}

enum QuestStatus {
    case active
    case inactive
    case completed
}
