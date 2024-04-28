import Foundation

public protocol ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol? { get set }
    
}

final class ProfilePresenter: ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol?
    
    
    private func fetchProfile() {
        //todo
    }
    
    private func convertToProfileModel() {
        //todo
    }
    
}


