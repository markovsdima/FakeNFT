@testable import FakeNFT
import Foundation

final class MockProfileService: ProfileService {
    weak var delegate: FakeNFT.ProfileServiceDelegate?

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProfile(id: String, completion: @escaping (Result<FakeNFT.ProfileResponse, Error>) -> Void) {
        networkClient.send(
            request: FetchProfileRequest(id: id),
            type: FakeNFT.ProfileResponse.self,
            onResponse: completion
        )
    }

    func updateProfile(
        with profileUpdate: ProfileUpdate,
        completion: (@escaping (Result<FakeNFT.ProfileResponse, Error>) -> Void)
    ) {
        let request = UpdateProfileRequest(profile: profileUpdate)

        networkClient.send(request: request, type: FakeNFT.ProfileResponse.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
