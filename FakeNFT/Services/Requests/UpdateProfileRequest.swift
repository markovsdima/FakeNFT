import Foundation

struct UpdateProfileRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod = HttpMethod.put

    var body: Data?

    init(profile: ProfileUpdate) {
        let likesItem: [URLQueryItem]
        
        if profile.likes.isEmpty {
            likesItem = [
                URLQueryItem(name: "likes", value: "null")
            ]
        } else {
            likesItem = profile.likes.map {
                URLQueryItem(name: "likes", value: $0)
            }
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "name", value: profile.name),
            URLQueryItem(name: "avatar", value: profile.avatar),
            URLQueryItem(name: "description", value: profile.description),
            URLQueryItem(name: "website", value: profile.website)
        ] + likesItem

        if let queryString = components.percentEncodedQuery {
            self.body = queryString.data(using: .utf8)
        }
    }
}
