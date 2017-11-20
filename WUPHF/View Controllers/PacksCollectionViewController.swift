//
//  PacksCollectionViewController.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/19/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PacksCollectionViewController: UICollectionViewController {
    
    
    //temprorary values
    var packs: [Pack] = []
    var imageTest: UIImage? = #imageLiteral(resourceName: "facebook_login")
    var users: [User] = []
    var users1: [User] = []
    
    override func viewDidLoad() {
        users1.append(User(id: 1, firstName: "test", lastName: "er", email: "", phone: "",
                           enableSMS: false, facebookLinked: false, twitterLinked: false))
        
        users.append(User(id: 1, firstName: "test", lastName: "er", email: "", phone: "",
                           enableSMS: false, facebookLinked: false, twitterLinked: false))
        users.append(User(id: 2, firstName: "test", lastName: "er2", email: "", phone: "",
                          enableSMS: false, facebookLinked: false, twitterLinked: false))
        users.append(User(id: 3, firstName: "test", lastName: "er3", email: "", phone: "",
                          enableSMS: false, facebookLinked: false, twitterLinked: false))
        users.append(User(id: 4, firstName: "test", lastName: "er4", email: "", phone: "",
                          enableSMS: false, facebookLinked: false, twitterLinked: false))
        packs.append(Pack(name: "Test", image: imageTest!, members: users1))
        packs.append(Pack(name: "Test2", image: imageTest!, members: users))
        packs.append(Pack(name: "Test3", image: imageTest!, members: users))
        packs.append(Pack(name: "Test4", image: imageTest!, members: users))
        packs.append(Pack(name: "Test5", image: imageTest!, members: users))
        

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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return packs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! PackCollectionViewCell
    
        
        // Configure the cell...
        let pack = packs[indexPath.row]
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
                vc.pack = packs[indexPaths.row]
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

}
