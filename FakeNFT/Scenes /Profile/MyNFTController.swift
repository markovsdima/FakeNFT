import UIKit

protocol MyNFTViewControllerProtocol {
    
    func refreshNfts(nfts: [MyNFT])
}

protocol MyNFTViewControllerDelegate {
    func didSelectCategory()
}

final class MyNFTViewController: UIViewController {
    
    var delegate: MyNFTViewControllerDelegate?
    var presenter: FavoriteNFTPresenterProtocol?
    
    private var visibleNfts: [MyNFT] = []

    private let nfts: [String] = ["Lilo", "Spring", "April"]
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        button.image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.action = #selector(close)
        button.target = self
        return button
    }()
    
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(
                named: "profileImages/sort"
            )?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        return button
    }()
    
    private lazy var myNFTTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .ypWhite
        table.delegate = self
        table.dataSource = self
        table.register(
            ProfileMyNFTTableCell.self,
            forCellReuseIdentifier: ProfileMyNFTTableCell.reuseIdentifier
        )
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var emptyNFTsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.text = "У Вас ещё нет NFT"
        label.isHidden = true
        return label
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupNavBar()
        addElements()
        setupConstraints()
    }
    
    //MARK: - Private Methods
    @objc
    private func sortButtonTapped(){
        print("sort button tapped")
        showSortAlert()
        
    }
    
    @objc private func close() {
        print("closed")
        navigationController?.popViewController(animated: true)
        
    }
    
    func selectCell(cellIndex: Int) {

    }
    
    private func setupNavBar(){
        navigationItem.title = "Мои NFT"
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
    }
    
    private func addElements() {
        view.addSubview(myNFTTableView)
        view.addSubview(emptyNFTsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            myNFTTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emptyNFTsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNFTsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func showSortAlert() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "По цене",
                                      style: .default) { _ in
            
        })
        alert.addAction(UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { _ in
        })
        alert.addAction(UIAlertAction(
            title: "По названию",
            style: .default
        ) { _ in
        })
        alert.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel
        ) { _ in
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupPaceholder() {
        let nftsEmpty = nfts.isEmpty
        if nftsEmpty == true {
            emptyNFTsLabel.isHidden = false
//            sortButton.isHidden = true
            navigationItem.title = ""
//            tableView.isHidden = true
        }
    }
}

//MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileMyNFTTableCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileMyNFTTableCell else {
            return ProfileMyNFTTableCell()
        }
        
        cell.configureCell(name: nfts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

//MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(cellIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
