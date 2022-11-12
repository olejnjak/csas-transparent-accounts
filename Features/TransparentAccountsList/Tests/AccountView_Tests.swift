import SnapshotTesting
import XCTest

@testable import TransparentAccountsList

final class AccountView_Tests: XCTestCase {
    func test_appearance() {
        assertSnapshot(
            matching: AccountView(account: .test()),
            as: .image(layout: .fixed(width: 300, height: 150))
        )
    }
}
