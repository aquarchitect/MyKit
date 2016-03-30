//
//  PresentationTransition.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/21/15.
//
//

public protocol PresentationAnimatedTransitionDataSource: class {

    func animateTransitionForPresenting(context: UIViewControllerContextTransitioning)
    func animateTransitionForDismissing(context: UIViewControllerContextTransitioning)
}

public class PresentationAnimatedTransition: UIPercentDrivenInteractiveTransition {

    public weak var dataSource: PresentationAnimatedTransitionDataSource?

    public let presentedContentRect: CGRect
    public var interactionEnabled = false

    public var dimming: (transparent: CGFloat, dismissal: Bool) = (0.4, true)

    internal private(set) var isPresenting = true

    public init(presentedContentRect rect: CGRect) {
        self.presentedContentRect = rect
        super.init()
    }

    public override convenience init() {
        let rect = UIScreen.mainScreen().bounds
        self.init(presentedContentRect: rect)
    }
}

extension PresentationAnimatedTransition: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        (isPresenting ? dataSource?.animateTransitionForPresenting : dataSource?.animateTransitionForPresenting)?(transitionContext)
    }
}

extension PresentationAnimatedTransition: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return PresentationViewController(presented: presented, presenting: source, contentRect: presentedContentRect).then {
            $0.managedView.then {
                $0.userInteractionEnabled = dimming.dismissal
                $0.backgroundColor = UIColor(white: 0, alpha: dimming.transparent)
            }
        }
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