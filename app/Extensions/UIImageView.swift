//
//  UIImage.swift
//  app
//
//  Created by Егор Кожемин on 08.09.2021.
//

import UIKit

extension UIImageView {
    func resizeAndSpringAnimate() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 1,
                    delay: 0,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 10,
                    options: .curveEaseInOut,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                )
            }
        )
    }
}
