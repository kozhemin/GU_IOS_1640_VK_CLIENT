//
//  NetworkService.swift
//  app
//
//  Created by Егор Кожемин on 02.10.2021.
//
import UIKit

class NetworkService {
   
    private let session = URLSession.shared
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()
    
    // MARK: Получение списка друзей
    func getFriends() {
        guard let url = prepareUrl(
            methodName: "friends.get",
            params: URLQueryItem(name: "fields", value: "nickname, domain, sex, bdate, city, country"))
        else { return }
        vkRequest(url: url)
    }
    
    // MARK: Получение фотографий человека
    func getPhotos(ownerId: Int) {
        guard let url = prepareUrl(
            methodName: "photos.getAll",
            params: URLQueryItem(name: "owner_id", value: String(ownerId)))
        else { return }
        vkRequest(url: url)
    }
    
    // MARK: Получение групп текущего пользователя
    func getGroups(userId: Int) {
        guard let url = prepareUrl(
            methodName: "groups.get",
            params: URLQueryItem(name: "user_id", value: String(userId)))
        else { return }
        vkRequest(url: url)
    }
    
    // MARK: Получение групп по поисковому запросу
    func searchGroups(query: String) {
        guard let url = prepareUrl(
            methodName: "groups.search",
            params: URLQueryItem(name: "q", value: query))
        else { return }
        vkRequest(url: url)
    }
    
    private func prepareUrl(methodName: String, params: URLQueryItem? = nil) -> URL? {
        urlConstructor.path = "/method/" + methodName
        urlConstructor.queryItems = [
            URLQueryItem(
                name: "user_ids",
                value: String(AuthData.share.userId)),
            URLQueryItem(
                name: "access_token",
                value: AuthData.share.token),
            URLQueryItem(
                name: "v",
                value: "5.131"),
        ]
        if params != nil {
            urlConstructor.queryItems?.append(params!)
        }
        return urlConstructor.url
    }
    
    private func vkRequest(url: URL) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        
        session.dataTask(with: request) { responseData, urlResponse, error in
            if let response = urlResponse as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let responseData = responseData
            else { return }
            let json = try? JSONSerialization.jsonObject(
                with: responseData,
                options: .fragmentsAllowed)
            
                print(json)
             
        }
        .resume()
    }
}
