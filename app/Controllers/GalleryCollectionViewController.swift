//
//  GalleryCollectionViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

private let reuseIdentifier = "galleryCell"

class GalleryCollectionViewController: UICollectionViewController {
    private var galleryItem = [PhotoGallery]()

    func loadData(items: [PhotoGallery]) {
        galleryItem = items
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return galleryItem.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? GalleryCollectionViewCell
        else { return UICollectionViewCell() }

        cell.configure(item: galleryItem[indexPath.item])

        return cell
    }
}
