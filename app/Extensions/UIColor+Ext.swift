//
//  UIColor.swift
//  app
//
//  Created by Егор Кожемин on 07.09.2021.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1),
            alpha: 1.0
        )
    }
}
