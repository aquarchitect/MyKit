//
// JSONSerialization+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import Foundation

public extension JSONSerialization {

    class func prettyPrintedDescription(JSONObject obj: Any) throws -> String {
        let data = try self.data(withJSONObject: obj, options: [.prettyPrinted])

        guard let string = String(data: data, encoding: .utf8) else {
            fatalError("Unable to parse \(obj) to json!")
        }

        return string
    }
}
