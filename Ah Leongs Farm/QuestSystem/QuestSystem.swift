class QuestSystem {

    private var quests: [QuestComponent]
    private var currentQuestIndex: Int?

    init(quests: [QuestComponent], currentQuestIndex: Int? = 0) {
        self.quests = quests
        self.currentQuestIndex = quests.isEmpty ? nil : currentQuestIndex
    }

    private var currentQuest: QuestComponent? {

        guard let index = currentQuestIndex else {
            return nil
        }

        return quests[index]
    }

    func getCurrentQuest() -> QuestComponent? {
        return currentQuest
    }

    func getAllQuests() -> [QuestComponent] {
        return quests
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
        guard let index = currentQuestIndex, index + 1 < quests.count else {
            currentQuestIndex = nil // No more quests left
            return
        }
        currentQuestIndex = index + 1
    }
}
