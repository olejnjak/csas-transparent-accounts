import Combine
import Core
import SwiftUI
import UIKit

public final class AccountsListViewController: UIViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, Account>
    
    private let viewModel: AccountsListViewModeling
    private static let cell = "Cell"
    
    private var dataSource: DataSource?
    private var cancellables = Set<AnyCancellable>()
    
    private weak var loadingAI: UIActivityIndicatorView!
    private weak var errorView: UIHostingController<ErrorView>!
    private weak var emptyView: UIHostingController<ErrorView>!
    
    // MARK: - Initializers
    
    public init(viewModel: AccountsListViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    public override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        
        let refreshControl = UIRefreshControl()
        refreshControl.addAction(.init { [weak self] action in
            if let refreshControl = action.sender as? UIRefreshControl {
                Task {
                    await self?.viewModel.fetchAccounts(isRefreshing: true)
                    refreshControl.endRefreshing()
                }
            }
        }, for: .valueChanged)
        
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cell)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let dataSource = DataSource(tableView: tableView, cellProvider: Self.cellProvider)
        self.dataSource = dataSource
        
        let loadingAI = UIActivityIndicatorView()
        loadingAI.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingAI)
        NSLayoutConstraint.activate([
            loadingAI.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAI.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        self.loadingAI = loadingAI
        
        let errorView = createErrorView(
            tableView: tableView,
            message: TransparentAccountsListStrings.unableToFetchListOfAccounts,
            action: errorRetryAction()
        )
        self.errorView = errorView
        
        let emptyView = createErrorView(
            tableView: tableView,
            message: TransparentAccountsListStrings.noAccounts,
            action: errorRetryAction()
        )
        self.emptyView = emptyView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await viewModel.fetchAccounts(isRefreshing: false)
        }
        setupBindings()
    }
    
    // MARK: - Private helpers
    
    private static func cellProvider(
        _ tableView: UITableView,
        indexPath: IndexPath,
        account: Account
    ) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cell, for: indexPath)
        cell.contentConfiguration = UIHostingConfiguration {
            AccountView(account: account)
        }
        return cell
    }
    
    private func setupBindings() {
        viewModel.state.sink { [weak self] state in
            DispatchQueue.main.async {
                self?.updateState(state)
            }
        }
        .store(in: &cancellables)
    }
    
    private func updateState(_ state: DataState<[Account], Error>) {
        switch state {
        case .loading:
            loadingAI.startAnimating()
            errorView.view.isHidden = true
            emptyView.view.isHidden = true
            showAccounts([])
        case .refreshing:
            loadingAI.stopAnimating()
        case .error:
            showAccounts([])
            loadingAI.stopAnimating()
            errorView.view.isHidden = false
            emptyView.view.isHidden = true
        case .data(let data):
            loadingAI.stopAnimating()
            errorView.view.isHidden = true
            emptyView.view.isHidden = !data.isEmpty
            showAccounts(data)
        }
    }
    
    private func showAccounts(_ accounts: [Account]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Account>()
        snapshot.appendSections([0])
        snapshot.appendItems(accounts)
        dataSource?.apply(snapshot)
    }
    
    private func errorRetryAction() -> ErrorView.Action {
        .init(title: TransparentAccountsListStrings.tryAgain) { [weak self] in
            Task {
                await self?.viewModel.fetchAccounts(isRefreshing: false)
            }
        }
    }
    
    private func createErrorView(
        tableView: UITableView,
        message: String,
        action: ErrorView.Action?
    ) -> UIHostingController<ErrorView> {
        let hosting = UIHostingController(rootView: ErrorView(
            message: message,
            action: action
        ))
        hosting.sizingOptions = .intrinsicContentSize
        hosting.view.isHidden = true
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.willMove(toParent: self)
        addChild(hosting)
        tableView.addSubview(hosting.view)
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 150),
            hosting.view.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            hosting.view.widthAnchor.constraint(lessThanOrEqualTo: view.readableContentGuide.widthAnchor),
        ])
        hosting.didMove(toParent: self)
        return hosting
    }
}
