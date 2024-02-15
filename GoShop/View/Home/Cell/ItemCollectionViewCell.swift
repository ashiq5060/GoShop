//
//  ItemCollectionViewCell.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 14/02/24.
//

import UIKit
import CoreData

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImgItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    private var product: Product?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the cell's state when it's about to be reused
        ImgItem.image = nil
    }
    
    func configure(with product: Product) {
        self.product = product
        lblName.text = product.name
        lblPrice.text = "\u{20B9} \(product.price)"
        
        // Use ImageLoader to load the image asynchronously
        ImageLoader.loadImage(from: product.image, into: ImgItem, showLoader: true)
    }
    
    @IBAction func btnAddCart(_ sender: UIButton) {
        
        AnimationHelper.animateButtonClick(for: sender) {
            guard let product = self.product else { return }
            
            CoreDataManager.shared.createCartItem(productName: product.name, quantity: 1, unitPrice: product.price, imageUrl: product.image)
            
        }
    }
}
