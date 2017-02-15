//
//  Photo.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Photo {
    internal let photoName: String? = ""
    internal let photoUrl: String?
    internal let owner: String? = ""
    internal var category: String? = ""
    
    init(photoURL: String, category: String) {
        self.photoUrl = photoURL
        self.category = category
    }
}
