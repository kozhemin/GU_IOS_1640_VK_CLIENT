//
//  RealmFriend.swift
//  app
//
//  Created by Егор Кожемин on 17.10.2021.
//

import Foundation
import RealmSwift

class RealmFriend: Object {
    @Persisted var id: String = ""
    @Persisted var userId: Double
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var nickName: String?
    @Persisted var photo: String
    @Persisted var domain: String
    @Persisted var sex: Int?

    override class func primaryKey() -> String? {
        "id"
    }

    override class func indexedProperties() -> [String] {
        ["userId"]
    }
}

extension RealmFriend {
    convenience init(friend: Friend) {
        self.init()
        id = UUID().uuidString
        userId = friend.id
        firstName = friend.firstName
        lastName = friend.lastName
        nickName = friend.nickName
        photo = friend.photo
        domain = friend.domain
        sex = friend.sex
    }
}

extension RealmFriend {
    var photoUrl: URL? {
        URL(string: photo)
    }
}
