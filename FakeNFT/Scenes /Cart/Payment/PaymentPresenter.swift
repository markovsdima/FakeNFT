import Foundation

protocol PaymentPreseterView: AnyObject {
    func updatePaymentData(_ data: [PaymentSystemModel])
    func thePaymentIsCompleted(_ success: Bool)
}

final class PaymentPresenter {
    weak var view: PaymentPreseterView?
    
    // MARK: - Properties
    let urlUserAgreement = "https://yandex.ru/legal/practicum_termsofuse/"
    private(set) var nftsProfile = [String]()
    private(set) var nftsCart = [String]()
    private(set) var nftsPUTCart = [String]()
  
    init(view: PaymentPreseterView) {
        self.view = view
    }
    
    func creatingArrayNftsPUTCart() {
        nftsPUTCart = Array(Set(nftsProfile + nftsCart))
   
        print(nftsPUTCart.count)
    }
    
    func fetchCurrencies() {
        CartNetworkClient.shared.fetchPaymentSystems { result in
            switch result {
            case .success(let paymentSystems):
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
    
    func fetchProfileCart() {
        CartNetworkClient.shared.fetchProfileCart { result, isLoaded in
            switch result {
            case .success(let profile):
                self.nftsProfile = profile.nfts
                if isLoaded {
                    print("nftsProfile \(self.nftsProfile.count)")
                    self.fetchOrdersCart()
                }
            case .failure(let error):
                print("Error fetching payment systems: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchOrdersCart() {
        CartNetworkClient.shared.fetchOrdersCart { result, isLoaded in
            switch result {
            case .success(let nfts):
                self.nftsCart = nfts.nfts
                if isLoaded {
                    print("nftsCart \(self.nftsCart.count)")
                    self.creatingArrayNftsPUTCart()
                }
            case .failure(let error):
                print("there is no response from the server: \(error.localizedDescription)")
            }
        }
    }
}
