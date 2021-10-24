//
//  FirebaseVkUserAuthLog.swift
//  app
//
//  Created by Егор Кожемин on 24.10.2021.
//

import Firebase

struct FirebaseVkUserAuthLog {
    let userId: Int
    let dt: Int
    let ref: DatabaseReference?

    init(userId: Int, dt: Int) {
        ref = nil
        self.userId = userId
        self.dt = dt
    }

    func toAnyObject() -> [String: Any] {
        [
            "userId": userId,
            "dt": dt,
        ]
    }
}
