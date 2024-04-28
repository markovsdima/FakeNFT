import UIKit

class FavoriteNFTCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "FavoriteNFTCollectionCell"
    
    private lazy var likeButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageViewNFT: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var labelName: UILabel = {
        let label: UILabel = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var labelPriceValue: UILabel = {
        let label: UILabel = UILabel()
        label.font = .caption1
        return label
    }()
    
    private lazy var stackNFT: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var stackRating: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private lazy var viewNFTContent: UIView = UIView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addElements()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        for view in stackRating.arrangedSubviews {
            stackRating.removeArrangedSubview(view)
        }
    }
    
    private func addElements(){
        contentView.addSubview(viewNFTContent)
        
        viewNFTContent.addSubview(imageViewNFT)
        viewNFTContent.addSubview(likeButton)
        viewNFTContent.addSubview(stackNFT)
        
        stackNFT.addArrangedSubview(labelName)
        stackNFT.addArrangedSubview(stackRating)
        stackNFT.addArrangedSubview(labelPriceValue)
        
    }
    
    private func setupLayout(){
        [imageViewNFT, likeButton,
         stackNFT, labelName, stackRating,
         labelPriceValue, viewNFTContent].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            viewNFTContent.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewNFTContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewNFTContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewNFTContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageViewNFT.heightAnchor.constraint(equalToConstant: 80),
            imageViewNFT.widthAnchor.constraint(equalToConstant: 80),
            imageViewNFT.topAnchor.constraint(equalTo: viewNFTContent.topAnchor),
            imageViewNFT.leadingAnchor.constraint(equalTo: viewNFTContent.leadingAnchor),
            
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.topAnchor.constraint(equalTo: viewNFTContent.topAnchor, constant: 0),
            likeButton.leadingAnchor.constraint(equalTo: viewNFTContent.leadingAnchor, constant: 50),
            
            stackNFT.heightAnchor.constraint(equalToConstant: 66),
            
            stackNFT.leadingAnchor.constraint(equalTo: imageViewNFT.trailingAnchor, constant: 8),
            stackNFT.trailingAnchor.constraint(equalTo: viewNFTContent.trailingAnchor),
            stackNFT.centerYAnchor.constraint(equalTo: viewNFTContent.centerYAnchor),
            
            stackRating.heightAnchor.constraint(equalToConstant: 12),
            stackRating.widthAnchor.constraint(equalToConstant: 68),
        ])
    }
    
    @objc
    private func likeButtonTapped(){
        print("like button tapped")
    }
    
}
