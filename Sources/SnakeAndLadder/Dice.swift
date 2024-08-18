public struct Dice: Sendable {
    private let minValue: Int  // inclusive
    private let maxValue: Int  // exclusive

    public private(set) var currentValue: Int

    init(minValue: Int = 1, maxValue: Int = 7) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.currentValue = Int.random(in: minValue..<maxValue)
    }

    mutating func roll() -> Int {
        currentValue = Int.random(in: minValue..<maxValue)
        return currentValue
    }
}
