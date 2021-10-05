//
//  AuthData.swift
//  app
//
//  Created by Егор Кожемин on 29.09.2021.
//

import UIKit

final class AuthData: AuthDataProtocol {
    var token = ""
    var userId = 0
    static let share = AuthData()
    private init() {}
}
