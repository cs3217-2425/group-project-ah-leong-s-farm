import Foundation

class QuestComponent: ComponentAdapter {
    let title: String
    var status: QuestStatus
    var objectives: [QuestObjective]
    let order: Int  // Lower number = earlier in sequence

    init(title: String,
         objectives: [QuestObjective],
         order: Int = Int.max) {
        self.title = title
        self.status = .inactive
        self.objectives = objectives
        self.order = order
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
