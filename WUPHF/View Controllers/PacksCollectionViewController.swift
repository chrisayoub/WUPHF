//
//  PacksCollectionViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class PacksCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    var alert: UIAlertController? = nil
    lazy var createPackName: UITextField? = nil
    lazy var createPackImage: UIImageView? = nil
    
    var displayPacks: [Pack] = []
    var cells: [PackCollectionViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let load = Common.getLoadingAnimation(view: self.view)
        
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                // Loading animation
                load.startAnimating()
            }
            // Populate pack listing, then refresh
            self.getPacks()
            DispatchQueue.main.sync {
                self.collectionView?.reloadData()
                load.stopAnimating()
            }
        }
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
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
        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
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
        DispatchQueue.global().async {
            // Store the data, async so we return quick
            let strPack = pack.toString()
            var packs = UserDefaults.standard.dictionary(forKey: "packs")
            var packsList: [String] = []
            if let tempPacks = packs![String(describing: Common.loggedInUser!.id)] as? [String] {
                packsList = tempPacks
            }
            packsList.append(strPack)
            packs![String(describing: Common.loggedInUser!.id)] = packsList
            UserDefaults.standard.set(packs, forKey: "packs")
            UserDefaults.standard.synchronize()
        }
        // Add to currently stored array
        displayPacks.append(pack)
    }
    
    func getPacks() {
        // Clear packs
        if !displayPacks.isEmpty {
            displayPacks = []
        }
        // Get packs from user defaults
        var packs = UserDefaults.standard.dictionary(forKey: "packs")
        if packs == nil {
            packs = Dictionary()
            packs![String(describing: Common.loggedInUser!.id)] = []
            UserDefaults.standard.set(packs, forKey: "packs")
        }
        var tempPacks: [String] = []
        if let packList = packs![String(describing: Common.loggedInUser!.id)] {
            tempPacks = packList as! [String]
        }
        for p in tempPacks {
            displayPacks.append(toPack(str: p))
        }
        UserDefaults.standard.synchronize()
    }
    
    // Parses string into a Pack object
    func toPack(str: String) -> Pack {
        let strArr = str.components(separatedBy: "\n")
        let name: String = strArr[0]
        let imageName: String = strArr[1]
        
        var memIDs: [Int] = []
        let membersSplit = strArr[2].components(separatedBy: ",")
        for id in membersSplit {
            if id != "" {
                memIDs.append(Int(id)!)
            }
        }
        
        return Pack(name: name, imageName: imageName, members: memIDs)
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
        
        cell.config(messageText: pack.name, messageImage: image, users: pack.members)
        cell.parentVC = self
        cells.append(cell)
        return cell
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPack" {
            // Get the table view row that was tapped.
            if let indexPaths = self.collectionView?.indexPath(for: sender as! UICollectionViewCell) {
                let vc = segue.destination as! PackMembersTableViewController
                // Pass the selected data model object to the destination view controller.
                vc.pack = displayPacks[indexPaths.row]
                // Set the navigation bar back button text.
                // If you don't do this, the back button text is this screens title text.
                // If this screen didn't have any nav bar title text, the back button text would be 'Back', by default.
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
                // Set delegate
                vc.delegate = sender as! PackCollectionViewCell
            }
        } else if segue.identifier == "SendBark" {
            if let btn = sender as? UIButton, let view = btn.superview?.superview {
                if let indexPath = self.collectionView?.indexPath(for: view as! UICollectionViewCell) {
                    let members = getPackMembersForIndexPath(index: indexPath)
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
                    if getPackMembersForIndexPath(index: indexPath).count == 0 {
                        Common.alertPopUp(warning: "Cannot send a Bark to an empty Pack.", vc: self)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func getPackMembersForIndexPath(index: IndexPath) -> [Int] {
        let cellVc = cells[index.row]
        return cellVc.members
    }
}

