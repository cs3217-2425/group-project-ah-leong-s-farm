import XCTest
@testable import Ah_Leongs_Farm

class GridComponentTests: XCTestCase {

    func testInitialization() {
        let gridComponent = GridComponent(rows: 3, columns: 3)
        XCTAssertEqual(gridComponent.numberOfRows, 3)
        XCTAssertEqual(gridComponent.numberOfColumns, 3)
    }

    func testSetAndGetEntity() {
        let gridComponent = GridComponent(rows: 3, columns: 3)
        let entity = EntityAdapter()

        gridComponent.setEntity(entity, row: 1, column: 1)

        guard let gridEntity = gridComponent.getEntity(row: 1, column: 1) else {
            XCTFail()
            return
        }

        XCTAssertEqual(gridEntity.id, entity.id)
    }

    func testSetEntityOutOfBounds() {
        let gridComponent = GridComponent(rows: 3, columns: 3)
        let entity = EntityAdapter()

        gridComponent.setEntity(entity, row: 3, column: 3)
        XCTAssertNil(gridComponent.getEntity(row: 3, column: 3))
    }

    func testGetEntityOutOfBounds() {
        let gridComponent = GridComponent(rows: 3, columns: 3)
        XCTAssertNil(gridComponent.getEntity(row: 3, column: 3))
    }
}
