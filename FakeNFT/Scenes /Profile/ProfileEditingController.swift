import UIKit

final class ProfileEditingViewController: UIViewController {
        
    private lazy var profileCloseButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold
        )
        button.image = UIImage(systemName: "xmark", withConfiguration: config)
        button.action = #selector(closeButtonTapped)
        button.target = self
        return button
    }()

    private lazy var profileAvatar: UIImageView = {
        let avatar = UIImageView()
        avatar.image = UIImage(named: "profileImages/profileAvatarMock")
        avatar.contentMode = .scaleAspectFill
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.layer.cornerRadius = 35
        avatar.layer.masksToBounds = true
        return avatar
        
    }()
    
    private lazy var profileAvatarBackground: UIView = {
        let view = UIView(frame: profileAvatar.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlackUniversal?.withAlphaComponent(0.6)
        return view
    }()
    
    private lazy var labelChangePhoto: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.ypWhiteUniversal
        label.text = "Сменить фото"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePhotoTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.textColor = UIColor.ypBlack
        label.text = "Имя"
        return label
    }()
    
    private lazy var  profileNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.font = .bodyRegular
        textField.backgroundColor = .ypLightGrey
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:16, height:10))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.textColor = .ypBlack
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.textColor = UIColor.ypBlack
        label.text = "Описание"
        return label
    }()
    
    private lazy var profileBioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 12
        textView.font = .bodyRegular
        textView.backgroundColor = .ypLightGrey
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.textColor = .ypBlack
        return textView
    }()
    
    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.textColor = .ypBlack
        label.text = "Сайт"
        return label
    }()
    
    private lazy var profileLinkTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.font = .bodyRegular
        textField.backgroundColor = .ypLightGrey
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:16, height:10))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.textColor = .ypBlack
        return textField
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupNavBar()
        addElements()
        setupConstraints()
        
        profileSetText()
       
    }
    
    //MARK: - Private Methods
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = profileCloseButton
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
    }
    
    private func addElements() {
        [profileAvatar, nameLabel, profileNameTextField,
         profileBioTextView, descriptionLabel, siteLabel, profileLinkTextField].forEach { view.addSubview($0) }
        
        profileAvatar.addSubview(profileAvatarBackground)
        profileAvatarBackground.addSubview(labelChangePhoto)
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileAvatar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileAvatar.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            profileAvatar.heightAnchor.constraint(equalToConstant: 70),
            profileAvatar.widthAnchor.constraint(equalToConstant: 70),
            
            profileAvatarBackground.centerXAnchor.constraint(equalTo: profileAvatar.centerXAnchor),
            profileAvatarBackground.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            profileAvatarBackground.heightAnchor.constraint(equalToConstant: 70),
            profileAvatarBackground.widthAnchor.constraint(equalToConstant: 70),
            
            labelChangePhoto.centerXAnchor.constraint(equalTo: profileAvatarBackground.centerXAnchor),
            labelChangePhoto.centerYAnchor.constraint(equalTo: profileAvatarBackground.centerYAnchor),
            labelChangePhoto.heightAnchor.constraint(equalToConstant: 24),
            labelChangePhoto.widthAnchor.constraint(equalToConstant: 45),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: 24),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            profileNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            profileNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: profileNameTextField.bottomAnchor, constant: 24),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28),
            
            profileBioTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileBioTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileBioTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            profileBioTextView.heightAnchor.constraint(equalToConstant: 132),
            
            siteLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            siteLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            siteLabel.topAnchor.constraint(equalTo: profileBioTextView.bottomAnchor, constant: 24),
            siteLabel.heightAnchor.constraint(equalToConstant: 28),
            
            profileLinkTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileLinkTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileLinkTextField.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 8),
            profileLinkTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func profileSetText() {
        let profileName = profileConstants.profileNameString
        profileNameTextField.text = profileName
        
        let profileBio = profileConstants.profileBioString
        profileBioTextView.text = profileBio
        
        let profileWebLink = profileConstants.profileWebLinkString
        profileLinkTextField.text = profileWebLink
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func closeButtonTapped() {
        print("tapped")
        dismiss(animated: true)
    }
    
    @objc private func changePhotoTapped() {
        print("change photo")
        
    }
}