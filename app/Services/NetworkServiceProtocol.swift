//
//  NetworkServiceProtocol.swift
//  app
//
//  Created by Егор Кожемин on 06.01.2022.
//

protocol NetworkServiceProtocol {
    func getFriends(completion: @escaping ([Friend]) -> Void)
    func getPhotos(ownerId: Int, completion: @escaping ([PhotoGallery]) -> Void)
    func getGroups(completion: @escaping ([Group]) -> Void)
    func searchGroups(query: String, completion: @escaping ([Group]) -> Void)
    func joinToGroup(groupId: Int, completion: @escaping (Int) -> Void)
    func leaveGroup(groupId: Int, completion: @escaping (Int) -> Void)
    func getNews(startFrom: String?, completion: @escaping (NewsResponse) -> Void)
}
