import XCTest
@testable import Ah_Leongs_Farm

final class QuestCriteriaTests: XCTestCase {

    func testPlantCropCriteria_correctCropType() {
        let criteria = PlantCropCriteria(cropType: .apple)
        let eventData = PlantCropEventData(row: 0, column: 2, cropType: .apple, isSuccessfullyPlanted: true)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 1.0)
    }

    func testPlantCropCriteria_incorrectCropType() {
        let criteria = PlantCropCriteria(cropType: .apple)
        let eventData = PlantCropEventData(row: 3, column: 0, cropType: .potato, isSuccessfullyPlanted: true)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testPlantCropCriteria_invalidEventData() {
        let criteria = PlantCropCriteria(cropType: .apple)
        let eventData = EndTurnEventData(endTurnCount: 5)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testHarvestCropCriteria_correctCropType() {
        let criteria = HarvestCropCriteria(cropType: .apple)
        let eventData = HarvestCropEventData(type: .apple, quantity: 10)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 10.0)
    }

    func testHarvestCropCriteria_incorrectCropType() {
        let criteria = HarvestCropCriteria(cropType: .apple)
        let eventData = HarvestCropEventData(type: .potato, quantity: 10)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testHarvestCropCriteria_invalidEventData() {
        let criteria = HarvestCropCriteria(cropType: .apple)
        let eventData = EndTurnEventData(endTurnCount: 5)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testSurviveNumberOfTurnsCriteria_validData() {
        let criteria = SurviveNumberOfTurnsCriteria()
        let eventData = EndTurnEventData(endTurnCount: 3)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 3.0)
    }

    func testSurviveNumberOfTurnsCriteria_invalidEventData() {
        let criteria = SurviveNumberOfTurnsCriteria()
        let eventData = HarvestCropEventData(type: .apple, quantity: 5)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testSellCropCriteria_correctCropType() {
        let criteria = SellCropCriteria(cropType: .apple)
        let eventData = SellCropEventData(type: .apple, quantity: 8)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 8.0)
    }

    func testSellCropCriteria_incorrectCropType() {
        let criteria = SellCropCriteria(cropType: .apple)
        let eventData = SellCropEventData(type: .potato, quantity: 8)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testSellCropCriteria_invalidEventData() {
        let criteria = SellCropCriteria(cropType: .apple)
        let eventData = EndTurnEventData(endTurnCount: 2)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }
}
