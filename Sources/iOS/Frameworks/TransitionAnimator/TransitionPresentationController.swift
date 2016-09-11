/*
 * TransitionPresentationController.swift
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

public class TransitionPresentationController: UIPresentationController {

    public var presentedRect = UIScreen.mainScreen().bounds

    public var backgroundColor: UIColor? {
        didSet {
            dimView.backgroundColor = backgroundColor
        }
    }

    internal let dimView = UIView().then {
        $0.frame = UIScreen.mainScreen().bounds
        $0.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)

        UITapGestureRecognizer()
            .then { $0.addTarget(self, action: #selector(handleTap)) }
            .then(dimView.addGestureRecognizer)
    }

    public override func presentationTransitionWillBegin() {
        self.containerView?.insertSubview(dimView, atIndex: 0)
        fadeDim(appearing: true, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        self.presentedView()?.endEditing(true)
        fadeDim(appearing: false) {
            [weak dimView] in
            dimView?.removeFromSuperview()
        }
    }

    private func fadeDim(appearing flag: Bool, completion: (Void -> Void)?) {
        dimView.alpha = flag ? 0 : 1

        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({
            [unowned dimView] _ in
            dimView.alpha = flag ? 1 : 0
        }, completion: { _ in completion?() })
    }

    public override func containerViewWillLayoutSubviews() {
        self.presentedView()?.frame = presentedRect
    }

    func handleTap(sender: UITapGestureRecognizer) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}