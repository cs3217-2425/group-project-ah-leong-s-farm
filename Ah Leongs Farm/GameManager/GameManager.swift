import GameplayKit

class GameManager {
    private let gameWorld: GameWorld
    private var gameObservers: [any IGameObserver] = []

    init(scene: SKScene) {
        gameWorld = GameWorld()
        setUpEntities()
        setUpGameObservers(scene: scene)
    }

    func update(_ currentTime: TimeInterval) {
        gameWorld.updateSystems(deltaTime: currentTime)
        gameObservers.forEach { $0.notify(gameWorld) }
    }

    private func setUpEntities() {
        let farmLand = FarmLand(rows: 20, columns: 20)
        gameWorld.addEntity(farmLand)

        guard let gridComponent = farmLand.component(ofType: GridComponent.self) else {
            return
        }

        for row in 0..<gridComponent.numberOfRows {
            for column in 0..<gridComponent.numberOfColumns {
                let plot = Plot(position: CGPoint(x: row, y: column))
                gridComponent.setObject(plot, row: row, column: column)
                gameWorld.addEntity(plot)
            }
        }
    }

    private func setUpGameObservers(scene: SKScene) {
        gameObservers.append(GameRenderer(scene: scene))
    }
}
