import UIKit

public final class AccountsListViewController: UIViewController {
    private let viewModel: AccountsListViewModeling
    
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
    }
}
