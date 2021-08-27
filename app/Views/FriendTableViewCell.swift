//
//  FriendTableViewCell.swift
//  app
//
//  Created by Егор Кожемин on 27.08.2021.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var contentImage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
