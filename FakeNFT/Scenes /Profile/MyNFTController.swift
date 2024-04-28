import UIKit

protocol MyNFTViewControllerDelegate {
    func didSelectCategory()
}

final class MyNFTViewController: UIViewController {
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        button.image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.action = #selector(close)
        button.target = self
        return button
    }()

    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        button.image = UIImage(systemName: "chevron.right", withConfiguration: config)//TO DO
//        button.image = UIImage(named: "sort", inBundle: <#Bundle?#>, withConfiguration: config)
        button.action = #selector(sortButtonTapped)
        button.target = self
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
        
    @objc
    private func sortButtonTapped(){
        print("sort button tapped")
    }
    
    @objc private func close() {
        print("closed")
        navigationController?.popViewController(animated: true)

    }
    
    private func setupNavBar(){
        navigationItem.title = "Мои NFT"
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
    }
    
}
    
//    var delegate: MyNFTViewControllerDelegate?
//
//        enum OrderProperty: String {
//            case name = "name"
//            case prise = "price"
//            case rating = "rating"
//        }
//
//    private lazy var myNFTSortButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .ypBlack
//        button.setImage(UIImage(named: "profileImages/sort"), for: .normal)
//        button.accessibilityIdentifier = "sortButton"
//        button.addTarget(self, action: #selector(showSortingOptions), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//        private lazy var myNFTtableView: UITableView = {
//            let table = UITableView()
//            table.translatesAutoresizingMaskIntoConstraints = false
//            table.backgroundColor = .ypWhite
//            table.delegate = self
//            table.dataSource = self
//            table.register(ProfileMyNFTTableCell.self, forCellReuseIdentifier: ProfileMyNFTTableCell.reuseIdentifier)
//            table.separatorStyle = .none
//            return table
//        }()
//
//
//
////        init(myNFTsViewModel: ProfileMyNFTsViewModel) {
////            self.myNFTsViewModel = myNFTsViewModel
////            super.init(nibName: nil, bundle: nil)
////
////            setupBindings()
////        }
////
////        required init?(coder: NSCoder) {
////            fatalError("init(coder:) has not been implemented")
////        }
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            setupUI()
//            setupUILayout()
//        }
//
//        @objc
//    @objc func showSortingOptions() {
//        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: {_
//        }))
//        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: {_
//        }))
//        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: {_
//        }))
//        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
//
//        present(alert, animated: true)
//    }
//
//    //MARK: - UICollectionViewDataSource
//    extension MyNFTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            visibleNFTs.count
//        }
//
//        func collectionView(_ collectionView: UICollectionView,
//                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let nft = visibleNFTs[indexPath.item]
//            switch viewType {
//            case .showNFTs:
//                let isLiked = profile.likes.contains(nft.id)
//                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyNFTCell.identifier,
//                        for: indexPath) as? MyNFTCell {
//                    cell.configure(with: nft, isLiked: isLiked)
//                    return cell
//                }
//            case .showFavoriteNFTs:
//                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteNFTCell.identifier,
//                        for: indexPath) as? FavoriteNFTCell {
//                    cell.configure(with: nft)
//                    cell.likeButtonTapped = { [weak self] in
//                        self?.handleLikeButtonTapped(nftId: nft.id)
//                    }
//                    return cell
//                }
//            }
//            return UICollectionViewCell()
//        }
//
//        private func createFlowLayout() -> UICollectionViewFlowLayout {
//            let layout = UICollectionViewFlowLayout()
//
//            let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//            layout.sectionInset = sectionInsets
//
//            let availableWidth = view.bounds.width - sectionInsets.left - sectionInsets.right
//            layout.itemSize = CGSize(width: availableWidth, height: 140)
//            layout.minimumLineSpacing = 0
//            return layout
//        }
//
//        private func createGridLayout() -> UICollectionViewFlowLayout {
//            let layout = UICollectionViewFlowLayout()
//            let interItemSpacing: CGFloat = 7
//            let numberOfItemsPerRow: CGFloat = 2
//            let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//            layout.sectionInset = sectionInsets
//            let availableWidth = view.bounds.width - sectionInsets.left - sectionInsets.right - interItemSpacing
//            let itemWidth: CGFloat = availableWidth / numberOfItemsPerRow
//            layout.itemSize = CGSize(width: itemWidth, height: 80)
//            layout.minimumInteritemSpacing = interItemSpacing
//            layout.minimumLineSpacing = 20
//            return layout
//        }
//
//        private func handleLikeButtonTapped(nftId: String) {
//            guard viewType == .showFavoriteNFTs else {
//                return
//            }
//
//            if let index = visibleNFTs.firstIndex(where: { $0.id == nftId }) {
//                visibleNFTs.remove(at: index)
//                collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
//
//                var updatedLikes = visibleNFTs.map {
//                    $0.id
//                }
//                presenter?.updateLikes(id: Constants.profileId, likes: updatedLikes)
//
//                if visibleNFTs.isEmpty {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        self.reloadPlaceholders()
//                    }
//                }
//            }
//        }
//    }
