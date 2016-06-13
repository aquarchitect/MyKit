/*
 * StreamService.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

private enum Exception: ErrorType {

    case IPInvalid
}

public class StreamService: NSObject {

    public struct Host {

        public let ip: String
        public let port: UInt32

        public init(ip: String, port: UInt32) throws {
            guard ip.isValidAs(.IP) else {
                throw Exception.IPInvalid
            }

            self.ip = ip
            self.port = port
        }
    }

    // MARK: Property

    public static let EventNotification = "StreamServiceEventNotification"

    public private(set) var host: Host?
    private var timeoutID: Schedule.ID?

    private var inputStream: NSInputStream?
    private var outputStream: NSOutputStream?

    // MARK: Override Method

    public func write(data: NSData) {
        outputStream?.then {
            guard $0.hasSpaceAvailable else { return }
            $0.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
    }

    public func read(data: NSData) {}
}

public extension StreamService {

    // MARK: Action Method

    func connectTo(ip: String, port: UInt32, timeout: CFTimeInterval = 3) throws {
        let host = try Host(ip: ip, port: port)
        connectTo(host, timeout: timeout)
    }

    func connectTo(host: Host, timeout: CFTimeInterval = 3) {
        self.host = host

        var readStream: Unmanaged<CFReadStreamRef>?
        var writeStream: Unmanaged<CFWriteStreamRef>?

        CFStreamCreatePairWithSocketToHost(nil, host.ip, host.port, &readStream, &writeStream)

        self.inputStream = readStream?.takeUnretainedValue()
        self.outputStream = writeStream?.takeUnretainedValue()

        ([inputStream, outputStream] as [NSStream?]).forEach {
            $0?.delegate = self
            $0?.scheduleInRunLoop(.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            $0?.open()
        }

        timeoutID = Schedule.timeout(timeout) {
            self.stream(NSStream(), handleEvent: .ErrorOccurred)
        }
    }

    func disconnect() {
        inputStream?.close()
        inputStream = nil

        outputStream?.close()
        outputStream = nil
    }

    func reconnect() {
        if let host = self.host { connectTo(host) }
    }
}

extension StreamService: NSStreamDelegate {

    // MARK: Stream Delegate

    public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        Schedule.cancel(timeoutID ?? 0)

        switch eventCode {
        case _ where !eventCode.isDisjointWith([.EndEncountered, .ErrorOccurred]): disconnect()
        case [.HasBytesAvailable] where (aStream as? NSInputStream)?.then { $0.hasBytesAvailable } == true:
            var buffer = [UInt8](count: 8, repeatedValue: 0)

            guard let result = inputStream?.read(&buffer, maxLength: buffer.count) else { break }
            NSData(bytes: buffer, length: result).then(read)
        default: break
        }

        NSNotificationCenter.defaultCenter().postNotificationName(self.dynamicType.EventNotification, object: Box(eventCode))
    }
}