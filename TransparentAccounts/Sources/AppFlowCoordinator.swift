import TransparentAccountsList
import UIKit

final class AppFlowCoordinator {
    func start(in window: UIWindow) {
        let listVM = createAccountsListVM(accountsAPI: appDependencies.transparentAccountsAPI)
        let listVC = AccountsListViewController(viewModel: listVM)
        
        window.rootViewController = listVC
        window.makeKeyAndVisible()
    }
}
