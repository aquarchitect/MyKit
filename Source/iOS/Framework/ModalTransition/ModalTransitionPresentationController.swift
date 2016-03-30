//
//  ModalTransitionPresentationController.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/17/15.
//
//

public class ModalTransitionPresentationController: UIPresentationController {

    public let presentedContentRect: CGRect
    internal let managedView = UIView().then{ $0.alpha = 0 }

    public init(presented: UIViewController, presenting: UIViewController, contentRect: CGRect) {
        self.presentedContentRect = contentRect
        super.init(presentedViewController: presented, presentingViewController: presenting)

        UITapGestureRecognizer().then {
            $0.addTarget(self, action: #selector(handleTap(_:)))
            managedView.addGestureRecognizer($0)
        }
    }

    public convenience init(presented: UIViewController, presenting: UIViewController) {
        let rect = UIScreen.mainScreen().bounds
        self.init(presented: presented, presenting: presenting, contentRect: rect)
    }

    public override func presentationTransitionWillBegin() {
        self.containerView?.insertSubview(managedView, atIndex: 0)
        animateDimView(1, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        self.presentedView()?.endEditing(true)
        animateDimView(0) { [weak managedView] in managedView?.removeFromSuperview() }
    }

    private func animateDimView(alpha: CGFloat, completion: (Void -> Void)?) {
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.managedView.alpha = alpha }, completion: { _ in completion?() })
    }

    public override func containerViewWillLayoutSubviews() {
        self.presentedView()?.frame = presentedContentRect
    }

    public override func containerViewDidLayoutSubviews() {
        managedView.frame = self.containerView?.bounds ?? .zero
    }

    func handleTap(sender: UITapGestureRecognizer) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}