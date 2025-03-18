import GameplayKit

class TurnSystem: GKComponentSystem<TurnComponent> {

    override init() {
        super.init(componentClass: TurnComponent.self)
    }

    func incrementTurn() -> Bool {
        guard let turnComponent = components.first else { return false }

        turnComponent.currentTurn += 1
        replenishEnergy()
        let shouldContinue = turnComponent.currentTurn <= turnComponent.maxTurns

        return shouldContinue
    }

    // Energy management functions
    func useEnergy(amount: Int) -> Bool {
        guard let turnComponent = components.first else { return false }
        guard turnComponent.currentEnergy >= amount else { return false }

        turnComponent.currentEnergy -= amount
        return true
    }

    func replenishEnergy() {
        guard let turnComponent = components.first else { return }
        turnComponent.currentEnergy = turnComponent.maxEnergy
    }

    func increaseMaxEnergy(by amount: Int) {
        guard let turnComponent = components.first else { return }
        turnComponent.maxEnergy += amount
    }

    // Getter methods for turn state
    func getCurrentTurn() -> Int {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.currentTurn
    }

    func getMaxTurns() -> Int {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.maxTurns
    }

    func getCurrentEnergy() -> Int {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.currentEnergy
    }

    func getMaxEnergy() -> Int {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.maxEnergy
    }

    func isGameOver() -> Bool {
        guard let turnComponent = components.first else { return true }
        return turnComponent.currentTurn > turnComponent.maxTurns
    }
}
