import Foundation

typealias QuestID = UUID
class QuestComponent: ComponentAdapter {
    let title: String
    var status: QuestStatus
    var objectives: [QuestObjective]
    let order: Int
    var prerequisites: [QuestID]
    let id: QuestID

    init(title: String,
         objectives: [QuestObjective],
         prerequisites: [QuestID],
         order: Int,
         id: QuestID = UUID()) {
        self.title = title
        self.status = .inactive
        self.objectives = objectives
        self.prerequisites = prerequisites
        self.order = order
        self.id = id
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
