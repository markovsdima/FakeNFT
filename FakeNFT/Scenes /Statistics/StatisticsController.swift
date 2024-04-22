import UIKit
import Kingfisher
import ProgressHUD

final class StatisticsViewController: UIViewController, StatisticsViewDelegate {
    
    // MARK: - Private Properties
    private let loadingIndicator = StatisticsUIBlockingProgressHud()
    private let statisticsPresenter = StatisticsPresenter()
    private var users: [StatisticsUser] = []
    private var page: Int = 0
    private var isLoading = false
    private var pagesOut = false
    
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
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        self.tabBarController?.tabBar.isTranslucent = false
        
        statisticsPresenter.setViewDelegate(statisticsViewDelegate: self)
        statisticsPresenter.statisticsViewOpened()
    }
    
    // MARK: Public Methods
    func stopLoadingPages() {
        pagesOut = true
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
        
        self.users += users
        tableView.reloadData()
    }
    
    func loadNextPage(users: [StatisticsUser]) {
        self.users += users
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func showSortActionSheet() {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("Statistics.sort", comment: ""),
            preferredStyle: .actionSheet
        )
        
        let sortByNameAction = UIAlertAction(
            title: NSLocalizedString("Statistics.sort.byName", comment: ""),
            style: .default
        ) { _ in
            
            alert.dismiss(animated: true)
        }
        
        let sortByRatingAction = UIAlertAction(
            title: NSLocalizedString("Statistics.sort.byRating", comment: ""),
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Statistics.sort.close", comment: ""),
            style: .cancel
        ) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(sortByNameAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc private func didTapSortButton() {
        showSortActionSheet()
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsTableViewCell.defaultReuseIdentifier,
            for: indexPath
        )
        guard let cell = cell as? StatisticsTableViewCell else { return UITableViewCell() }
        
        // Load cell image from url
        if let url = URL(string: users[indexPath.row].avatar) {
            
            let processor = RoundCornerImageProcessor(cornerRadius: 100, backgroundColor: .clear)
            
            cell.statisticsAvatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle.fill"),
                options: [.processor(processor)]
            )
        }
        
        cell.configureCell(
            position: users[indexPath.row].rating,
            name: users[indexPath.row].name,
            nft: "\(users[indexPath.row].score)",
            url: users[indexPath.row].avatar
        )
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard pagesOut == false else { return }
        
        if indexPath.row + 1 == users.count {
            
            let nextPage: Double = (Double(users.count) / 15).rounded(.up)
            
            statisticsPresenter.loadNextPage(page: Int(nextPage))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = StatisticsProfileViewController(userId: users[indexPath.row].id)
        view.modalPresentationStyle = .currentContext
        view.modalTransitionStyle = .crossDissolve
        present(view, animated: true)
        
    }
}
