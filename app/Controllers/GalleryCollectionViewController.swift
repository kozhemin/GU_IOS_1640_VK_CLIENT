//
//  GalleryCollectionViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import UIKit

private let reuseIdentifier = "galleryCell"

class GalleryCollectionViewController: UICollectionViewController {
    private var galleryItem = [PhotoGallery]() {
        didSet {
            collectionView.reloadData()
        }
    }

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

    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: "showPhotoSlider",
            sender: indexPath
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sliderVc = segue.destination as? PhotoSliderViewController
        else { return }

        let indexPath = sender as! IndexPath
        sliderVc.setImages(images: galleryItem, indexAt: indexPath.row)
    }
}
