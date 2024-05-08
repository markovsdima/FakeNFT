import Foundation

import UIKit

protocol CartPreseterView: AnyObject {
    var totalPrice: String { get set }
    var nftDataCount: Int { get set }
}

final class CartPresenter {
    // MARK: - Properties
    weak var view: CartPreseterView?
    
    var nftData: [NFTCartModel] = [NFTCartModel(name: "Apec",
                                                image: "ApecoinCart",
                                                rating: 1,
                                                paymentSystem: "Apecoin",
                                                currency: "APE",
                                                price: 7,
                                                id: UUID()),
                                   NFTCartModel(name: "Bit",
                                                image: "BitcoinCart",
                                                rating: 3,
                                                paymentSystem: "Bitcoin",
                                                currency: "ВТС",
                                                price: 2,
                                                id: UUID())]
    
    var totalPrice: Double = 0
    var nftDataCount = 0
    
    init(view: CartPreseterView) {
        self.view = view
    }
    
    // MARK: - Lifecycle
    func nftCount() {
        nftDataCount = 0
        nftDataCount = nftData.count
        view?.nftDataCount = nftDataCount
    }
    
    func deleteNFT() {
        totalPrice = 0
        nftData.removeAll()
        view?.totalPrice = String(totalPrice)
    }
    
    func sumNFT() {
        for newPrice in nftData {
            totalPrice += newPrice.price
        }
        view?.totalPrice = String(totalPrice)
    }
    
    
    
    func ifIsEmptyNftData(_ filter: UIButton,
                          _ countNFT: UILabel,
                          _ priceNFT: UILabel,
                          _ payment: UIButton,
                          _ payBackground: UIView,
                          _ cartIsEmpty: UILabel,
                          _ cart: UICollectionView) {
        
        if nftData.isEmpty {
            filter.isHidden = true
            countNFT.isHidden = true
            priceNFT.isHidden = true
            payment.isHidden = true
            payBackground.isHidden = true
            cartIsEmpty.isHidden = false
        } else {
            filter.isHidden = false
            countNFT.isHidden = false
            priceNFT.isHidden = false
            payment.isHidden = false
            payBackground.isHidden = false
            cartIsEmpty.isHidden = true
        }
        cart.reloadData()
    }
    
    func confirmationOfDeletion(_ nftImage: UIImageView,
                                _ blur: UIVisualEffectView,
                                _ delete: UIButton,
                                _ returnButton: UIButton,
                                _ warnings: UILabel,
                                _ cart: UICollectionView) {
        
        nftImage.isHidden = true
        blur.isHidden = true
        delete.isHidden = true
        returnButton.isHidden = true
        warnings.isHidden = true
        
        cart.reloadData()
    }
    
    func confirmationOfDeletion(_ isTapped: Bool,
                                _ nftImage: UIImageView,
                                _ blur: UIVisualEffectView,
                                _ delete: UIButton,
                                _ returnButton: UIButton,
                                _ warnings: UILabel) {
        if isTapped {
            nftImage.isHidden = false
            blur.isHidden = false
            delete.isHidden = false
            returnButton.isHidden = false
            warnings.isHidden = false
        }
    }
    
    func showActionSheet() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let priceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            
        }
        
        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            
        }
        
        
        let nameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(priceAction)
        alertController.addAction(ratingAction)
        alertController.addAction(nameAction)
        alertController.addAction(cancelAction)
        
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = scene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
