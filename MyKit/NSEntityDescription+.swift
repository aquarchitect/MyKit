//
//  NSEntityDescription+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/31/15.
//
//

public extension NSEntityDescription {

    public convenience init(name: String) {
        self.init()
        self.name = name
        //self.managedObjectClassName = name
    }
}