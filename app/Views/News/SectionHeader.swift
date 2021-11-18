//
//  SectionHeader.swift
//  app
//
//  Created by Егор Кожемин on 10.11.2021.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var datePostLabel: UILabel!

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
