//
//  UIViewClip.swift
//  app
//
//  Created by Егор Кожемин on 28.08.2021.
//

import UIKit

extension UIView {
    func clip(
        cornerRadius: CGFloat = 50.0,
        borderWidth: CGFloat = 1.0,
        borderColor: CGColor = UIColor.lightGray.cgColor
    ) {
        let layer = self.layer
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }
}
