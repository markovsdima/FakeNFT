import Foundation

protocol ProfileEditingPresenterProtocol {
    
    var view: ProfileEditingViewControllerProtocol? { get set }
    
    func updateProfile()
}

final class ProfileEditingPresenter: ProfileEditingPresenterProtocol {
    
    weak var view: ProfileEditingViewControllerProtocol?
    
    func updateProfile() {
        let profileName = ProfileConstants.profileNameString
        let profileBio = ProfileConstants.profileBioString
        let profileWebLink = ProfileConstants.profileWebLinkString
        
        view?.updateTitles(profileName: profileName, profileBio: profileBio, profileWebLink: profileWebLink)
    }
    
}
