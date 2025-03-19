import GameplayKit

class QuestEntity: GKEntity {
    init(objectives: [QuestObjective], reward: Reward) {
        super.init()
        addComponent(QuestComponent(objectives: objectives, completionReward: reward))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
