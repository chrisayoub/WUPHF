//
//  AppDelegate.swift
//  WUPHF
//
//  Created by Chris on 10/8/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userContainers: Dictionary<String, NSPersistentContainer> = Dictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Twitter.sharedInstance().start(withConsumerKey:"dE7W4G2gjrFS16oyDatS1Ujhh", consumerSecret:"jNS8daivgRdIjBFSCzkUvU9DotUz4SdhOxwGcDdrGOoZtEILnT")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    func getPersistentContainer() -> NSPersistentContainer? {
        var storeName = "WUPHF"
        if let id = Common.loggedInUser?.id {
            storeName += "-\(id)"
        } else {
            return nil
        }
        
        if userContainers[storeName] != nil {
            return userContainers[storeName]
        }
        
        guard let mom = NSManagedObjectModel.mergedModel(from: nil) else {
            fatalError("Could not load model")
        }
        let container = NSPersistentContainer(name: storeName, managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        userContainers[storeName] = container
        return container
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        guard let context = getPersistentContainer()?.viewContext else {
            return
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
