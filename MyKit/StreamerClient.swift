//
//  StreamerClient.swift
//  MyKit
//
//  Created by Hai Nguyen on 12/25/15.
//
//

public protocol StreamerClientDelegate: class {

    func clientReceivesData(data: NSData)
}

public class StreamerClient: NSObject {

    public weak var delegate: StreamerClientDelegate?

    public private(set) var inputStream: NSInputStream?
    public private(set) var outputStream: NSOutputStream?

    public init(ip: String, port: UInt32) {
        super.init()

        var readStream: Unmanaged<CFReadStreamRef>?
        var writeStream: Unmanaged<CFWriteStreamRef>?

        CFStreamCreatePairWithSocketToHost(nil, ip, port, &readStream, &writeStream)

        self.inputStream = readStream?.takeUnretainedValue()
        self.outputStream = writeStream?.takeUnretainedValue()
        ([inputStream, outputStream] as [NSStream?]).forEach(self.setup)
    }

    private func setup(stream: NSStream?) {
        let loop = NSRunLoop.currentRunLoop()
        stream?.delegate = self
        stream?.scheduleInRunLoop(loop, forMode: NSDefaultRunLoopMode)
        stream?.open()
    }
}

extension StreamerClient: NSStreamDelegate {

    public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {

        case [.OpenCompleted]: print("Stream opened")
        case [.ErrorOccurred]: print("Host unavailable")

        case [.EndEncountered]:
            let runLoop = NSRunLoop.currentRunLoop()

            aStream.close()
            aStream.removeFromRunLoop(runLoop, forMode: NSDefaultRunLoopMode)

            switch aStream {

            case _ where aStream === inputStream: inputStream = nil
            case _ where aStream === outputStream: outputStream = nil
            default: break
            }
        case [.HasBytesAvailable] where aStream === inputStream && inputStream?.hasBytesAvailable == true:
            var buffer = [UInt8](count: 8, repeatedValue: 0)

            guard let result = inputStream?.read(&buffer, maxLength: buffer.count) else { break }
            let data = NSData(bytes: buffer, length: result)
            delegate?.clientReceivesData(data)

        default: break
        }
    }
}