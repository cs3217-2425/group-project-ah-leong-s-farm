struct QuestComponent {
    var status: QuestStatus
    var progress: Float
    var objectives: [QuestObjective]
    var reward: Reward

    init(status: QuestStatus = .inactive, objectives: [QuestObjective], reward: Reward) {
        self.status = status
        self.progress = 0
        self.objectives = objectives
        self.reward = reward
    }

    var isCompleted: Bool {
        return objectives.allSatisfy { $0.progress >= $0.target }
    }

    mutating func updateObjectiveProgress(for objective: QuestObjective, by amount: Float) {
        
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
