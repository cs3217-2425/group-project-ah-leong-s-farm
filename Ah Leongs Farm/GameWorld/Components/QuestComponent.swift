import Foundation
import GameplayKit

class QuestComponent: GKComponent {
    private(set) var status: QuestStatus
    private(set) var progress: Float
    private(set) var objectives: [QuestObjective]
    private(set) var completionReward: Reward

    init(status: QuestStatus, objectives: [QuestObjective], completionReward: Reward) {
        self.status = status
        self.progress = 0
        self.objectives = objectives
        self.completionReward = completionReward
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
