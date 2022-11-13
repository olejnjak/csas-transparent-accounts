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
                    await self?.viewModel.fetchAccounts()
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
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await viewModel.fetchAccounts()
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
            showAccounts([])
        case .error(let error):
            loadingAI.stopAnimating()
            showAccounts([])
        case .data(let data):
            loadingAI.stopAnimating()
            showAccounts(data)
        }
    }
    
    private func showAccounts(_ accounts: [Account]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Account>()
        snapshot.appendSections([0])
        snapshot.appendItems(accounts)
        dataSource?.apply(snapshot)
    }
}
