struct Reward {
    var rewards: [any SpecificReward]
}

enum RewardType {
    case xp
    case currency
    case item
}

protocol SpecificReward {
    var type: RewardType { get }
}

struct XPSpecificReward: SpecificReward {
    let type = RewardType.xp
    let amount: Float
}

struct CurrencySpecificReward: SpecificReward {
    let type = RewardType.currency
    let currencies: [CurrencyType: Double]
}

struct ItemSpecificReward: SpecificReward {
    let type = RewardType.item
    let itemTypes: [ItemType: Int]
}
