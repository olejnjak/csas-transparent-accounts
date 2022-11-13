import ProjectDescription

public let transparentAccountsList = Target(
    name: "TransparentAccountsList",
    platform: .iOS,
    product: .staticFramework,
    bundleId: "cz.olejnjak.TransparentAccounts.TransparentAccountsList",
    sources: [
        "Features/TransparentAccountsList/Sources/**",
        "Features/TransparentAccountsList/Development_Sources/**",
    ],
    resources: "Features/TransparentAccountsList/Resources/**",
    dependencies: [
        .target(name: core.name),
    ],
    settings: .settings(base: [
        "DEVELOPMENT_ASSET_PATHS": "$SRCROOT/Features/TransparentAccountsList/Development_Sources"
    ])
)

public let transparentAccountsListTests = Target(
    name: transparentAccountsList.name + "_Tests",
    platform: .iOS,
    product: .unitTests,
    bundleId: transparentAccountsList.bundleId + ".tests",
    sources: "Features/TransparentAccountsList/Tests/**",
    dependencies: [
        .target(name: transparentAccountsList.name),
        .package(product: "SnapshotTesting")
    ]
)
