//
//  Miscellaneous.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/12/16.
//  
//

public typealias ErrorHandler = NSError -> Void

public enum FileError: ErrorType {

    case InvalidResourcePath
    case UnableToDecryptTheFile
}

public enum AccessControl {

    case Private
    case Public
}