//
//  PhotoSliderViewController.swift
//  app
//
//  Created by Егор Кожемин on 10.09.2021.
//

import Nuke
import UIKit

enum SwipeDirection {
    case left
    case right
}

final class PhotoSliderViewController: UIViewController {
    @IBOutlet var sliderArea: UIView!
    @IBOutlet var sliderIndicator: UIStackView!

    private var imageView: UIImageView?
    private var propertyAnimator: UIViewPropertyAnimator?
    private var images = [PhotoGallery]()
    private var indicatorImages = [UIImageView]()
    private var currentImageIndex: Int = 0 {
        didSet {
            changeImageLabel()
            changeSliderIndicator()
        }
    }

    private var imageLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // config view
        imageViewConfig()
        imageLabelViewConfig()
        indicatorViewConfig()

        let panGR = UIPanGestureRecognizer(
            target: self,
            action: #selector(swipePan(_:))
        )
        imageView?.addGestureRecognizer(panGR)

        presentDefaultImage()
    }

    func setImages(images: [PhotoGallery], indexAt: Int) {
        self.images = images
        setSliderIndicator()
        currentImageIndex = indexAt
    }

    private func setSliderIndicator() {
        for _ in images.enumerated() {
            let indicatorImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            indicatorImageView.image = UIImage(systemName: "circle.fill")
            indicatorImageView.tintColor = UIColor.systemBlue
            indicatorImages.append(indicatorImageView)
        }
    }

    private func presentDefaultImage() {
        guard let url = images[currentImageIndex].items.getImageByType(type: "x")?.photoUrl,
              let imageView = imageView
        else { return }

        Nuke.loadImage(
            with: url,
            into: imageView
        )

        changeImageLabel()
    }

    private func indicatorViewConfig() {
        guard indicatorImages.count > 1 else { return }
        for item in indicatorImages {
            sliderIndicator.addArrangedSubview(item)
        }
    }

    private func imageViewConfig() {
        imageView = UIImageView(frame: sliderArea.bounds)
        imageView?.contentMode = .scaleAspectFill
        imageView?.isUserInteractionEnabled = true

        guard let imageView = imageView
        else { return }

        sliderArea.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = imageView.topAnchor.constraint(equalTo: sliderArea.topAnchor)
        let leadingConstraint = imageView.leadingAnchor.constraint(equalTo: sliderArea.leadingAnchor)
        let trailingConstraint = imageView.trailingAnchor.constraint(equalTo: sliderArea.trailingAnchor)
        let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: sliderArea.bottomAnchor)
        sliderArea.addConstraints([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
    }

    private func imageLabelViewConfig() {
        imageLabel = UILabel()
        imageLabel?.adjustsFontSizeToFitWidth = true
        imageLabel?.backgroundColor = UIColor.lightGray
        imageLabel?.alpha = 0.8
        imageView?.addSubview(imageLabel ?? UILabel())
        imageLabel?.translatesAutoresizingMaskIntoConstraints = false

        guard let imageLabel = imageLabel,
              let imageView = imageView
        else { return }

        NSLayoutConstraint.activate([
            imageLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imageLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageLabel.heightAnchor.constraint(equalToConstant: 50),
            imageLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
    }

    private func changeImageLabel() {
        imageLabel?.text = images[currentImageIndex].description
    }

    private func changeSliderIndicator() {
        guard indicatorImages.count > 1 else { return }
        for item in indicatorImages {
            item.tintColor = UIColor.systemBlue
        }
        indicatorImages[currentImageIndex].tintColor = UIColor.red
    }

    @objc
    private func swipePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: sliderArea)
        switch gesture.state {
        case .began:
            propertyAnimator = UIViewPropertyAnimator(
                duration: 2,
                curve: .easeInOut,
                animations: {
                    self.imageView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.imageView?.alpha = 0.8
                }
            )
            propertyAnimator?.pauseAnimation()
        case .changed:
            propertyAnimator?.fractionComplete = abs(translation.x / 100)
        case .ended:
            propertyAnimator?.stopAnimation(true)
            propertyAnimator?.finishAnimation(at: .current)

            imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            imageView?.alpha = 1

            if abs(translation.x) > 50 {
                changeSlide(direction: translation.x > 0 ? SwipeDirection.left : SwipeDirection.right)
            }
        default:
            return
        }
    }

    private func changeSlide(direction: SwipeDirection) {
        var imageDirectionOffest: CGFloat = 1000
        var showImage = false

        switch direction {
        case .left:
            if currentImageIndex > 0 {
                currentImageIndex -= 1
                showImage = true
            }
            imageDirectionOffest *= -1
        case .right:
            if images.count - 1 > currentImageIndex {
                currentImageIndex += 1
                showImage = true
            }
        }

        if showImage {
            guard let url = images[currentImageIndex].items.getImageByType(type: "x")?.photoUrl,
                  let imageView = imageView
            else { return }

            Nuke.loadImage(
                with: url,
                into: imageView
            )

            // Hide off the screen
            imageView.center.x += imageDirectionOffest
            sliderArea.addSubview(imageView)

            UIView.animate(
                withDuration: 0.6,
                delay: 0.0,
                options: [.curveLinear, .transitionCrossDissolve]
            ) {
                self.imageView?.center.x += (imageDirectionOffest * -1)
            }
        }
    }
}
