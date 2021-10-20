//
//  RealmPhotoGallery.swift
//  app
//
//  Created by Егор Кожемин on 17.10.2021.
//

import Foundation
import RealmSwift

class RealmPhotoGallery: Object {
    @Persisted var id: String = ""
    @Persisted var galleryId: Double
    @Persisted var albumId: Double
    @Persisted var ownerId: Double
    @Persisted var text: String
    @Persisted var images = Map<String, String>()

    override class func primaryKey() -> String? {
        "id"
    }
}

extension RealmPhotoGallery {
    convenience init(gallery: PhotoGallery) {
        self.init()
        id = UUID().uuidString
        galleryId = gallery.id
        albumId = gallery.albumId
        ownerId = gallery.ownerId
        text = gallery.text

        for itemImage in gallery.items {
            images[itemImage.type] = itemImage.url
        }
    }
}

extension RealmPhotoGallery {
    func getImageUrlByType(type: String) -> URL? {
        for item in images {
            if item.key == type {
                return URL(string: item.value)
            }
        }
        return nil
    }
}
