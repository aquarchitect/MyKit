//
//  TransitionDelegate.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/21/15.
//
//

@objc public protocol TransitionAnimation: class {

    optional func animateTransitionForPresenting(context: UIViewControllerContextTransitioning)
    optional func animateTransitionForDismissing(context: UIViewControllerContextTransitioning)

    optional func animateControllerSubviewsAlongsideTransitionForPresenting(controller: UIViewController)
    optional func animateControllerSubviewsAlongsideTransitionForDismissing(controller: UIViewController)
}

public class TransitionDelegate: UIPercentDrivenInteractiveTransition {

    public weak var dataSource: TransitionAnimation?

    public let presentedRect: CGRect
    public var interactionEnabled = false

    public var dimming: (transparent: CGFloat, dismissal: Bool) = (0.4, true)

    private(set) internal var isPresenting = true

    public init(presentedRect rect: CGRect) {
        self.presentedRect = rect
        super.init()
    }
}

extension TransitionDelegate: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresenting ? dataSource?.animateTransitionForPresenting?(transitionContext) : dataSource?.animateTransitionForPresenting?(transitionContext)
    }
}

extension TransitionDelegate: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let controller = PresentationController(contentFrame: presentedRect, presentedController: presented, presentingController: source)
        controller.alongsideAnimation = (dataSource?.animateControllerSubviewsAlongsideTransitionForPresenting, dataSource?.animateControllerSubviewsAlongsideTransitionForDismissing)
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

    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionEnabled ? self: nil
    }
}