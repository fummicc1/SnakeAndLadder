public enum GameEvent: Sendable {
    case gameFinished
    case playerWon(Player)
    case playerProgressed(player: Player, to: Int)
    case playerFallBacked(player: Player, recedingAmount: Int)
}

public final actor Game {
    public let snakeCount: Int
    public let ladderCount: Int

    public private(set) var players: [Player]
    public let snakes: [Snake]
    public let ladders: [Ladder]

    public private(set) var dice: Dice
    public let board: Board

    public init(snakeCount: Int, ladderCount: Int, boardLength: Int = 10) {
        let boardSize = boardLength * boardLength
        self.snakeCount = snakeCount
        self.ladderCount = ladderCount
        self.players = []
        self.board = Board(length: boardLength)
        self.dice = Dice()

        var snakes = Set<Snake>()
        var ladders = Set<Ladder>()

        for _ in 0..<snakeCount {
            var snake: Snake
            repeat {
                snake = Snake.makeRandomly(size: boardSize)
            } while snakes.contains(snake)
            snakes.insert(snake)
        }

        for _ in 0..<ladderCount {
            var ladder: Ladder
            repeat {
                ladder = Ladder.makeRandomly(size: boardSize)
            } while ladders.contains(ladder)
            ladders.insert(ladder)
        }

        self.snakes = snakes.map { $0 }
        self.ladders = ladders.map { $0 }
    }

    func add(player: Player) {
        players.append(player)
    }
    public func play() -> AsyncStream<GameEvent> {
        AsyncStream { continuation in
            repeat {
                guard var player = players.dropFirst().first else {
                    break
                }
                let progress = dice.roll()
                let newPosition = player.position + progress
                let positionAfterWarp = calculatePositionAfterWarpEvent(of: newPosition)
                let end = board.end
                if end == positionAfterWarp {
                    // goal
                    player.position = end
                    player.won = true
                    continuation.yield(.playerWon(player))
                    continue
                } else if end < positionAfterWarp {
                    // need to go back [positionAfterWarp - end] steps
                    let receding = positionAfterWarp - end
                    player.position = end - receding
                    continuation.yield(.playerFallBacked(player: player, recedingAmount: receding))
                } else {
                    // continue game
                    player.position = positionAfterWarp
                    continuation.yield(.playerProgressed(player: player, to: positionAfterWarp))
                }
                // add to last (considering order, round-robin)
                players.append(player)
            } while players.count < 2
            continuation.yield(.gameFinished)
            continuation.finish()
        }
    }

    func calculatePositionAfterWarpEvent(of position: Int) -> Int {
        for snake in snakes {
            if snake.start == position {
                return calculatePositionAfterWarpEvent(of: snake.end)
            }
        }
        for ladder in ladders {
            if ladder.start == position {
                return calculatePositionAfterWarpEvent(of: ladder.end)
            }
        }
        return position
    }
}
