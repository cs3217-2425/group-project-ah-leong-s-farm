import Foundation
import GameplayKit

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

        if let eventQueueable = eventQueueable {
            let completionEvent = QuestCompletedEvent(
                reward: questComponent.completionReward
            )

            eventQueueable.queueEvent(completionEvent)
        }
    }

    // TODO: Redefine quest logic once EventQueueable is done
//    private weak var eventContext: EventContext?
//
//    init(eventContext: EventContext) {
//        self.eventContext = eventContext
//        super.init(componentClass: QuestComponent.self)
//    }
//
//    private func updateQuestProgress(_ questComponent: QuestComponent, with eventData: EventData) {
//        var questUpdated = false
//
//        for i in 0..<questComponent.objectives.count {
//            var objective = questComponent.objectives[i]
//            let criteria = objective.criteria
//
//            if objective.isCompleted {
//                continue
//            }
//
//            let criteriaMet = checkCriteria(criteria, againstEvent: eventData)
//
//            if criteriaMet {
//                let increment = criteria.progressCalculator.calculateProgress(from: eventData)
//
//                objective.progress += increment
//                objective.progress = min(objective.progress, objective.target)
//
//                questComponent.objectives[i] = objective
//                questUpdated = true
//            }
//        }
//
//        if questUpdated && questComponent.isCompleted && questComponent.status != .completed {
//            completeQuest(questComponent)
//        }
//    }
//
//    private func checkCriteria(_ criteria: QuestCriteria, againstEvent eventData: EventData) -> Bool {
//        if criteria.eventType != eventData.eventType {
//            return false
//        }
//        // Check each required data attribute
//        for (dataType, requiredValue) in criteria.requiredData {
//            guard let eventValue = eventData.data[dataType] else {
//                return false
//            }
//            if AnyHashable(eventValue) != AnyHashable(requiredValue) {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    private func completeQuest(_ questComponent: QuestComponent) {
//        questComponent.status = .completed
//
//        if let eventContext = eventContext {
//            let completionEvent = QuestCompletedEvent(
//                reward: questComponent.completionReward
//            )
//
//            eventContext.queueEvent(completionEvent)
//        }
//    }
//
//    private var currentQuests: [QuestComponent] {
//        components.filter { $0.status == .active }
//    }
//
//    func getCurrentQuests() -> [QuestComponent] {
//        currentQuests
//    }
//
//    func getAllQuests() -> [QuestComponent] {
//        components
//    }
//
//    func addQuest(_ quest: QuestComponent) {
//        self.addComponent(quest)
//    }
//
//    func moveToNextQuest() {
//        guard !components.isEmpty else {
//            return
//        }
//
//        // Change the first inactive quest to active
//        if let firstInactiveQuest = components.first(where: { $0.status == .inactive }) {
//            firstInactiveQuest.status = .active
//        }
//
//        for component in components where component.status == .completed {
//            self.removeComponent(component)
//        }
//    }

}

// extension QuestSystem: IEventObserver {
//    func onEvent(_ eventData: EventData) {
//        for component in components where component.status == .active {
//            updateQuestProgress(component, with: eventData)
//        }
//    }
// }
