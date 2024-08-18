public struct Snake: Sendable, WarpEvent {
    public let start: Int
    public let end: Int

    public init(start: Int, end: Int) {
        precondition(start > end, "start must be bigger than end")
        self.start = start
        self.end = end
    }

    public static func makeRandomly(size: Int) -> Snake {
        var start: Int
        var end: Int
        repeat {
            start = Int.random(in: 0..<size)
            end = Int.random(in: 0..<size)
        } while start <= end
        return Snake(start: start, end: end)
    }
}
