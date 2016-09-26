/*
 * DateFormatter+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import Foundation

public extension DateFormatter {

    static var shared: DateFormatter {
        struct Singleton {
            static let value = DateFormatter()
        }
        
        return Singleton.value
    }
}

public extension DateFormatter {

    func string(from date: Date, format: String) -> String {
        self.dateFormat = format
        return self.string(from: date)
    }

    func date(from string: String, format: String) -> Date? {
        self.dateFormat = format
        return self.date(from: string)
    }
}
