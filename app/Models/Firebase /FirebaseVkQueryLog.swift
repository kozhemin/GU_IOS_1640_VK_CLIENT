//
//  FirebaseVkQueryLog.swift
//  app
//
//  Created by Егор Кожемин on 24.10.2021.
//

import Firebase

struct FirebaseVkQueryLog {
    let userId: Int
    let query: String
    let ref: DatabaseReference?

    init(userId: Int, query: String) {
        ref = nil
        self.userId = userId
        self.query = query
    }

    func toAnyObject() -> [String: Any] {
        [
            "userId": userId,
            "query": query,
        ]
    }
}
