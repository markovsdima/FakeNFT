import UIKit

class FavoriteNFTController: UIViewController {
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        button.image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.action = #selector(close)
        button.target = self
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
        
    
    @objc private func close() {
        print("closed")
        navigationController?.popViewController(animated: true)

    }
    
    private func setupNavBar(){
        navigationItem.title = "Избранные NFT"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
    }

    
}
    
//    private lazy var collectionView: UICollectionView = {
//        let colView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        colView.backgroundColor = UIColor(named: ColorNames.white)
//        colView.dataSource = self
//        colView.delegate = self
//        colView.register(
//            ProfileFavoriteNFTsCollectionViewCell.self,
//            forCellWithReuseIdentifier: ProfileFavoriteNFTsCollectionViewCell.reuseIdentifier
//        )
//        colView.translatesAutoresizingMaskIntoConstraints = false
//        return colView
//    }()
//
//    init(favoriteNFTsViewModel: ProfileFavoriteNFTsViewModel) {
//        self.favoriteNFTsViewModel = favoriteNFTsViewModel
//        super.init(nibName: nil, bundle: nil)
//
//        setupBindings()
//    }
//
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        setupUI()
////        setupUILayout()
////    }
//
//    private func setupBindings(){
//        favoriteNFTsViewModel.$favoriteNFTs.sink(receiveValue: { [weak self] list in
//            guard let self else { return }
//            if let nftList = list {
//                self.favoriteNFTs = nftList
//                self.gotNFTsData = true
//                collectionView.reloadData()
//                ProgressHUD.dismiss()
//            }
//        }).store(in: &subscriptions)
//
//        favoriteNFTsViewModel.alertInfo = { [weak self] (title, buttonTitle, message) in
//            guard let self else { return }
//            let action = UIAlertAction(title: buttonTitle, style: .cancel)
//            AlertPresenter.shared.presentAlert(title: title, message: message, actions: [action], target: self)
//            ProgressHUD.dismiss()
//        }
//    }
//
//    private func setupUI(){
//        title = NSLocalizedString(LocalizableKeys.profileFavoriteNFTs, comment: "")
//        view.backgroundColor = UIColor(named: ColorNames.white)
//        view.addSubview(collectionView)
//        view.addSubview(plugView)
//        ProgressHUD.show(interaction: false)
//    }
//
//    private func setupUILayout(){
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        ])
//    }
//}
//
//extension ProfileFavoriteNFTsController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let number = favoriteNFTs.count
//        plugView.isHidden = number > 0
//        return number
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: ProfileFavoriteNFTsCollectionViewCell.reuseIdentifier,
//            for: indexPath
//        ) as? ProfileFavoriteNFTsCollectionViewCell ?? ProfileFavoriteNFTsCollectionViewCell()
//
//        cell.setup(with: favoriteNFTs[indexPath.row], delegateTo: self)
//
//        return cell
//    }
//}
//
//extension ProfileFavoriteNFTsController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth = (collectionView.bounds.width - 48) / 2
//        return CGSize(width: cellWidth, height: 80)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let inset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
//        return inset
//    }
//}
//
//extension ProfileFavoriteNFTsController: UnlikerProtocol {
//    func unlikeNFT(with id: String) {
//        ProgressHUD.show(interaction: false)
//
//        var newFavoriteNFTsArray: [String] = []
//        favoriteNFTs.forEach { nft in
//            if nft.id != id {
//                newFavoriteNFTsArray.append(nft.id)
//            }
//        }
//        favoriteNFTsViewModel.saveProfileLikes(with: newFavoriteNFTsArray)
//    }
//}
