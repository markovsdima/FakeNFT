import Foundation

public protocol ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol? { get set }
    
    func openAboutDeveloper()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    var profileView: ProfileViewControllerProtocol?
    
    func openAboutDeveloper() {
        profileView?.openWebView(url: profileConstants.developerLink)
    }
}


