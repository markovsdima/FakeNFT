@testable import FakeNFT
import XCTest

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var profileView: FakeNFT.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    func fetchProfile() {}
    func openAboutDeveloper() {}
    func onMyNftsClicked() {}
    func onFavouriteNftsClicked() {}
    func onEditProfileClicked() {}
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: FakeNFT.ProfilePresenterProtocol?
    var openWebViewCalled: Bool = false
    var openMyNftsCalled: Bool = false
    var openFavouriteNftsCalled: Bool = false
    var showErrorCalled: Bool = false
    
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    func setLoader(_ visible: Bool) {}
    func openWebView(url: URL?) {
        openWebViewCalled = true
    }
    func updateProfileDetails(profile: FakeNFT.ProfileUIModel) {}
    func updateProfileAvatar(avatar: URL?) {}
    func showError(_ model: FakeNFT.ErrorModel) {
        showErrorCalled = true
    }
    func openMyNfts(profile: FakeNFT.ProfileResponse) {
        openMyNftsCalled = true
    }
    func openFavouriteNfts(profile: FakeNFT.ProfileResponse) {
        openFavouriteNftsCalled = true
    }
    func openEditProfile(avatarUrl: URL?, name: String, description: String, link: URL?, likes: [String]) {}
    
}

final class ProfileUnitTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        
        //given
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()
        
        let servicesAssembly = ServicesAssembly(
            networkClient: mockNetworkClient,
            nftStorage: mockNftStorage
        )
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )
        viewController.presenter = presenter
        
        // when
        viewController.viewDidLoad()
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsOpenWebView() {
        
        //given
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()
        let mockProfileService = MockProfileService(networkClient: mockNetworkClient)
        let servicesAssembly = ServicesAssembly(
            networkClient: mockNetworkClient,
            nftStorage: mockNftStorage
        )
        let presenter = ProfilePresenter(
            service: mockProfileService,
            profileId: ProfileConstants.profileId
        )
        presenter.loadedProfile = ProfileResponse(name: "", description: "", nfts: [], likes: [], id: "")
        
        let viewController = ProfileViewControllerSpy(
            presenter: presenter
        )
        
        presenter.profileView = viewController
        
        // when
        presenter.openAboutDeveloper()
        
        // then
        XCTAssertTrue(viewController.openWebViewCalled)
    }
    
    func testPresenterCallsOpenMyNfts() {
        
        //given
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()
        let mockProfileService = MockProfileService(networkClient: mockNetworkClient)
        let servicesAssembly = ServicesAssembly(
            networkClient: mockNetworkClient,
            nftStorage: mockNftStorage
        )
        let presenter = ProfilePresenter(
            service: mockProfileService,
            profileId: ProfileConstants.profileId
        )
        presenter.loadedProfile = ProfileResponse(name: "", description: "", nfts: [], likes: [], id: "")
        
        let viewController = ProfileViewControllerSpy(
            presenter: presenter
        )
        
        presenter.profileView = viewController
        
        // when
        presenter.onMyNftsClicked()
        
        // then
        XCTAssertTrue(viewController.openMyNftsCalled)
    }
    
    func testPresenterCallsOpenFavouriteNfts() {
        
        //given
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()
        let mockProfileService = MockProfileService(networkClient: mockNetworkClient)
        let servicesAssembly = ServicesAssembly(
            networkClient: mockNetworkClient,
            nftStorage: mockNftStorage
        )
        let presenter = ProfilePresenter(
            service: mockProfileService,
            profileId: ProfileConstants.profileId
        )
        presenter.loadedProfile = ProfileResponse(name: "", description: "", nfts: [], likes: [], id: "")
        
        let viewController = ProfileViewControllerSpy(
            presenter: presenter
        )
        
        presenter.profileView = viewController
        
        // when
        presenter.onFavouriteNftsClicked()
        
        // then
        XCTAssertTrue(viewController.openFavouriteNftsCalled)
    }
    
    func testPresenterFetchNoError() {
        //given
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()
        let mockProfileService = MockProfileService(networkClient: mockNetworkClient)
        let servicesAssembly = ServicesAssembly(
            networkClient: mockNetworkClient,
            nftStorage: mockNftStorage
        )
        let presenter = ProfilePresenter(
            service: mockProfileService,
            profileId: ProfileConstants.profileId
        )
        
        let viewController = ProfileViewControllerSpy(
            presenter: presenter
        )
        
        presenter.profileView = viewController
        
        // when
        presenter.fetchProfile()
        
        // then
        XCTAssertFalse(viewController.showErrorCalled)
    }
}

