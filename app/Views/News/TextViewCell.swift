//
//  TextViewCell.swift
//  app
//
//  Created by Егор Кожемин on 10.11.2021.
//

import UIKit

class TextViewCell: UITableViewCell {
    @IBOutlet var postTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
