//
//  PacksCollectionViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PacksCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var newName: String? = ""
    var newImage: UIImage?

    var alert:UIAlertController? = nil
    lazy var createPackName: UITextField? = nil
    lazy var createPackImage: UIImageView? = nil
    
    //temprorary values
    var packs: [String] = []
    var displayPacks: [Pack] = []
    var imageTest: UIImage? = #imageLiteral(resourceName: "facebook_login")
    var users: [Int] = []
    var users1: [User] = []
    
    override func viewDidLoad() {
       /* users.append(1)
        users.append(2)
        users.append(3)
        users.append(4)
        
        packs.append(Pack(name: "Test1", image: imageTest!, members: users))
        packs.append(Pack(name: "Test2", image: imageTest!, members: users))
        packs.append(Pack(name: "Test3", image: imageTest!, members: users))
        print(packs[0].toString())
        packs.append(toPack(str: packs[0].toString()))
       */
     //   packs.append(Pack(name: "Test4", image: imageTest!, members: users))
       // packs.append(Pack(name: "Test5", image: imageTest!, members: users))*/
        getPacks()
       
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    
    @IBAction func createPackAlert(_ Sender: AnyObject) {
            self.alert = UIAlertController(title: "Create a Pack", message: "", preferredStyle: UIAlertControllerStyle.alert)
            self.alert!.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.default))
        
            let getPhoto = UIAlertAction(title: "Add Photo", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .photoLibrary;
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.modalPresentationStyle = .popover
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                    //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                }
            })
            self.alert!.addAction(getPhoto)
        
            present(self.alert!, animated: true, completion: nil)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            self.newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            self.dismiss(animated: true, completion: {
                let alertController = UIAlertController(title: "Name your pack", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addTextField(configurationHandler: { (textField : UITextField) -> Void in
                    self.createPackName = textField
                })
                
                let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (sender : UIAlertAction) -> Void in
                    self.newName = self.createPackName?.text
                    print("writing name")
                    self.addPack(pack: Pack(name: self.newName!, image: self.newImage!, members: []))
                    self.collectionView?.reloadData()
                    
                })
                
                alertController.addAction(doneAction)
                
                self.present(alertController, animated: true, completion: nil)
               
            })
        }
        func addPack(pack: Pack){
            let strPack = pack.toString()
            var packs = UserDefaults.standard.dictionary(forKey: "packs")
            var newPacks: [String] = []
            newPacks.append(strPack)
            for p in displayPacks{
                newPacks.append(p.toString())
            }
            
            packs![String(describing: Common.loggedInUser!.id)] = newPacks
            UserDefaults.standard.set(packs, forKey: "packs")
            UserDefaults.standard.synchronize()
            getPacks()
        }
        func getPacks(){
            if !displayPacks.isEmpty{
                displayPacks.removeAll(keepingCapacity: false)
            }
            var packs = UserDefaults.standard.dictionary(forKey: "packs")
            if packs == nil {
                packs = Dictionary()
                UserDefaults.standard.set(packs, forKey: "packs")
            }
            var tempPacks: [String] = []
            if let packList = packs![String(describing: Common.loggedInUser!.id)]{
                tempPacks = packList as! [String]
            }
            for p in tempPacks {
                displayPacks.append(toPack(str: p))
            }
            UserDefaults.standard.synchronize()

        }
    
        //What to do if the image picker cancels.
        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            dismiss(animated: false, completion: nil)
        }

        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
            
        }


        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of items
            print(displayPacks.count)
            return displayPacks.count
        }

        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PackCollectionViewCell
        
            
            // Configure the cell...
            let pack = displayPacks[indexPath.row]
            cell.delegate = self
            
            cell.config(messageText: pack.name, messageImage: pack.image, users: pack.members)
        
            return cell
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowPack" {
                // Get the table view row that was tapped.
                if let indexPaths = self.collectionView?.indexPath(for: sender as! UICollectionViewCell){
                    let vc = segue.destination as! PackMembersTableViewController
                    // Pass the selected data model object to the destination view controller.
                    vc.pack = displayPacks[indexPaths.row]
                    // Set the navigation bar back button text.
                    // If you don't do this, the back button text is this screens title text.
                    // If this screen didn't have any nav bar title text, the back button text would be 'Back', by default.
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    navigationItem.backBarButtonItem = backItem
                }
            }
        }

        // MARK: UICollectionViewDelegate

        /*
        // Uncomment this method to specify if the specified item should be highlighted during tracking
        override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
            return true
        }
        */

        /*
        // Uncomment this method to specify if the specified item should be selected
        override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            return true
        }
        */

        /*
        // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
        override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
            return false
        }

        override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
            return false
        }

        override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    func toPack(str:String) -> Pack{
        let strArr = str.components(separatedBy: "\n")
        let name:String = strArr[0]
        let dataDecoded:Data = NSData(base64Encoded: strArr[1], options: Data.Base64DecodingOptions.ignoreUnknownCharacters)! as Data
        let image:UIImage! = UIImage(data: dataDecoded)
        
        var memIDs: [Int] = []
        
        for char in strArr[2]{
            memIDs.append(Int(String(char))!)
        }
        
        
        return Pack(name: name, image: image, members: memIDs)
    }

}
