import GameplayKit

class GridSystem: GKComponentSystem<GridComponent> {

    override init() {
        super.init(componentClass: GridComponent.self)
    }

    /// Create a new entity for a crop
    func plantCrop(ofType cropType: CropType, grid: GridComponent, row: Int, column: Int) -> Crop? {
        guard let plot = grid.matrix[row][column],
              let position = plot.component(ofType: PositionComponent.self),
              let soil = plot.component(ofType: SoilComponent.self) else {
            return nil
        }

        let crop = Crop(ofType: cropType, position: position.toCGPoint())

        plot.crop = crop

        return crop
    }

    /// Remove crop entity and add harvested crop entityx
    func harvestCrop(grid: GridComponent, row: Int, column: Int) -> Crop? {
        guard let plot = grid.matrix[row][column] else {
            return nil
        }

        let crop = plot.crop
        plot.crop = nil

        return crop
    }

    func addSoil(quality: Float, moisture: Float, grid: GridComponent, row: Int, column: Int) {
        guard let plot = grid.matrix[row][column] else {
            return
        }

        plot.addComponent(SoilComponent(quality: quality, moisture: moisture))
    }

    func getAllCrops() -> [Crop] {
        components.flatMap{ $0.matrix }
            .flatMap { $0.compactMap { $0?.crop } }
    }

}

