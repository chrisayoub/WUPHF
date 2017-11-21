//
//  AddToPackTableViewCell.swift
//  WUPHF
//
//  Created by Matthew Savignano on 11/20/17.
//  Copyright © 2017 Group13. All rights reserved.
//

import UIKit

class AddToPackTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    private var user: User?
    var delegate: AddtoPackTableViewController!
    var pack: Pack!
    var allPacks: [Pack]!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        name.text = ""
    }
    @IBAction func addBTn(_ sender: Any) {
        addPackMember()
    }
    
    func sendInfo(user: User) {
        self.user = user
        name.text = "\(user.firstName) \(user.lastName)"
    }
    func addPackMember(){
        getPacks()
        
        var packs = UserDefaults.standard.dictionary(forKey: "packs")
        var newPacks: [String] = []
        
        for p in allPacks{
            if p.toString() == self.pack.toString(){
                p.members.append((user?.id)!)
                newPacks.append(p.toString())
            } else{
                newPacks.append(p.toString())
            }
            
        }
        packs![String(describing: Common.loggedInUser!.id)] = newPacks
        UserDefaults.standard.set(packs, forKey: "packs")
        UserDefaults.standard.synchronize()
        
        
    }
    func getPacks(){
        if !allPacks.isEmpty{
            allPacks.removeAll(keepingCapacity: false)
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
            allPacks.append(toPack(str: p))
        }
        UserDefaults.standard.synchronize()
        
    }
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
