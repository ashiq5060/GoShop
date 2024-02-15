//
//  HomeVC.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 14/02/24.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var ProductTableView: UITableView!
    
    private var productViewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch data
        fetchData()
        
    }
    // MARK: - Data Fetching
    private func fetchData() {
        Task {
            do {
                let success = try await productViewModel.fetchData()
                if success {
                    DispatchQueue.main.async {
                        self.ProductTableView.reloadData()
                    }
                } else {
                    print("Failed to fetch data.")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
}

// MARK: - Tableview Delagate and Datasource
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productViewModel.getCategories().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 // Each section will have one row for the UICollectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let category = productViewModel.getCategories()[indexPath.section]
        let products = productViewModel.getProducts(for: category)
        
        cell.products = products
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return productViewModel.getCategories()[section]
    }
    
    
}
