//
//  FetchDataFriendPromise.swift
//  app
//
//  Created by Егор Кожемин on 26.11.2021.
//

import Foundation
import PromiseKit

final class FetchDataFriendPromise {
    private let session = URLSession.shared
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()

    func getFriends() -> Promise<[Friend]> {
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_ids", value: String(AuthData.share.userId)),
            URLQueryItem(name: "access_token", value: AuthData.share.token),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "fields", value: "photo_100, nickname, domain, sex, bdate, city, country"),
        ]

        guard let url = urlConstructor.url else {
            return Promise.value([Friend]())
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 50.0

        return Promise { seal in
            sendRequest(request)
                .map(on: .global()) { data in
                    try JSONDecoder()
                        .decode(VKResponse<FriendItems>.self, from: data)
                        .response.items
                }.done {
                    seal.fulfill($0)
                }.catch {
                    seal.reject($0)
                }
        }
    }

    private func sendRequest(_ request: URLRequest) -> Promise<Data> {
        return Promise { seal in
            session.dataTask(with: request) { responseData, urlResponse, error in
                if let response = urlResponse as? HTTPURLResponse {
                    print(response.statusCode)
                }
                guard
                    error == nil,
                    let responseData = responseData
                else { return seal.reject(error!) }
                seal.fulfill(responseData)
            }.resume()
        }
    }
}
