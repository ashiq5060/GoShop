//
//  ButtonAnimationHelper.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 15/02/24.
//

import UIKit

class AnimationHelper {

    // MARK: - Button Animation

    static func animateButtonClick(for button: UIButton, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
           
            UIView.animate(withDuration: 0.2) {
                button.transform = .identity
            }

            
            completion?()
        }
    }

   
}
