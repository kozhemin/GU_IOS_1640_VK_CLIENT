//
//  GalleryCollectionViewController.swift
//  app
//
//  Created by Егор Кожемин on 18.08.2021.
//

import RealmSwift
import UIKit

private let reuseIdentifier = "galleryCell"

class GalleryCollectionViewController: UICollectionViewController {
    public var ownerId: Double = 0
    private var galleryToken: NotificationToken?
    private var gallery: Results<RealmPhotoGallery>?
    private let realmProvider = ProviderDataService()

    let sectionInset: CGFloat = 20
    let itemsPerRow: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        gallery = try? RealmService
            .load(typeOf: RealmPhotoGallery.self)
            .filter("ownerId = %f", ownerId)
    }

    override func viewDidAppear(_: Bool) {
        loadData()
    }

    public func loadData() {
        realmProvider.loadPhoto(ownerId: Int(ownerId))
        galleryToken = gallery?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.collectionView.reloadData()
            case .update:
                self?.collectionView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return gallery?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? GalleryCollectionViewCell,
            let imageUrl = gallery?[indexPath.item].getImageUrlByType(type: "x")
        else { return UICollectionViewCell() }

        cell.configure(url: imageUrl)
        return cell
    }

    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: "showPhotoSlider",
            sender: indexPath
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sliderVc = segue.destination as? PhotoSliderViewController,
              let gallery = gallery
        else { return }

        let indexPath = sender as! IndexPath
        sliderVc.setImages(gallery: gallery, indexAt: indexPath.row)
    }
}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let paddingWidth = sectionInset * (itemsPerRow + 1)
        let availWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        sectionInset
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        sectionInset
    }
}
