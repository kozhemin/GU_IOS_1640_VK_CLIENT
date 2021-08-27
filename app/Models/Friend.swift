//
//  Friend.swift
//  app
//
//  Created by Егор Кожемин on 25.08.2021.
//

import UIKit

struct PhotoGallery {
    var description: String?
    var image: UIImage?
}

struct Friend: DefaultTableDataProtocol {
    var name: String
    var image: UIImage?
    var description: String?
    var photoGallery: [PhotoGallery]?
}

var testFriendData: [Friend] = [
    Friend(
        name: "Иванов Иван",
        image: UIImage(named: "friend-1"),
        description: "Lorem ipsum...",
        photoGallery: [
            PhotoGallery(description: "Lorem ipsum...", image: UIImage(named: "friend-1.1")),
            PhotoGallery(description: "Lorem ipsum...", image: UIImage(named: "friend-1.2")),
            PhotoGallery(description: "Lorem ipsum...", image: UIImage(named: "friend-1.3")),
        ]
    ),
    Friend(
        name: "Серафима Григорьевна",
        image: UIImage(named: "friend-2"),
        description: "Lorem ipsum...",
        photoGallery: [
            PhotoGallery(image: UIImage(named: "friend-2.1")),
            PhotoGallery(image: UIImage(named: "friend-2.2")),
            PhotoGallery(image: UIImage(named: "friend-2.3")),
        ]
    ),
    Friend(
        name: "Петров Петр",
        image: UIImage(named: "friend-3"),
        description: "Lorem ipsum...",
        photoGallery: [
            PhotoGallery(image: UIImage(named: "friend-3.1")),
            PhotoGallery(image: UIImage(named: "friend-3.2")),
            PhotoGallery(image: UIImage(named: "friend-3.3")),
        ]
    ),
    Friend(
        name: "Кузнецов Кузя",
        image: UIImage(named: "friend-4"),
        description: ""
    ),
]
