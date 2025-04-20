import XCTest
@testable import Ah_Leongs_Farm

final class QuestCriteriaTests: XCTestCase {

    func testPlantCropCriteria_correctCropType() {
        let criteria = PlantCropCriteria(cropType: Apple.type)
        let eventData = PlantCropEventData(row: 0, column: 2, cropType: Apple.type, isSuccessfullyPlanted: true)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 1.0)
    }

    func testPlantCropCriteria_incorrectCropType() {
        let criteria = PlantCropCriteria(cropType: BokChoy.type)
        let eventData = PlantCropEventData(row: 3, column: 0, cropType: Potato.type, isSuccessfullyPlanted: true)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testPlantCropCriteria_invalidEventData() {
        let criteria = PlantCropCriteria(cropType: BokChoy.type)
        let eventData = EndTurnEventData(endTurnCount: 5)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testHarvestCropCriteria_correctCropType() {
        let criteria = HarvestCropCriteria(cropType: Potato.type)
        let eventData = HarvestCropEventData(cropType: Potato.type, quantity: 10)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 10.0)
    }

    func testHarvestCropCriteria_incorrectCropType() {
        let criteria = HarvestCropCriteria(cropType: Apple.type)
        let eventData = HarvestCropEventData(cropType: Potato.type, quantity: 10)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testHarvestCropCriteria_invalidEventData() {
        let criteria = HarvestCropCriteria(cropType: Apple.type)
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
        let eventData = HarvestCropEventData(cropType: BokChoy.type, quantity: 5)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testSellCropCriteria_correctCropType() {
        let criteria = SellItemCriteria(itemType: Apple.type)
        let eventData = SellItemEventData(itemType: Apple.type, quantity: 8)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 8.0)
    }

    func testSellCropCriteria_incorrectCropType() {
        let criteria = SellItemCriteria(itemType: Apple.type)
        let eventData = SellItemEventData(itemType: Potato.type, quantity: 8)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }

    func testSellCropCriteria_invalidEventData() {
        let criteria = SellItemCriteria(itemType: Apple.type)
        let eventData = EndTurnEventData(endTurnCount: 2)
        XCTAssertEqual(criteria.calculateValue(from: eventData), 0.0)
    }
}
