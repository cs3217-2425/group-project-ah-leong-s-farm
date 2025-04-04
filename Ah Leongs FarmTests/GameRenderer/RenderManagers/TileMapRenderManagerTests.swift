import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class TileMapRenderManagerTests: XCTestCase {

    func testCreateNode() {
        let tileMapRenderManager = TileMapRenderManager()
        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)

        let renderer = GameRenderer()
        tileMapRenderManager.createNode(for: entity, in: renderer)

        XCTAssertEqual(renderer.allRenderNodes.count, 1)
    }

    func testCreateNodeWithoutGridComponent() {
        let tileMapRenderManager = TileMapRenderManager()
        let entity = GKEntity()

        let renderer = GameRenderer()
        tileMapRenderManager.createNode(for: entity, in: renderer)

        XCTAssertTrue(renderer.allRenderNodes.isEmpty)
    }
}
