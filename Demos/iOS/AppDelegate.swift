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
        let layout = MagnifyFluidLayout().then {
            $0.magnifyConfig = MagnifyLayoutConfig()
            $0.itemSize = CGSizeMake(100, 100)
            $0.iterimSpacing = 20
        }

        window = UIWindow(frame: UIScreen.mainScreen().bounds).then {
            $0.rootViewController = CollectionViewController<UICollectionViewCell>(collectionViewLayout: layout)
            $0.backgroundColor = .blackColor()
            $0.makeKeyAndVisible()
        }

        return true
    }
}