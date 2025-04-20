//
//  PlotOccupantSlotComponentTests.swift
//  Ah Leongs FarmTests
//
//  Created by Lester Ong on 20/4/25.
//

import XCTest
@testable import Ah_Leongs_Farm

final class PlotOccupantSlotComponentTests: XCTestCase {
    class MockPlotOccupant: EntityAdapter, PlotOccupant {}

    func testInitWithNilPlotOccupant() {
        let component = PlotOccupantSlotComponent()

        XCTAssertNotNil(component)
        XCTAssertNil(component.plotOccupant)
    }

    func testInitWithPlotOccupant() {
        let mockOccupant = MockPlotOccupant()
        let component = PlotOccupantSlotComponent(plotOccupant: mockOccupant)

        XCTAssertNotNil(component)
        XCTAssertNotNil(component.plotOccupant)
        XCTAssertTrue(component.plotOccupant === mockOccupant)
    }

    func testSetPlotOccupant() {
        let component = PlotOccupantSlotComponent()
        let mockOccupant = MockPlotOccupant()

        component.plotOccupant = mockOccupant

        XCTAssertNotNil(component.plotOccupant)
        XCTAssertTrue(component.plotOccupant === mockOccupant)
    }

    func testSetPlotOccupantToNil() {
        let mockOccupant = MockPlotOccupant()
        let component = PlotOccupantSlotComponent(plotOccupant: mockOccupant)

        component.plotOccupant = nil

        XCTAssertNil(component.plotOccupant)
    }
}
