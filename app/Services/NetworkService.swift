//
//  NetworkService.swift
//  app
//
//  Created by Егор Кожемин on 02.10.2021.
//
import UIKit

class NetworkService: NetworkServiceProtocol {
    private let session = URLSession.shared
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()

    // MARK: Получение списка друзей

    func getFriends(completion: @escaping ([Friend]) -> Void) {
        guard let url = prepareUrl(
            methodName: "friends.get",
            params: [URLQueryItem(name: "fields", value: "photo_100, nickname, domain, sex, bdate, city, country")]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let friendList = try JSONDecoder()
                    .decode(VKResponse<FriendItems>.self, from: resp)
                completion(friendList.response.items)
            } catch {
                print("getFriends: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    // MARK: Получение фотографий человека

    func getPhotos(ownerId: Int,
                   completion: @escaping ([PhotoGallery]) -> Void)
    {
        guard let url = prepareUrl(
            methodName: "photos.getAll",
            params: [URLQueryItem(name: "owner_id", value: String(ownerId))]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let photoList = try JSONDecoder()
                    .decode(VKResponse<PhotoGalleryItems>.self, from: resp)
                completion(photoList.response.items)
            } catch {
                print("getPhotos: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    // MARK: Получение групп текущего пользователя

    func getGroups(completion: @escaping ([Group]) -> Void) {
        guard let url = prepareUrl(
            methodName: "groups.get",
            params: [
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "fields", value: "description"),
            ]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let groupList = try JSONDecoder()
                    .decode(VKResponse<GroupItems>.self, from: resp)
                completion(groupList.response.items)
            } catch {
                print("getGroups: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    // MARK: Получение групп по поисковому запросу

    func searchGroups(query: String,
                      completion: @escaping ([Group]) -> Void)
    {
        guard let url = prepareUrl(
            methodName: "groups.search",
            params: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "count", value: "30"),
                URLQueryItem(name: "fields", value: "description"),
            ]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let groupList = try JSONDecoder()
                    .decode(VKResponse<GroupItems>.self, from: resp)
                completion(groupList.response.items)
            } catch {
                print("searchGroups: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    // MARK: вступить в группу

    func joinToGroup(groupId: Int,
                     completion: @escaping (Int) -> Void)
    {
        guard let url = prepareUrl(
            methodName: "groups.join",
            params: [
                URLQueryItem(name: "group_id", value: String(groupId)),
            ]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let vkResp = try JSONDecoder()
                    .decode(VKResponse<Int>.self, from: resp)
                completion(vkResp.response)
            } catch {
                print("joinToGroup: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    // MARK: покинуть сообщество

    func leaveGroup(groupId: Int,
                    completion: @escaping (Int) -> Void)
    {
        guard let url = prepareUrl(
            methodName: "groups.leave",
            params: [
                URLQueryItem(name: "group_id", value: String(groupId)),
            ]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let vkResp = try JSONDecoder()
                    .decode(VKResponse<Int>.self, from: resp)
                completion(vkResp.response)
            } catch {
                print("leaveGroup: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    // MARK: Получение новостей

    func getNews(startFrom: String? = nil, completion: @escaping (NewsResponse) -> Void) {
        var params = [
            URLQueryItem(name: "count", value: "5"),
            URLQueryItem(name: "filters", value: "post,photo,note"),
            URLQueryItem(name: "fields", value: "first_name,last_name,photo_100,photo_50,description"),
            URLQueryItem(name: "start_time", value: "\(NSDate().timeIntervalSince1970 + 1)"),
        ]

        if startFrom != nil {
            params.append(URLQueryItem(name: "start_from", value: startFrom))
        }
        guard let url = prepareUrl(
            methodName: "newsfeed.get",
            params: params
        )
        else { return }

        let dispGroup = DispatchGroup()
        var newsList = NewsItems(items: [NewsPost]())
        var newsProfile = NewsProfiles(profiles: [Friend]())
        var newsGroup = NewsGroups(groups: [Group]())
        var nextFrom = ""

        vkRequest(url: url) { resp in
            DispatchQueue.global().async(group: dispGroup) {
                do {
                    newsList = try JSONDecoder()
                        .decode(VKResponse<NewsItems>.self, from: resp).response

                    newsProfile = try JSONDecoder()
                        .decode(VKResponse<NewsProfiles>.self, from: resp).response

                    newsGroup = try JSONDecoder()
                        .decode(VKResponse<NewsGroups>.self, from: resp).response

                    nextFrom = try JSONDecoder()
                        .decode(VKResponse<NewsNextFrom>.self, from: resp).response.nextFrom

                } catch {
                    print("getNews: Что-то пошло не так c JSONDecoder!", error.localizedDescription)
                }
            }

            dispGroup.notify(queue: .main) {
                completion(NewsResponse(
                    newsItems: newsList,
                    groupItems: newsGroup,
                    profileItems: newsProfile,
                    nextFrom: nextFrom
                ))
            }
        }
    }

    private func prepareUrl(methodName: String, params: [URLQueryItem]?) -> URL? {
        urlConstructor.path = "/method/" + methodName
        urlConstructor.queryItems = [
            URLQueryItem(
                name: "user_ids",
                value: String(AuthData.share.userId)
            ),
            URLQueryItem(
                name: "access_token",
                value: AuthData.share.token
            ),
            URLQueryItem(
                name: "v",
                value: "5.131"
            ),
        ]

        if let p = params {
            for itemParam in p {
                urlConstructor.queryItems?.append(itemParam)
            }
        }

        return urlConstructor.url
    }

    private func vkRequest(url: URL, completion: @escaping (Data) -> Void) {
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

            // debug
//            let json = try? JSONSerialization.jsonObject(
//                with: responseData,
//                options: .fragmentsAllowed)
//                print(json)

            do {
                DispatchQueue.main.async {
                    completion(responseData)
                }
            } catch {
                print("Ошибка при получении ответа: \(error)")
            }
        }
        .resume()
    }
}
