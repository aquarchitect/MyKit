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

    func recognitionTask(_ request: SFSpeechRecognitionRequest) -> Observable<SFSpeechRecognitionResult> {
        return Observable().then {
            self.recognitionTask(with: request, resultHandler: $0.update)
        }
    }
}
