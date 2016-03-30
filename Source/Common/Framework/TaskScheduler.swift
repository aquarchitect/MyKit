//
//  TaskScheduler.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/2/16.
//
//

final public class TaskScheduler {

    private var timer: NSTimer?

    public init() {}

    public func runAfter(interval: CFTimeInterval, @noescape block: Void -> Void) {
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(timerFireMethod(_:)), userInfo: Box(block), repeats: false).then {
            NSRunLoop.currentRunLoop().addTimer($0, forMode: NSDefaultRunLoopMode)
        }
    }

    public func runAfter(interval: CFTimeInterval, target: AnyObject, action: Selector, withObject object: AnyObject? = nil) {
        runAfter(interval) { [weak target] in
            target?.performSelector(action, withObject: object)
        }
    }

    public func cancel() {
        timer?.invalidate()
        timer = nil
    }

    @objc internal func timerFireMethod(timer: NSTimer) {
        (timer.userInfo as? Box<(Void -> Void)>)?.value()
        self.timer = nil
    }
}