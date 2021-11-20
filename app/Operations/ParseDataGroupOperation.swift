//
//  ParseDataGroupOperation.swift
//  app
//
//  Created by Егор Кожемин on 20.11.2021.
//

import Foundation

final class ParseDataGroupOperation: AsyncOperation {
    var groupDataResponce: VKResponse<GroupItems>?

    override func main() {
        guard
            !isCancelled,
            let fetchOperation = dependencies.first as? FetchDataGroupOperation,
            let responceData = fetchOperation.jsonGroupDataResponce
        else {
            state = .finished
            return
        }

        do {
            groupDataResponce = try JSONDecoder()
                .decode(VKResponse<GroupItems>.self, from: responceData)
            state = .finished
        } catch {
            print("Что-то пошло не так c JSONDecoder!: ", error.localizedDescription)
        }
    }
}
