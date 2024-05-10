import UIKit

final class PaymentEndViewController: UIViewController {
    // MARK: - Properties
    private lazy var imageEnd: UIImageView = {
        var image = UIImageView(image: UIImage(named: "imageEndCart"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.frame = CGRect(x: 0, y: 0, width: 278, height: 278)
        return image
    }()
    
    private lazy var successfulPaymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        return label
    }()
    
    private lazy var paymentEndStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            imageEnd,
            successfulPaymentLabel
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var endButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitle("Вернуться в каталог", for: .normal)
        button.addTarget(self, action: #selector(endButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConstraints()
    }
    
    // MARK: - Lifecycle
    private func viewConstraints() {
        view.backgroundColor = .ypWhite
       
        view.addSubview(paymentEndStack)
        view.addSubview(endButton)
        
        NSLayoutConstraint.activate([
            paymentEndStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentEndStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            endButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            endButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            endButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func endButtonDidTapped() {
        print("endButtonDidTapped")
    }
}
