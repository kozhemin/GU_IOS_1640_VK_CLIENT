//
//  UIViewShadow.swift
//  app
//
//  Created by Егор Кожемин on 28.08.2021.
//

import UIKit

extension UIView {
    func addShadow(
        cornerRadius: CGFloat = 50.0,
        shadowColor: CGColor = UIColor.gray.cgColor,
        shadowRadius: CGFloat = 5.0,
        shadowOpacity: Float = 0.8
    ) -> Void {
        let layer = self.layer
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}
