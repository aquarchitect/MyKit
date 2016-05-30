//
//  TransitionPresentationController.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/17/15.
//
//

public class TransitionPresentationController: UIPresentationController {

    public var presentedRect: CGRect = UIScreen.mainScreen().bounds
    public var dimmedView: UIView?

    public override func presentationTransitionWillBegin() {
        dimmedView?.then { self.containerView?.insertSubview($0, atIndex: 0) }

        UITapGestureRecognizer().then {
            $0.addTarget(self, action: #selector(handleTap))
            dimmedView?.addGestureRecognizer($0)
        }

        animateDimView(1, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        self.presentedView()?.endEditing(true)
        animateDimView(0) { [weak dimmedView] in dimmedView?.removeFromSuperview() }
    }

    private func animateDimView(alpha: CGFloat, completion: (Void -> Void)?) {
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.dimmedView?.alpha = alpha }, completion: { _ in completion?() })
    }

    public override func frameOfPresentedViewInContainerView() -> CGRect {
        return presentedRect
    }

    public override func containerViewDidLayoutSubviews() {
        dimmedView?.frame = self.containerView?.bounds ?? .zero
    }

    func handleTap(sender: UITapGestureRecognizer) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}