import UIKit

protocol MyNFTViewControllerDelegate {
    func didSelectCategory()
}

final class MyNFTViewController: UIViewController {
    
    var delegate: MyNFTViewControllerDelegate?
    
    //MARK: - Private Properties
    private lazy var emptySearchImage: UIImageView = {
        let emptySearchImage = UIImageView()
        emptySearchImage.image = UIImage(named: "TabBar/profile")
        emptySearchImage.contentMode = .scaleToFill
        emptySearchImage.translatesAutoresizingMaskIntoConstraints = false
        emptySearchImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptySearchImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        emptySearchImage.translatesAutoresizingMaskIntoConstraints = false
        return emptySearchImage
    } ()
    
    private lazy var  textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = "MY NFT"
        textLabel.numberOfLines = 0
        textLabel.textColor = .ypBlack
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textAlignment = NSTextAlignment.center
        return textLabel
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureEmptySearchPlaceholder()
        
    }
    
    //MARK: - Methods
    private func configureEmptySearchPlaceholder() {
        
        view.addSubview(textLabel)
        view.addSubview(emptySearchImage)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: emptySearchImage.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptySearchImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptySearchImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

