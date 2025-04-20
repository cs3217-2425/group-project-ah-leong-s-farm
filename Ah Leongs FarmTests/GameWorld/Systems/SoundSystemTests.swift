import XCTest
import AVFoundation
@testable import Ah_Leongs_Farm

class SoundSystemTests: XCTestCase {
    var soundSystem: SoundSystem!
    var mockEntityManager: EntityManager!

    override func setUp() {
        super.setUp()
        mockEntityManager = EntityManager()
        soundSystem = SoundSystem(for: mockEntityManager)
    }

    override func tearDown() {
        soundSystem = nil
        mockEntityManager = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertNotNil(soundSystem)
        XCTAssertNotNil(soundSystem.manager)
    }

    func testMuteState() {
        XCTAssertFalse(soundSystem.isSoundMuted())

        soundSystem.setMuted(true)
        XCTAssertTrue(soundSystem.isSoundMuted())

        soundSystem.setMuted(false)
        XCTAssertFalse(soundSystem.isSoundMuted())
    }

    func testInvalidSoundFiles() {
        soundSystem.playBackgroundMusic(named: "nonexistent")
        soundSystem.playSoundEffect(named: "nonexistent")
    }
}
