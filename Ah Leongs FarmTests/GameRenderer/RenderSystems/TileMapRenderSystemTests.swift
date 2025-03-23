import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class TileMapRenderSystemTests: XCTestCase {

    func testCreateNode() {
        let tileMapRenderSystem = TileMapRenderSystem()
        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)

        let node = tileMapRenderSystem.createNode(of: entity)

        XCTAssertNotNil(node)
        XCTAssertTrue(node is TileMapRenderNode)
    }

    func testCreateNodeWithoutGridComponent() {
        let tileMapRenderSystem = TileMapRenderSystem()
        let entity = GKEntity()

        let node = tileMapRenderSystem.createNode(of: entity)

        XCTAssertNil(node)
    }
}
