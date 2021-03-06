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

    static var cacheImages = [String: UIImage]()

    func lazyLoadingImage(link: String, contentMode: UIView.ContentMode) {
        if UIImageView.cacheImages[link] != nil {
            image = UIImageView.cacheImages[link]
            return
        }

        URLSession.shared.dataTask(with: NSURL(string: link)! as URL, completionHandler: {
            data, _, _ -> Void in
            DispatchQueue.main.async {
                self.contentMode = contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                    UIImageView.cacheImages[link] = self.image
                }
            }
        }).resume()
    }
}
