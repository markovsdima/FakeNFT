import Foundation

import UIKit

protocol CartPreseterView: AnyObject {
    var totalPrice: String { get set }
    var nftDataCount: Int { get set }
}

final class CartPresenter {
    weak var view: CartPreseterView?
    
    var nftData: [NFTCartModel] = [NFTCartModel(name: "Apec",
                                                image: "ApecoinCart",
                                                rating: 4,
                                                paymentSystem: "Apecoin",
                                                currency: "APE",
                                                price: 7,
                                                id: UUID()),
                                   NFTCartModel(name: "Bit",
                                                image: "BitcoinCart",
                                                rating: 4,
                                                paymentSystem: "Bitcoin",
                                                currency: "ВТС",
                                                price: 2,
                                                id: UUID())]
    
    var totalPrice: Double = 0
    var nftDataCount = 0
    
    init(view: CartPreseterView) {
        self.view = view
    }
    
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
        for i in nftData {
            totalPrice += i.price
        }
        view?.totalPrice = String(totalPrice)
    }
    

    
    func ifIsEmptyNftData(_ filterButton: UIButton, _ countNFTLabel: UILabel, _ priceNFTLabel: UILabel, _ paymentButton: UIButton, _ payBackgroundColor: UIView, _ cartIsEmpty: UILabel,_ cartCollection: UICollectionView) {
        
        if nftData.isEmpty {
            filterButton.isHidden = true
            countNFTLabel.isHidden = true
            priceNFTLabel.isHidden = true
            paymentButton.isHidden = true
            payBackgroundColor.isHidden = true
            cartIsEmpty.isHidden = false
        } else {
            filterButton.isHidden = false
            countNFTLabel.isHidden = false
            priceNFTLabel.isHidden = false
            paymentButton.isHidden = false
            payBackgroundColor.isHidden = false
            cartIsEmpty.isHidden = true
        }
        cartCollection.reloadData()
    }
    
    func confirmationOfDeletion(_ nftImageView: UIImageView, _ blurView: UIVisualEffectView, _ deleteButton: UIButton, _ returnButton: UIButton, _ warningsLabel: UILabel, _ cartCollection: UICollectionView) {
        
        nftImageView.isHidden = true
        blurView.isHidden = true
        deleteButton.isHidden = true
        returnButton.isHidden = true
        warningsLabel.isHidden = true
        
        cartCollection.reloadData()
    }
    
    func confirmationOfDeletion(_ isTapped: Bool, _ nftImageView: UIImageView, _ blurView: UIVisualEffectView, _ deleteButton: UIButton, _ returnButton: UIButton, _ warningsLabel: UILabel) {
        if isTapped {
            nftImageView.isHidden = false
            blurView.isHidden = false
            deleteButton.isHidden = false
            returnButton.isHidden = false
            warningsLabel.isHidden = false
        }
    }
    
    func showActionSheet() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "По цене", style: .default) { _ in
            
        }
        alertController.addAction(action1)
        
        let action2 = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            
        }
        alertController.addAction(action2)
        
        let action3 = UIAlertAction(title: "По названию", style: .default) { _ in
            
        }
        alertController.addAction(action3)
        
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = scene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
