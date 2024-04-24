import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Properties
    let servicesAssembly: ServicesAssembly
    private let paymentViewController = PaymentViewController()
    
    private lazy var filterButton: UIButton = {
        let imageButton = UIImage(named: "SortButton")?.withTintColor(
            .black, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
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
//        collection.delegate = self
        return collection
    }()
    
    private lazy var countNFTLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "3 NFT"
        return label
    }()
    
    private lazy var priceNFTLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypGreenUniversal
        label.text = "5,34 ETH"
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
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConstraints()
    }
    
    // MARK: - Lifecycle

    private func viewConstraints() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(filterButton)
        view.addSubview(cartCollection)
        view.addSubview(payBackgroundColor)
        view.addSubview(payStack)
        
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            filterButton.heightAnchor.constraint(equalToConstant: 42),
            filterButton.widthAnchor.constraint(equalToConstant: 42),
            
            cartCollection.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 35),
            cartCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cartCollection.bottomAnchor.constraint(equalTo: payBackgroundColor.bottomAnchor),
            
            payBackgroundColor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            payBackgroundColor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            payBackgroundColor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            payBackgroundColor.heightAnchor.constraint(equalToConstant: 76),
            
            payStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -99),
            payStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            paymentButton.widthAnchor.constraint(equalToConstant: 244),
            paymentButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func showActionSheet() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "По цене", style: .default) { _ in
    
        }
        alertController.addAction(action1)
        
        let action2 = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            
        }
        alertController.addAction(action2)
        
        let action3 = UIAlertAction(title: "По названию", style: .default) { _ in
            
        }
        alertController.addAction(action3)
        
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let viewController = scene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func filterButtonTapped() {
        showActionSheet()
    }
    
    @objc private func payButtonDidTapped() {
        paymentViewController.modalPresentationStyle = .fullScreen
        present(paymentViewController, animated: true)
    }
}



extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCell.cartCellIdentifier, for: indexPath)
        
        return cell
    }
}
