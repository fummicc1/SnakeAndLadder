public struct Board: Sendable {
    public let length: Int
    public var size: Int {
        length * length
    }
    public let start: Int
    public let end: Int

    public init(length: Int) {
        self.length = length
        self.start = 0
        self.end = length * length - 1
    }
}
