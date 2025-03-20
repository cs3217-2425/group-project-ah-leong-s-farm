//
//  FixedProgressCalculator.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 21/3/25.
//

struct FixedProgressCalculator: ProgressCalculator {
    let amount: Float

    init(amount: Float = 1.0) {
        self.amount = amount
    }

    func calculateProgress(from eventData: EventData) -> Float {
        return amount
    }
}
