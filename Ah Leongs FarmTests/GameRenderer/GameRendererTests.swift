import XCTest
import GameplayKit
@testable import Ah_Leongs_Farm

class GameRendererTests: XCTestCase {

    func testInit() {
        let gameScene = GameScene(size: CGSize(width: 100, height: 100))
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)
        XCTAssertNotNil(gameRenderer)
    }

    func testNotifyAddsNodesToScene() {
        let gameScene = GameScene(size: CGSize(width: 100, height: 100))
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)
        
        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)
        let entities: Set<GKEntity> = [entity]
        
        // Using the observer method to trigger node creation.
        gameRenderer.observe(entities: entities)
        
        // Assert that a node was added to the game scene.
        XCTAssertEqual(gameScene.children.count, 1)
    }

    func testNotifyDoesNotAddDuplicateNodes() {
        let gameScene = GameScene(size: CGSize(width: 100, height: 100))
        let gameRenderer = GameRenderer()
        gameRenderer.setScene(gameScene)
        
        let entity = GKEntity()
        let gridComponent = GridComponent(rows: 3, columns: 3)
        entity.addComponent(gridComponent)
        let entities: Set<GKEntity> = [entity]
        
        // First update should add the node.
        gameRenderer.observe(entities: entities)
        // Second update should not add a duplicate.
        gameRenderer.observe(entities: entities)
        
        XCTAssertEqual(gameScene.children.count, 1)
    }
}
