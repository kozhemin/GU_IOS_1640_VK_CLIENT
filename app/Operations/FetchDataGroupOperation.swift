//
//  FetchDataGroupOperation.swift
//  app
//
//  Created by Егор Кожемин on 20.11.2021.
//

import Foundation

final class FetchDataGroupOperation: AsyncOperation {
    var jsonGroupDataResponce: Data?
    private let session = URLSession.shared
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()

    override func main() {
        guard
            !isCancelled
        else { return }

        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_ids", value: String(AuthData.share.userId)),
            URLQueryItem(name: "access_token", value: AuthData.share.token),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
        ]

        guard let url = urlConstructor.url else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0

        session.dataTask(with: request) { responseData, urlResponse, error in
            if let response = urlResponse as? HTTPURLResponse {
                print("Код ответа: \(response.statusCode)")
            }
            guard
                error == nil,
                let responseData = responseData
            else { return }
            self.jsonGroupDataResponce = responseData
            self.state = .finished
        }
        .resume()
    }
}
