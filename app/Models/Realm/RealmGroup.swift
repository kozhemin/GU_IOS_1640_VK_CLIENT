//
//  RealmGroup.swift
//  app
//
//  Created by Егор Кожемин on 17.10.2021.
//

import Foundation
import RealmSwift

class RealmGroup: Object {
    @Persisted var id: String = ""
    @Persisted var groupId: Double
    @Persisted var name: String
    @Persisted var screenName: String
    @Persisted var photo: String
    @Persisted var text: String

    override class func primaryKey() -> String? {
        "id"
    }

    override class func indexedProperties() -> [String] {
        ["name"]
    }
}

extension RealmGroup {
    convenience init(group: Group) {
        self.init()
        id = UUID().uuidString
        groupId = group.id
        name = group.name
        screenName = group.screenName
        photo = group.photo
        text = group.description
    }
}
