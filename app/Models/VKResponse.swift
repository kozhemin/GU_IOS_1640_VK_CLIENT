//
//  VKResponse.swift
//  app
//
//  Created by Егор Кожемин on 05.10.2021.
//

struct VKResponse<T: Codable> {
    let response: T
}

extension VKResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case response
    }
}
