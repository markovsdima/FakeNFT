import Foundation

protocol ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol? { get set }
    
    func openAboutDeveloper()
    func viewDidLoad()
    func setupProfileDetails(profile: ProfileRequest)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - Properties
    weak var profileView: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService
    private let profileId: String
    
    //MARK: - Init
    init(
        service: ProfileService,
        profileId: String
    ) {
        profileService = service
        self.profileId = profileId
    }
    
    //MARK: - Methods
    func viewDidLoad() {
        fetchProfile()
    }
    
    func openAboutDeveloper() {
        profileView?.openWebView(url: ProfileConstants.developerLink)
    }
    
    func setupProfileDetails(profile: ProfileRequest) {
        //        profileView?.updateProfileDetails(profile: profile)
    }
    
    private func fetchProfile() {
        profileService.fetchProfile(id: profileId) { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    let profileUiModel = ProfileUIModel(from: profile)
                    
                    self?.profileView?.updateProfileDetails(profile: profileUiModel)
                    self?.profileView?.updateProfileAvatar(avatar: profile.avatar)
                }
            case .failure(let error):
                if let errorModel = self?.checkError(error) {
                    DispatchQueue.main.async {
                        self?.profileView?.showError(errorModel)
                    }
                }
                
                print("Error fetching profile: \(error)")
            }
        }
    }
    
    private func checkError(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.fetchProfile()
        }
    }
}



