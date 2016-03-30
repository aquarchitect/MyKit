//
//  Host.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/22/16.
//  
//

private enum Exception: ErrorType {

    case IPAddressInvalid
}

public struct Host {

    public let ip: String
    public let port: UInt32

    public init(ip: String, port: UInt32) throws {
        guard ip.isValidatedAs(.IPAddress) else {
            throw Exception.IPAddressInvalid
        }

        self.ip = ip
        self.port = port
    }
}