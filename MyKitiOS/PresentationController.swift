//
//  PresentationController.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/17/15.
//
//

public class PresentationController: UIPresentationController {

    internal weak var alongside: TransitionAlongside?
    public let contentRect: CGRect

    public let dimView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    public init(presented: UIViewController, presenting: UIViewController, rect: CGRect) {
        self.contentRect = rect
        super.init(presentedViewController: presented, presentingViewController: presenting)

        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "handleTap:")
        dimView.addGestureRecognizer(tap)
    }

    public convenience init(presented: UIViewController, presenting: UIViewController) {
        let rect = UIScreen.mainScreen().bounds
        self.init(presented: presented, presenting: presenting, rect: rect)
    }

    public override func presentationTransitionWillBegin() {
        self.containerView?.insertSubview(dimView, atIndex: 0)
        animateDimView(1, completion: nil)

        let controller = self.presentingViewController
        controller.transitionCoordinator()?.animateAlongsideTransitionInView(controller.view, animation: { _ in self.alongside?.animateControllerSubviewsAlongsideTransitionForPresenting?(controller) }, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        animateDimView(0) { self.dimView.removeFromSuperview() }

        self.presentedViewController.view.endEditing(true)

        let controller = self.presentingViewController
        controller.transitionCoordinator()?.animateAlongsideTransitionInView(controller.view, animation: { _ in self.alongside?.animateControllerSubviewsAlongsideTransitionForDismissing?(controller) }, completion: nil)
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
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}