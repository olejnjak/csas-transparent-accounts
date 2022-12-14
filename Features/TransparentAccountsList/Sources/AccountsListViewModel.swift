import Combine
import Core
import Foundation

public protocol AccountsListViewModeling {
    var state: any Publisher<DataState<[Account], Error>, Never> { get }
    
    func fetchAccounts(isRefreshing: Bool) async
}

public func createAccountsListVM(
    accountsAPI: Core.TransparentAccountsAPI
) -> AccountsListViewModeling {
    AccountsListViewModel(accountsAPI: accountsAPI)
}

final class AccountsListViewModel: AccountsListViewModeling {
    @Property(.data([])) var state: any Publisher<DataState<[Account], Error>, Never>
    
    private let accountsAPI: Core.TransparentAccountsAPI
    
    // MARK: - Initializers
    
    init(accountsAPI: Core.TransparentAccountsAPI) {
        self.accountsAPI = accountsAPI
    }
    
    func fetchAccounts(isRefreshing: Bool) async {
        do {
            $state.value = isRefreshing ? .refreshing : .loading
            
            let response = try await accountsAPI.transparentAccounts(page: 0, size: 25, filter: nil)
            $state.value = .data(response.page?.compactMap { $0.domain } ?? [])
        } catch {
            $state.value = .error(error)
        }
    }
}
