//
//  CartVC.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 15/02/24.
//

import UIKit
import CoreData

class CartVC: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    
    var cartItems: [Cart] = []
    var totalPrice: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch cart items from Core Data
        fetchCartItems()
    }
    
    // MARK: - Core Data Methods
    
    private func fetchCartItems() {
        cartItems = CoreDataManager.shared.fetchAllCartItems()
        displayTotalCost()
        
        
        
    }
    
    func displayTotalCost() {
        guard !cartItems.isEmpty else {
            print("Cart is empty")
            return
        }
        
        let totalCost = cartItems.reduce(0.0) { $0 + $1.totalCost }
        totalPrice = totalCost
        cartTableView.reloadData()
        print("Total Cost of Cart: \(totalCost)")
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Tableview Delagate and Datasource
extension CartVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        let cartItem = cartItems[indexPath.row]
        cell.configure(with: cartItem)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Check if the cart is empty
        guard !cartItems.isEmpty else {
            return nil
        }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        footerView.backgroundColor = UIColor.lightGray
        
        let totalPriceLabel = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 30))
        totalPriceLabel.text = "Total Price:  \u{20B9} \(totalPrice)"
        totalPriceLabel.textAlignment = .right
        
        footerView.addSubview(totalPriceLabel)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cartItems.isEmpty ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    
}

// MARK: - CartTableViewCell Delegate methods

extension CartVC : CartTableViewCellDelegate {
    func cartCellDidTapDelete(_ cell: CartCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        let cartItem = cartItems[indexPath.row]
        
        CoreDataManager.shared.deleteCartItem(cartItem: cartItem)
        cartItems.remove(at: indexPath.row)
        cartTableView.deleteRows(at: [indexPath], with: .automatic)
        displayTotalCost()
    }
    
    func cartCellDidTapUpdate(_ cell: CartCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        cartTableView.reloadRows(at: [indexPath], with: .automatic)
        displayTotalCost()
    }
}
