import GameplayKit

class TurnSystem: GKComponentSystem<TurnComponent> {

    override init() {
        super.init(componentClass: TurnComponent.self)
    }

    func incrementTurn() -> Bool {
        guard let turnComponent = components.first else { return false }

        turnComponent.currentTurn += 1
        let shouldContinue = turnComponent.currentTurn <= turnComponent.maxTurns

        return shouldContinue
    }

    func getCurrentTurn() -> Int {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.currentTurn
    }

    func getMaxTurns() -> Int {
        guard let turnComponent = components.first else { return 0 }
        return turnComponent.maxTurns
    }

    func isGameOver() -> Bool {
        guard let turnComponent = components.first else { return true }
        return turnComponent.currentTurn > turnComponent.maxTurns
    }
}
