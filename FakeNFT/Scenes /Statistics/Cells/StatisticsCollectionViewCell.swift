import UIKit

protocol StatisticsCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(id: String)
    func didTapOrderButton(id: String)
}

final class StatisticsCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Properties
    lazy var statisticsNftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "scribble.variable")
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .ypRedUniversal
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Statistics/like")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .ypWhiteUniversal
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var ratingStarsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "Archie"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.text = "1,78 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Statistics/cart")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOrderButton), for: .touchUpInside)
        
        return button
    }()
    
    private var rating: Int = 3
    private var id = String()
    private var isLiked: Bool = false
    private var isOrdered: Bool = false
    
    weak var delegate: StatisticsCollectionViewCellDelegate?
    
    // MARK: - Override Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statisticsNftImageView.kf.cancelDownloadTask()
        statisticsNftImageView.kf.setImage(with: URL(string: ""))
        statisticsNftImageView.image = nil
    }
    
    // MARK: - Public Methods
    func configureStatisticsCollectionCell(nft: StatisticsNFTCell) {
        priceLabel.text = "\(nft.price) ETH"
        nameLabel.text = nft.name
        self.rating = nft.rating
        self.id = nft.id
        self.isLiked = nft.isLiked
        updateLike(nft.isLiked)
        updateOrder(nft.isOrdered)
        updateStars()
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        contentView.addSubview(statisticsNftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(ratingStarsContainer)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(orderButton)
        
        NSLayoutConstraint.activate([
            statisticsNftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statisticsNftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statisticsNftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            statisticsNftImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: statisticsNftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: statisticsNftImageView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            ratingStarsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStarsContainer.topAnchor.constraint(equalTo: statisticsNftImageView.bottomAnchor, constant: 8),
            ratingStarsContainer.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: ratingStarsContainer.bottomAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: orderButton.leadingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            orderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            orderButton.topAnchor.constraint(equalTo: ratingStarsContainer.bottomAnchor, constant: 4),
            orderButton.widthAnchor.constraint(equalToConstant: 40),
            orderButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        createStars()
    }
    
    private func createStars() {
        for index in 1...5 {
            let star = makeStarIcon()
            star.tag = index
            ratingStarsContainer.addArrangedSubview(star)
        }
    }
    
    private func updateStars() {
        ratingStarsContainer.arrangedSubviews.forEach { subviews in
            guard let starImageView = subviews as? UIImageView else { return }
            
            if starImageView.tag <= rating {
                starImageView.tintColor = .ypYellowUniversal
            }
        }
    }
    
    private func updateLike(_ liked: Bool) {
        if liked {
            likeButton.tintColor = .ypRedUniversal
        }
    }
    
    private func changeLikeState() {
        if isLiked {
            likeButton.tintColor = .ypWhiteUniversal
            isLiked.toggle()
        } else {
            likeButton.tintColor = .ypRedUniversal
            isLiked.toggle()
        }
    }
    
    private func updateOrder(_ ordered: Bool) {
        if ordered {
            changeOrderState()
        }
    }
    
    private func changeOrderState() {
        if isOrdered {
            let image = UIImage(named: "Statistics/cart")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            orderButton.setImage(tintedImage, for: .normal)
            orderButton.tintColor = .ypBlack
            isOrdered.toggle()
        } else {
            let image = UIImage(named: "Statistics/cartRemove")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            orderButton.setImage(tintedImage, for: .normal)
            orderButton.tintColor = .ypRedUniversal
            isOrdered.toggle()
        }
    }
    
    private func makeStarIcon() -> UIImageView {
        let image = UIImage(named: "Statistics/star")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintedImage)
        imageView.tintColor = .ypLightGrey
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    @objc private func didTapLikeButton() {
        changeLikeState()
        delegate?.didTapLikeButton(id: id)
    }
    
    @objc private func didTapOrderButton() {
        changeOrderState()
        delegate?.didTapOrderButton(id: id)
    }
}
