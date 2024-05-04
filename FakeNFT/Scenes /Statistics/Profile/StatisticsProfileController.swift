import UIKit
import Kingfisher

final class StatisticsProfileViewController: UIViewController, StatisticsProfileViewDelegate {
    
    // MARK: - Private Properties
    private let statisticsProfilePresenter: StatisticsProfilePresenterProtocol?
    
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
    
    private var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.layer.cornerRadius = 35
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlack
        label.text = "Joaquin Phoenix"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 13)
        textView.textColor = .ypBlack
        textView.text =
        """
        Дизайнер из Казани, люблю цифровое искусство
        и бейглы. В моей коллекции уже 100+ NFT,
        и еще больше — на моём сайте. Открыт
        к коллаборациям.
        """
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var openSiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .ypWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypBlack?.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapSiteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var nftCollectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Коллекция NFT (112)", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTapNftCollectionButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var nftCollectionButtonChevronView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Statistics/chevron.forward")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        
        imageView.image = tintedImage
        imageView.tintColor = .ypBlack
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Initializers
    init(presenter: StatisticsProfilePresenterProtocol) {
        self.statisticsProfilePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        statisticsProfilePresenter?.statisticsProfileViewOpened()
    }
    
    // MARK: - Overrides
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                openSiteButton.layer.borderColor = UIColor.ypBlack?.cgColor
            }
        }
    }
    
    // MARK: Public Methods
    @MainActor
    func showLoadingIndicator(_ show: Bool) {
        if show == true {
            StatisticsUIBlockingProgressHud.show()
        } else {
            StatisticsUIBlockingProgressHud.dismiss()
        }
    }
    
    func displayProfileInfo(user: StatisticsUserAdvanced) {
        
        nameLabel.text = user.name
        descriptionTextView.text = user.description
        
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(openSiteButton)
        view.addSubview(nftCollectionButton)
        nftCollectionButton.addSubview(nftCollectionButtonChevronView)
        
        NSLayoutConstraint.activate([
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 42),
            
            backButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            openSiteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 28),
            openSiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            openSiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            openSiteButton.heightAnchor.constraint(equalToConstant: 40),
            
            nftCollectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollectionButton.topAnchor.constraint(equalTo: openSiteButton.bottomAnchor, constant: 40),
            nftCollectionButton.heightAnchor.constraint(equalToConstant: 54),
            
            nftCollectionButtonChevronView.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),
            nftCollectionButtonChevronView.trailingAnchor.constraint(equalTo: nftCollectionButton.trailingAnchor, constant: -16),
            nftCollectionButtonChevronView.widthAnchor.constraint(equalToConstant: 8),
            nftCollectionButtonChevronView.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        avatarImageView.kf.indicatorType = .activity
        
        if let url = URL(string: user.avatar) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle.fill"),
                options: [.processor(processor)]
            )
        }
        
        nftCollectionButton.setTitle("Коллекция NFT (\(user.nftsCount))", for: .normal)
    }
    
    func openWebView(website: String) {
        let view = WebViewViewController(urlString: website)
        
        view.modalPresentationStyle = .currentContext
        view.modalTransitionStyle = .crossDissolve
        present(view, animated: true)
    }
    
    func openNftCollection(nfts: [String]) {
        let presenter = StatisticsCollectionPresenter(networkManager: StatisticsNetworkManager.shared, nfts: nfts)
        
        let view = StatisticsCollectionViewController(
            presenter: presenter,
            nfts: nfts
        )
        presenter.setViewDelegate(statisticsCollectionViewDelegate: view)
        
        view.modalPresentationStyle = .currentContext
        view.modalTransitionStyle = .crossDissolve
        present(view, animated: true)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSiteButton() {
        statisticsProfilePresenter?.didTapSiteButton()
    }
    
    @objc private func didTapNftCollectionButton() {
        statisticsProfilePresenter?.didTapNftCollectionButton()
    }
}
