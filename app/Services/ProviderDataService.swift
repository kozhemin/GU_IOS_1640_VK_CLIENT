//
//  ProviderDataService.swift
//  app
//
//  Created by Егор Кожемин on 16.10.2021.
//
import Foundation
import PromiseKit
import RealmSwift

class ProviderDataService {
    let networkService = NetworkService()
    let syncTimeout = 60.0

    // MARK: Синхронизация друзей

    func loadFriends() {
        /*
         Example promise usage:
         ---------------------
         firstly{
             Promise.value("Hello world")
         }.then { str -> Promise<String> in
             print(str)
             return Promise.value("Hello world2")
         }.then { str2 ->Promise<Bool> in
             print(str2)
             return Promise.value(true)
         }.ensure {
             print("something that should happen whatever the outcome")
         }.done { ret in
              print("DONE: " , ret)
         }.catch {
             print("Error \($0)")
         }
         */

        if checkSync(forKey: "friend") {
            let promiseData = FetchDataFriendPromise()
            promiseData.getFriends()
                .done { resp in
                    let realmFriend = try? RealmService.load(typeOf: RealmFriend.self)
                    let friendResult = resp.map { RealmFriend(friend: $0) }
                        .filter { item in
                            if realmFriend?.contains(where: { $0.userId == item.userId }) ?? true {
                                return false
                            }
                            return true
                        }

                    try RealmService.save(items: friendResult)

                }.catch { error in
                    print("error RealmFriend: ", error.localizedDescription)
                }
        }
    }

    // MARK: Синхронизация групп

    func loadGroups() {
        if checkSync(forKey: "group") {
            let realmGroup = try? RealmService.load(typeOf: RealmGroup.self)
            let operationQ = OperationQueue()
            operationQ.maxConcurrentOperationCount = 10

            let fetchOperation = FetchDataGroupOperation()
            let parseOperation = ParseDataGroupOperation()
            let saveOperation = SaveDataGroupOperation(realmGroup: realmGroup)

            parseOperation.addDependency(fetchOperation)
            saveOperation.addDependency(parseOperation)

            operationQ.addOperation(fetchOperation)
            operationQ.addOperation(parseOperation)
            operationQ.addOperation(saveOperation)

            saveOperation.completionBlock = {
                print("Save group success! Status: \(saveOperation.state)")
            }
        }
    }

    // MARK: Удаление группы

    func leaveGroup(group: RealmGroup) {
        networkService.leaveGroup(
            groupId: Int(group.groupId)
        ) { codeResp in
            if codeResp == 1 {
                let objectsToDelete = try? RealmService.load(typeOf: RealmGroup.self)
                    .filter("groupId = %f", group.groupId)

                guard let item = objectsToDelete else { return }
                try? RealmService.delete(object: item)
            }
        }
    }

    // MARK: Добавление в группу

    func joinToGroup(group: Group) {
        networkService.joinToGroup(groupId: Int(group.id)) { codeResp in
            if codeResp == 1 {
                try? RealmService.save(items: [RealmGroup(group: group)])
            }
        }
    }

    // MARK: Синхронизация фотографий

    func loadPhoto(ownerId: Int) {
        if checkSync(forKey: "photo_\(ownerId)") {
            let realmPhotoGallery = try? RealmService.load(typeOf: RealmPhotoGallery.self)
                .filter("ownerId = %f", ownerId)

            networkService.getPhotos(ownerId: ownerId) { resp in
                do {
                    let galleryResult = resp.map { RealmPhotoGallery(gallery: $0) }
                        .filter { item in
                            if realmPhotoGallery?.contains(where: { $0.galleryId == item.galleryId }) ?? true {
                                return false
                            }
                            return true
                        }
                    try RealmService.save(items: galleryResult)
                } catch {
                    print("error RealmPhotoGallery: ", error)
                }
            }
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
