import Foundation

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
    
}
