import UIKit
import Kingfisher

final class StatisticsTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Properties
    private lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var userView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var statisticsAvatarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.layer.cornerRadius = 14
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nftAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Override Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statisticsAvatarImageView.kf.cancelDownloadTask()
        statisticsAvatarImageView.kf.setImage(with: URL(string: ""))
        statisticsAvatarImageView.image = nil
    }
    
    // MARK: - Public Methods
    func configureCell(user: StatisticsUser) {
        positionLabel.text = String(user.rating)
        nameLabel.text = user.name
        nftAmountLabel.text = String(user.score)
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        contentView.backgroundColor = .ypWhite
        
        contentView.addSubview(positionLabel)
        contentView.addSubview(userView)
        userView.addSubview(statisticsAvatarImageView)
        userView.addSubview(nameLabel)
        userView.addSubview(nftAmountLabel)
        
        NSLayoutConstraint.activate([
            positionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            positionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            positionLabel.widthAnchor.constraint(equalToConstant: 27),
            
            userView.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 8),
            userView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            userView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            userView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            statisticsAvatarImageView.widthAnchor.constraint(equalToConstant: 28),
            statisticsAvatarImageView.heightAnchor.constraint(equalToConstant: 28),
            statisticsAvatarImageView.leadingAnchor.constraint(equalTo: userView.leadingAnchor, constant: 16),
            statisticsAvatarImageView.centerYAnchor.constraint(equalTo: userView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: statisticsAvatarImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: userView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: nftAmountLabel.leadingAnchor),
            
            nftAmountLabel.trailingAnchor.constraint(equalTo: userView.trailingAnchor, constant: -16),
            nftAmountLabel.centerYAnchor.constraint(equalTo: userView.centerYAnchor),
            nftAmountLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}
