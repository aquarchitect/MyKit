//
//  AppDelegate.swift
//  MyKit-iOSDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds).then {
            $0.rootViewController = ViewController()
            $0.backgroundColor = .blackColor()
            $0.makeKeyAndVisible()
        }

        return true
    }
}