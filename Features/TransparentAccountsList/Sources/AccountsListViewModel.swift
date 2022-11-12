import Combine
import Core
import Foundation

public protocol AccountsListViewModeling {
    var state: any Publisher<DataState<[Account], Error>, Never> { get }
    
    func fetchAccounts() async
}

final class AccountsListViewModel: AccountsListViewModeling {
    struct Dependencies {
        let accountsAPI: Core.TransparentAccountsAPI
    }
    
    @Property(.data([])) var state: any Publisher<DataState<[Account], Error>, Never>
    
    private let accountsAPI: Core.TransparentAccountsAPI
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        accountsAPI = dependencies.accountsAPI
    }
    
    func fetchAccounts() async {
        do {
            $state.value = .loading
            
            let response = try await accountsAPI.transparentAccounts(page: 0, size: 25, filter: nil)
            $state.value = .data(response.page?.map { $0.domain } ?? [])
        } catch {
            $state.value = .error(error)
        }
    }
}
