//
//  Global.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import Foundation
class Global {
    class var shared : Global {
        struct Static {
            static let instance : Global  = Global()
        }
        return Static.instance
    }
    var headerToken = ""
}
