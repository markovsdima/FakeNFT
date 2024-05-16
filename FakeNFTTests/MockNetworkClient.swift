@testable import FakeNFT
import Foundation

final class MockNetworkClient: NetworkClient {
    var sendCalled = false
    var returnedData: Data?
    var returnedError: Error?

    func send<T>(request: NetworkRequest, type: T.Type, completionQueue: DispatchQueue,
                 onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? where T: Decodable {
        sendCalled = true
        completionQueue.async {
            if let data = self.returnedData {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    onResponse(.success(decoded))
                } catch {
                    onResponse(.failure(error))
                }
            } else if let error = self.returnedError {
                onResponse(.failure(error))
            }
        }
        return nil
    }

    func send(request: NetworkRequest, completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        sendCalled = true
        completionQueue.async {
            if let data = self.returnedData {
                onResponse(.success(data))
            } else if let error = self.returnedError {
                onResponse(.failure(error))
            }
        }
        return nil
    }
}
