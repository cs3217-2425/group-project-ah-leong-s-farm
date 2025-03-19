struct Reward {
    var rewards: [RewardType]
}

enum RewardType {
    case xp(Int)
    case currency(Int)
    case item(String)
}
