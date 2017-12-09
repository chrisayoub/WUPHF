//
//  PacksCollectionViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit
import CoreData

class PacksCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    var alert: UIAlertController? = nil
    lazy var createPackName: UITextField? = nil
    lazy var createPackImage: UIImageView? = nil
    
    var displayPacks: [Pack] = []
    var cells: [PackCollectionViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // Gesture recognizer
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gesture.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Load the packs
        let load = Common.getLoadingAnimation(view: self.view)
        load.startAnimating()
        self.getPacks()
        self.collectionView?.reloadData()
        load.stopAnimating()
    }
    
    @IBAction func createPackAlert(_ Sender: AnyObject) {
        self.alert = UIAlertController(title: "Create a Pack", message: "", preferredStyle: UIAlertControllerStyle.alert)
        self.alert!.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default))
        
        let getPhoto = UIAlertAction(title: "Add Photo",
                                     style: UIAlertActionStyle.default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = true
                self.imagePicker.modalPresentationStyle = .popover
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        self.alert!.addAction(getPhoto)
        
        present(self.alert!, animated: true, completion: nil)
    }
    
    // MARK: Image picker
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let newImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.dismiss(animated: true, completion: {
            let alertController = UIAlertController(title: "Name your pack", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addTextField(configurationHandler: { (textField : UITextField) -> Void in
                self.createPackName = textField
            })
            
            let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (sender : UIAlertAction) -> Void in
                // Check for duplicate
                let newName = self.createPackName?.text
                for pack in self.displayPacks {
                    if pack.name == newName {
                        Common.alertPopUp(warning: "Please enter a unique pack name.", vc: self)
                        return
                    }
                }

                self.addPack(pack: Pack(name: newName!, image: newImage!, members: []))
                self.cells = []
                self.collectionView?.reloadData()
            })
            
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    // What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Pack loading
    
    func addPack(pack: Pack) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let persist = appDelegate.getPersistentContainer() else {
            return
        }
        let managedContext = persist.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PackEntity",
                                                in: managedContext)!
        let packEntity = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        
        packEntity.setValue(pack.name, forKeyPath: "name")
        packEntity.setValue(pack.imageName, forKeyPath: "imageName")
        packEntity.setValue(pack.members, forKeyPath: "members")
        do {
            try managedContext.save()
            // Add to currently stored array
            displayPacks.append(pack)
            // Save entity in Pack
            pack.entity = packEntity
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getPacks() {
        // Clear packs
        if !displayPacks.isEmpty {
            displayPacks = []
        }
        // Load from Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        guard let persist = appDelegate.getPersistentContainer() else {
            return
        }
        let managedContext = persist.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PackEntity")
        do {
            let entities = try managedContext.fetch(fetchRequest)
            for e in entities {
                let name = e.value(forKey: "name") as! String
                let imageName = e.value(forKey: "imageName") as! String
                let members: [Int] = e.value(forKey: "members") as! [Int]
                let pack = Pack(name: name, imageName: imageName, members: members, entity: e)
                displayPacks.append(pack)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayPacks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PackCollectionViewCell
    
        let pack = displayPacks[indexPath.row]
        var image: UIImage = #imageLiteral(resourceName: "Packs")
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent(pack.imageName)
            image = UIImage(contentsOfFile: fileURL.path)!
        } catch {
            print(error)
        }
        
        cell.config(pack: pack, messageImage: image)
        cells.append(cell)
        return cell
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPack" {
            // Get the table view row that was tapped.
            if let indexPaths = self.collectionView?.indexPath(for: sender as! UICollectionViewCell) {
                let vc = segue.destination as! PackMembersTableViewController
                vc.pack = displayPacks[indexPaths.row]
            }
        } else if segue.identifier == "SendBark" {
            if let btn = sender as? UIButton, let view = btn.superview?.superview {
                if let indexPath = self.collectionView?.indexPath(for: view as! UICollectionViewCell) {
                    let members = displayPacks[indexPath.row].members
                    // Get target VC
                    let tempController = segue.destination as? UINavigationController
                    let vc = tempController?.topViewController as! SendWUPHFViewController
                    vc.targetIds = members
                    vc.navigationItem.title = "Send Bark"
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SendBark" {
            if let btn = sender as? UIButton, let view = btn.superview?.superview {
                if let indexPath = self.collectionView?.indexPath(for: view as! UICollectionViewCell) {
                    if displayPacks[indexPath.row].members.count == 0 {
                        Common.alertPopUp(warning: "Cannot send a Bark to an empty Pack.", vc: self)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    // Handles deleting of packs
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .began {
            return
        }
        
        let p = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: p) {
            let pack = displayPacks[indexPath.item]
            
            let message = "Delete \"" + pack.name + "\"?"
            let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                self.displayPacks.remove(at: indexPath.item)
                self.collectionView?.reloadData()
                pack.deletePack()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

