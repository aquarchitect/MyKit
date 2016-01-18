//
//  TaskManager.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/2/16.
//
//

final public class TaskManager {

    private var timer: NSTimer?

    public var valid: Bool {
        return timer?.valid ?? false
    }

    public init() {}

    public func schedule(time: CFTimeInterval, @noescape block: Void -> Void) {
        let timer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "timerFireMethod:", userInfo: Box(block), repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        self.timer = timer
    }

    public func schedule(time: CFTimeInterval, target: AnyObject, action: Selector, withObject object: AnyObject? = nil) {
        schedule(time) { [weak target] in
            target?.performSelector(action, withObject: object)
        }
    }

    public func cancel() {
        timer?.invalidate()
        timer = nil
    }

    @objc internal func timerFireMethod(timer: NSTimer) {
        (timer.userInfo as? Box<Void -> Void>)?.unbox()
    }
}