struct Reward {
    var rewards: [RewardType]
}

enum RewardType {
    case xp(Int)
    case currency(CurrencyType, Int)
    case item(String, Int)
}
