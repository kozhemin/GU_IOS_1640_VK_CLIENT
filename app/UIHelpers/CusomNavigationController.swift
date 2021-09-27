//
//  CusomNavigationController.swift
//  app
//
//  Created by Егор Кожемин on 22.09.2021.
//

import UIKit

final class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    var isStart = false
    var isFinish = false
}

class CusomNavigationController: UINavigationController {
    private let interactiveTransition = InteractiveTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        let edgePanGR = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:))
        )
        edgePanGR.edges = .left
        view.addGestureRecognizer(edgePanGR)
    }

    @objc
    private func handlePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveTransition.isStart = true
            popViewController(animated: true)

        case .changed:
            guard let width = recognizer.view?.bounds.width else {
                interactiveTransition.isStart = false
                interactiveTransition.cancel()
                return
            }

            let translation = recognizer.translation(in: view)
            let relativeTranslation = translation.x / width
            let progress = max(0, min(relativeTranslation, 1))
            interactiveTransition.update(progress)
            interactiveTransition.isFinish = progress > 0.35

        case .ended:
            interactiveTransition.isStart = false
            interactiveTransition.isFinish ? interactiveTransition.finish() : interactiveTransition.cancel()

        case
            .failed,
            .cancelled:
            interactiveTransition.isStart = false
            interactiveTransition.cancel()

        default: break
        }
    }
}

extension CusomNavigationController: UINavigationControllerDelegate {
    // MARK: NavigationController Delegate

    func navigationController(
        _: UINavigationController,
        animationControllerFor _: UINavigationController.Operation,
        from _: UIViewController,
        to _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func navigationController(
        _: UINavigationController,
        interactionControllerFor _: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition.isStart ? interactiveTransition : nil
    }
}

// MARK: Навигация экрану друзей

class FriendNavigationContoller: CusomNavigationController {
    override func navigationController(
        _: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from _: UIViewController,
        to _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let pushAnimatior = PushAnimation()
        let popAnimator = PopAnimation()
        switch operation {
        case .push:
            return pushAnimatior
        case .pop:
            return popAnimator
        default:
            return nil
        }
    }
}

// MARK: Навигация экрана групп

class GroupNavigationContoller: CusomNavigationController {
    override func navigationController(
        _: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from _: UIViewController,
        to _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let animator = Animator()
        switch operation {
        case .push:
            animator.presenting = true
            return animator
        case .pop:
            animator.presenting = false
            return animator
        default:
            return nil
        }
    }
}
