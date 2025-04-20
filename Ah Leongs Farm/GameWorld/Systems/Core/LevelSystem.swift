import Foundation

class LevelSystem: ISystem {
    unowned var manager: EntityManager?
    private weak var eventQueueable: EventQueueable?

    required init(for manager: EntityManager, eventQueueable: EventQueueable) {
        self.manager = manager
        self.eventQueueable = eventQueueable
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    private var levelComponent: LevelComponent? {
        manager?.getSingletonComponent(ofType: LevelComponent.self)
    }

    func addXP(_ amount: Float) {
        guard let levelComponent = levelComponent else {
            return
        }

        var newXP = levelComponent.currentXP + amount
        var newLevel = levelComponent.level
        var newThreshold = LevelComponent.calculateXPThreshold(for: newLevel)

        while newXP >= newThreshold {
            newXP -= newThreshold
            newLevel += 1
            eventQueueable?.queueEvent(LevelUpEvent())
            newThreshold = LevelComponent.calculateXPThreshold(for: newLevel)
        }

        levelComponent.setLevel(newLevel, xp: newXP)
    }

    func getCurrentLevel() -> Int {
        levelComponent?.level ?? 0
    }

    func getCurrentXP() -> Float {
        levelComponent?.currentXP ?? 0
    }

    func getXPForCurrentLevel() -> Float {
        guard let component = levelComponent else {
            return 1
        }

        return component.thresholdXP
    }

    func getXPForNextLevel() -> Float {
        levelComponent.map { LevelComponent.calculateXPThreshold(for: $0.level + 1) } ?? 0
    }

    func getXPProgress() -> Float {
        guard let component = levelComponent else {
            return 0
        }
        return component.currentXP / component.thresholdXP
    }
}
