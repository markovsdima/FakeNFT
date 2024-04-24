import Foundation

import UIKit

final class CartCell: UICollectionViewCell {
    static let cartCellIdentifier = "CartCell"
    
    private lazy var imageNFT: UIImageView = {
        var image = UIImageView(image: UIImage(named: "AppIcon"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "April"
        return label
    }()
    
    private var starRatingImage1 = UIImage(named: "StarsYesCart")
    private var starRatingImage2 = UIImage(named: "StarsYesCart")
    private var starRatingImage3 = UIImage(named: "StarsYesCart")
    private var starRatingImage4 = UIImage(named: "StarsYesCart")
    private var starRatingImage5 = UIImage(named: "StarsYesCart")
    
    private lazy var starStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            UIImageView(image: starRatingImage1),
            UIImageView(image: starRatingImage2),
            UIImageView(image: starRatingImage3),
            UIImageView(image: starRatingImage4),
            UIImageView(image: starRatingImage5)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }()
    
    private lazy var nameAndStarStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            starStack
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Цена"
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "1,78 ETH"
        return label
    }()
    
    private lazy var PriceAndAmountStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            priceLabel,
            amountLabel
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameAndStarStack,
            PriceAndAmountStack
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CartDelete"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func viewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageNFT)
        contentView.addSubview(infoStack)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 140),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            imageNFT.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageNFT.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageNFT.heightAnchor.constraint(equalToConstant: 108),
            imageNFT.widthAnchor.constraint(equalToConstant: 108),
            
            infoStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            infoStack.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
