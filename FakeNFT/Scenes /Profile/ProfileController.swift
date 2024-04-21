import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
}

protocol ProfileViewControllerDelegate {
    //todo
}
                                            
final class ProfileViewController: UIViewController & ProfileViewControllerProtocol & ProfileViewControllerDelegate {
    
    //MARK: - Properties
    var presenter: ProfilePresenterProtocol?
    let servicesAssembly: ServicesAssembly
    var delegate: ProfileViewControllerDelegate?

    
  //MARK: - Private properties
    
    private lazy var profileEditButton: UIBarButtonItem = {
        let profileEditButton = UIBarButtonItem ()
    } ()
    
    private lazy var profileStackView: UIStackView = {
        let profileStackView = UIStackView()
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        profileStackView.axis = .horizontal
        profileStackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileStackView.spacing = 16
        return profileStackView
    } ()
    
    private lazy var profileAvatar: UIImageView = {
        let profileAvatar = UIImageView()
        profileAvatar.image = UIImage(named: "profileImages/profileAvatarMock")
        profileAvatar.contentMode = .scaleAspectFill
        profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        profileAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileAvatar.layer.cornerRadius = 70/2
        profileAvatar.layer.masksToBounds = true
        return profileAvatar
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.textColor = .ypBlack
        profileNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        profileNameLabel.textAlignment = NSTextAlignment.left
        profileNameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return profileNameLabel
    }()
    
    private lazy var profileBioLabel: UILabel = {
        let profileBioLabel = UILabel()
        profileBioLabel.translatesAutoresizingMaskIntoConstraints = false
        profileBioLabel.textColor = .ypBlack
        profileBioLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        profileBioLabel.textAlignment = NSTextAlignment.left
        profileBioLabel.numberOfLines = 4
        return profileBioLabel
    }()
    
    private lazy var profileWebLinkLabel: UILabel = {
        let profileWebLinkLabel = UILabel()
        profileWebLinkLabel.translatesAutoresizingMaskIntoConstraints = false
        profileWebLinkLabel.textColor = .ypBlueUniversal
        profileWebLinkLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        profileWebLinkLabel.textAlignment = NSTextAlignment.left
        profileWebLinkLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return profileWebLinkLabel
    }()
    
    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileTableView.register(
            ProfileTableCell.self,
            forCellReuseIdentifier: ProfileTableCell.reuseIdentifier
        )
        return profileTableView
    }()

    
    
    //MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        profileAddElements()
        profileSetupLayout()
        profileSetText()
        
        setupNavBar()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
    }
    
    
        //MARK: - Private Methods
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            let rightButton = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .plain,
                target: self,
                action: #selector(profileEditTapped)
            )
            navBar.topItem?.setRightBarButton(rightButton, animated: false)
        }
    }//TODO
    
    @objc
    private func profileEditTapped(){
        print("profile edit button tapped")
    }
    
    private func profileAddElements() {
        view.addSubview(profileStackView)
        view.addSubview(profileBioLabel)
        view.addSubview(profileWebLinkLabel)
        view.addSubview(profileTableView)

        profileStackView.addArrangedSubview(profileAvatar)
        profileStackView.addArrangedSubview(profileNameLabel)
    }
    
    private func profileSetupLayout() {
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62), //need change
            profileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            profileAvatar.topAnchor.constraint(equalTo: profileStackView.topAnchor),
            profileAvatar.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor),
            
            profileNameLabel.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: profileStackView.trailingAnchor),
            
            profileBioLabel.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 20),
            profileBioLabel.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor),
            profileBioLabel.trailingAnchor.constraint(equalTo: profileStackView.trailingAnchor),
            
            profileWebLinkLabel.topAnchor.constraint(equalTo: profileBioLabel.bottomAnchor, constant: 8),
            profileWebLinkLabel.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor),
            
            profileTableView.topAnchor.constraint(equalTo: profileWebLinkLabel.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func profileSetText() {
        let profileName = profileConstants.profileNameString
        profileNameLabel.text = profileName
        
        let profileBio = profileConstants.profileBioString
        profileBioLabel.text = profileBio
        
        let profileWebLink = profileConstants.profileWebLinkString
        profileWebLinkLabel.text = profileWebLink
    }
    
}//end of class

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.reuseIdentifier, for: indexPath) as? ProfileTableCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell.profileTableTitle.text = "Мои NFT (112)"
        } else {
            cell.profileTableTitle.text = "Избранные NFT (11)"
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let myNFTViewController = MyNFTViewController()//need change
            myNFTViewController.delegate = self
            navigationController?.pushViewController(myNFTViewController, animated: true)
            
        } else if indexPath.row == 1 {
            let favouritesNFTViewController = MyNFTViewController()
            favouritesNFTViewController.delegate = self
            navigationController?.pushViewController(favouritesNFTViewController, animated: true)
        }
    }
}

//MARK: - MyNFTViewControllerDelegate

extension ProfileViewController: MyNFTViewControllerDelegate {
    func didSelectCategory() {
        print("ButtonTapped")
    }
}
