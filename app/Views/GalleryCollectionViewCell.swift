//
//  GalleryCollectionViewCell.swift
//  app
//
//  Created by Егор Кожемин on 25.08.2021.
//

import Nuke
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var galleryLabel: UILabel!
    @IBOutlet var galleryImage: UIImageView!

    func configure(url: URL) {
        Nuke.loadImage(
            with: url,
            into: galleryImage
        )
    }
}
