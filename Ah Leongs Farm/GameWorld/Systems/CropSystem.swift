import GameplayKit

class CropSystem: GKComponentSystem<CropComponent> {

    override init() {
        super.init(componentClass: GridComponent.self)
    }

    /// Create a new entity for a crop
    func plantCrop(ofType cropType: CropType, grid: GridComponent, row: Int, column: Int) -> CropComponent? {
        guard let entity = grid.getObject(row: row, column: column),
              let position = entity.component(ofType: PositionComponent.self),
              let soil = entity.component(ofType: SoilComponent.self) else {
            return nil
        }

        let crop = CropComponent(
            cropType: cropType,
            health: 1,
            growth: 1,
            yieldPotential: 1,
            plantedTurn: 1
        )

        entity.addComponent(crop)
        return crop
    }

    /// Remove crop entity and add harvested crop entityx
    func harvestCrop(grid: GridComponent, row: Int, column: Int) -> CropComponent? {
        guard let entity = grid.getObject(row: row, column: column),
              let crop = entity.component(ofType: CropComponent.self) else {
            return nil
        }

        entity.removeComponent(ofType: CropComponent.self)

        return crop
    }
}
