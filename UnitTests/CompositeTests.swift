/*
 * CompositeTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 1/17/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

precedencegroup Composite {
    associativity: left
}

infix operator •: Composite

final class CompositeTests: XCTestCase {

    func testOptionals() {
        func foo(_ int: Int) -> Int {
            return 2 * int
        }

        func bar(_ int: Int) -> String {
            return "\(int)"
        }

        XCTAssertNotNil(bar • Optional(foo))
    }
}
