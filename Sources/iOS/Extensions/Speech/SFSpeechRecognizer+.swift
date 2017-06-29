//
// SFSpeechRecognizer+.swift
// MyKit
//
// Created by Hai Nguyen on 6/29/17.
// Copyright (c) 2017 Hai Nguyen.
//

import Speech

@available(iOS 10.0, *)
public extension SFSpeechRecognizer {

    static var authorizationRequest: Observable<SFSpeechRecognizerAuthorizationStatus> {
        return Observable().then {
            SFSpeechRecognizer.requestAuthorization($0.update)
        }
    }

    func recognitionTask(with request: SFSpeechRecognitionRequest) -> Observable<SFSpeechRecognitionResult> {
        return Observable().then {
            self.recognitionTask(with: request, resultHandler: $0.update)
        }
    }
}
