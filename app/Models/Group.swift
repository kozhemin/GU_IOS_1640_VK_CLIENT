//
//  Group.swift
//  app
//
//  Created by Егор Кожемин on 24.08.2021.
//
import UIKit
import SwiftUI

struct GroupItems: Codable {
    var items: [Group]
}

struct Group: Codable {
    var id: Double
    var name: String
    var screenName: String
    var photo: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case photo = "photo_50"
        case description
    }
}

extension Group {
    var photoUrl: URL? {
        URL(string: photo)
    }
}

extension Group {
    func toAnyObject() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "description": description
        ]
    }
}
