import GameplayKit

class TurnSystem: ISystem {
    unowned var manager: EntityManager?

    private var turnComponent: TurnComponent? {
        manager?.getSingletonComponent(ofType: TurnComponent.self)
    }

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func incrementTurn() -> Bool {
        guard let turnComponent = turnComponent else {
            return false
        }

        turnComponent.currentTurn += 1
        let shouldContinue = turnComponent.currentTurn <= turnComponent.maxTurns

        return shouldContinue
    }

    func getCurrentTurn() -> Int {
        guard let turnComponent = turnComponent else {
            return 1
        }
        return turnComponent.currentTurn
    }

    func getMaxTurns() -> Int {
        guard let turnComponent = turnComponent else {
            return 1
        }
        return turnComponent.maxTurns
    }

    func isGameOver() -> Bool {
        guard let turnComponent = turnComponent else {
            return true
        }
        return turnComponent.currentTurn > turnComponent.maxTurns
    }
}
