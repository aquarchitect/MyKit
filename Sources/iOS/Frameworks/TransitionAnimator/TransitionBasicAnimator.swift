/*
 * TransitionBasicAnimator.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

/**
 * `TransitionBasicAnimator` simplify a basic transition between view controllers.
 * When the device rotates, `viewWillTransitionToSize` gives you an opportunity 
 * to correct presented view frame.
 */
final public class TransitionBasicAnimator: NSObject {

    // MARK: Property

    internal private(set) var isPresenting = true
    public let presentedRect: CGRect

    public var animations: ((presentedView: UIView, isPresenting: Bool) -> Void)?

    // MARK: Initialization

    public init(centeredScreen size: CGSize) {
        let bounds = UIScreen.mainScreen().bounds
        self.presentedRect = CGRect(center: bounds.center, size: size)
        super.init()
    }
}

extension TransitionBasicAnimator: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }

        isPresenting ? transitionContext.containerView().addSubview(toController.view) : ()

        let options: UIViewAnimationOptions = [.AllowUserInteraction, .BeginFromCurrentState, isPresenting ? .CurveEaseIn : .CurveEaseOut]
        let duration = transitionDuration(transitionContext)

        UIView.animateWithDuration(duration, delay: 0, options: options, animations: {
            [unowned self] in
            let controller = self.isPresenting ? toController : fromController
            self.animations?(presentedView: controller.view, isPresenting: self.isPresenting)
            }, completion: { [weak self, weak fromController, weak transitionContext] _ in
                if self?.isPresenting == false { fromController?.view.removeFromSuperview() }
                transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled() == true))
        })
    }
}

extension TransitionBasicAnimator: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        guard presentedRect != UIScreen.mainScreen().bounds else { return nil }

        return TransitionPresentationController(presentedViewController: presented, presentingViewController: source).then {
            $0.presentedRect = presentedRect
            $0.backgroundColor = UIColor(white: 0, alpha: 0.7)
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
