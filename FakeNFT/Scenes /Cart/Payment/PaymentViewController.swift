import UIKit
import WebKit

final class PaymentViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Properties
    private var paymentPresenter: PaymentPresenter?
    
    private lazy var backwardButton: UIButton = {
        let imageButton = UIImage(systemName: "chevron.backward")?.withTintColor(
            .black, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(backwardButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backwardButtonWebView: UIButton = {
        let imageButton = UIImage(systemName: "chevron.backward")?.withTintColor(
            .black, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(backwardButtonWebViewDidTapped), for: .touchUpInside)
        button.isHidden = true
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
        collection.register(PaymentCell.self, forCellWithReuseIdentifier: PaymentCell.paymentCellIdentifier)
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
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.isHidden = true
        return webView
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .medium
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var paymentSystem: [PaymentSystemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConstraints()
        paymentPresenter = PaymentPresenter(view: self)
        paymentPresenter?.fetchCurrencies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorStarandStop()
    }
    
    // MARK: - Lifecycle
    private func viewConstraints() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(payBackgroundColor)
        view.addSubview(backwardButton)
        view.addSubview(paymentMethodLabel)
        view.addSubview(paymentSystemCollection)
        view.addSubview(payButton)
        view.addSubview(userAgreementButton)
        view.addSubview(userAgreementLabel)
        view.addSubview(activityIndicator)
        view.addSubview(webView)
        view.addSubview(backwardButtonWebView)

     
        NSLayoutConstraint.activate([
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            paymentMethodLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25),
            
            backwardButtonWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            backwardButtonWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func openWebView(_ open: Bool) {
        payBackgroundColor.isHidden = open
        backwardButton.isHidden = open
        paymentMethodLabel.isHidden = open
        paymentSystemCollection.isHidden = open
        payButton.isHidden = open
        userAgreementButton.isHidden = open
        userAgreementLabel.isHidden = open
        activityIndicator.isHidden = open
        backwardButtonWebView.isHidden = !open
        webView.isHidden = !open
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            webView.load(URLRequest(url: url))
        }
    }
    
    private func activityIndicatorStarandStop() {
        if self.paymentSystem.isEmpty {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func backwardButtonWebViewDidTapped() {
        openWebView(false)
        activityIndicator.stopAnimating()
    }
    
    @objc private func backwardButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc private func openLink() {
        openWebView(true)
        openURL(paymentPresenter?.urlUserAgreement ?? "")
    }
    
    @objc private func payDidTapped() {
        paymentPresenter?.fetchPay("1")
//        guard let selectedIndexPaths = paymentSystemCollection.indexPathsForSelectedItems,
//              !selectedIndexPaths.isEmpty else {
//            showAlert(from: self)
//            return
//        }
//        let paymentEndViewController = PaymentEndViewController()
//        paymentEndViewController.modalPresentationStyle = .fullScreen
//        present(paymentEndViewController, animated: true)
    }
}

// MARK: - extension UICollectionViewDelegateFlowLayout
extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 16
        let availableWidth = collectionView.bounds.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: collectionView.bounds.height / 12)
    }
}

// MARK: - extension UICollectionViewDataSource
extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paymentSystem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCell.paymentCellIdentifier, for: indexPath) as? PaymentCell {
            if let presenter = paymentPresenter {
                cell.updatePaymentCell(paymentSystemModel: paymentSystem[indexPath.row], presenter: presenter)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - extension UICollectionViewDelegate
extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == paymentSystemCollection {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 12
                let selectedPaymentSystem = paymentSystem[indexPath.row]
                let selectedId = selectedPaymentSystem.id
                print(" selectedId \(selectedId)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == paymentSystemCollection {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.layer.borderWidth = 0
            }
        }
    }
}

extension PaymentViewController {
    func showAlert(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Не удалось произвести оплату", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        let replayAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            print("replayAction")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(replayAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension PaymentViewController: PaymentPreseterView {
    func updatePaymentData(_ data: [PaymentSystemModel]) {
        DispatchQueue.main.sync {
            self.paymentSystem = data
            self.paymentSystemCollection.reloadData()
            self.activityIndicatorStarandStop()
        }
    }
}
