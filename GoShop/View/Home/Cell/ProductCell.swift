//
//  ProductCell.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 14/02/24.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var lblcategory: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var products: [Product] = [] {
        didSet {
            productCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: - CollectionView Delagate and Datasource
extension ProductCell : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
}
