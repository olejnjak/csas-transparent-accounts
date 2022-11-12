import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = UIViewController()
        window.rootViewController?.view.backgroundColor = .red
        window.makeKeyAndVisible()
        self.window = window
        
        Task {
            do {
                let response = try await appDependencies.transparentAccountsAPI
                    .transparentAccounts(page: 0, size: 25, filter: nil)
                print("[RESPONSE]", response.page)
            } catch {
                print("[ERROR]", error)
            }
        }
    }
}

