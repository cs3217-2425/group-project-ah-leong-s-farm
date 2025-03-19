//
//  GameOverEvent.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 20/3/25.
//

struct GameOverEvent: GameEvent {

    func execute(in context: EventContext) {
        guard let turnSystem = context.getSystem(ofType: TurnSystem.self),
              let walletSystem = context.getSystem(ofType: WalletSystem.self) else {
            return
        }

        let finalTurn = turnSystem.getCurrentTurn()
        let maxTurns = turnSystem.getMaxTurns()
        let finalCoins = walletSystem.getTotalAmount(of: .coin)

        let finalScore = calculateScore(turns: finalTurn, coins: finalCoins)

        // Placeholder print statements
        print("Game Over!")
        print("Final turn: \(finalTurn)/\(maxTurns)")
        print("Final coins: \(finalCoins)")
        print("Final score: \(finalScore)")

    }

    private func calculateScore(turns: Int, coins: Double) -> Int {
        // Placeholder score formula
        return Int(coins) * 10
    }
}
