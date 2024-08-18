public struct Ladder: Sendable, WarpEvent {
    public let start: Int
    public let end: Int

    public init(start: Int, end: Int) {
        precondition(start < end, "start must be smaller than end")
        self.start = start
        self.end = end
    }

    public static func makeRandomly(size: Int) -> Ladder {
        var start: Int
        var end: Int
        repeat {
            start = Int.random(in: 0..<size)
            end = Int.random(in: 0..<size)
        } while start >= end
        return Ladder(start: start, end: end)
    }
}
