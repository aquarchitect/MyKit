//
//  NSDateTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/14/16.
//  
//

final class NSDateTests: XCTestCase {

    func testDateByAddingUnits() {
        let components = NSDateComponents().then {
                $0.calendar = NSDate.Calendar
                $0.day = 23
                $0.month = 1
                $0.year = 1990
            }

        guard let date = components.date else { return XCTFail() }

        [(.Day, 24), (.Month, 2), (.Year, 1991)].forEach {
            XCTAssertEqual(date.dateByAdding($0, value: 1).component($0), $1)
        }
    }
}