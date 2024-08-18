public struct Player: Sendable {
    public let name: String
    public var position: Int
    public var won: Bool

    public init(name: String) {
        self.name = name
        self.position = 0
        self.won = false
    }
}
