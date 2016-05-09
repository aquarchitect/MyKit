//
//  AppDelegate.swift
//  MyKitDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

@UIApplicationMain
final class AppDelegate: UIResponder {

    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        let layout = MagnifyingSuperLayout().then {
//            $0.magnifyingConfig = MagnifyingLayoutConfig()
//            $0.itemSize = CGSizeMake(100, 100)
//            $0.iterimSpacing = 20
//        }

        let layout = CenteringFlowLayout(itemHeight: 50).then {
            $0.cornerRadii = CGSizeMake(10, 10)
        }

        window = UIWindow(frame: UIScreen.mainScreen().bounds).then {
            $0.rootViewController = CollectionViewController<CenteringFlowCell>(collectionViewLayout: layout)
            $0.backgroundColor = .blackColor()
            $0.makeKeyAndVisible()
        }

        return true
    }
}