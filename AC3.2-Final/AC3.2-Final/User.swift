//
//  User.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class User {
    internal var name: String?
    internal var email: String?
    internal var password: String?
    
    init(name: String?, email: String?, password: String?) {
    self.name = name
    self.email = email
    self.password = password
    }
}
