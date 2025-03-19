import Foundation
import GameplayKit

class QuestComponent: GKComponent {
    private(set) var status: QuestStatus
    private(set) var progress: Float
    private(set) var objectives: [QuestObjective]
    private(set) var completionReward: Reward

    init(status: QuestStatus = .inactive, objectives: [QuestObjective], completionReward: Reward) {
        self.status = status
        self.progress = 0
        self.objectives = objectives
        self.completionReward = completionReward
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isCompleted: Bool {
        return objectives.allSatisfy { $0.progress >= $0.target }
    }

    func updateObjectiveProgress(for objective: QuestObjective, by amount: Float) {
        
        guard let index = objectives.firstIndex(where: { $0.description == objective.description }) else {
            return
        }

        let completed = objectives[index].updateProgress(by: amount)

        if completed, isCompleted {
            status = .completed
        }
    }
}

enum QuestStatus {
    case active
    case inactive
    case completed
}
