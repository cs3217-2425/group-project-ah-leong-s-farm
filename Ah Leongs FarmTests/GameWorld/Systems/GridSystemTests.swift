import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class GridSystemTests: XCTestCase {

    func testAddComponent() {
        let gridSystem = GridSystem()
        let gridComponent = GridComponent(rows: 3, columns: 3)

        gridSystem.addComponent(gridComponent)
        XCTAssertEqual(gridSystem.grid, gridComponent)
    }

    func testAddMultipleComponents() {
        let gridSystem = GridSystem()
        let gridComponent1 = GridComponent(rows: 3, columns: 3)
        let gridComponent2 = GridComponent(rows: 3, columns: 3)

        gridSystem.addComponent(gridComponent1)
        gridSystem.addComponent(gridComponent2)

        XCTAssertEqual(gridSystem.grid, gridComponent1)
        XCTAssertNotEqual(gridSystem.grid, gridComponent2)
    }

    func testPlantCrop() {
        let gridSystem = GridSystem()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        gridSystem.addComponent(gridComponent)

        let entity = GKEntity()
        gridComponent.setEntity(entity, row: 1, column: 1)

        let crop = gridSystem.plantCrop(cropType: .potato, row: 1, column: 1)
        XCTAssertNotNil(crop)
        XCTAssertEqual(entity.component(ofType: CropComponent.self), crop)
    }

    func testPlantCropOnOccupiedEntity() {
        let gridSystem = GridSystem()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        gridSystem.addComponent(gridComponent)

        let entity = GKEntity()
        gridComponent.setEntity(entity, row: 1, column: 1)

        let crop1 = gridSystem.plantCrop(cropType: .potato, row: 1, column: 1)
        let crop2 = gridSystem.plantCrop(cropType: .potato, row: 1, column: 1)

        XCTAssertNotNil(crop1)
        XCTAssertNil(crop2)
    }

    func testHarvestCrop() {
        let gridSystem = GridSystem()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        gridSystem.addComponent(gridComponent)

        let entity = GKEntity()
        gridComponent.setEntity(entity, row: 1, column: 1)

        let crop = gridSystem.plantCrop(cropType: .potato, row: 1, column: 1)
        let harvestedCrop = gridSystem.harvestCrop(row: 1, column: 1)

        XCTAssertEqual(crop, harvestedCrop)
        XCTAssertNil(entity.component(ofType: CropComponent.self))
    }

    func testHarvestCropFromEmptyEntity() {
        let gridSystem = GridSystem()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        gridSystem.addComponent(gridComponent)

        let entity = GKEntity()
        gridComponent.setEntity(entity, row: 1, column: 1)

        let harvestedCrop = gridSystem.harvestCrop(row: 1, column: 1)
        XCTAssertNil(harvestedCrop)
    }
}
