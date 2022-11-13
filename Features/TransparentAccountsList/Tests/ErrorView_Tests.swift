import SnapshotTesting
import XCTest

@testable import TransparentAccountsList

final class ErrorView_Tests: XCTestCase {
    func test_appearance_noAction() {
        assertSnapshot(
            matching: ErrorView(message: "Nepodařilo se načíst data", action: nil),
            as: .image(layout: .device(config: .iPhone13Pro)),
            record: true
        )
    }
    
    func test_appearance_withAction() {
        assertSnapshot(
            matching: ErrorView(
                message: "Nepodařilo se načíst data",
                action: .init(title: "Opakovat", handler: { })
            ),
            as: .image(layout: .device(config: .iPhone13Pro)),
            record: true
        )
    }
}
