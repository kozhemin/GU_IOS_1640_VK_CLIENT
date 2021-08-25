//
//  GalleryCollectionViewCell.swift
//  app
//
//  Created by Егор Кожемин on 25.08.2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var galleryLabel: UILabel!
    @IBOutlet var galleryImage: UIImageView!

    func configure(item: PhotoGallery) {
        galleryLabel.text = item.description
        galleryImage.image = item.image
    }
}
