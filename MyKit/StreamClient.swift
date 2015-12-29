//
//  StreamClient.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/25/15.
//
//

/// StreamerCline is meant to subclass
public class StreamClient: NSObject {

    public static let EventNotification = "StreamClientEventNotification"

    public private(set) var ip: String?
    public private(set) var port: UInt32?

    private var inputStream: NSInputStream?
    private var outputStream: NSOutputStream?

    public func connectToHost(ip: String, port: UInt32) {
        self.ip = ip
        self.port = port

        var readStream: Unmanaged<CFReadStreamRef>?
        var writeStream: Unmanaged<CFWriteStreamRef>?

        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, ip, port, &readStream, &writeStream)

        self.inputStream = readStream?.takeUnretainedValue()
        self.outputStream = writeStream?.takeUnretainedValue()
        [inputStream, outputStream].forEach(self.addStream)
    }

    public func disconnect() {
        removeStream(&inputStream)
        removeStream(&outputStream)
    }

    public func reconnect() {
        guard let ip = self.ip, port = self.port else { return }
        connectToHost(ip, port: port)
    }

    public func writeData(data: NSData) {
        guard outputStream?.hasSpaceAvailable == true else { return }
        outputStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }

    public func readData(data: NSData) {}

    private func addStream<T: NSStream>(stream: T?) {
        let loop = NSRunLoop.currentRunLoop()
        stream?.delegate = self
        stream?.scheduleInRunLoop(loop, forMode: NSDefaultRunLoopMode)
        stream?.open()
    }

    private func removeStream<T: NSStream>(inout stream: T?) {
        let loop = NSRunLoop.currentRunLoop()
        stream?.close()
        stream?.delegate = self
        stream?.scheduleInRunLoop(loop, forMode: NSDefaultRunLoopMode)
        stream = nil
    }
}

extension StreamClient: NSStreamDelegate {

    public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {

        case let options where !options.isDisjointWith([.EndEncountered, .ErrorOccurred]):
            removeStream(&inputStream)
            removeStream(&outputStream)

        case [.HasBytesAvailable] where aStream === inputStream && inputStream?.hasBytesAvailable == true:
            var buffer = [UInt8](count: 8, repeatedValue: 0)

            guard let result = inputStream?.read(&buffer, maxLength: buffer.count) else { break }
            let data = NSData(bytes: buffer, length: result)
            readData(data)

        default: break
        }

        NSNotificationCenter.defaultCenter().postNotificationName(self.dynamicType.EventNotification, object: Box(eventCode))
    }
}