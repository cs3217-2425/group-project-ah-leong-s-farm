import GameplayKit

class QuestEntity: GKEntity {

    init(objectives: [QuestObjective], reward: Reward) {
        super.init()
        self.addComponent(QuestComponent(status: .active, objectives: objectives, completionReward: reward))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
