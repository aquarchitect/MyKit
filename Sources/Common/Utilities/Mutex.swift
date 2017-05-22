// 
// Mutex.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import Darwin

/// Concurrency control - execute tasks one at a time
public class Mutex {

    private var mutex = pthread_mutex_t()

    public init() {
        pthread_mutex_init(&mutex, nil)
    }

    deinit {
        pthread_mutex_destroy(&mutex)
    }

    public func perform(_ execute: () -> Void) {
        pthread_mutex_lock(&mutex)
        execute()
        pthread_mutex_unlock(&mutex)
    }
}
