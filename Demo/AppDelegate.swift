//
//  AppDelegate.swift
//  Demo
//
//  Created by Hai Nguyen on 8/25/15.
//
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = ViewController()
        window?.backgroundColor = .blackColor()
        window?.makeKeyAndVisible()

        return true
    }
}