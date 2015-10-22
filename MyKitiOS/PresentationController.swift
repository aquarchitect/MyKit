//
//  PresentationController.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/17/15.
//
//

public class PresentationController: UIPresentationController {

    var dimDismissalEnabled = true
    private var contentFrame: CGRect

    public private(set) lazy var dimView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.userInteractionEnabled = self.dimDismissalEnabled
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.containerView!.insertSubview(view, atIndex: 0)

        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "handleTap:")
        view.addGestureRecognizer(tap)

        return view
    }()

    public init(contentFrame: CGRect, presentedViewController: UIViewController, presentingViewController: UIViewController) {
        self.contentFrame = contentFrame
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        guard let rect = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue else { return }
        self.presentedView()?.frame.origin.y -= rect.height / 2
    }

    func keyboardWillHide(notification: NSNotification) {
        guard let rect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return }
        self.presentedView()?.frame.origin.y += rect.height / 2
    }

    private func animateDim(alpha: CGFloat) {
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.dimView.alpha = alpha }, completion: nil)
    }

    public override func presentationTransitionWillBegin() { animateDim(1) }

    public override func dismissalTransitionWillBegin() { animateDim(0) }

    public override func containerViewWillLayoutSubviews() {
        self.presentedView()!.frame = contentFrame
    }

    func handleTap(sender: UITapGestureRecognizer) {
        let controller = self.presentingViewController
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}