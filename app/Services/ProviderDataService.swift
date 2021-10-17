//
//  ProviderDataService.swift
//  app
//
//  Created by Егор Кожемин on 16.10.2021.
//
import Foundation
import RealmSwift

class ProviderDataService {
    let networkService = NetworkService()
    let syncTimeout = 60.0

    func loadFriends(forceReload: Bool = false, completion: @escaping ([Friend]) -> Void) {
        let realmFriend = try? RealmService.load(typeOf: RealmFriend.self)
        if checkSync(forKey: "friend") || forceReload {
            networkService.getFriends { resp in
                do {
                    let friendResult = resp.map { RealmFriend(friend: $0) }
                        .filter { item in
                            if realmFriend?.contains(where: { $0.userId == item.userId }) ?? true {
                                return false
                            }
                            return true
                        }
                    completion(resp)
                    try RealmService.save(items: friendResult)

                } catch {
                    print("error RealmFriend: ", error)
                }
            }
        } else {
            guard let friendResult = realmFriend else { return }
            var result = [Friend]()
            for friendItem in friendResult {
                result.append(Friend(
                    id: friendItem.userId,
                    firstName: friendItem.firstName,
                    lastName: friendItem.lastName,
                    nickName: friendItem.nickName,
                    photo: friendItem.photo,
                    domain: friendItem.domain,
                    sex: friendItem.sex
                ))
            }
            completion(result)
        }
    }

    func loadGroups(forceReload: Bool = false, completion: @escaping ([Group]) -> Void) {
        let realmGroup = try? RealmService.load(typeOf: RealmGroup.self)
        if checkSync(forKey: "group") || forceReload {
            networkService.getGroups { resp in
                do {
                    let groupResult = resp.map { RealmGroup(group: $0) }
                        .filter { item in
                            if realmGroup?.contains(where: { $0.groupId == item.groupId }) ?? true {
                                return false
                            }
                            return true
                        }
                    completion(resp)
                    try RealmService.save(items: groupResult)

                } catch {
                    print("error RealmGroup: ", error)
                }
            }
        } else {
            guard let groupResult = realmGroup else { return }
            var result = [Group]()
            for groupItem in groupResult {
                result.append(Group(
                    id: groupItem.groupId,
                    name: groupItem.name,
                    screenName: groupItem.screenName,
                    photo: groupItem.photo,
                    description: groupItem.text
                ))
            }
            completion(result)
        }
    }

    func leaveGroup(group: Group, completion: @escaping (Bool) -> Void) {
        networkService.leaveGroup(
            groupId: Int(group.id)
        ) { codeResp in
            if codeResp == 1 {
                let objectsToDelete = try? RealmService.load(typeOf: RealmGroup.self)
                    .filter("groupId = %f", group.id)
                guard let item = objectsToDelete else { return }
                try? RealmService.delete(object: item)
            }
            completion(true)
        }
    }

    func joinToGroup(group: Group) {
        networkService.joinToGroup(
            groupId: Int(group.id)
        ) { codeResp in
            if codeResp == 1 {
                self.loadGroups(forceReload: true, completion: { _ in })
            }
        }
    }

    func loadPhoto(forceReload: Bool = false, ownerId: Int, completion: @escaping ([PhotoGallery]) -> Void) {
        let realmPhotoGallery = try? RealmService.load(typeOf: RealmPhotoGallery.self)
            .filter("ownerId = %f", ownerId)

        if checkSync(forKey: "photo_\(ownerId)") || forceReload {
            networkService.getPhotos(ownerId: ownerId) { resp in
                do {
                    let galleryResult = resp.map { RealmPhotoGallery(gallery: $0) }
                        .filter { item in
                            if realmPhotoGallery?.contains(where: { $0.galleryId == item.galleryId }) ?? true {
                                return false
                            }
                            return true
                        }
                    completion(resp)
                    try RealmService.save(items: galleryResult)

                } catch {
                    print("error RealmPhotoGallery: ", error)
                }
            }
        } else {
            guard let galleryResult = realmPhotoGallery else { return }
            var result = [PhotoGallery]()
            for galleryItem in galleryResult {
                var imageItems = [ImageItem]()

                // fetch images
                for item in galleryItem.images {
                    imageItems.append(ImageItem(
                        type: item.key,
                        url: item.value
                    ))
                }

                result.append(PhotoGallery(
                    id: galleryItem.galleryId,
                    albumId: galleryItem.albumId,
                    ownerId: galleryItem.ownerId,
                    text: galleryItem.text,
                    items: imageItems
                ))
            }
            completion(result)
        }
    }

    private func checkSync(forKey: String) -> Bool {
        let timestamp = NSDate().timeIntervalSince1970
        let lastSync = UserDefaults.standard.double(forKey: forKey)
        if !(lastSync < (timestamp - syncTimeout)) {
            return false
        }
        UserDefaults.standard.set(timestamp, forKey: forKey)
        return true
    }
}
