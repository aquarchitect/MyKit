//
//  PresentationTransition.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/7/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class PresentationTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    private class Controller: UIPresentationController {

        var presentedRect: CGRect

        lazy var dimView: UIView = {
            let view = UIView(frame: self.containerView!.bounds)
            view.alpha = 0
            view.backgroundColor = UIColor(white: 0, alpha: 0.8)
            self.containerView!.insertSubview(view, atIndex: 0)

            let tap = UITapGestureRecognizer(target: self, action: "tapHandle:")
            view.addGestureRecognizer(tap)

            return view
            }()

        init(presentedRect: CGRect, presentedController: UIViewController, presentingController: UIViewController) {
            self.presentedRect = presentedRect

            super.init(presentedViewController: presentedController, presentingViewController: presentingController)
        }

        override func presentationTransitionWillBegin() {
            self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.dimView.alpha = 1 }, completion: nil)
        }

        override func dismissalTransitionWillBegin() {
            self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.dimView.alpha = 0 }, completion: nil)
        }

        override func containerViewWillLayoutSubviews() {
            self.presentedView()!.frame = presentedRect
        }

        func tapHandle(sender: UITapGestureRecognizer) {
            let controller = self.presentingViewController
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: Property

    public var presentedRect: CGRect!
    public var interactionEnabled = false
    public var dismissedTransform: CGAffineTransform?
    private var isPresenting = true

    // MARK: Transition Delegate

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        let containerView = transitionContext.containerView()
        if isPresenting { containerView!.addSubview(toController.view) }

        // identify controller view that will be animating
        let controller = isPresenting ? toController : fromController

        if let transform = dismissedTransform {
            let duration = transitionDuration(transitionContext)

            controller.view.transform = isPresenting ? transform : CGAffineTransformIdentity
            UIView.animateWithDuration(duration, delay: 0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
                controller.view.transform = self.isPresenting ? CGAffineTransformIdentity : transform
                }, completion: { _ in
                    if !self.isPresenting { fromController.view.removeFromSuperview() }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }

    // MARK: Presentation Controller

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {

        return Controller(presentedRect: presentedRect, presentedController: presented, presentingController: presenting)
    }

    // MARK: Animated Transition

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }

    // MARK: Interacted Transition

    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionEnabled ? self : nil
    }
}