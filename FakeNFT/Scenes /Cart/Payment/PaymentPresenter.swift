import UIKit

final class PaymentPresenter {
    // MARK: - Properties
    let urlUserAgreement = "https://yandex.ru/legal/practicum_termsofuse/"
    
    let paymentSystem: [PaymentSystemModel] = [
        PaymentSystemModel(image: "BitcoinCart", paymentSystem: "Bitcoin", currency: "ВТС"),
        PaymentSystemModel(image: "DogecoinCart", paymentSystem: "Dogecoin", currency: "DOGE"),
        PaymentSystemModel(image: "TetherCart", paymentSystem: "Tether", currency: "USDT"),
        PaymentSystemModel(image: "ApecoinCart", paymentSystem: "Apecoin", currency: "APE"),
        PaymentSystemModel(image: "SolanaCart", paymentSystem: "Solana", currency: "SOL"),
        PaymentSystemModel(image: "EthereumCart", paymentSystem: "Ethereum", currency: "ETH"),
        PaymentSystemModel(image: "CardanoCart", paymentSystem: "Cardano", currency: "ADA"),
        PaymentSystemModel(image: "ShibaInuCart", paymentSystem: "Shiba Inu", currency: "SHIB")
    ]
    
    // MARK: - Lifecycle
    func showAlert(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Не удалось произвести оплату", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            print("cancelAction")
        }
        
        let replayAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            print("replayAction")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(replayAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
