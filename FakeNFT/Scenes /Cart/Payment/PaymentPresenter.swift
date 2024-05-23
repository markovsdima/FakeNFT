import Foundation

protocol PaymentPreseterView: AnyObject {
    func updatePaymentData(_ data: [PaymentSystemModel])
    func thePaymentIsCompleted(_ success: Bool)
}

final class PaymentPresenter {
    weak var view: PaymentPreseterView?
    
    // MARK: - Properties
    let urlUserAgreement = "https://yandex.ru/legal/practicum_termsofuse/"
    
    init(view: PaymentPreseterView) {
        self.view = view
    }
    
    func fetchCurrencies() {
        CartNetworkClient.shared.fetchPaymentSystems { result in
            switch result {
            case .success(let paymentSystems):
                // Преобразование массива PaymentSystemModel
                self.view?.updatePaymentData(paymentSystems)
            case .failure(let error):
                print("Error fetching payment systems: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPay(_ idPaymentSystem: String) {
        CartNetworkClient.shared.fetchPayCart(id: idPaymentSystem) { result in
            switch result {
            case .success(let payResult):
                self.view?.thePaymentIsCompleted(payResult.success)
                print(payResult)
            case .failure(let error):
                print("Error fetching payment systems: \(error.localizedDescription)")
            }
        }
    }
}
