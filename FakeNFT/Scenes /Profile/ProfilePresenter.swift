import Foundation

public protocol ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol? { get set }
    
}

final class ProfilePresenter: ProfilePresenterProtocol {
    var profileView: ProfileViewControllerProtocol?
    
    //TODO
}


