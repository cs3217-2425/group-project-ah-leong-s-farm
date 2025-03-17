import GameplayKit

class TurnSystem: GKComponentSystem<TurnComponent> {

    func incrementTurn() -> Bool {
        guard let turnComponent = components.first else { return false }

        let oldTurn = turnComponent.currentTurn
        let shouldContinue = turnComponent.incrementTurn()
        let newTurn = turnComponent.currentTurn

        return shouldContinue
    }

    // Energy management functions
    func useEnergy(amount: Float) -> Bool {
        guard let turnComponent = components.first else { return false }
        return turnComponent.useEnergy(amount: amount)
    }

    func replenishEnergy() {
        guard let turnComponent = components.first else { return }
        turnComponent.replenishEnergy()
    }

    func increaseMaxEnergy(by amount: Float) {
        guard let turnComponent = components.first else { return }
        turnComponent.increaseMaxEnergy(by: amount)
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

    func getCurrentEnergy() -> Float {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.currentEnergy
    }

    func getMaxEnergy() -> Float {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.maxEnergy
    }

    func isGameOver() -> Bool {
        guard let turnComponent = components.first else { return true }
        return turnComponent.isGameOver()
    }
}
