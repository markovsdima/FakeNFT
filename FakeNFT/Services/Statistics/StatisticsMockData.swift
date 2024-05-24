import Foundation

final class StatisticsMockData {
    static let shared = StatisticsMockData()
    private init() {}
    
    // MARK: - Private Properties
    private let emulatedDelayInSeconds: Double = 0.5
    
    // MARK: - Public Methods
    func getUsersListData(pageNumber: Int) async throws -> (Data, URLResponse) {
        
        if pageNumber != 0 {
            throw StatisticsNetworkManagerError.emptyResponse
        }
        
        guard let data = usersListMockJson.data(using: .utf8) else {
            return (Data(), URLResponse())
        }
        
        try await Task.sleep(nanoseconds: secondsToNano(seconds: emulatedDelayInSeconds))
        
        return (data, URLResponse())
    }
    
    func getUserInfoData() async throws -> (Data, URLResponse) {
        guard let data = userInfoMockJson.data(using: .utf8) else {
            return (Data(), URLResponse())
        }
        
        try await Task.sleep(nanoseconds: secondsToNano(seconds: emulatedDelayInSeconds))
        
        return (data, URLResponse())
    }
    
    func getNft() async throws -> (Data, URLResponse) {
        guard let data = nftMockJson.data(using: .utf8) else {
            return (Data(), URLResponse())
        }
        
        try await Task.sleep(nanoseconds: secondsToNano(seconds: emulatedDelayInSeconds))
        
        return (data, URLResponse())
    }
    
    // MARK: - Private Methods
    private func secondsToNano(seconds: Double) -> UInt64 {
        return UInt64(seconds * 1_000_000_000)
    }
}

// MARK: - Mock JSONs
fileprivate let usersListMockJson = """
[
  {
    "name": "Lucille Heaney",
    "avatar": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/753.jpg",
    "description": "Supporting artists through NFTs is my passion ❤",
    "website": "https://practicum.yandex.ru/promo/courses/email-marketing",
    "nfts": [
      "1",
      "4",
      "5"
    ],
    "rating": "10",
    "id": "2"
  },
  {
    "name": "Ann",
    "avatar": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/753.jpg",
    "description": "Supporting artists through NFTs is my passion ❤",
    "website": "https://practicum.yandex.ru/promo/courses/email-marketing",
    "nfts": [
      "1",
      "4",
      "5",
      "7"
    ],
    "rating": "11",
    "id": "3"
  }
]
"""

fileprivate let userInfoMockJson = """
{
  "name": "Студентус Практикумус",
  "avatar": "https://code.s3.yandex.net/landings-v2-ios-developer/space.PNG",
  "description": "Прошел 5-й спринт, и этот пройду",
  "website": "https://practicum.yandex.ru/ios-developer",
  "nfts": [
    "123,456"
  ],
  "likes": [
    "1,3,5,6"
  ],
  "id": "1"
}
"""

fileprivate let nftMockJson = """
{
  "createdAt": "2023-04-20T02:22:27Z",
  "name": "April",
  "images": [
    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png",
    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png"
  ],
  "rating": 5,
  "description": "A 3D model of a mythical creature.",
  "price": 8.81,
  "author": "49",
  "id": "1"
}
"""
