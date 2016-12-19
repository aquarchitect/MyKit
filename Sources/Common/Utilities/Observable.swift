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

    private(set) var callbacks: [Result<T>.Callback] = []
    fileprivate let mutex = Mutex()

    public init() {}

    internal func subscribe(_ callback: @escaping Result<T>.Callback) {
        mutex.perform { callbacks.append(callback) }
    }

    public func unsubscribeAll() {
        mutex.perform { callbacks.removeAll() }
    }
}

extension Observable: Then {}

public extension Observable {

    static func lift(on queue: DispatchQueue = .main, _ constructor: @escaping () throws -> T) -> Observable {
        let observable = Observable()

        queue.async {
            do {
                try (observable.update • constructor)()
            } catch {
                observable.update(error)
            }
        }

        return observable
    }
}

public extension Observable {

    internal func update(_ result: Result<T>) {
        mutex.perform { callbacks.forEach { $0(result) }}
    }

    internal func update(_ value: T?, _ error: Error?) {
        update(.init(value, error))
    }

    func update(_ value: T) {
        update(.fulfill(value))
    }

    func update(_ error: Error) {
        update(.reject(error))
    }
}

public extension Observable {

    func map<U>(_ transformer: @escaping (T) throws -> U) -> Observable<U> {
        let observable = Observable<U>()

        subscribe { result in
            observable.update(result.map(transformer))
        }

        return observable
    }

    func flatMap<U>(_ transformer: @escaping (T) -> Observable<U>) -> Observable<U> {
        let observable = Observable<U>()

        subscribe { result in
            do {
                try (transformer • result.resolve)().subscribe(observable.update)
            } catch {
                observable.update(.reject(error))
            }
        }

        return observable
    }

    func flatMapLatest<U>(_ transformer: @escaping (T) throws -> Observable<U>) -> Observable<U> {
        let observable = Observable<U>()
        var lastResult: Box<Result<T>>?

        subscribe { outerResult in
            let boxedResult = Box(outerResult)
            lastResult = boxedResult

            do {
                try (transformer • outerResult.resolve)().subscribe { innerResult in
                    guard lastResult === boxedResult else { return }
                    observable.update(innerResult)
                    lastResult = nil
                }
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
                if try (check • result.resolve)() { observable.update(result) }
            } catch {
                observable.update(.reject(error))
            }
        }

        return observable
    }
}

public extension Observable {

    func recover(_ transformer: @escaping (Error) -> Observable) -> Observable {
        let observable = Observable()

        subscribe { result in
            guard case .reject(let error) = result else { return }
            transformer(error).subscribe(observable.update)
        }

        return observable
    }
    
    func retry(attemptCount count: Int) -> Observable {
        let obserable = Observable()

        subscribe { result in
            func _retry(atttempCount count: Int) {
                switch (result, count) {
                case (.fulfill(_), _), (.reject(_), 0):
                    obserable.update(result)
                default:
                    _retry(atttempCount: count - 1)
                }
            }

            _retry(atttempCount: count)
        }

        return obserable
    }
}

public extension Observable {

    @discardableResult
    func onNext(_ handler: @escaping (T) -> Void) -> Observable {
        subscribe { result in
            if case .fulfill(let value) = result { handler(value) }
        }

        return self
    }

    @discardableResult
    func onError(_ handler: @escaping (Error) -> Void) -> Observable {
        subscribe { result in
            if case .reject(let error) = result { handler(error) }
        }

        return self
    }
}

public extension Observable {

    func join(_ others: Observable...) -> Observable {
        for other in others {
            subscribe(other.update)
            other.subscribe(update)
        }

        return self
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

    /**
     * The observable only fires once per specified time interval. The last
     * call to update will always be delivered (although it might be delayed 
     * up to thhe specified amount of seconds).
     */
    func debounce(_ timeInterval: TimeInterval) -> Observable {
        let observable = Observable()
        var lastResult: Box<Result<T>>?

        subscribe { result in
            let boxedResult = Box(result)
            lastResult = boxedResult

            let deadline: DispatchTime = .now() + timeInterval
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                guard lastResult === boxedResult else { return }
                observable.update(result)
            }
        }

        return observable
    }
}

public extension Observable {

    @discardableResult
    func on(_ queue: DispatchQueue) -> Observable {
        let observable = Observable()

        subscribe { result in
            queue.async {
                observable.update(result)
            }
        }

        return observable
    }

    @discardableResult
    func inBackground() -> Observable {
        return on(.global(qos: .background))
    }

    @discardableResult
    func inMainQueue() -> Observable {
        return on(.main)
    }
}

public func zip<A, B>(_ observableA: Observable<A>, observableB: Observable<B>) -> Observable<(A, B)> {
    let observable = Observable<(A, B)>()
    var resultA: Result<A>?, resultB: Result<B>?

    func update() {
        zip(resultA, resultB)
            .map { zip($0, $1) }
            .map(observable.update)
    }

    observableA.subscribe { resultA = $0; update() }
    observableB.subscribe { resultB = $0; update() }

    return observable
}
