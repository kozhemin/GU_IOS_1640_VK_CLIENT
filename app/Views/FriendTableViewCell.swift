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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAvatarImage(_:)))
        self.contentImage.addGestureRecognizer(gesture)
    }
    
    @objc func tapAvatarImage(_ gestureRecognizer : UITapGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .ended {
            self.avatarImage.resizeAndSpringAnimate()
        }
    }
}
