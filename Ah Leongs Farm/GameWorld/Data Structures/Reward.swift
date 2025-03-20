struct Reward {
    var xpReward: Float?
    var currencyReward: (type: CurrencyType, amount: Double)?
    var itemReward: (type: ItemType, stackable: Bool, quantity: Int)?
}
