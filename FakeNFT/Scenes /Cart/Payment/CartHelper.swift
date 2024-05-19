//
//  File.swift
//  FakeNFT
//
//  Created by Алексей Гвоздков on 14.05.2024.
//

import UIKit

final class CartHelper {
    static let cartHelper = CartHelper()
    
    func fetchImageFromURL(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
}
