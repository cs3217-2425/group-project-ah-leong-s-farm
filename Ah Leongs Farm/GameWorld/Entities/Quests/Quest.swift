import Foundation

class Quest: EntityAdapter {

    init(questComponent: QuestComponent, rewardComponents: [any RewardComponent]) {
        super.init()
        self.attachComponent(questComponent)
        for rewardComponent in rewardComponents {
            self.attachComponent(rewardComponent)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
