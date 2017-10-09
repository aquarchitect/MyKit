//
// Diff+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import XCTest
import MyKit

extension Diff {

    var isDeleted: Bool {
        switch self {
        case .delete: return true
        default: return false
        }
    }

    var isInserted: Bool {
        switch self {
        case .insert: return true
        default: return false
        }
    }

    var isUpdated: Bool {
        switch self {
        case .update: return true
        default: return false
        }
    }

    var value: T {
        switch self {
        case .delete(let value): return value
        case .insert(let value): return value
        case .update(let value): return value
        }
    }
}
