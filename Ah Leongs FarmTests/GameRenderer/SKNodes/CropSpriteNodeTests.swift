//
//  CropSpriteNodeTests.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 6/4/25.
//

import XCTest
import SpriteKit
@testable import Ah_Leongs_Farm

class CropSpriteNodeTests: XCTestCase {
    func testInitialization() {
        let texture = SKTexture(imageNamed: "testTexture")
        let spriteNode = SpriteNode(texture: texture, color: .red, size: CGSize(width: 32, height: 32))

        XCTAssertEqual(spriteNode.texture, texture)
        XCTAssertEqual(spriteNode.color, .red)
        XCTAssertEqual(spriteNode.size, CGSize(width: 32, height: 32))
        XCTAssertTrue(spriteNode.isUserInteractionEnabled)
    }

    func testSetHandler() {
        let cropSpriteNode = CropSpriteNode(imageNamed: "testTexture")
        let mockHandler = MockCropSpriteNodeTouchHandler()

        cropSpriteNode.setHandler(mockHandler)

        XCTAssertTrue(cropSpriteNode.handler === mockHandler)
    }

    func testTouchesBegan() {
        let cropSpriteNode = CropSpriteNode(imageNamed: "testTexture")
        let mockHandler = MockCropSpriteNodeTouchHandler()
        cropSpriteNode.setHandler(mockHandler)

        cropSpriteNode.touchesBegan(Set<UITouch>(), with: nil)

        XCTAssertTrue(mockHandler.didHandleTouch)
    }
}

// Mock classes
class MockCropSpriteNodeTouchHandler: CropSpriteNodeTouchHandler {
    var didHandleTouch = false

    func handleTouch(node: CropSpriteNode) {
        didHandleTouch = true
    }
}
