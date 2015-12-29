//
//  PresentationController.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/17/15.
//
//

public class PresentationController: UIPresentationController {

    typealias ControllerBlock = UIViewController -> Void
    internal var alongsideAnimation: (presenting: ControllerBlock?, dismissing: ControllerBlock?)

    public let contentRect: CGRect

    public let dimView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    public init(contentFrame: CGRect, presentedController: UIViewController, presentingController: UIViewController) {
        self.contentRect = contentFrame
        super.init(presentedViewController: presentedController, presentingViewController: presentingController)

        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "handleTap:")
        dimView.addGestureRecognizer(tap)
    }

    public override func presentationTransitionWillBegin() {
        self.containerView?.insertSubview(dimView, atIndex: 0)
        animateDimView(1, completion: nil)

        let controller = self.presentingViewController
        controller.transitionCoordinator()?.animateAlongsideTransitionInView(controller.view, animation: { _ in self.alongsideAnimation.presenting?(controller) }, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        animateDimView(0) { self.dimView.removeFromSuperview() }

        let controller = self.presentingViewController
        controller.transitionCoordinator()?.animateAlongsideTransitionInView(controller.view, animation: { _ in self.alongsideAnimation.dismissing?(controller) }, completion: nil)
    }

    private func animateDimView(alpha: CGFloat, completion: (Void -> Void)?) {
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.dimView.alpha = alpha }, completion: { _ in completion?() })
    }

    public override func containerViewWillLayoutSubviews() {
        self.presentedView()!.frame = contentRect
    }

    public override func containerViewDidLayoutSubviews() {
        dimView.frame = self.containerView?.bounds ?? .zero
    }

    func handleTap(sender: UITapGestureRecognizer) {
        let controller = self.presentingViewController
        controller.view.endEditing(true)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}