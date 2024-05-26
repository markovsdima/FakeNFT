import UIKit

protocol BlurViewDelegate: AnyObject {
    func activatingBlurView(_ activating: Bool)
}

final class CartViewController: UIViewController {
    
    // MARK: - Properties
    let servicesAssembly: ServicesAssembly
    weak var blurViewDelegate: BlurViewDelegate?
    weak var returnDelegate: ReturnDelegate?
    
    private let paymentViewController: PaymentViewController
    private var cartPresenter: CartPresenter?
    private var isTapped = false
    private var idNFT = ""
    
    private lazy var filterButton: UIButton = {
        let imageButton = UIImage(named: "SortButton")?.withTintColor(
            .black, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "filterButton"
        return button
    }()
    
    private lazy var cartCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 140)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .ypWhite
        collection.register(CartCell.self, forCellWithReuseIdentifier: CartCell.cartCellIdentifier)
        collection.dataSource = self
        collection.accessibilityIdentifier = "cartCollectionView"
        return collection
    }()
    
    private lazy var countNFTLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var priceNFTLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypGreenUniversal
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitle("К оплате", for: .normal)
        button.addTarget(self, action: #selector(payButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [countNFTLabel, priceNFTLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private lazy var payStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelStack, paymentButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private lazy var payBackgroundColor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.frame = UIScreen.main.bounds
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var warningsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Вы уверены, что хотите \nудалить объект из корзины?"
        label.isHidden = true
        return label
    }()
    
    private lazy var nftStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nftImageView, warningsLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 12
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.ypRedUniversal, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 12
        button.setTitle("Вернуться", for: .normal)
        button.addTarget(self, action: #selector(returnButtonDidTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [deleteButton, returnButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var deleteStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nftStack, buttonStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private lazy var cartIsEmpty: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.text = "Корзина пуста"
        label.isHidden = true
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .medium
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.paymentViewController = PaymentViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConstraints()
        cartPresenter = CartPresenter(view: self)
        paymentViewController.returnDelegate = self.returnDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartPresenter?.fetchOrdersCart()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ifIsEmptyNftData()
    }
    
    // MARK: - Lifecycle
    private func viewConstraints() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(filterButton)
        view.addSubview(cartCollection)
        view.addSubview(payBackgroundColor)
        view.addSubview(payStack)
        view.addSubview(blurView)
        view.addSubview(deleteStack)
        view.addSubview(cartIsEmpty)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            filterButton.heightAnchor.constraint(equalToConstant: 42),
            filterButton.widthAnchor.constraint(equalToConstant: 42),
            
            cartCollection.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 35),
            cartCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cartCollection.bottomAnchor.constraint(equalTo: payBackgroundColor.bottomAnchor, constant: -70),
            
            payBackgroundColor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            payBackgroundColor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            payBackgroundColor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            payBackgroundColor.heightAnchor.constraint(equalToConstant: 76),
            
            payStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payStack.bottomAnchor.constraint(equalTo: payBackgroundColor.bottomAnchor),
            payStack.centerYAnchor.constraint(equalTo: payBackgroundColor.centerYAnchor),
            payStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            paymentButton.widthAnchor.constraint(equalToConstant: 244),
            paymentButton.heightAnchor.constraint(equalToConstant: 44),
            
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            deleteStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            
            returnButton.heightAnchor.constraint(equalToConstant: 44),
            returnButton.widthAnchor.constraint(equalToConstant: 127),
            
            cartIsEmpty.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartIsEmpty.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func ifIsEmptyNftData() {
        if cartPresenter?.nftData.isEmpty ?? false {
            filterButton.isHidden = true
            countNFTLabel.isHidden = true
            priceNFTLabel.isHidden = true
            paymentButton.isHidden = true
            payBackgroundColor.isHidden = true
            cartIsEmpty.isHidden = false
        } else {
            filterButton.isHidden = false
            countNFTLabel.isHidden = false
            priceNFTLabel.isHidden = false
            paymentButton.isHidden = false
            payBackgroundColor.isHidden = false
            cartIsEmpty.isHidden = true
        }
        cartCollection.reloadData()
    }
    
    private func confirmationOfDeletion(_ isTapped: Bool) {
        nftImageView.isHidden = isTapped
        deleteButton.isHidden = isTapped
        returnButton.isHidden = isTapped
        warningsLabel.isHidden = isTapped
        blurView.isHidden = isTapped
        cartCollection.reloadData()
        
    }
    
    private func activityIndicatorStarandStop() {
        if cartPresenter?.nftData.isEmpty ?? false {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func sumAndCountNFT() {
        countNFTLabel.text = cartPresenter?.countNFT()
        priceNFTLabel.text = cartPresenter?.priceNFT()
    }
    
    @objc private func filterButtonTapped() {
        showActionSheet()
    }
    
    @objc private func deleteButtonDidTapped() {
        cartPresenter?.deleteNFT(idNFT)
        confirmationOfDeletion(true)
    }
    
    @objc private func returnButtonDidTapped() {
        confirmationOfDeletion(true)
    }
    
    @objc private func payButtonDidTapped() {
        paymentViewController.modalPresentationStyle = .fullScreen
        present(paymentViewController, animated: true)
    }
}


// MARK: - extension UICollectionViewDataSource
extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartPresenter?.nftData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCell.cartCellIdentifier, for: indexPath) as? CartCell {
            
            guard indexPath.row < cartPresenter?.nftData.count ?? 0 else {
                return UICollectionViewCell()
            }
            
            let nftItem = cartPresenter?.nftData[indexPath.row]
            cell.configure(with: nftItem)
            cell.delegate = self
            
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - extension CartCellDelete
extension CartViewController {
    func showActionSheet() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let priceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            self.cartPresenter?.sortPriceNFTData()
            self.cartCollection.reloadData()
        }
        
        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.cartPresenter?.sortRatingNFTData()
            self.cartCollection.reloadData()
        }
        
        
        let nameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            self.cartPresenter?.sortNameNFTData()
            self.cartCollection.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(priceAction)
        alertController.addAction(ratingAction)
        alertController.addAction(nameAction)
        alertController.addAction(cancelAction)
        
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = scene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - extension CartCellDelete
extension CartViewController: CartCellDelete {
    func deleteNFT(_ image: UIImage, _ idNFT: String) {
        nftImageView.image = image
        self.idNFT = idNFT
        sumAndCountNFT()
        confirmationOfDeletion(false)
    }
}

// MARK: - extension CartPreseterView
extension CartViewController: CartView {
    func activityIndicator(_ activity: Bool) {
        DispatchQueue.main.async {
            if activity {
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    func collectionReloadData() {
        DispatchQueue.main.async {
            self.cartCollection.reloadData()
            self.sumAndCountNFT()
        }
    }
}
