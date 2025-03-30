import GameplayKit

class Quest: GKEntity {

    init(questComponent: QuestComponent, rewardComponents: [any RewardComponent]) {
        super.init()
        self.addComponent(questComponent)
        for rewardComponent in rewardComponents {
            self.addComponent(rewardComponent)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
