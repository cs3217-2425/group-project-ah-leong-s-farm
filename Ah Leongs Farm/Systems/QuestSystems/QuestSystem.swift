import Foundation
import GameplayKit

class QuestSystem: GKComponentSystem<QuestComponent> {

    private var currentQuestIndex: Int?

    override init() {
        super.init()
    }

    // Get the current quest
    private var currentQuest: QuestComponent? {
        guard let index = currentQuestIndex else {
            return nil
        }

        return components[index]
    }

    func getCurrentQuest() -> QuestComponent? {
        return currentQuest
    }

    func getAllQuests() -> [QuestComponent] {
        return components
    }

    func updateCurrentQuestProgress(objective: QuestObjective, by amount: Float) {
        guard var quest = currentQuest else {
            return
        }

        quest.updateObjectiveProgress(for: objective, by: amount)

        if quest.isCompleted {
            moveToNextQuest()
        }
    }

    private func moveToNextQuest() {
        guard let index = currentQuestIndex, index + 1 < components.count else {
            currentQuestIndex = nil // No more quests left
            return
        }
        currentQuestIndex = index + 1
    }

    func addQuest(_ quest: QuestComponent) {
        self.addComponent(quest)
    }

    func setCurrentQuestIndex(_ index: Int) {
        guard index >= 0 && index < components.count else { return }
        currentQuestIndex = index
    }
}
