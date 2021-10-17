//
//  PhotoSliderViewController.swift
//  app
//
//  Created by Егор Кожемин on 10.09.2021.
//

import Nuke
import UIKit

enum PhotoSwipe {
    case left
    case right
}

final class PhotoSliderViewController: UIViewController {
    @IBOutlet var sliderArea: UIView!

    private lazy var sourseView = UIImageView()
    private lazy var targetView = UIImageView()

    private var currentImageIndex: Int = 0
    private var images = [PhotoGallery]()
    private let animateTime = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(respondToSwipeGesture)
        )
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(
            target: self,
            action: #selector(respondToSwipeGesture)
        )
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        // img congfig
        targetView = UIImageView(frame: sliderArea.frame)
        sourseView = UIImageView(frame: sliderArea.frame)

        sourseView.contentMode = .scaleAspectFill
        targetView.contentMode = .scaleAspectFill

        sliderArea.addSubview(targetView)
        sliderArea.addSubview(sourseView)

        showSlide(direction: nil)
    }

    func setImages(images: [PhotoGallery], indexAt: Int) {
        self.images = images
        currentImageIndex = indexAt
    }

    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                showSlide(direction: PhotoSwipe.right)
            case .left:
                showSlide(direction: PhotoSwipe.left)
            default:
                break
            }
        }
    }

    private func showSlide(direction: PhotoSwipe?) {
        var translationSourseX: CGFloat = 0
        var translationTargetX: CGFloat = 0
        let oldCurrentImageIndex = currentImageIndex

        if direction != nil {
            var targetImageIndex: Int
            switch direction! {
            case .right:
                translationSourseX = 1000.0
                translationTargetX = -targetView.bounds.width
                targetImageIndex = getNextImageIndex(direction: .right)
            case .left:
                translationSourseX = -1000.0
                translationTargetX = targetView.bounds.width
                targetImageIndex = getNextImageIndex(direction: .left)
            }

            if targetImageIndex == oldCurrentImageIndex {
                return
            }

            guard let url = images[targetImageIndex].items.getImageByType(type: "x")?.photoUrl
            else { return }

            Nuke.loadImage(
                with: url,
                into: targetView
            )

            UIView.animateKeyframes(
                withDuration: animateTime,
                delay: 0.0,
                options: .calculationModePaced
            ) {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.75
                ) {
                    let translation = CGAffineTransform(
                        translationX: translationSourseX,
                        y: 0.0
                    )
                    let scale = CGAffineTransform(
                        scaleX: 0.5,
                        y: 0.5
                    )
                    self.sourseView.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4) {
                    let translation = CGAffineTransform(
                        translationX: translationTargetX,
                        y: 0.0
                    )
                    let scale = CGAffineTransform(
                        scaleX: 0.8,
                        y: 1.2
                    )
                    self.targetView.transform = translation.concatenating(scale)
                }

                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                    self.targetView.transform = .identity
                }
            }
            completion: { isCompleted in
                if isCompleted {
                    self.sourseView.image = self.targetView.image
                    self.sourseView.transform = .identity
                }
            }

        } else {
            guard let url = images[getNextImageIndex(direction: direction)]
                .items.getImageByType(type: "x")?.photoUrl
            else { return }

            Nuke.loadImage(
                with: url,
                into: sourseView
            )
        }
    }

    // MARK: Определяем индекс изображения

    private func getNextImageIndex(direction: PhotoSwipe?) -> Int {
        guard direction != nil else { return currentImageIndex }
        switch direction {
        case .right:
            if currentImageIndex > 0 {
                currentImageIndex -= 1
            }
        case .left:
            if images.count - 1 > currentImageIndex {
                currentImageIndex += 1
            }
        default:
            break
        }
        return currentImageIndex
    }
}
