//
// IOGetEthernetInterfaces.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import Foundation
import IOKit

public func IOGetEthernetInterfaces() -> io_iterator_t? {
    // note that another option here would be `IOBSDMatching("en0")`
    // but en0 isn't necessarily the primary interface, especially
    // on systems with multiple Ethernet ports.

    guard let matchingDict = Optional(IOServiceMatching("IOEthernetInterface"))
        .map({ $0 as NSMutableDictionary })
        else { return nil }

    matchingDict["IOPropertyMatch"] = ["IOPrimaryInterface": true]
    var matchingServices: io_iterator_t = 0



    guard IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &matchingServices) == KERN_SUCCESS else { return nil }
    return matchingServices
}
