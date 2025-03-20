import Foundation
import GameplayKit

class QuestSystem: GKComponentSystem<QuestComponent> {
    private weak var eventContext: EventContext?

    init(eventContext: EventContext) {
        self.eventContext = eventContext
        super.init(componentClass: QuestComponent.self)
    }

    private func updateQuestProgress(_ questComponent: QuestComponent, with eventData: EventData) {
        var questUpdated = false

        for i in 0..<questComponent.objectives.count {
            var objective = questComponent.objectives[i]
            let criteria = objective.criteria

            if objective.isCompleted {
                continue
            }

            let criteriaMet = checkCriteria(criteria, againstEvent: eventData)

            if criteriaMet {
                let increment = criteria.progressCalculator.calculateProgress(from: eventData)

                objective.progress += increment
                objective.progress = min(objective.progress, objective.target)

                questComponent.objectives[i] = objective
                questUpdated = true
            }
        }

        if questUpdated && questComponent.isCompleted && questComponent.status != .completed {
            completeQuest(questComponent)
        }
    }

    private func checkCriteria(_ criteria: QuestCriteria, againstEvent eventData: EventData) -> Bool {
        if criteria.eventType != eventData.eventType {
            return false
        }
        // Check each required data attribute
        for (dataType, requiredValue) in criteria.requiredData {
            guard let eventValue = eventData.data[dataType] else {
                return false
            }
            if AnyHashable(eventValue) != AnyHashable(requiredValue) {
                return false
            }
        }

        return true
    }

    private func completeQuest(_ questComponent: QuestComponent) {
        questComponent.status = .completed

        if let eventContext = eventContext {
            let completionEvent = QuestCompletedEvent(
                reward: questComponent.completionReward
            )

            eventContext.queueEvent(completionEvent)
        }
    }

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

    func moveToNextQuest() {
        guard !components.isEmpty else {
            return
        }

        self.removeComponent(components[0])
    }
}
extension QuestSystem: IEventObserver {
    func onEvent(_ eventData: EventData) {
        for component in components where component.status == .active {
            updateQuestProgress(component, with: eventData)
        }
    }
}
