//
//  UITableViewControllerExtension.swift
//  app
//
//  Created by Егор Кожемин on 24.08.2021.
//
import Nuke
import UIKit

extension UITableViewController {
    func configGroupCell(cell: inout UITableViewCell, for indexPath: IndexPath, item: [Group]) {
        var conf = cell.defaultContentConfiguration()
        let itemGroup = item[indexPath.row]
        conf.text = itemGroup.name
        conf.secondaryText = itemGroup.description

        if let photoUrl = itemGroup.photoUrl {
            // Nuke так и не завелось :-(
//            let imageView = UIImageView()
//            Nuke.loadImage(
//                with: photoUrl,
//                into: imageView)
//            conf.image = imageView.image

            let data = try? Data(contentsOf: photoUrl)
            conf.image = UIImage(data: data!)
        }

        cell.contentConfiguration = conf
    }
}
