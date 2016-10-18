/*
 * Observable.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

/**
 * Future Value
 */
final public class Observable<T> {

    public typealias Token = UInt8
    private(set) var callbacks: [Token: Result<T>.Callback] = [:]

#if swift(>=3.0)
    fileprivate let mutex = Mutex()
#else
    private let mutex = Mutex()
#endif
    private var token: Token = 0

    public init() {}

#if swift(>=3.0)
    @discardableResult
    public func subscribe(_ callback: @escaping Result<T>.Callback) -> Token {
        token += 1
        mutex.perform { callbacks[token] = callback }
        return token
    }

    @discardableResult
    public func unsubscribe(_ token: Token) -> Result<T>.Callback? {
        return callbacks.removeValue(forKey: token)
    }
#else
    public func subscribe(callback: Result<T>.Callback) -> Token {
        token += 1
        mutex.perform { callbacks[token] = callback }
        return token
    }

    public func unsubscribe(token: Token) -> Result<T>.Callback? {
        return callbacks.removeValueForKey(token)
    }
#endif
}

public extension Observable {

#if swift(>=3.0)
    fileprivate func update(_ result: Result<T>) {
        mutex.perform { callbacks.values.forEach { $0(result) }}
    }

    func update(_ value: T) {
        update(.fulfill(value))
    }
#else
    private func update(result: Result<T>) {
        mutex.perform { callbacks.values.forEach { $0(result) }}
    }

    func update(value: T) {
        update(.fulfill(value))
    }
#endif
}

public extension Observable {

#if swift(>=3.0)
    func map<U>(_ transform: @escaping (T) throws -> U) -> Observable<U> {
        let observable = Observable<U>()

        subscribe { result in
            observable.update(result.map(transform))
        }

        return observable
    }
#else
    func map<U>(transform: (T) throws -> U) -> Observable<U> {
        let observable = Observable<U>()

        subscribe { result in
            observable.update(result.map(transform))
        }

        return observable
    }
#endif

#if swift(>=3.0)
    func flatMap<U>(_ transform: @escaping (T) throws -> Observable<U>) -> Observable<U> {
        let observable = Observable<U>()

        subscribe { result in
            do {
                try (result.resolve >>> transform)().subscribe(observable.update)
            } catch {
                observable.update(.reject(error))
            }
        }

        return observable
    }
#else
    func flatMap<U>(transform: (T) throws -> Observable<U>) -> Observable<U> {
        let observable = Observable<U>()

        subscribe { result in
            do {
                try (result.resolve >>> transform)().subscribe(observable.update)
            } catch {
                observable.update(.reject(error))
            }
        }

        return observable
    }
#endif

#if swift(>=3.0)
    func filter(_ check: @escaping (T) throws -> Bool) -> Observable {
        let observable = Observable()

        subscribe { result in
            do {
                if try (result.resolve >>> check)() { observable.update(result) }
            } catch {
                observable.update(.reject(error))
            }
        }

        return observable
    }
#else
    func filter(check: (T) throws -> Bool) -> Observable {
        let observable = Observable()

        subscribe { result in
            do {
                if try (result.resolve >>> check)() { observable.update(result) }
            } catch {
                observable.update(.reject(error))
            }
        }

        return observable
    }
#endif
}

public extension Observable {

#if swift(>=3.0)
    @discardableResult
    func onNext(_ handle: @escaping (T) -> Void) -> Observable {
        subscribe { result in
            if case .fulfill(let value) = result { handle(value) }
        }

        return self
    }
#else
    @discardableResult
    func onNext(handle: (T) -> Void) -> Observable {
        subscribe { result in
            if case .fulfill(let value) = result { handle(value) }
        }

        return self
    }

#endif

#if swift(>=3.0)
    @discardableResult
    func onError(_ handle: @escaping (Error) -> Void) -> Observable {
        subscribe { result in
            if case .reject(let error) = result { handle(error) }
        }

        return self
    }
#else
    @discardableResult
    func onError(handle: (ErrorType) -> Void) -> Observable {
        subscribe { result in
            if case .reject(let error) = result { handle(error) }
        }

        return self
    }
#endif
}

public extension Observable {

    private func _join(other: Observable) -> Observable {
        let observable = Observable()
        subscribe(observable.update)
        other.subscribe(observable.update)

        return observable
    }

#if swift(>=3.0)
    func join(_ other: Observable) -> Observable {
        return _join(other: other)
    }
#else
    func join(other: Observable) -> Observable {
        return _join(other)
    }
#endif
}

public extension Observable {

#if swift(>=3.0)
    func delay(_ timeInterval: TimeInterval) -> Observable {
        let observable = Observable()

        subscribe { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                observable.update(result)
            }
        }

        return observable
    }
#else
    func delay(timeInterval: NSTimeInterval) -> Observable {
        let observable = Observable()

        subscribe { result in
            MyKit.delay(timeInterval) {
                observable.update(result)
            }
        }

        return observable
    }
#endif

#if swift(>=3.0)
    func debounce(_ timeInterval: TimeInterval) -> Observable {
        let outerObservable = Observable()
        var lastCall: Date?

        subscribe { outerResult in
            let currentTime = Date()

            func updateIfNeeded(_ innerObservable: Observable) -> Result<T>.Callback {
                return { innerResult in
                    let timeSinceLastCall = lastCall?.timeIntervalSinceNow

                    if (timeSinceLastCall ?? -timeInterval) <= -timeInterval {
                        // update if time frame is outside of debounce window
                        lastCall = Date()
                        innerObservable.update(innerResult)
                    } else if case .orderedAscending? = lastCall?.compare(currentTime) {
                        // skip result if there was a new result
                        let deadline: DispatchTime = .now() + timeInterval - (timeSinceLastCall ?? 0)

                        DispatchQueue.main.asyncAfter(deadline: deadline) {
                            updateIfNeeded(innerObservable)(innerResult)
                        }
                    }
                }
            }

            updateIfNeeded(outerObservable)(outerResult)
        }

        return outerObservable
    }
#else
    func debounce(timeInterval: NSTimeInterval) -> Observable {
        let outerObservable = Observable()
        var lastCall: NSDate?

        subscribe { outerResult in
            let currentTime = NSDate()

            func updateIfNeeded(innerObservable: Observable) -> Result<T>.Callback {
                return { innerResult in
                    let timeSinceLastCall = lastCall?.timeIntervalSinceNow

                    if (timeSinceLastCall ?? -timeInterval) <= -timeInterval {
                        // update if time frame is outside of debounce window
                        lastCall = NSDate()
                        innerObservable.update(innerResult)
                    } else if case .OrderedAscending? = lastCall?.compare(currentTime) {
                        // skip result if there was a new result
                        MyKit.delay(timeInterval - (timeSinceLastCall ?? 0)) {
                            updateIfNeeded(innerObservable)(innerResult)
                        }
                    }
                }
            }

            updateIfNeeded(outerObservable)(outerResult)
        }
        
        return outerObservable
    }
#endif
}

public extension Observable {

    func inBackground() -> Observable {
        let observable = Observable()

        subscribe { result in
#if swift(>=3.0)
            DispatchQueue.global(qos: .background).async {
                observable.update(result)
            }
#else
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                observable.update(result)
            }
#endif
        }

        return observable
    }

    func inMainQueue() -> Observable {
        let observable = Observable()

        subscribe { result in
#if swift(>=3.0)
            DispatchQueue.main.async {
                observable.update(result)
            }
#else
            dispatch_async(dispatch_get_main_queue()) {
                observable.update(result)
            }
#endif
        }

        return observable
    }
}
