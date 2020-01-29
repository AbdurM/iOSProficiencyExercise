//
//  Photo+CoreDataProperties.swift
//  PhotoDisplayer
//
//  Created by ABDUR RAFAY on 29/1/20.
//  Copyright © 2020 ABDUR RAFAY. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoId: String?
    @NSManaged public var title: String?
    @NSManaged public var photoDescription: String?
    @NSManaged public var remoteURL: NSURL?

}
