//
//  NetworkServiceProxy.swift.swift
//  app
//
//  Created by Егор Кожемин on 06.01.2022.
//

class NetworkServiceProxy: NetworkServiceProtocol {
    
    var networkService: NetworkService
    
    init(_ base: NetworkService){
        self.networkService = base
    }
    
    func getFriends(completion: @escaping ([Friend]) -> Void) {
        networkService.getFriends(completion: completion)
        printLog(method: "getFriends")
    }
    
    func getPhotos(ownerId: Int, completion: @escaping ([PhotoGallery]) -> Void) {
        networkService.getPhotos(ownerId: ownerId, completion: completion)
        printLog(method: "getPhotos")
    }
    
    func getGroups(completion: @escaping ([Group]) -> Void) {
        networkService.getGroups(completion: completion)
        printLog(method: "getGroups")
    }
    
    func searchGroups(query: String, completion: @escaping ([Group]) -> Void) {
        networkService.searchGroups(query: query, completion: completion)
        printLog(method: "networkService")
    }
    
    func joinToGroup(groupId: Int, completion: @escaping (Int) -> Void) {
        networkService.joinToGroup(groupId: groupId, completion: completion)
        printLog(method: "joinToGroup")
    }
    
    func leaveGroup(groupId: Int, completion: @escaping (Int) -> Void) {
        networkService.leaveGroup(groupId: groupId, completion: completion)
        printLog(method: "leaveGroup")
    }
    
    func getNews(startFrom: String? = nil, completion: @escaping (NewsResponse) -> Void) {
        networkService.getNews(startFrom: startFrom, completion: completion)
        printLog(method: "getNews")
    }
    
    
    private func printLog(method: String){
        print("Proxy Log networkService method: " + method )
    }
}
