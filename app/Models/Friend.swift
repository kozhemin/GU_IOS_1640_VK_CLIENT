//
//  Friend.swift
//  app
//
//  Created by Егор Кожемин on 25.08.2021.
//

import Foundation

struct FriendItems: Codable {
    var items: [Friend]
}

struct Friend: Codable {
    var id: Double
    var firstName: String
    var lastName: String
    var nickName: String?
    var photo: String
    var domain: String
    var sex: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName = "nickname"
        case photo = "photo_100"
        case domain
        case sex
    }
}

extension Friend {
    var photoUrl: URL? {
        URL(string: photo)
    }
}
