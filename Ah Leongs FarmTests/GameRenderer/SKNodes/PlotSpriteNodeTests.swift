//
//  PlotSpriteNodeTests.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 6/4/25.
//

import XCTest
import SpriteKit
@testable import Ah_Leongs_Farm

class PlotSpriteNodeTests: XCTestCase {
    func testPlotSpriteNodeInitialization() {
        let texture = SKTexture(imageNamed: "testTexture")
        let plotSpriteNode = PlotSpriteNode(texture: texture, color: .blue, size: CGSize(width: 32, height: 32))

        XCTAssertEqual(plotSpriteNode.texture, texture)
        XCTAssertEqual(plotSpriteNode.color, .blue)
        XCTAssertEqual(plotSpriteNode.size, CGSize(width: 32, height: 32))
        XCTAssertTrue(plotSpriteNode.isUserInteractionEnabled)
    }

    func testSetHandler() {
        let plotSpriteNode = PlotSpriteNode(imageNamed: "testTexture")
        let mockHandler = MockPlotSpriteNodeTouchHandler()

        plotSpriteNode.setHandler(mockHandler)

        XCTAssertTrue(plotSpriteNode.handler === mockHandler)
    }

    func testTouchesBegan() {
        let plotSpriteNode = PlotSpriteNode(imageNamed: "testTexture")
        let mockHandler = MockPlotSpriteNodeTouchHandler()
        plotSpriteNode.setHandler(mockHandler)

        plotSpriteNode.touchesBegan(Set<UITouch>(), with: nil)

        XCTAssertTrue(mockHandler.didHandleTouch)
    }
}

// Mock classes
class MockPlotSpriteNodeTouchHandler: PlotSpriteNodeTouchHandler {
    var didHandleTouch = false

    func handleTouch(node: PlotSpriteNode) {
        didHandleTouch = true
    }
}
