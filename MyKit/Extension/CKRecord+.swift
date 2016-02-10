//
//  CKRecord+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/9/16.
//  
//

public extension CKRecord {

    public func unload<T: CloudObject>()  -> T? {
        guard let result = try? T(record: self) else { return nil }

        for key in self.allKeys() where result.respondsToSelector(Selector(key)) {
            guard let value = self[key] else { continue }
            self.setValue(value, forKey: key)
        }

        return result
    }

    public func load<T: CloudObject>(obj: T) {
        guard obj.recordID == self.recordID else { return }

        for key in self.allKeys() where obj.respondsToSelector(Selector(key)) {
            self[key] = obj.valueForKey(key) as? CKRecordValue
        }
    }
}