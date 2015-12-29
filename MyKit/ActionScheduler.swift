//
//  ActionScheduler.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/29/15.
//
//

final public class ActionScheduler {

    public var interval: CFTimeInterval
    private var timer: NSTimer?
    private weak var target: AnyObject?
    private var action: Selector?

    public init(interval: CFTimeInterval) {
        self.interval = interval
    }

    public func addTarget(target: AnyObject?, action: Selector) {
        self.target = target
        self.action = action
    }

    public func dispatch(withObject object: AnyObject? = nil) {
        let timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "timerFireMethod:", userInfo: object, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        self.timer = timer
    }

    public func cancel() {
        timer?.invalidate()
        timer = nil
    }

    @objc internal func timerFireMethod(timer: NSTimer) {
        guard let selector = self.action else { return }
        target?.performSelector(selector, withObject: timer.userInfo)
    }
}