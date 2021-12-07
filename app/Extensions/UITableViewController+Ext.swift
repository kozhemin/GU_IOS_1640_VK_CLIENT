//
//  UITableViewControllerExtension.swift
//  app
//
//  Created by Егор Кожемин on 24.08.2021.
//
import Nuke
import RealmSwift
import UIKit

extension UITableViewController {
    func configGroupCell(cell: inout UITableViewCell, group: RealmGroup) {
        cell.textLabel?.backgroundColor = .white
        cell.textLabel?.isOpaque = true

        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.text

        cell.imageView?.image = UIImage(named: "placeholder")
        cell.imageView?.lazyLoadingImage(link: group.photo, contentMode: .scaleAspectFit)
    }

    func configGroupCell(cell: inout UITableViewCell, group: Group) {
        cell.textLabel?.backgroundColor = .white
        cell.textLabel?.isOpaque = true

        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.description

        cell.imageView?.image = UIImage(named: "placeholder")
        cell.imageView?.lazyLoadingImage(link: group.photo, contentMode: .scaleAspectFit)
    }
}
