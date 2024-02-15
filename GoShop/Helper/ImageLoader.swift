//
//  ImageLoader.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 15/02/24.
//

import UIKit

class ImageLoader {
    static var cache = NSCache<NSString, UIImage>()

    static func loadImage(from urlString: String, into imageView: UIImageView, showLoader: Bool = true) {
        guard let url = URL(string: urlString) else { return }

        if showLoader {
            showLoadingIndicator(on: imageView)
        }

        // Check if the image is already in the cache
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            // If cached, set the image with a smooth fade transition
            DispatchQueue.main.async {
                UIView.transition(with: imageView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    imageView.image = cachedImage
                                  },
                                  completion: nil)
            }

            if showLoader {
                hideLoadingIndicator(on: imageView)
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if showLoader {
                hideLoadingIndicator(on: imageView)
            }

            if let data = data, let image = UIImage(data: data) {
                // Cache the image
                cache.setObject(image, forKey: urlString as NSString)

                // Set image with a smooth fade transition on the main thread
                DispatchQueue.main.async {
                    UIView.transition(with: imageView,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        imageView.image = image
                                      },
                                      completion: nil)
                }
            } else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    private static func showLoadingIndicator(on imageView: UIImageView) {
        let loaderView = UIActivityIndicatorView(style: .medium)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.startAnimating()

        DispatchQueue.main.async {
            imageView.addSubview(loaderView)

            NSLayoutConstraint.activate([
                loaderView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                loaderView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
        }
    }

    private static func hideLoadingIndicator(on imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.subviews.filter { $0 is UIActivityIndicatorView }.forEach {
                $0.removeFromSuperview()
            }
        }
    }
}
