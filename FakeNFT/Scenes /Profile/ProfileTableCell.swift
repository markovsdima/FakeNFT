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
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.addSubview(profileTableTitle)
        
        NSLayoutConstraint.activate([
            profileTableTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileTableTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileTableTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        profileTableTitle.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
