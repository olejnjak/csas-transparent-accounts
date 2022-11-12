import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TransparentAccounts",
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            requirement: .upToNextMajor(from: "1.10.0")
        ),
    ],
    targets: [
        app,
        core,
        transparentAccountsList, transparentAccountsListTests,
    ]
)
