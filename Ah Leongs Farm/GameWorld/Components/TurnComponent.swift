import GameplayKit

class TurnComponent: GKComponent {
    private(set) var currentTurn: Int
    private(set) var maxTurns: Int
    private(set) var currentEnergy: Float
    private(set) var maxEnergy: Float

    required init?(coder: NSCoder) {
        currentTurn = 1
        maxTurns = 30
        currentEnergy = 10
        maxEnergy = 10
        super.init(coder: coder)
    }

    init(maxTurns: Int, maxEnergy: Float) {
        self.currentTurn = 1
        self.maxTurns = maxTurns
        self.maxEnergy = maxEnergy
        self.currentEnergy = maxEnergy
        super.init()
    }

    func incrementTurn() -> Bool {
        currentTurn += 1
        replenishEnergy()
        return currentTurn <= maxTurns
    }

    func useEnergy(amount: Float) -> Bool {
        guard currentEnergy >= amount else { return false }

        currentEnergy -= amount
        return true
    }

    func replenishEnergy() {
        currentEnergy = maxEnergy
    }

    func increaseMaxEnergy(by amount: Float) {
        maxEnergy += amount
    }

    func isGameOver() -> Bool {
        return currentTurn > maxTurns
    }
}
