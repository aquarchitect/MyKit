//
//  PresentationTransition.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/7/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class PresentationTransition: UIPercentDrivenInteractiveTransition {

    public enum Style {

        case Custom(CGRect)
        case Center(CGSize)
    }

    public var interactionEnabled = false
    public var dimDismissalEnabled = false

    public var dismissedAlpha: CGFloat = 1
    public var dismissedTransform: CGAffineTransform?

    private var isPresenting = true
    private let contentStyle: Style

    public init(contentStyle: Style) {
        self.contentStyle = contentStyle
        super.init()
    }
}

extension PresentationTransition: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        let containerView = transitionContext.containerView()
        if isPresenting { containerView!.addSubview(toController.view) }

        // identify controller view that will be animating
        let controller = isPresenting ? toController : fromController
        let transform = dismissedTransform ?? CGAffineTransformIdentity
        let duration = transitionDuration(transitionContext)

        controller.view.alpha = isPresenting ? (dismissedAlpha ?? 1) : 1
        controller.view.transform = isPresenting ? transform : CGAffineTransformIdentity

        UIView.animateWithDuration(duration, delay: 0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
            controller.view.alpha = self.isPresenting ? 1 : (self.dismissedAlpha ?? 1)
            controller.view.transform = self.isPresenting ? CGAffineTransformIdentity : transform
            }, completion: { _ in
                if !self.isPresenting { fromController.view.removeFromSuperview() }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}

extension PresentationTransition: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentedRect: CGRect

        switch contentStyle {

        case .Custom(let rect):
            presentedRect = rect

        case .Center(let size):
            let presentingSize = source.view.bounds.size

            let presentingOriginX = (presentingSize.width - size.width) / 2
            let presentingOriginY = (presentingSize.height - size.height) / 2

            let presentedOrigin = CGPoint(x: presentingOriginX, y: presentingOriginY)
            presentedRect = CGRect(origin: presentedOrigin, size: size)
        }

        let controller = PresentationController(contentFrame: presentedRect, presentedViewController: presented, presentingViewController: source)
        controller.dimDismissalEnabled = dimDismissalEnabled
        return controller
    }

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }

    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionEnabled ? self : nil
    }
}