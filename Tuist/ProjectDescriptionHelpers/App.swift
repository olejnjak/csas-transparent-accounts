import ProjectDescription

private let environment = Environment.environment.getString(default: "Sandbox")
public let app = Target(
    name: "TransparentAccounts",
    platform: .iOS,
    product: .app,
    bundleId: "cz.olejnjak.TransparentAccounts",
    infoPlist: .extendingDefault(with: [
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                    ]
                ]
            ]
        ],
        "UILaunchScreen": [
            "UINavigationBar": [:]
        ],
    ]),
    sources: "TransparentAccounts/Sources/**",
    resources: [
        "TransparentAccounts/Environment/\(environment)/**",
        "TransparentAccounts/Resources/**",
    ],
    dependencies: [
        .target(name: core.name),
        .target(name: transparentAccountsList.name),
    ]
)
