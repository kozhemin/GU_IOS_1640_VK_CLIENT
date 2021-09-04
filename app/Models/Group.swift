//
//  Group.swift
//  app
//
//  Created by Егор Кожемин on 24.08.2021.
//
import UIKit

struct Group: DefaultTableDataProtocol {
    var name: String
    var image: UIImage?
    var description: String?
    var isMain: Bool
}

extension Array where Element == Group {
    mutating func changeAttrIsMainByName(groupName: String, direction: Bool) -> Void {
        guard let index = self.firstIndex(where: {$0.name == groupName }) else {
            return
        }
        self[index].isMain = direction
    }
    
    func isMain(groupName: String) -> Bool {
        guard let index = self.firstIndex(where: {$0.name == groupName }) else {
            return false
        }
        return self[index].isMain
    }
}

var testGroupData: [Group] = [
    Group(
        name: "Группа1",
        image: UIImage(named: "grouop-1"),
        description: "Описание группы 1",
        isMain: true
    ),
    Group(
        name: "Группа2",
        image: UIImage(named: "grouop-2"),
        description: "Описание группы 2",
        isMain: false
    ),
    Group(
        name: "Группа3",
        image: UIImage(named: "grouop-3"),
        isMain: true
    ),
    Group(
        name: "Группа4",
        image: UIImage(named: "grouop-4"),
        isMain: false
    ),
    Group(
        name: "Группа5",
        image: UIImage(named: "grouop-5"),
        description: "Описание группы 5",
        isMain: true
    ),
]
