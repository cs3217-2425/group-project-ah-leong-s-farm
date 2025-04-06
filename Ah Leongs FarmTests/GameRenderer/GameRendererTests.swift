import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class GameRendererTests: XCTestCase {

    func testInit() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)
        XCTAssertNotNil(gameRenderer)
    }

    func testNotifyAddsNodesToScene() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)
        let entities: Set<GKEntity> = [entity]

        gameRenderer.observe(entities: entities)

        XCTAssertEqual(gameScene.children.count, 1)
    }

    func testNotifyDoesNotAddDuplicateNodes() {
        let gameScene = GameScene(view: SKView())
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)

        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)
        let entities: Set<GKEntity> = [entity]

        gameRenderer.observe(entities: entities)
        gameRenderer.observe(entities: entities)

        XCTAssertEqual(gameScene.children.count, 1)
    }
}
