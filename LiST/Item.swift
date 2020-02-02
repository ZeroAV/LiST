//
//  Item.swift
//  LiST
//
//  Created by Aditya Alvari on 02/02/20.
//  Copyright © 2020 Aditya Alvari. All rights reserved.
//

import UIKit
import os.log

class Item: NSObject, NSCoding {
    var name: String
    var photo: UIImage?
    
    init?(name: String, photo: UIImage?){
        guard !name.isEmpty else{
            return nil
        }
        self.name = name
        self.photo = photo
    }
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
    }
    
    //NSCODING
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    

    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(name: name, photo: photo)
    }
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")


}
