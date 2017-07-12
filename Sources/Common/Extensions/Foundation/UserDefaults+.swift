//
// UserDefaults+.swift
// MyKit
//
// Created by Hai Nguyen on 7/12/17.
// Copyright (c) 2017 Hai Nguyen.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import MyKitPrivate

public extension UserDefaults {

    var encryptedKey: String? {
        get { return getAssociatedObject() }
        set { setAssociatedObject(newValue) }
    }
}

extension UserDefaults {

    static var encryptedDefaultValueKey: String {
        return "EncryptDefaultValueKey"
    }

    static var encryptedDefaultHashKey: String {
        return "EncryptDefaultHashKey"
    }

    func hash(_ object: NSCopying) -> String {
        guard let encryptedKeyData = self.encryptedKey?.data(using: .utf8) else {
            fatalError("Missing secure key.")
        }

        guard let deviceIDData = { () -> String? in
#if os(iOS)
            return UIDevice.current.identifierForVendor?.uuidString
#elseif os(OSX)
            return IOGetEthernetInterfaces().flatMap(IOServiceGetMACAddress)
#endif
        }()?.data(using: .utf8) else {
            fatalError("Not found the device's unique identifier.")
        }

        var data = NSKeyedArchiver.archivedData(withRootObject: object.copy(with: nil))
        data.append(encryptedKeyData)
        data.append(deviceIDData)
        return (data as NSData).md5
    }
}

public extension UserDefaults {

    /// Like all of `UserDefaults` methods, `value` is required to be PropertyList
    func setEncryptedObject(_ value: Any?, forKey defaultName: String) {
        var dict: [String: Any] = [:]
        dict[UserDefaults.encryptedDefaultValueKey] = value
        dict[UserDefaults.encryptedDefaultHashKey] = (value as? NSCopying).map(hash)

        return self.set(dict, forKey: defaultName)
    }

    func encryptedObject(forKey defaultName: String) -> Any? {
        guard let encryptedDict = self.dictionary(forKey: defaultName),
            let encryptedValue = encryptedDict[UserDefaults.encryptedDefaultValueKey] as? NSCopying,
            let encryptedHash = encryptedDict[UserDefaults.encryptedDefaultHashKey] as? String
            else { return nil }

        return hash(encryptedValue) == encryptedHash ? encryptedValue : nil
    }
}
