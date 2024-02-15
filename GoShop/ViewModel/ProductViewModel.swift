//
//  ProductViewModel.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 14/02/24.
//

import Foundation

class ProductViewModel {
    private var productsByCategory: [String: [Product]] = [:]
    private var currentPage: Int = 1
    private let pageSize: Int = 10 // Adjust the page size as needed
    private var isFetchingData: Bool = false
    private let jsonFileName = "mock_products"
    
    func fetchData() async throws -> Bool {
            guard !isFetchingData else {
                return false
            }
            
            isFetchingData = true
            
            do {
                let data = try await fetchDataFromJSON()
                let jsonData = try decodeJSON(data: data)
                
                for product in jsonData.products {
                    if productsByCategory[product.category] == nil {
                        productsByCategory[product.category] = [product]
                    } else {
                        productsByCategory[product.category]?.append(product)
                    }
                }
                
                currentPage += 1
                isFetchingData = false
                
                return true
            } catch {
                print("Error: \(error.localizedDescription)")
                isFetchingData = false
                throw error
            }
        }
    
    private func fetchDataFromJSON() async throws -> Data {
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            return data
        } else {
            throw NSError(domain: "Invalid JSON file", code: 0, userInfo: nil)
        }
    }
    
    private func decodeJSON(data: Data) throws -> ProductModel {
        let decoder = JSONDecoder()
        return try decoder.decode(ProductModel.self, from: data)
    }
    
    func getCategories() -> [String] {
            return Array(productsByCategory.keys)
        }
        
        func getProducts(for category: String) -> [Product] {
            return productsByCategory[category] ?? []
        }
    
}
