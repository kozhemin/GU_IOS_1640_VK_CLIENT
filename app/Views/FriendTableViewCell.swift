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
    @IBOutlet var contentLikeImage: UIView!
    @IBOutlet var likeImage: UIImageView!

    private static var isLike: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        let gestureAvatar = UITapGestureRecognizer(target: self, action: #selector(tapAvatarImage(_:)))
        contentImage.addGestureRecognizer(gestureAvatar)

        // like image icon
        setImageState()

        let gestureLikeImage = UITapGestureRecognizer(target: self, action: #selector(tapLikeImage(_:)))
        contentLikeImage.addGestureRecognizer(gestureLikeImage)
    }

    @objc func tapAvatarImage(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }

        if gestureRecognizer.state == .ended {
            avatarImage.resizeAndSpringAnimate()
        }
    }

    @objc func tapLikeImage(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        FriendTableViewCell.isLike.toggle()
        UIView.transition(
            with: likeImage,
            duration: 0.8,
            options: [.transitionCrossDissolve, .curveEaseInOut],
            animations: {
                self.setImageState()
            }
        )
    }

    private func setImageState() {
        if FriendTableViewCell.isLike {
            likeImage.alpha = 1
            likeImage.tintColor = UIColor.red
            likeImage.image = UIImage(systemName: "heart.fill")
        } else {
            likeImage.image = UIImage(systemName: "heart.circle")
            likeImage.tintColor = UIColor.gray
            likeImage.alpha = 0.5
        }
    }
}
