import Foundation

protocol ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol? { get set }
    
    func openAboutDeveloper()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var profileView: ProfileViewControllerProtocol?
    
    func openAboutDeveloper() {
        profileView?.openWebView(url: ProfileConstants.developerLink)
    }
}


