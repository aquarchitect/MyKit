//
// JSONSerialization+.swift
// MyKit
//
// Created by Hai Nguyen on 5/22/17.
// Copyright (c) 2017 Hai Nguyen.
//

import Foundation

public extension JSONSerialization {

    static func prettyPrintedDescription(JSONObject obj: Any) throws -> String {
        let data = try self.data(withJSONObject: obj, options: [.prettyPrinted])

        guard let string = String(data: data, encoding: .utf8) else {
            enum Exception: Error { case unableToParseJSONObject }
            throw Exception.unableToParseJSONObject
        }

        return string
    }
}
