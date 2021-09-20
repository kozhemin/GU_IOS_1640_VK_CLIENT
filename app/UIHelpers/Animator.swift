//
//  Animator.swift
//  app
//
//  Created by Егор Кожемин on 17.09.2021.
//

import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationTime = 0.8
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
//            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = transitionContext.containerView.frame
        
        transitionContext.containerView.bringSubviewToFront(destination.view)
         
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        let offsetFromMoveX: CGFloat = destination.view.bounds.width / 2
        let offsetFromMoveY: CGFloat = -destination.view.bounds.height / 2
        
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: offsetFromMoveX, y: offsetFromMoveY)
        t = t.rotated(by: presenting ? -.pi/2 : .pi/2)
        destination.view.transform = t
        
        UIView.animate(withDuration: animationTime) {
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: offsetFromMoveX, y: offsetFromMoveY)
            t = t.rotated(by: 0)
            destination.view.transform = t
        } completion: { isCompleted in
            transitionContext.completeTransition(isCompleted)
        }
    }
}
