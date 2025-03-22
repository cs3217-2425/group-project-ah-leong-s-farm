//
//  EventAmountCalculator.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 21/3/25.
//

struct EventAmountCalculator: ProgressCalculator {
    let dataType: EventDataType

    func calculateProgress(from eventData: EventData) -> Float {
        if let intAmount = eventData.data[dataType] as? Int {
            return Float(intAmount)
        } else if let floatAmount = eventData.data[dataType] as? Float {
            return floatAmount
        } else if let doubleAmount = eventData.data[dataType] as? Double {
            return Float(doubleAmount)
        }
        return 0
    }
}
