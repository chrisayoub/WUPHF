//
//  Pack.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Pack {
    
    private var _name: String
    private var _imageName: String
    private var _members: [Int]
    private var _entity: NSManagedObject?
    
    init(name: String, image: UIImage, members: [Int]) {
        _name = name
        
        let imageName = UUID().uuidString
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent(imageName)
            if let imageData = UIImagePNGRepresentation(image) {
                try imageData.write(to: fileURL)
            }
        } catch {
            print(error)
        }
        
        _imageName = imageName
        _members = members
    }
    
    init(name: String, imageName: String, members: [Int], entity: NSManagedObject) {
        _name = name
        _imageName = imageName
        _members = members
        _entity = entity
    }
    
    var name: String {
        get { return _name }
        set(data) { _name = data }
    }
    
    var imageName: String {
        get { return _imageName }
        set(data) { _imageName = data }
    }
    
    var members: [Int] {
        get { return _members }
        set(data) { _members = data }
    }
    
    var entity: NSManagedObject? {
        get { return _entity }
        set(data) { _entity = data }
    }
    
    func writePack() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let persist = appDelegate.getPersistentContainer() else {
            return
        }
        let managedContext = persist.viewContext

        guard let e = entity else {
            return
        }
        e.setValue(name, forKeyPath: "name")
        e.setValue(imageName, forKeyPath: "imageName")
        e.setValue(members, forKeyPath: "members")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deletePack() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let persist = appDelegate.getPersistentContainer() else {
            return
        }
        let managedContext = persist.viewContext
        
        guard let e = entity else {
            return
        }
        managedContext.delete(e)
        
        // Delete image
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent(imageName)
            try fileManager.removeItem(at: fileURL)
        } catch {
            print(error)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
