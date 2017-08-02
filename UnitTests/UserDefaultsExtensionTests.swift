//
// UserDefaultsExtensionTests.swift
// MyKit
//
// Created by Hai Nguyen on 7/12/17.
// Copyright (c) 2017 Hai Nguyen.
//

@testable import MyKit

final class UserDefaultsExtensionTests: XCTestCase {

    fileprivate var userDefaults: UserDefaults?

    fileprivate var suiteName: String {
        return "MockUserDefaults"
    }

    override func setUp() {
        super.setUp()

        UserDefaults().removePersistentDomain(forName: suiteName)
        userDefaults = UserDefaults(suiteName: suiteName)?.then {
            $0.encryptedKey = "Test"
        }
    }

    override func tearDown() {
        super.tearDown()

        UserDefaults().removePersistentDomain(forName: suiteName)
    }
}

extension UserDefaultsExtensionTests {

    func testEncryptedObjectGetter() {
        let sensitiveTuple = (key: "Foo", value: "Bar")
        userDefaults?.setEncryptedObject(sensitiveTuple.value, forKey: sensitiveTuple.key)

        XCTAssertEqual(
            userDefaults?.encryptedObject(forKey: sensitiveTuple.key) as? String,
            sensitiveTuple.value
        )

        userDefaults?.set([
            UserDefaults.encryptedDefaultValueKey: sensitiveTuple.value,
            UserDefaults.encryptedDefaultHashKey: "Invalid Hash"
        ], forKey: sensitiveTuple.key)

        XCTAssertNil(userDefaults?.encryptedObject(forKey: sensitiveTuple.key))
    }
}
