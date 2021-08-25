//
//  UITableViewControllerExtension.swift
//  app
//
//  Created by Егор Кожемин on 24.08.2021.
//
import UIKit

extension UITableViewController {
    func configGroupCell(cell: inout UITableViewCell, for indexPath: IndexPath, item: [DefaultTableDataProtocol]) {
        var conf = cell.defaultContentConfiguration()
        conf.text = item[indexPath.row].name
        conf.secondaryText = item[indexPath.row].description
        conf.image = item[indexPath.row].image
        cell.contentConfiguration = conf
    }
}
