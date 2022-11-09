import ProjectDescription

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
    resources: "TransparentAccounts/Resources/**",
    dependencies: [
        .target(name: core.name),
    ]
)
