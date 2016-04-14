//
//  TransitionBasicAnimator.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/21/15.
//
//

final public class TransitionBasicAnimator: TransitionGenericAnimator {

    // MARK: Property

    public var animating: (alpha: CGFloat, transform: CGAffineTransform) = (0, CGAffineTransformIdentity)

    // MARK: Initialization

    public convenience init(centeredScreen size: CGSize) {
        let bounds = UIScreen.mainScreen().bounds

        let x = (bounds.width - size.width) / 2
        let y = (bounds.height - size.height) / 2

        let rect = CGRectMake(x, y, size.width, size.height)
        self.init(presentedRect: rect)
    }

    // MARK: System Method

    public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }

        if isPresenting { transitionContext.containerView()?.addSubview(toController.view) }

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