//
//  AuthData.swift
//  app
//
//  Created by Егор Кожемин on 29.09.2021.
//

import UIKit

final class AuthData {
    let token = "xxx-yyy-zzz"
    let userId = 7962266
    static let share = AuthData()
    private let dt = NSDate().timeIntervalSince1970
    private init () {}
}

// MARK: Информация о создании Singleton
extension AuthData: CustomStringConvertible {
    var description: String {
        return "Singleton created: \(dt)"
    }
}
