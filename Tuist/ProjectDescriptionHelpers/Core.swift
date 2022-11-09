import ProjectDescription

public let core = Target(
    name: "Core",
    platform: .iOS,
    product: .framework,
    bundleId: "cz.olejnjak.TransparentAccounts.Core",
    sources: "Core/Sources/**",
    resources: "Core/Resources/**"
)
