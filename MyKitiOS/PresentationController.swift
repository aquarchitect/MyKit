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
        view.alpha = 0
        view.userInteractionEnabled = self.dimDismissalEnabled
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.containerView!.insertSubview(view, atIndex: 0)

        let tap = UITapGestureRecognizer(target: self, action: "tapHandle:")
        view.addGestureRecognizer(tap)

        return view
        }()

    public init(contentFrame: CGRect, presentedViewController: UIViewController, presentingViewController: UIViewController) {
        self.contentFrame = contentFrame
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }

    public override func presentationTransitionWillBegin() {
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.dimView.alpha = 1 }, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ _ in self.dimView.alpha = 0 }, completion: nil)
    }

    public override func containerViewWillLayoutSubviews() {
        self.presentedView()!.frame = contentFrame
    }

    func tapHandle(sender: UITapGestureRecognizer) {
        let controller = self.presentingViewController
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}