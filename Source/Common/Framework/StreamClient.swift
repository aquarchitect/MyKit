//
//  StreamClient.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/25/15.
//
//

public class StreamClient: NSObject {

    // MARK: Property

    public static let EventNotification = "StreamClientEventNotification"

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

public extension StreamClient {

    // MARK: Action Method

    final public func connectTo(host: Host, withTimeout interval: CFTimeInterval = 3) {
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

        timeoutID = Schedule.timeout(interval) {
            self.stream(NSStream(), handleEvent: .ErrorOccurred)
        }
    }

    final public func disconnect() {
        inputStream?.close()
        inputStream = nil

        outputStream?.close()
        outputStream = nil
    }

    final public func reconnect() {
        if let host = self.host { connectTo(host) }
    }
}

extension StreamClient: NSStreamDelegate {

    // MARK: Stream Delegate

    final public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
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