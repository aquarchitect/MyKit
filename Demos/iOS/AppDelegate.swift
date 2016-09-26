/*
 * AppDelegate.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

@UIApplicationMain
final class AppDelegate: UIResponder {

    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds).then {
            $0.rootViewController = TableController().then(UINavigationController.init)
            $0.backgroundColor = .blackColor()
            $0.makeKeyAndVisible()
        }

        return true
    }
}
