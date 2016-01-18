//
//  UITableViewCellEditingStyle+.swift
//  MyKit
//
//  Created by Hai Nguyen on 9/16/15.
//
//

extension UITableViewCellEditingStyle: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {

        case .Delete: return "Delete"
        case .Insert: return "Insert"
        case .None: return "None"
        }
    }
}