// 
// Bundle+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import Foundation

public extension Bundle {

    var productName: String {
        return (self.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String) ?? "Unknown"
    }
    
    var version: String {
        return self.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "Unknown"
    }
    
    var shortVersion: String {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    func launchImageName(isPortrait: Bool, size: CGSize) -> String? {
        let orientation = isPortrait ? "Portrait" : "Landscape"
        
        return self.infoDictionary?["UILaunchImages"]
            .flatMap({ $0 as? [[String: Any]] })?
            .first {
                ($0["UILaunchImageSize"] as? String) == (NSStringFromCGSize(size) as String)
                    && ($0["UILaunchImageOrientation"] as? String) == orientation
            }.flatMap {
                $0["UILaunchImageName"] as? String
        }
    }
}
