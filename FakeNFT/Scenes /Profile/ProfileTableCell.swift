import UIKit

final class ProfileTableCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "ProfileTableCell"
   
    let profileTableTitle: UILabel = {
        let profileTableTitle = UILabel()
        profileTableTitle.translatesAutoresizingMaskIntoConstraints = false
        profileTableTitle.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        profileTableTitle.numberOfLines = 0
        profileTableTitle.textAlignment = .left
        return profileTableTitle
    }()
    
    private lazy var profileTableCustomImage: UIImageView = {
        let profileTableCustomImage = UIImageView()
        profileTableCustomImage.translatesAutoresizingMaskIntoConstraints = false
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        profileTableCustomImage.image = UIImage(systemName: "chevron.right", withConfiguration: boldConfig)
        profileTableCustomImage.contentMode = .scaleAspectFit
        profileTableCustomImage.tintColor = UIColor.ypBlack
        return profileTableCustomImage
    }()
    
    // MARK: - Private Methods
    
    func configureCell(title: String) {
        [profileTableTitle,
         profileTableCustomImage].forEach { contentView.addSubview($0) }
        selectionStyle = .none
        profileTableTitle.text = title
        
        NSLayoutConstraint.activate([
            profileTableTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileTableTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileTableTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            profileTableCustomImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profileTableCustomImage.widthAnchor.constraint(equalToConstant: 7.98),
            profileTableCustomImage.heightAnchor.constraint(equalToConstant: 13.86),
            profileTableCustomImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

        ])
        profileTableTitle.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
}
