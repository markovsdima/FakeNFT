import UIKit
import Kingfisher

final class StatisticsCollectionViewController: UIViewController, StatisticsCollectionViewDelegate {
    
    // MARK: - Private properties
    private let statisticsCollectionPresenter: StatisticsCollectionPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<Int, StatisticsNFTCell>?
    private var snapshot: NSDiffableDataSourceSnapshot<Int, StatisticsNFTCell>?
    
    // MARK: - UI Properties
    private lazy var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Statistics/back")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "Коллекция NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(192)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(9)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
            
            return section
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        return collectionView
    }()
    
    // MARK: - Initializers
    init(presenter: StatisticsCollectionPresenterProtocol, nfts: [String]) {
        self.statisticsCollectionPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupUI()
        setupDataSource()
        
        collectionView.register(
            StatisticsCollectionViewCell.self,
            forCellWithReuseIdentifier: StatisticsCollectionViewCell.defaultReuseIdentifier
        )
        
        statisticsCollectionPresenter?.statisticsCollectionViewOpened()
    }
    
    // MARK: - Public Methods
    func displayCollection(collection: ([StatisticsNFTCell])) {
        reloadData(collection: collection)
    }
    
    @MainActor
    func showLoadingIndicator(_ show: Bool) {
        if show {
            StatisticsUIBlockingProgressHud.show()
        } else {
            StatisticsUIBlockingProgressHud.dismiss()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(titleLabel)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 42),
            
            backButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            
            titleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, StatisticsNFTCell>(collectionView: collectionView) {
            (collectionView, IndexPath, ItemIdentifier) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCollectionViewCell.defaultReuseIdentifier, for: IndexPath) as? StatisticsCollectionViewCell
            
            cell?.configureStatisticsCollectionCell(
                nft: ItemIdentifier
            )
            
            // Load cell image from url
            if let urlString = ItemIdentifier.images.first {
                let url = URL(string: urlString)
                
                cell?.statisticsNftImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "scribble.variable")
                )
            }
            
            return cell
        }
    }
    
    private func reloadData(collection: [StatisticsNFTCell]) {
        snapshot = NSDiffableDataSourceSnapshot<Int, StatisticsNFTCell>()
        snapshot?.appendSections([0])
        snapshot?.appendItems(collection, toSection: 0)
        snapshot?.reloadSections([0])
        
        guard let snapshot else { return }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
}

