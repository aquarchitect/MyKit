//
//  TransitionBasicAnimator.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/21/15.
//
//

final public class TransitionBasicAnimator: NSObject {

    // MARK: Property

    public private(set) var isPresenting = true
    public let presentedRect: CGRect

    public var dimming: (transparent: CGFloat, dismissal: Bool)?
    public var animating: (alpha: CGFloat, transform: CGAffineTransform) = (0, CGAffineTransformIdentity)

    // MARK: Initialization

    public init(centeredScreen size: CGSize) {
        let bounds = UIScreen.mainScreen().bounds

        let x = (bounds.width - size.width) / 2
        let y = (bounds.height - size.height) / 2

        self.presentedRect = CGRectMake(x, y, size.width, size.height)
        super.init()
    }

    public override init() {
        self.presentedRect = UIScreen.mainScreen().bounds
        super.init()
    }
}

extension TransitionBasicAnimator: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }

        isPresenting ? transitionContext.containerView()?.addSubview(toController.view) : ()

        let options: UIViewAnimationOptions = [.AllowUserInteraction, .BeginFromCurrentState, isPresenting ? .CurveEaseIn : .CurveEaseOut]
        let duration = transitionDuration(transitionContext)

        let controller = (isPresenting ? toController : fromController).then {
            $0.view.alpha = isPresenting ? animating.alpha : 1
            $0.view.transform = isPresenting ? animating.transform : CGAffineTransformIdentity
        }

        UIView.animateWithDuration(duration, delay: 0, options: options, animations: { [unowned self, unowned controller] in
            controller.view.then {
                $0.alpha = self.isPresenting ? 1 : self.animating.alpha
                $0.transform = self.isPresenting ? CGAffineTransformIdentity : self.animating.transform
            }
            }, completion: { [weak self, weak fromController, weak transitionContext] _ in
                if self?.isPresenting == false { fromController?.view.removeFromSuperview() }
                transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled() == true))
        })
    }
}

extension TransitionBasicAnimator: UIViewControllerTransitioningDelegate {

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
}