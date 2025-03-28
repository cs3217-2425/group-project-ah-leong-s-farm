import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class TileMapRenderManagerTests: XCTestCase {

    func testCreateNode() {
        let TileMapRenderManager = TileMapRenderManager()
        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)

        let scene = SKScene(size: CGSize(width: 100, height: 100))
        TileMapRenderManager.createNode(of: entity, in: scene)

        XCTAssertTrue(scene.children.count == 1)
    }

    func testCreateNodeWithoutGridComponent() {
        let TileMapRenderManager = TileMapRenderManager()
        let entity = GKEntity()

        let scene = SKScene(size: CGSize(width: 100, height: 100))
        TileMapRenderManager.createNode(of: entity, in: scene)

        XCTAssertTrue(scene.children.isEmpty)
    }
}
