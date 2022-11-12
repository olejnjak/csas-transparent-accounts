import SnapshotTesting
import XCTest

@testable import TransparentAccountsList

final class AccountInfoView_Tests: XCTestCase {
    func test_appearance() {
        assertSnapshot(
            matching: AccountInfoView(account: .test()),
            as: .image(layout: .fixed(width: 300, height: 120))
        )
    }
}
