//
//  AuthDataProtocol.swift
//  app
//
//  Created by Егор Кожемин on 03.10.2021.
//

protocol AuthDataProtocol {
    var token: String { get set }
    var userId: Int { get set }
}
