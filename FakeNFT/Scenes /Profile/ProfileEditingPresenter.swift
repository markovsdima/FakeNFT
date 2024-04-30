import Foundation

protocol ProfileEditingPresenterProtocol {
    
    var view: ProfileEditingViewControllerProtocol? { get set }
    
    func udateProfile()
}

class ProfileEditingPresenter: ProfileEditingPresenterProtocol {
    var view: ProfileEditingViewControllerProtocol?

    func udateProfile() {
        let profileName = profileConstants.profileNameString
        let profileBio = profileConstants.profileBioString
        let profileWebLink = profileConstants.profileWebLinkString
        
        view?.updateTitles(profileName: profileName, profileBio: profileBio, profileWebLink: profileWebLink)
    }
    
}
