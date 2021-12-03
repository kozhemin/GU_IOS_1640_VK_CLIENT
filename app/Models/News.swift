//
//  News.swift
//  app
//
//  Created by Егор Кожемин on 10.11.2021.
//

import Foundation

struct NewsResponse {
    var newsItems: NewsItems
    var groupItems: NewsGroups
    var profileItems: NewsProfiles
    var nextFrom: String
}

// MARK: Структура новостей

struct NewsItems: Codable {
    var items: [NewsPost]
}

struct Cn: Codable {
    var count: Int
}

struct NewsPhoto: Codable {
    var id: Double
    var date: Double
    var sizes: [ImageItem]
}

struct NewsAttach: Codable {
    var type: String
    var photo: NewsPhoto?
}

struct NewsPost: Codable {
    var postId: Double?
    var sourceId: Double
    var date: Double
    var text: String?
    var postType: String?
    var comments: Cn?
    var likes: Cn?
    var views: Cn?
    var reposts: Cn?
    var attachments: [NewsAttach]?

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case sourceId = "source_id"
        case date
        case text
        case postType = "post_type"
        case comments
        case views
        case reposts
        case attachments
    }
}

extension NewsPost {
    var postDate: String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}

// MARK: Структура для групп

struct NewsGroups: Codable {
    var groups: [Group]
}

// MARK: Структура для профилей

struct NewsProfiles: Codable {
    var profiles: [Friend]
}

// MAARK: Структура для смещения новостей

struct NewsNextFrom: Codable {
    var nextFrom: String
    enum CodingKeys: String, CodingKey {
        case nextFrom = "next_from"
    }
}

// MARK: Структура для секций

enum CellType {
    case photo
    case text
}

struct NewsDataRow {
    var type: CellType
    var photo: URL?
    var text: String?
}

struct NewsSection {
    var postId: Double?
    var date: String
    var author: String
    var authorPhoto: URL?
    var comments: Int
    var likes: Int
    var views: Int
    var reposts: Int
    var data: [NewsDataRow]
}
