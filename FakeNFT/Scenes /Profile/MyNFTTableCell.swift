import UIKit

final class ProfileMyNFTTableCell: UITableViewCell {
    
    static let reuseIdentifier = "MyNFTTableCell"
    
    private lazy var likeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "TabBar/profile"), for: .normal)
        button.backgroundColor = .ypWhite
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageViewNFT: UIImageView = {
        let image: UIImageView = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.backgroundColor = .gray//delete
        return image
    }()
    
    private lazy var labelName: UILabel = {
        let label: UILabel = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var labelAuthor: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.textColor = .ypBlack
        label.text = "от John Doe"//delete
        return label
    }()
    
    private lazy var labelFrom: UILabel = {
        let label: UILabel = UILabel()
        label.text = "от"
        label.font = .caption1
        return label
    }()
    
    private lazy var labelPrice: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Цена"
        label.font = .caption2
        return label
    }()
    
    private lazy var labelPriceValue: UILabel = {
        let label: UILabel = UILabel()
        label.font = .bodyBold
        label.text = "1,78 ETH" //delete
        return label
    }()
    
    private lazy var stackNFT: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var stackNFTLeft: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var stackNFTRight: UIStackView = {
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
    
    private lazy var viewAuthor: UIView = {
        let view: UIView = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var viewNFTContent: UIView = UIView()
    
    override func prepareForReuse() {
        for view in stackRating.arrangedSubviews {
            stackRating.removeArrangedSubview(view)
        }
    }
    
    @objc
    private func likeButtonTapped(){
        print("like button tapped")
    }
    
    func configureCell(name: String) {
        backgroundColor = .ypWhite
        selectionStyle = .none
        labelName.text = name
        
        addElements()
        setupConstraints()
    }
    
    private func addElements(){
        //        self.accessoryType = .none
        contentView.backgroundColor = .ypWhite
        contentView.addSubview(viewNFTContent)
        
        viewNFTContent.addSubview(imageViewNFT)
        viewNFTContent.addSubview(likeButton)
        viewNFTContent.addSubview(stackNFT)
        
        stackNFT.addArrangedSubview(stackNFTLeft)
        stackNFT.addArrangedSubview(stackNFTRight)
        
        stackNFTLeft.addArrangedSubview(labelName)
        stackNFTLeft.addArrangedSubview(stackRating)
        stackNFTLeft.addArrangedSubview(viewAuthor)
        
        viewAuthor.addSubview(labelFrom)
        viewAuthor.addSubview(labelAuthor)
        
        stackNFTRight.addArrangedSubview(labelPrice)
        stackNFTRight.addArrangedSubview(labelPriceValue)
    }
    
    private func setupConstraints(){
        [likeButton, imageViewNFT, stackNFT,
         stackNFTLeft, labelName, stackRating, viewAuthor, labelFrom, labelAuthor,
         stackNFTRight, labelPrice, labelPriceValue, viewNFTContent].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            viewNFTContent.heightAnchor.constraint(equalToConstant: 108),
            viewNFTContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewNFTContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            viewNFTContent.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            imageViewNFT.heightAnchor.constraint(equalToConstant: 108),
            imageViewNFT.widthAnchor.constraint(equalToConstant: 108),
            imageViewNFT.leadingAnchor.constraint(equalTo: viewNFTContent.leadingAnchor),
            imageViewNFT.centerYAnchor.constraint(equalTo: viewNFTContent.centerYAnchor),
            
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: viewNFTContent.topAnchor, constant: 0),
            likeButton.leadingAnchor.constraint(equalTo: viewNFTContent.leadingAnchor, constant: 68),
            
            stackNFTLeft.heightAnchor.constraint(equalToConstant: 62),
            stackNFTLeft.widthAnchor.constraint(equalToConstant: 95),
            stackNFTRight.heightAnchor.constraint(equalToConstant: 42),
            stackNFTRight.widthAnchor.constraint(equalToConstant: 90),
            
            stackNFT.topAnchor.constraint(equalTo: viewNFTContent.topAnchor, constant: 23),
            stackNFT.leadingAnchor.constraint(equalTo: viewNFTContent.leadingAnchor, constant: 128),
            stackNFT.trailingAnchor.constraint(equalTo: viewNFTContent.trailingAnchor, constant: 0),
            stackNFT.bottomAnchor.constraint(equalTo: viewNFTContent.bottomAnchor, constant: -23),
            
            stackRating.heightAnchor.constraint(equalToConstant: 12),
            stackRating.widthAnchor.constraint(equalToConstant: 68),
            
            viewAuthor.heightAnchor.constraint(equalToConstant: 20),
            viewAuthor.widthAnchor.constraint(equalToConstant: 78),
            
            labelFrom.leadingAnchor.constraint(equalTo: viewAuthor.leadingAnchor),
            labelFrom.centerYAnchor.constraint(equalTo: viewAuthor.centerYAnchor),
            
            labelAuthor.leadingAnchor.constraint(equalTo: labelFrom.trailingAnchor, constant: 5),
            labelAuthor.centerYAnchor.constraint(equalTo: viewAuthor.centerYAnchor),
        ])
    }
}
