import Foundation
import GameplayKit

class QuestSystem: GKComponentSystem<QuestComponent> {

    override init() {
        super.init()
    }

    // Get the current quest (first in the queue)
    private var currentQuest: QuestComponent? {
        return components.first
    }

    func getCurrentQuest() -> QuestComponent? {
        return currentQuest
    }

    func getAllQuests() -> [QuestComponent] {
        return components
    }
    
    func isCurrentQuestCompleted() -> Bool {
        return currentQuest?.isCompleted ?? false
    }
    
    func addQuest(_ quest: QuestComponent) {
        self.addComponent(quest)
    }

    func updateCurrentQuestProgress(objective: QuestObjective, by amount: Float) {
        guard let quest = currentQuest else { return }

        quest.updateObjectiveProgress(for: objective, by: amount)

    }

    private func moveToNextQuest() {
        guard !components.isEmpty else { return }

        self.removeComponent(components[0])
    }
}
