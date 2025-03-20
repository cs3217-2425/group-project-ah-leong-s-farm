struct Reward {
    var rewards: [RewardType]
}

enum RewardType {
    case xp(Int)
    case currency(CurrencyType, Int)
    // TODO: Change item to its relevant item type
    case item(String, Int)
}
