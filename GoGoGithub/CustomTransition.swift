//
//  CustomTransition.swift
//  GoGoGithub
//
//  Created by Cathy Oun on 4/5/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning { // have to be subclass of NSObject to conform to protocol
    
    var duration: TimeInterval
    
    init(duration: TimeInterval = 0.5) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0.0
        UIView.animate(withDuration: duration, animations: { 
            toViewController.view.alpha = 1.0
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
