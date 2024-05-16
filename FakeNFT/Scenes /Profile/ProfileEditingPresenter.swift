import Foundation

protocol ProfileEditingPresenterProtocol {

    var view: ProfileEditingViewControllerProtocol? { get set }

    func updateProfile()

    func saveProfile(
        name: String,
        description: String,
        website: String
    )
    
    func updateAvatar(_ url: URL)
}

protocol ProfileEditingPresenterDelegate {

    func profileDidUpdate()
}

final class ProfileEditingPresenter: ProfileEditingPresenterProtocol {

    weak var view: ProfileEditingViewControllerProtocol?

    private let profileService: ProfileService

    private let delegate: ProfileEditingPresenterDelegate?

    private var initAvatarUrl: URL?
    private let initName: String
    private let initDescription: String
    private let initWebsite: URL?
    private let likes: [String]
    
    init(
        view: ProfileEditingViewControllerProtocol,
        servicesAssembly: ServicesAssembly,
        delegate: ProfileEditingPresenterDelegate?,
        initAvatarUrl: URL?,
        initName: String,
        initDescription: String,
        website: URL?,
        likes: [String]
    ) {
        self.view = view
        self.profileService = servicesAssembly.profileService
        self.delegate = delegate
        self.initAvatarUrl = initAvatarUrl
        self.initName = initName
        self.initDescription = initDescription
        self.initWebsite = website
        self.likes = likes
    }

    func updateProfile() {
        view?.updateTitles(
            profileName: initName,
            profileBio: initDescription,
            profileWebLink: initWebsite,
            avatar: initAvatarUrl
        )
    }

    func saveProfile(
        name: String,
        description: String,
        website: String
    ) {
        let profileUpdate = ProfileUpdate(
            name: name,
            avatar: initAvatarUrl?.absoluteString,
            description: description,
            website: website,
            likes: likes
        )

        profileService.updateProfile(with: profileUpdate) { result in
            switch result {
            case .success:
                self.delegate?.profileDidUpdate()
            case .failure:
                print("Update profile failed")
            }
        }
    }
    
    func updateAvatar(_ url: URL) {
        initAvatarUrl = url
        
        view?.refreshAvatar(url: url)
    }
}
