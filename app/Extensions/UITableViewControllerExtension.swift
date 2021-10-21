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
        var conf = cell.defaultContentConfiguration()
        conf.text = group.name
        conf.secondaryText = group.text

        if let photoUrl = group.photoUrl {
            // Nuke так и не завелось :-(
//            let imageView = UIImageView()
//            Nuke.loadImage(
//                with: photoUrl,
//                into: imageView)
//            conf.image = imageView.image

            let data = try? Data(contentsOf: photoUrl)
            if data != nil {
                conf.image = UIImage(data: data!)
            }
        }

        cell.contentConfiguration = conf
    }
}
