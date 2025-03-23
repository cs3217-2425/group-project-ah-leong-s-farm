import GameplayKit

class Quest: GKEntity {
    private(set) var questComponent: QuestComponent

    init(questComponent: QuestComponent) {
        self.questComponent = questComponent
        super.init()
        self.addComponent(questComponent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
