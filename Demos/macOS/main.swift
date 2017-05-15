//
// main.swift
// MyKit
//
// Created by Hai Nguyen on 5/15/17.
// Copyright (c) 2017 Hai Nguyen.
//

@objc(Application)
final class Application: NSApplication {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        super.setActivationPolicy(.accessory)
        super.delegate = self
    }
}

extension Application: NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        Swift.print(NSMenuItem.orderFrontStandardAboutPanel.title)
        (notification.object as? NSApplication)?.terminate(nil)
    }
}

Application.shared().run()
