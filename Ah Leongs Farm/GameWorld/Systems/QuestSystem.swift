class QuestSystem: ISystem {

    unowned var manager: EntityManager?
    private weak var eventQueueable: EventQueueable?

    required init(for manager: EntityManager, eventQueueable: EventQueueable) {
        self.manager = manager
        self.eventQueueable = eventQueueable
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    private var quests: [QuestComponent] {
        manager?.getAllComponents(ofType: QuestComponent.self) ?? []
    }

    private var currentQuests: [QuestComponent] {
        quests.filter { $0.status == .active }
    }

    func getCurrentQuests() -> [QuestComponent] {
        currentQuests
    }

    func getAllQuests() -> [QuestComponent] {
        quests
    }

    func moveToNextQuest() {
        guard !quests.isEmpty else {
            return
        }

        let sortedInactiveQuests = quests
            .filter { $0.status == .inactive }
            .sorted { $0.order < $1.order }

        if let nextQuest = sortedInactiveQuests.first {
            nextQuest.status = .active
        }
    }

    func ensureTargetActiveQuestCount(target: Int = 2) {
        let activeQuestsCount = quests.filter { $0.status == .active }.count

        for _ in 0..<(target - activeQuestsCount) {
            moveToNextQuest()
        }
    }

    private func updateQuestProgress(_ questComponent: QuestComponent, with eventData: EventData) {
        var questUpdated = false

        for i in 0..<questComponent.objectives.count {
            var objective = questComponent.objectives[i]
            let criteria = objective.criteria

            if objective.isCompleted {
                continue
            }

            let increment = criteria.calculateValue(from: eventData)

            objective.progress += increment
            objective.progress = min(objective.progress, objective.target)

            questComponent.objectives[i] = objective
            questUpdated = true

        }

        if questUpdated && questComponent.isCompleted && questComponent.status != .completed {
            questComponent.status = .completed
            completeQuest(questComponent)
        }
    }

    private func completeQuest(_ questComponent: QuestComponent) {
        guard let eventQueueable = eventQueueable,
              let questEntity = questComponent.ownerEntity as? Quest else {
            return
        }

        eventQueueable.queueEvent(QuestCompletedEvent(questTitle: questComponent.title))
        let rewardComponents = getAllRewardComponents(questEntity: questEntity)
        for rewardComponent in rewardComponents {
            rewardComponent.processReward(with: self)
        }
        ensureTargetActiveQuestCount()
    }
}

extension QuestSystem: IEventObserver {
    func onEvent(_ eventData: EventData) {
        for quest in quests where quest.status == .active {
            updateQuestProgress(quest, with: eventData)
        }
    }
}

extension QuestSystem: RewardEventQueuer {
    func getAllRewardComponents(questEntity: Quest) -> [any RewardComponent] {
        let components = questEntity.allComponents
        return components.compactMap { component in
            component as? any RewardComponent
        }
    }

    internal func queueRewardEvent(component: RewardXPComponent) {
        guard let eventQueueable = eventQueueable else {
            return
        }
        eventQueueable.queueEvent(RewardXPEvent(amount: component.amount))
    }

    internal func queueRewardEvent(component: RewardCurrencyComponent) {
        guard let eventQueueable = eventQueueable else {
            return
        }
        eventQueueable.queueEvent(RewardCurrencyEvent(currencies: component.currencies))
    }

    internal func queueRewardEvent(component: RewardItemComponent) {
        guard let eventQueueable = eventQueueable else {
            return
        }
        eventQueueable.queueEvent(RewardItemEvent(itemTypes: component.itemTypes))
    }
}
