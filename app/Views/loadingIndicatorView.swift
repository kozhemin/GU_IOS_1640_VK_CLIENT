//
//  loadingIndicatorView.swift
//  app
//
//  Created by Егор Кожемин on 06.09.2021.
//

import UIKit

class loadingIndicatorView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var c1: UIImageView!
    @IBOutlet var c2: UIImageView!
    @IBOutlet var c3: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        let nib = UINib(nibName: "loadingIndicatorView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        defaultConfigCrcle()
        addSubview(contentView)
    }

    private func defaultConfigCrcle() {
        c1.tintColor = UIColor.random
        c2.tintColor = UIColor.random
        c3.tintColor = UIColor.random
    }

    func indicatorAnimation() {
        let options: UIView.AnimationOptions = [
            .curveEaseInOut,
            .repeat,
            .autoreverse,
        ]

        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: options,
                       animations: { [weak self] in
                           self!.c1.alpha = 0
                       }, completion: nil)

        UIView.animate(withDuration: 1,
                       delay: 0.5,
                       options: options,
                       animations: { [weak self] in
                           self!.c2.alpha = 0
                       }, completion: nil)

        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: options,
                       animations: { [weak self] in
                           self!.c3.alpha = 0
                       }, completion: nil)
    }
}
