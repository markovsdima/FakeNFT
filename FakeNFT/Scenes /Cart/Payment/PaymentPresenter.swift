import Foundation
import UIKit

protocol PaymentPreseterView: AnyObject {
    func updatePaymentData(_ data: [PaymentSystemModel])
}

final class PaymentPresenter {
    weak var view: PaymentPreseterView?
    
    // MARK: - Properties
    let urlUserAgreement = "https://yandex.ru/legal/practicum_termsofuse/"
    
    init(view: PaymentPreseterView) {
        self.view = view
    }
    
    func fetchCurrencies() {
        CartNetworkClient.shared.fetchData(request: CurrenciesRequest()) { (result: Result<[PaymentSystemModel], Error>) in
            switch result {
            case .success(let currencies):
                // Преобразование массива Currency в массив PaymentSystemModel
                let paymentSystems = currencies.map { currency in
                    return PaymentSystemModel(title: currency.title,
                                              name: currency.name,
                                              image: currency.image,
                                              id: currency.id)
                }
                // Присвоение полученных данных массиву paymentSystem
                self.view?.updatePaymentData(paymentSystems)
            case .failure(let error):
                print("Error fetching currencies: \(error.localizedDescription)")
            }
        }
    }
    
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
