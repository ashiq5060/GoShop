//
//  CartCell.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 15/02/24.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func cartCellDidTapDelete(_ cell: CartCell)
    func cartCellDidTapUpdate(_ cell: CartCell)
}

class CartCell: UITableViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet private weak var stepper: UIStepper!
    
    private var cartItem: Cart?
    weak var delegate: CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        btnRemove.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with cartItem: Cart) {
        self.cartItem = cartItem
        lblName.text = cartItem.productName
        lblQuantity.text = "Quantity: \(cartItem.quantity)"
        lblPrice.text = "Total Cost: \u{20B9} \(cartItem.totalCost)"
        // Use ImageLoader to load the image asynchronously
                ImageLoader.loadImage(from: cartItem.imageUrl ?? "", into: imgItem, showLoader: true)
        
        // Set the stepper value to the quantity
        stepper.value = Double(cartItem.quantity)
    }
    
    @objc private func stepperValueChanged() {
        guard let cartItem = cartItem else { return }
        
        // Update the quantity label
        lblQuantity.text = "Quantity: \(Int(stepper.value))"
        
        // Ensure the new quantity is at least 1
        let newQuantity = max(1, Int16(stepper.value))
        lblPrice.text = "Total Cost: \u{20B9} \(cartItem.unitPrice * Double(newQuantity))"
        
        // Update the Core Data model
        CoreDataManager.shared.updateCartItem(cartItem: cartItem, quantity: newQuantity)
        delegate?.cartCellDidTapUpdate(self)
    }
    
    @objc private func removeButtonTapped() {
        delegate?.cartCellDidTapDelete(self)
    }
}
