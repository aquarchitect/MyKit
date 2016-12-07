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
open class Observable<T> {

    private(set) var callbacks: [Result<T>.Callback] = []
    fileprivate let mutex = Mutex()

    public init() {}

    fileprivate func subscribe(_ callback: @escaping Result<T>.Callback) {
        mutex.perform { callbacks.append(callback) }
    }
}

extension Observable: Then {}

public extension Observable {

    fileprivate func update(_ result: Result<T>) {
        mutex.perform { callbacks.forEach { $0(result) }}
    }

    func update(_ value: T) {
        update(.fulfill(value))
    }
}

public extension Observable {

    func map<U>(_ transform: @escaping (T) throws -> U) -> Observable<U> {
        let observable = Observable<U>()

        subscribe { result in
            observable.update(result.map(transform))
        }

        return observable
    }

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
}

public extension Observable {

    @discardableResult
    func onNext(_ handle: @escaping (T) -> Void) -> Observable {
        subscribe { result in
            if case .fulfill(let value) = result { handle(value) }
        }

        return self
    }

    @discardableResult
    func onError(_ handle: @escaping (Error) -> Void) -> Observable {
        subscribe { result in
            if case .reject(let error) = result { handle(error) }
        }

        return self
    }
}

public extension Observable {

    func join(_ other: Observable) -> Observable {
        let observable = Observable()
        subscribe(observable.update)
        other.subscribe(observable.update)

        return observable
    }

    static func merge(_ observables: Observable...) -> Observable {
        let observable = Observable()

        observables.forEach {
            $0.subscribe(observable.update)
        }

        return observable
    }
}

public extension Observable {

    func delay(_ timeInterval: TimeInterval) -> Observable {
        let observable = Observable()

        subscribe { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                observable.update(result)
            }
        }

        return observable
    }

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
}

public extension Observable {

    func inBackground() -> Observable {
        let observable = Observable()

        subscribe { result in
            DispatchQueue.global(qos: .background).async {
                observable.update(result)
            }
        }

        return observable
    }

    func inMainQueue() -> Observable {
        let observable = Observable()

        subscribe { result in
            DispatchQueue.main.async {
                observable.update(result)
            }
        }

        return observable
    }
}
