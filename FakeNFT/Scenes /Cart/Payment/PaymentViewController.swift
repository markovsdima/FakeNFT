import UIKit

final class PaymentViewController: UIViewController {
    private let paymentEndViewController = PaymentEndViewController()
    
    private lazy var backwardButton: UIButton = {
        let imageButton = UIImage(systemName: "chevron.backward")?.withTintColor(
            .black, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(backwardButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "Выберите способ оплаты"
        return label
    }()
    
    private lazy var paymentSystemCollection: UICollectionView = {
        var collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.register(PaymentCell.self, forCellWithReuseIdentifier: PaymentCell.PaymentCellIdentifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        return label
    }()
    
    private lazy var userAgreementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitle("Оплатить", for: .normal)
        button.addTarget(self, action: #selector(payDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var payBackgroundColor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let paymentSystem: [PaymentSystemModel] = [
        PaymentSystemModel(image: "Bitcoin", paymentSystem: "Bitcoin", currency: "ВТС"),
        PaymentSystemModel(image: "Dogecoin", paymentSystem: "Dogecoin", currency: "DOGE"),
        PaymentSystemModel(image: "Tether", paymentSystem: "Tether", currency: "USDT"),
        PaymentSystemModel(image: "Apecoin", paymentSystem: "Apecoin", currency: "APE"),
        PaymentSystemModel(image: "Solana", paymentSystem: "Solana", currency: "SOL"),
        PaymentSystemModel(image: "Ethereum", paymentSystem: "Ethereum", currency: "ETH"),
        PaymentSystemModel(image: "Cardano", paymentSystem: "Cardano", currency: "ADA"),
        PaymentSystemModel(image: "ShibaInu", paymentSystem: "Shiba Inu", currency: "SHIB")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConstraints()
    }
    
    
    private func viewConstraints() {
        view.backgroundColor = .ypWhite
       
        view.addSubview(payBackgroundColor)
        view.addSubview(backwardButton)
        view.addSubview(paymentMethodLabel)
        view.addSubview(paymentSystemCollection)
        view.addSubview(payButton)
        view.addSubview(userAgreementButton)
        view.addSubview(userAgreementLabel)
       
        
        
        NSLayoutConstraint.activate([
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            
            paymentMethodLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            paymentMethodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            paymentSystemCollection.topAnchor.constraint(equalTo: paymentMethodLabel.bottomAnchor, constant: 30),
            paymentSystemCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentSystemCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentSystemCollection.bottomAnchor.constraint(equalTo: userAgreementLabel.topAnchor, constant: -20),
            
            userAgreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementLabel.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -42),
            
            userAgreementButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementButton.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -20),
            
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            
            payBackgroundColor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            payBackgroundColor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            payBackgroundColor.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            payBackgroundColor.topAnchor.constraint(equalTo: userAgreementLabel.topAnchor, constant: -16),
        ])
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Не удалось произвести оплату", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (action:UIAlertAction!) in
            print("cancelAction")
        }
        
        let replayAction = UIAlertAction(title: "Повторить", style: .default) { (action:UIAlertAction!) in
            print("replayAction")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(replayAction)
        
        self.present(alertController, animated: true, completion:nil)
       }
    
    @objc func backwardButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc func openLink() {
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func payDidTapped() {
        showAlert()
//        paymentEndViewController.modalPresentationStyle = .fullScreen
//        present(paymentEndViewController, animated: true)
    }
}


extension PaymentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paymentSystem.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 16
        let availableWidth = collectionView.bounds.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: collectionView.bounds.height / 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCell.PaymentCellIdentifier, for: indexPath) as? PaymentCell {
            cell.updatePaymentCell(paymentSystemModel: paymentSystem[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    
}
