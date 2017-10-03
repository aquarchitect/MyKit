//
// SFSpeechRecognizer+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import Speech

@available(iOS 10.0, *)
public extension SFSpeechRecognizer {

#if true
    class func requestAuthorization() -> Promise<SFSpeechRecognizerAuthorizationStatus> {
        return Promise { callback in
            SFSpeechRecognizer.requestAuthorization(Result.fulfill >>> callback)
        }
    }
#else
    class func requestAuthorization() -> Observable<SFSpeechRecognizerAuthorizationStatus> {
        return Observable().then {
            SFSpeechRecognizer.requestAuthorization($0.update)
        }
    }
#endif

#if true
    func recognitionTask(with request: SFSpeechRecognitionRequest) -> Promise<SFSpeechRecognitionResult> {
        return Promise { (callback: @escaping Result<SFSpeechRecognitionResult>.Callback) in
            let handler = Result.init >>> callback
            self.recognitionTask(with: request, resultHandler: handler)
        }
    }
#else
    func recognitionTask(with request: SFSpeechRecognitionRequest) -> Observable<SFSpeechRecognitionResult> {
        return Observable().then {
            self.recognitionTask(with: request, resultHandler: Result.init >>> $0.update)
        }
    }
#endif
}
