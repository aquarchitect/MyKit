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
        let layout = Layout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.headerReferenceSize.height = 30

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = ViewController(collectionViewLayout: layout)
        window?.backgroundColor = .blackColor()
        window?.makeKeyAndVisible()

        return true
    }
}

private class Layout: UICollectionViewFlowLayout {

}