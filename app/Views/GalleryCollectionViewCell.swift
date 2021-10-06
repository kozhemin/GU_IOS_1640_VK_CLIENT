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

    func configure(item: PhotoGallery) {
        galleryLabel.text = item.description

        if item.items.count > 0,
           let sImage = item.items.getImageByType(type: "s"),
           let url = sImage.photoUrl
        {
            Nuke.loadImage(
                with: url,
                into: galleryImage
            )
        }
    }
}
