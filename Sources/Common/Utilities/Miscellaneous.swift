//
//  Miscellaneous.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/17/16.
//  
//

public enum Error: ErrorType {

    case FailedToLocate(file: String)
    case NoDataContent
}

public enum Side {

    case Top, Left, Bottom, Right
}