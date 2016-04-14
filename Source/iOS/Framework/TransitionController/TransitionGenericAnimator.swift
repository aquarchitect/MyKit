//
//  TransitionGenericAnimator.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/21/15.
//
//

public protocol ModalTransitionDataSource: class {

    func presentingAnimationForTransition(context: UIViewControllerContextTransitioning)
    func dismissingAnimationForTransition(context: UIViewControllerContextTransitioning)
}

public class TransitionGenericAnimator: UIPercentDrivenInteractiveTransition {

    // MARK: Property

    public weak var dataSource: ModalTransitionDataSource?

    public var interactionEnabled = false
    public let presentedRect: CGRect
    private(set) var isPresenting = true

    public var dimming: (transparent: CGFloat, dismissal: Bool)?

    // MARK: Initialization

    public init(presentedRect rect: CGRect = UIScreen.mainScreen().bounds) {
        self.presentedRect = rect
    }
}

extension TransitionGenericAnimator: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        (isPresenting ? dataSource?.presentingAnimationForTransition : dataSource?.dismissingAnimationForTransition)?(transitionContext)
    }
}

extension TransitionGenericAnimator: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return TransitionPresentationController(presentedViewController: presented, presentingViewController: source).then {
            $0.presentedRect = presentedRect

            guard let (transparent, dismissal) = dimming else { return }
            $0.dimmedView = UIView().then {
                $0.alpha = 0
                $0.backgroundColor = UIColor(white: 0, alpha: transparent)
                $0.userInteractionEnabled = dismissal
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