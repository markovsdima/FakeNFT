import UIKit
import WebKit

final class WebViewViewController: UIViewController, WebViewViewDelegate {
    
    // MARK: - Private properties
    private let webViewPresenter = WebViewPresenter()
    private var urlString: String?
    
    // MARK: - UI properties
    private var webView: WKWebView?
    
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
    
    // MARK: - Initializers
    convenience init(urlString: String) {
        self.init()
        
        self.urlString = urlString
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupWebViewConstraints()
        setupBackButton()
        webViewPresenter.setViewDelegate(webViewViewDelegate: self)
        webViewPresenter.webViewViewOpened(urlString: urlString)
    }
    
    // MARK: - Public Methods
    func displaySite(request: URLRequest) {
        webView?.load(request)
    }
    
    // MARK: - Private Methods
    private func setupWebView() {
        let webView = WKWebView()
        webView.backgroundColor = .ypRedUniversal
        view.addSubview(webView)
        self.webView = webView
    }
    
    private func setupWebViewConstraints() {
        guard let webView else { return }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.layer.zPosition = 10
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
}
