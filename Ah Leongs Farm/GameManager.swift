import GameplayKit

class GameManager {
    private let gameWorld: GameWorld

    init(scene: SKScene) {
        gameWorld = GameWorld()
        setUpEntities()
        setUpSystems(scene: scene)
    }

    func update(_ currentTime: TimeInterval) {
        gameWorld.updateSystems(deltaTime: currentTime)
    }

    private func setUpEntities() {
        gameWorld.addEntity(FarmLand(rows: 20, columns: 20))
    }

    private func setUpSystems(scene: SKScene) {
        gameWorld.addSystem(TileMapSystem(scene: scene))
        gameWorld.addSystem(SpriteSystem(scene: scene))
        gameWorld.addSystem(GridSystem())
    }

    func addCrop(at position: CGPoint) {
        let cropType = CropType.potato

        guard let farmLand: FarmLand = gameWorld.entities.first( where: { $0 is FarmLand}) as? FarmLand else {
            return
        }

        guard let gridSystem: GridSystem = gameWorld.systems
            .first( where: { $0.componentClass === GridComponent.self }) as? GridSystem else {
            return
        }

        guard let tileMapComponent = farmLand.component(ofType: TileMapComponent.self),
              let gridComponent = farmLand.component(ofType: GridComponent.self),
              let (row, column) = tileMapComponent.getSelectedRowAndColumn(at: position) else {
            return
        }
        
        guard let crop = gridSystem.plantCrop(ofType: cropType, grid: gridComponent, row: row, column: column) else {
            return
        }

        gameWorld.addEntity(crop)
    }
}
