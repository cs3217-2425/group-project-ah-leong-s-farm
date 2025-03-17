import Foundation

protocol QuestObjective {
    var description: String { get }
    var progress: Float { get set }
    var target: Float { get }

    mutating func updateProgress(by amount: Float) -> Bool
}

