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

    public let contentStyle: Style
    public var interactionEnabled = false

    public var dimming: (transparent: CGFloat, dismissal: Bool) = (0.4, true)
    public var animating: (alpha: CGFloat, transform: CGAffineTransform) = (1, CGAffineTransformIdentity)

    private var isPresenting = true

    public init(contentStyle: Style) {
        self.contentStyle = contentStyle
        super.init()
    }
}

extension PresentationTransition: UIViewControllerAnimatedTransitioning {

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
        let duration = transitionDuration(transitionContext)

        controller.view.alpha = isPresenting ? animating.alpha : 1
        controller.view.transform = isPresenting ? animating.transform : CGAffineTransformIdentity

        UIView.animateWithDuration(duration, delay: 0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
            controller.view.alpha = self.isPresenting ? 1 : self.animating.alpha
            controller.view.transform = self.isPresenting ? CGAffineTransformIdentity : self.animating.transform
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

        let controller = PresentationController(contentFrame: presentedRect, presentedController: presented, presentingController: source)
        controller.dimView.userInteractionEnabled = dimming.dismissal
        controller.dimView.backgroundColor = UIColor(white: 0, alpha: dimming.transparent)
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