import XCTest
@testable import Ah_Leongs_Farm

final class YieldComponentTests: XCTestCase {
    func testInitializationWithYieldAndMaxYield() {
        let yield = 5
        let maxYield = 10
        let component = YieldComponent(yield: yield, maxYield: maxYield)
        
        XCTAssertEqual(component.yield, yield)
        XCTAssertEqual(component.maxYield, maxYield)
    }
    
    func testInitializationWithMaxYield() {
        let maxYield = 10
        let component = YieldComponent(maxYield: maxYield)
        
        XCTAssertEqual(component.yield, maxYield)
        XCTAssertEqual(component.maxYield, maxYield)
    }
    
    func testYieldCannotExceedMaxYield() {
        let yield = 15
        let maxYield = 10
        let component = YieldComponent(yield: yield, maxYield: maxYield)
        
        XCTAssertEqual(component.yield, yield)
        XCTAssertEqual(component.maxYield, maxYield)
    }
    
    func testZeroYieldAndMaxYield() {
        let component = YieldComponent(yield: 0, maxYield: 0)
        
        XCTAssertEqual(component.yield, 0)
        XCTAssertEqual(component.maxYield, 0)
    }
    
    func testNegativeValues() {
        let yield = -5
        let maxYield = -10
        let component = YieldComponent(yield: yield, maxYield: maxYield)
        
        XCTAssertEqual(component.yield, yield)
        XCTAssertEqual(component.maxYield, maxYield)
    }
} 
