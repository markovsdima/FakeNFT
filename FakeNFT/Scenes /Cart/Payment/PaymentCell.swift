import UIKit

final class PaymentCell: UICollectionViewCell {
    // MARK: - Properties
    static let paymentCellIdentifier = "PaymentCell"
    
    private lazy var paymentImage: UIImageView = {
        var image = UIImageView(image: UIImage(named: "Bitcoin"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.backgroundColor = .ypBlack
        image.layer.cornerRadius = 6
        return image
    }()
    
    private lazy var paymentSystemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlack
        label.text = "Bitcoin"
        return label
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGreenUniversal
        label.text = "ВТС"
        return label
    }()
    
    private lazy var paymentSystemStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            paymentSystemLabel,
            currencyLabel
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.axis = .vertical
        return stack
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
    
    // MARK: - Lifecycle
    private func viewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .ypLightGrey
        contentView.layer.cornerRadius = 12
        
        contentView.addSubview(paymentImage)
        contentView.addSubview(paymentSystemStack)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalTo: heightAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            paymentImage.heightAnchor.constraint(equalToConstant: 36),
            paymentImage.widthAnchor.constraint(equalToConstant: 36),
            paymentImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            paymentImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            paymentSystemStack.leadingAnchor.constraint(equalTo: paymentImage.trailingAnchor, constant: 4),
            paymentSystemStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func updatePaymentCell(paymentSystemModel: PaymentSystemModel, presenter: PaymentPresenter) {
        paymentSystemLabel.text = paymentSystemModel.title
        currencyLabel.text = paymentSystemModel.name
        
        if let imageUrl = URL(string: paymentSystemModel.image) {
            presenter.fetchImageFromURL(url: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.paymentImage.image = image
                }
            }
        }
    }
}
