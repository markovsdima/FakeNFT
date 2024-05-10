import Foundation

protocol ProfileService {
    func fetchProfile(id: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(id: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        let request = FetchProfileRequest(id: id)
        networkClient.send(request: request, type: ProfileResponse.self, onResponse: completion)
    }
    
}
