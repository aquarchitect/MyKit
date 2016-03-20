//
//  StreamClient.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/25/15.
//
//

public class StreamClient: NSObject, NSStreamDelegate {

    // MARK: Property

    public static let EventNotification = "StreamClientEventNotification"

    private let stoppage = TaskScheduler()
    public var timeout: CFTimeInterval = 3

    public private(set) var ip: String?
    public private(set) var port: UInt32?

    private var inputStream: NSInputStream?
    private var outputStream: NSOutputStream?

    // MARK: Action Method

    final public func connectToHost(ip: String, port: UInt32) throws {
        guard ip.isValidatedFor(.IPAddress) else {
            enum Exception: ErrorType { case InvalidIPAddress }
            throw Exception.InvalidIPAddress
        }

        self.ip = ip
        self.port = port

        var readStream: Unmanaged<CFReadStreamRef>?
        var writeStream: Unmanaged<CFWriteStreamRef>?

        CFStreamCreatePairWithSocketToHost(nil, ip, port, &readStream, &writeStream)

        self.inputStream = readStream?.takeUnretainedValue()
        self.outputStream = writeStream?.takeUnretainedValue()

        ([inputStream, outputStream] as [NSStream?]).forEach {
            $0?.delegate = self
            $0?.scheduleInRunLoop(.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            $0?.open()
        }

        stoppage.schedule(timeout) { stream(NSStream(), handleEvent: .ErrorOccurred) }
    }

    final public func disconnect() {
        inputStream?.close()
        inputStream = nil

        outputStream?.close()
        outputStream = nil
    }

    final public func reconnect() throws {
        guard let ip = self.ip, port = self.port else { return }
        try connectToHost(ip, port: port)
    }

    // MARK: Override Method

    public func writeData(data: NSData) {
        outputStream?.then {
            guard $0.hasSpaceAvailable else { return }
            $0.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
    }

    public func readData(data: NSData) {}

    // MARK: Stream Delegate

    final public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        stoppage.cancel()

        switch eventCode {

        case _ where !eventCode.isDisjointWith([.EndEncountered, .ErrorOccurred]):
            disconnect()

        case [.HasBytesAvailable] where (aStream as? NSInputStream)?.then { $0.hasBytesAvailable } == true:
            var buffer = [UInt8](count: 8, repeatedValue: 0)

            guard let result = inputStream?.read(&buffer, maxLength: buffer.count) else { break }
            NSData(bytes: buffer, length: result).then(readData)

        default: break
        }

        NSNotificationCenter.defaultCenter().postNotificationName(self.dynamicType.EventNotification, object: Box(eventCode))
    }
}