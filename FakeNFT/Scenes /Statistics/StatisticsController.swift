import UIKit
import Kingfisher
import ProgressHUD

final class StatisticsViewController: UIViewController, StatisticsViewDelegate {
    
    // MARK: - Private Properties
    private let loadingIndicator = StatisticsUIBlockingProgressHud()
    private let statisticsPresenter: StatisticsPresenterProtocol?
    
    // MARK: - UI Properties
    private lazy var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Statistics/sort")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(StatisticsTableViewCell.self)
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    // MARK: - Initializers
    init(presenter: StatisticsPresenterProtocol) {
        self.statisticsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        self.tabBarController?.tabBar.isTranslucent = false
        
        statisticsPresenter?.statisticsViewOpened()
    }
    
    @MainActor
    func showLoadingIndicator(_ show: Bool) {
        if show == true {
            StatisticsUIBlockingProgressHud.show()
        } else {
            StatisticsUIBlockingProgressHud.dismiss()
        }
    }
    
    func displayUsersList(users: [StatisticsUser]) {
        view.addSubview(topBarView)
        topBarView.addSubview(sortButton)
        view.addSubview(tableView)
        tableView.backgroundColor = .ypWhite
        
        NSLayoutConstraint.activate([
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 42),
            
            sortButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -9),
            sortButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
    }
    
    func loadNextPage(users: [StatisticsUser]) {
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    func showSortActionSheet(alertModel: StatisticsAlertViewModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .actionSheet
        )
        
        for action in alertModel.actions {
            let action = UIAlertAction(title: action.title, style: .default) { _ in
                action.action()
                alert.dismiss(animated: true)
            }
            alert.addAction(action)
        }
        
        if alertModel.cancelAction {
            let cancelAction = UIAlertAction(
                title: NSLocalizedString("Statistics.sort.close", comment: ""),
                style: .cancel
            ) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true)
    }
    
    @objc private func didTapSortButton() {
        statisticsPresenter?.didTapSortButton()
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = statisticsPresenter?.getUsersCount() else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableViewCell.defaultReuseIdentifier,
            for: indexPath
        )
        guard let cell = cell as? StatisticsTableViewCell else { return UITableViewCell() }
        
        // Load cell image from url
        guard let users = statisticsPresenter?.getUsers() else { return UITableViewCell() }
        
        if let url = URL(string: users[indexPath.row].avatar) {
            
            let processor = RoundCornerImageProcessor(cornerRadius: 100, backgroundColor: .clear)
            
            cell.statisticsAvatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle.fill"),
                options: [.processor(processor)]
            )
        }
        
        cell.configureCell(
            user: users[indexPath.row]
        )
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard statisticsPresenter?.checkPagesOut() == false else { return }
        
        guard let usersCount = statisticsPresenter?.getUsersCount() else { return }
        
        if indexPath.row + 1 == usersCount {
            statisticsPresenter?.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let users = statisticsPresenter?.getUsers() else { return }
        
        let presenter = StatisticsProfilePresenter(
            networkManager: StatisticsNetworkManager.shared,
            userId: users[indexPath.row].id
        )
        
        let view = StatisticsProfileViewController(
            presenter: presenter
        )
        presenter.setViewDelegate(statisticsProfileViewDelegate: view)
        view.modalPresentationStyle = .currentContext
        view.modalTransitionStyle = .crossDissolve
        present(view, animated: true)
        
    }
}
