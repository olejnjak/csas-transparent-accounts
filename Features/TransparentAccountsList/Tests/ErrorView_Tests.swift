import SnapshotTesting
import XCTest

@testable import TransparentAccountsList

final class ErrorView_Tests: XCTestCase {
    func test_appearance() {
        assertSnapshot(
            matching: ErrorView(message: "Nepodařilo se načíst data"),
            as: .image(layout: .device(config: .iPhone13Pro))
        )
    }
}
