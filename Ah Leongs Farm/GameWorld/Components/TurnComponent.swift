import GameplayKit

class TurnComponent: GKComponent {
    var currentTurn: Int
    var maxTurns: Int
    var currentEnergy: Int
    var maxEnergy: Int

    required init?(coder: NSCoder) {
        currentTurn = 1
        maxTurns = 30
        currentEnergy = 10
        maxEnergy = 10
        super.init(coder: coder)
    }

    init(maxTurns: Int, maxEnergy: Int) {
        self.currentTurn = 1
        self.maxTurns = maxTurns
        self.maxEnergy = maxEnergy
        self.currentEnergy = maxEnergy
        super.init()
    }

}
