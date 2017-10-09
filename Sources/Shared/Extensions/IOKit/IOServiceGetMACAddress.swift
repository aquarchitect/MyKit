//
// IOServiceGetMACAddress.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import Foundation
import IOKit

public func IOServiceGetMACAddress(_ intfIterator: io_iterator_t) -> String? {
    var result: [UInt8]?

    var intfService = IOIteratorNext(intfIterator)
    while intfService != 0 {
        var controllerService: io_object_t = 0

        if IORegistryEntryGetParentEntry(intfService, "IOService", &controllerService) == KERN_SUCCESS,
            let data = IORegistryEntryCreateCFProperty(
                controllerService,
                "IOMACAddress" as CFString,
                kCFAllocatorDefault, 0
            ).takeRetainedValue() as? NSData
        {
            var macAddress: [UInt8] = [0, 0, 0, 0, 0, 0]
            data.getBytes(&macAddress, length: macAddress.count)
            result = macAddress

            IOObjectRelease(controllerService)
        }

        IOObjectRelease(intfService)
        intfService = IOIteratorNext(intfIterator)
    }

    return result?
        .map({ String(format: "%02x", $0) })
        .joined(separator: ":")
}
