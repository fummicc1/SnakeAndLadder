public protocol WarpEvent: Hashable {
    var start: Int { get }
    var end: Int { get }
}
