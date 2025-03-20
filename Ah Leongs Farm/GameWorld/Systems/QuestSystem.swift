import Foundation
import GameplayKit

class QuestSystem: GKComponentSystem<QuestComponent> {

    override init() {
        super.init(componentClass: QuestComponent.self)
    }

    // Get the current quest (first in the queue)
    private var currentQuest: QuestComponent? {
        components.first
    }

    func getCurrentQuest() -> QuestComponent? {
        currentQuest
    }

    func getAllQuests() -> [QuestComponent] {
        components
    }

    func isCurrentQuestCompleted() -> Bool {
        currentQuest?.isCompleted ?? false
    }

    func addQuest(_ quest: QuestComponent) {
        self.addComponent(quest)
    }

    func updateCurrentQuestProgress(objective: QuestObjective, by amount: Float) {
        guard let quest = currentQuest else {
            return
        }

        if let index = quest.objectives.firstIndex(where: { $0.description == objective.description }) {

            var objective = quest.objectives[index]
            let updatedProgress = quest.objectives[index].progress + amount

            objective.setProgress(by: updatedProgress)
        }
    }

    func moveToNextQuest() {
        guard !components.isEmpty else {
            return
        }

        self.removeComponent(components[0])
    }
}
