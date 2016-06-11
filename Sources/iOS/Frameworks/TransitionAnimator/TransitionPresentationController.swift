/*
 * TransitionPresentationController.swift
 *
 * Copyright (c) 2015–2016 Hai Nguyen (http://aquarchitect.github.io)
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