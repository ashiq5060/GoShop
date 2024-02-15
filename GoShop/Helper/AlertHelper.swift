//
//  AlertHelper.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 15/02/24.
//

import UIKit

class AlertHelper {

    static func showAlert(withTitle title: String, message: String) {
        guard let windowScene = UIApplication.getKeyWindowScene(),
              let topViewController = windowScene.windows.first?.rootViewController else {
            // If the top view controller is nil, print an error message
            print("Error: Cannot present alert. Top view controller not found.")
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        topViewController.present(alertController, animated: true, completion: nil)
    }
}

extension UIApplication {

    static func topViewController(base: UIViewController? = getKeyWindowScene()?.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }

    static func getKeyWindowScene() -> UIWindowScene? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }
        } else {
            return nil
        }
    }
}
