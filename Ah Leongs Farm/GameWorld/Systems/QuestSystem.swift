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

    var questComponentMap: [QuestID: QuestComponent] {
        Dictionary(uniqueKeysWithValues: quests.map {
            ($0.id, $0)
        })
    }

    func getCurrentQuests() -> [QuestComponent] {
        currentQuests
    }

    func getAllQuests() -> [QuestComponent] {
        quests
    }

    func initialiseQuestGraph() {
        validateQuestGraph()
        updateQuestStatuses()
    }

    private func allPrerequisitesCompleted(for quest: QuestComponent) -> Bool {
        for prerequisiteId in quest.prerequisites {
            guard let prerequisite = questComponentMap[prerequisiteId],
                  prerequisite.status == .completed else {
                return false
            }
        }
        return true
    }

    func updateQuestStatuses() {
        for quest in quests {
            if quest.status == .inactive && allPrerequisitesCompleted(for: quest) {
                quest.status = .active
            }
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
        updateQuestStatuses()
    }

    private func validateQuestGraph() {
        enum VisitState { case white, gray, black }
        var visitState: [QuestID: VisitState] = [:]

        // Initialize all quests as unvisited
        for quest in quests {
            visitState[quest.id] = .white
        }

        // Path tracking for cycle reporting
        var currentPath: [QuestID] = []

        // DFS function to detect cycles
        func dfs(questID: QuestID) {
            // Quest not found (invalid reference)
            guard let quest = questComponentMap[questID] else {
                fatalError("Quest not found!")
            }

            // Already fully explored this branch, no cycles
            if visitState[questID] == .black {
                return
            }

            // Node is in the current path - cycle detected!
            if visitState[questID] == .gray {
                // Find where the cycle starts in the current path
                if let cycleStart = currentPath.firstIndex(of: questID) {
                    let cycle = Array(currentPath[cycleStart...]) + [questID]
                    fatalError("Cyclic dependency found in quests: \(cycle)")
                } else {
                    // Shouldn't happen, but just in case
                    fatalError("Cycli dependency found in quests: \(currentPath), \(questID)")
                }
            }

            // Mark as being visited in current recursion path
            visitState[questID] = .gray
            currentPath.append(questID)

            // Visit all prerequisites (children in the dependency graph)
            for prereqID in quest.prerequisites {
                dfs(questID: prereqID)
            }

            // Done exploring this node, mark as fully visited
            visitState[questID] = .black
            currentPath.removeLast()
        }

        // Run DFS from each unvisited quest
        for quest in quests where visitState[quest.id] == .white {
            dfs(questID: quest.id)
        }
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

    internal func queueRewardEvent(component: RewardPointsComponent) {
        guard let eventQueueable = eventQueueable else {
            return
        }
        eventQueueable.queueEvent(RewardPointsEvent(amount: component.amount))
    }
}
