//
//  URLParameterDelegate.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 25/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import Foundation
import UIKit

protocol URLParameterDelegate:AnyObject {
    func removeParameter(for Key:String)
    func addParameter(key:String, value:String)
    func addPath(type:PathType, value:String)
    var presenter: UIViewController {get}
    var urlComponents:URLComponents {get set}
}

enum PathType {
    case sheme, host,path
}
